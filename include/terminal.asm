	;        Structure defining terminal properties and cursor information
	struc    INCLUDE_TERMINAL_STRUCTURE
	.width   resb 8; Width of the terminal in pixels
	.height  resb 8; Height of the terminal in pixels
	.address resb 8; Memory address for the terminal buffer
	.size_byte resb 8 ; Total size in byte
	.scanline_byte resb 8 ; Number of bytes per scanline
	.pointer resb 8; Pointer to the current terminal data
	.width_char resb 8 ; Width of a character in pixels
	.height_char resb 8 ; Height of a character in pixels
	.scanline_char resb 8 ; Number of characters per scanline

.cursor:
	resb  4; Cursor position (X coordinate placeholder)
	resb  4; Cursor position (Y coordinate placeholder)
	.lock resb 8; Lock status for cursor updates
	.foreground_color resb 4 ; Foreground color setting
	.background_color resb 4 ; Background color setting
	endstruc

	;     Structure defining cursor position
	struc INCLUDE_TERMINAL_STRUCTURE_CURSOR
	.x    resb 4; Cursor X position
	.y    resb 4; Cursor Y position
	endstruc

	; Initializes the terminal settings and properties

include_terminal:
	;    Save register
	push rax
	push rdx

	;   Calculate scanline character size
	mov rax, INCLUDE_FONT_HEIGHT_pixel
	mul qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_byte]
	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char], rax

	;   Compute terminal width in character units
	mov rax, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.width]
	xor edx, edx
	div qword [include_font_width_pixel]
	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.width_char], rax

	;   Compute terminal height in character units
	mov rax, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.height]
	xor edx, edx
	div qword [include_font_height_pixel]
	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.height_char], rax

	;   Unlock the terminal
	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.lock], STATIC_FALSE

	;    Drain terminal buffer and enable cursor
	call include_terminal_drain
	call include_terminal_cursor_enable

	;   Restore register
	pop rdx
	pop rax

	; Return to register
	ret

	; Clears the terminal display buffer

include_terminal_drain:
	;    Save register
	push rax
	push rcx
	push rdi

	;    Disable cursor while clearing
	call include_terminal_cursor_disable

	;   Get terminal buffer address and background color
	mov rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.address]
	mov eax, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.background_color]
	;   Compute buffer size and clear the display
	mov rcx, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.size_byte]
	shr rcx, KERNEL_VIDEO_DEPTH_shift
	rep stosd

	;   Reset cursor position
	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor], STATIC_EMPTY

	;    Restore and enable cursor
	call include_terminal_cursor_set
	call include_terminal_cursor_enable

	;   Restore Register
	pop rdi
	pop rcx
	pop rax

	; Return to register
	ret

	; Disable the terminal cursor by incrementing the lock counter

include_terminal_cursor_disable:
	inc qword [r8 + INCLUDE_TERMINAL_STRUCTURE.lock]

	;   If the lock is no longer false, return
	cmp qword [r8 + INCLUDE_TERMINAL_STRUCTURE.lock], STATIC_FALSE
	jne .ready

	;    Otherwise, switch the cursor state
	call include_terminal_cursor_switch

.ready:
	ret

	; Enables the terminal cursor by decrementing the lock counter

include_terminal_cursor_enable:
	cmp qword [r8 + INCLUDE_TERMINAL_STRUCTURE.lock], STATIC_EMPTY
	je  .ready

	dec qword [r8 + INCLUDE_TERMINAL_STRUCTURE.lock]

	;   If the lock is not empty, return
	cmp qword [r8 + INCLUDE_TERMINAL_STRUCTURE.lock], STATIC_EMPTY
	jne .ready

	;    Otherwise, switch the cursor state
	call include_terminal_cursor_switch

.ready:
	ret

	; Toggles the visibility of the terminal cursor

include_terminal_cursor_switch:
	push rax
	push rcx
	push rdi

	;   Load scanline byte size
	mov rax, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_byte]
	;   Number of lines per character
	mov rcx, INCLUDE_FONT_HEIGHT_pixel
	;   Cursor pointer address
	mov rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.pointer]

.loop:
	not dword [rdi]; Invert cursor pixel color
	;   Ensure max brightness or visibility
	or  byte [rdi + 0x03], STATIC_MAX_unsigned

	add rdi, rax; Move to the next scanline
	dec rcx; Decrement loop counter
	jnz .loop; Repeat utnil all scanline are update

.end:
	;   Restore register
	pop rdi
	pop rcx
	pop rax

	ret

; Sets the terminal cursor position
include_terminal_cursor_set:
  ; Save register
	push rax
	push rcx
	push rdx

  ; Compute vertical cursor position
	call include_terminal_cursor_disable

  ; Compute horizontal cursor position
	mov  eax, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor + INCLUDE_TERMINAL_STRUCTURE_CURSOR.y]
	mul  qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]
	push rax
	mov  eax, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor + INCLUDE_TERMINAL_STRUCTURE_CURSOR.x]
	mul  qword [include_font_width_byte]
	add  qword [rsp], rax
	pop  rax

  ; Compute final cursor address
	add rax, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.address]
	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.pointer], rax

	call include_terminal_cursor_enable

  ; Restore register
	pop rdx
	pop rcx
	pop rax

  ; Return from function
	ret

; Renders a character matrix onto the terminal display
include_terminal_matrix:
  ; Save register
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r9

  ; Compute font matrix offset based on character height
	mov ebx, dword [include_font_height_pixel]
	mul rbx

  ; Load font matrix pointer
	mov rsi, include_font_matrix
	add rsi, rax

  ; Load foreground color
	mov r9d, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.foreground_color]

.next:
	mov ecx, INCLUDE_FONT_WIDTH_pixel - 0x01 ; Set pixel width counter

.loop:
	bt  word [rsi], cx ; Test bit in font matrix
	jnc .continue ; Skip if bit is not set

	mov dword [rdi], r9d ; Set pixel to foreground
	mov dword [rdi + STATIC_QWORD_SIZE_byte], STATIC_EMPTY ; Clear adjacent pixel

.continue:
	add rdi, STATIC_DWORD_SIZE_byte ; Move to next pixel

	dec cl ; Decrease column counter
	jns .loop ; Repeat for all columns

  ; Adjust for next scanline
	sub rdi, INCLUDE_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift
	add rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_byte]

	inc rsi ; Move to next row in font matrix

	dec bl ; Decrease row counter
	jnz .next ; Decrease row counter

  ; Restore register
	pop r9
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

  ; Return to function
	ret

; Clear a character space on the terminal display
include_terminal_empty_char:
  ; Save register
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	mov ebx, INCLUDE_FONT_HEIGHT_pixel
	mov eax, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.background_color]

.next:
	mov cx, INCLUDE_FONT_WIDTH_pixel - 0x01

.loop:
	stosd ; Store background color in video memory

.continue:
	dec cl
	jns .loop

	sub rdi, INCLUDE_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift
	add rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_byte]

	dec bl
	jnz .next

  ; Restore to register
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

  ; Return to function
	ret

; Handles rendering and positioning of characters on the terminal
include_terminal_char:
  ; Save register
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	call include_terminal_cursor_disable

	mov ebx, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor + INCLUDE_TERMINAL_STRUCTURE_CURSOR.x]
	mov edx, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor + INCLUDE_TERMINAL_STRUCTURE_CURSOR.y]

	mov rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.pointer]

.loop:
	cmp ax, STATIC_ASCII_NEW_LINE
	je  .new_line

	cmp ax, STATIC_ASCII_BACKSPACE
	je  .backspace

	call include_terminal_empty_char

	sub  ax, STATIC_ASCII_SPACE
	call include_terminal_matrix

	inc ebx

	add rdi, qword [include_font_width_byte]

	cmp ebx, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.width_char]
	jb  .continue

	push rax
	push rdx

	mov rax, qword [include_font_width_byte]
	mul rbx
	sub rdi, rax
	add rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]

	pop rdx
	pop rax

	xor ebx, ebx
	inc edx

.row:
	cmp edx, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.height_char]
	jb  .continue

	dec edx

	sub rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]

	call include_terminal_scroll

.continue:
	dec rcx
	jnz .loop

	mov dword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor + INCLUDE_TERMINAL_STRUCTURE_CURSOR.x], ebx
	mov dword [r8 + INCLUDE_TERMINAL_STRUCTURE.cursor + INCLUDE_TERMINAL_STRUCTURE_CURSOR.y], ebx

	mov qword [r8 + INCLUDE_TERMINAL_STRUCTURE.pointer], rdi

	call include_terminal_cursor_enable

	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

.new_line:
	push rax
	push rdx

	mov eax, ebx
	mul qword [include_font_width_pixel]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	sub rdi, rax

	xor ebx, ebx
	add rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]

	pop rdx
	inc rdx

	pop rax

	jmp .row

.backspace:
	test ebx, ebx
	jz   .begin

	dec ebx

	jmp .clear

.begin:
	test edx, edx
	jz   .continue

	mov ebx, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.width_char]
	dec ebx

	dec edx

	push rax
	push rdx

	sub rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]
	mov rax, qword [include_font_width_byte]
	mul qword [r8 + INCLUDE_TERMINAL_STRUCTURE.width_char]
	add rdi, rax

	pop rdx
	pop rax

.clear:
	sub rdi, INCLUDE_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift

	call include_terminal_empty_char

	jmp .continue

include_terminal_scroll:
	push rcx
	push rsi
	push rdi

	call include_terminal_cursor_disable

	mov rcx, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.size_byte]
	sub rcx, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]
	shr rcx, KERNEL_VIDEO_DEPTH_shift

	mov rdi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.address]
	mov rsi, rdi
	add rsi, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]
	rep movsd

	mov  ecx, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.height_char]
	dec  ecx
	call include_terminal_empty_line

	call include_terminal_cursor_enable

	pop rdi
	pop rsi
	pop rcx

	ret

include_terminal_empty_line:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	call include_terminal_cursor_disable

	mov rax, rcx

	mov rcx, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.scanline_char]
	mul rcx
	add rax, qword [r8 + INCLUDE_TERMINAL_STRUCTURE.address]
	mov rdi, rax

	mov eax, dword [r8 + INCLUDE_TERMINAL_STRUCTURE.background_color]
	shr rcx, KERNEL_VIDEO_DEPTH_shift
	rep stosd

	call include_terminal_cursor_enable

	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

include_terminal_string:
	push rax
	push rbx
	push rcx
	push rdx
	push rsi

	call include_terminal_cursor_disable

	test rcx, rcx
	jz   .end

	xor eax, eax

.loop:
	lodsb

	test al, al
	jz   .end

	push rcx

	mov  ecx, 1
	call include_terminal_char

	pop rcx

.continue:
	dec rcx
	jnz .loop

.end:
	call include_terminal_cursor_enable

	pop rcx
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

include_terminal_number:
	push rax
	push rdx
	push rbp
	push r9

	call include_terminal_cursor_disable

	and ebx, STATIC_BYTE_mask

	cmp bl, 2
	jb  .error
	cmp bl, 36
	ja  .error

	mov r9, rdx
	sub r9, 0x30

	xor rdx, rdx
	mov rbp, rsp

.loop:
	div rbx

	push rdx
	dec  rcx

	xor rdx, rdx

	test rax, rax
	jnz  .loop

	cmp rcx, STATIC_EMPTY
	jle .print

.prefix:
	push r9

	dec rcx
	jnz .prefix

.print:
	mov ecx, 0x01

	cmp rsp, rbp
	je  .end

	pop rax

	add rax, 0x30
	cmp al, 0x3A
	jb  .no

	add al, 0x07

.no:
	call include_terminal_char

	jmp .print

.error:
	stc

.end:
	call include_terminal_cursor_enable

	pop r9
	pop rbp
	pop rdx
	pop rax

	ret
