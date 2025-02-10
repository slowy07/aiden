kernel_video_semaphore db STATIC_FALSE
kernel_video_base_address dq STATIC_EMPTY
kernel_video_pointer dq STATIC_EMPTY
kernel_video_framebuffer dq STATIC_EMPTY
kernel_video_size_byte dq STATIC_EMPTY
kernel_video_size_pixel dq STATIC_EMPTY
kernel_video_width_pixel dq STATIC_EMPTY
kernel_video_height_pixel dq STATIC_EMPTY
kernel_video_width_char dq STATIC_EMPTY
kernel_video_height_char dq STATIC_EMPTY
kernel_video_scanline_byte dq STATIC_EMPTY
kernel_video_scanline_char dq STATIC_EMPTY

kernel_video_color dd STATIC_COLOR_default
kernel_video_color_background dd STATIC_COLOR_BACKGROUND_default

kernel_video_cursor_lock dq STATIC_EMPTY

kernel_video_cursor:
.x:
	dd STATIC_EMPTY

.y:
	dd STATIC_EMPTY

	kernel_video_color_sequence_default db STATIC_COLOR_ASCII_DEFAULT
	kernel_video_color_sequence_black db STATIC_COLOR_ASCII_BLACK
	kernel_video_color_sequence_blue db STATIC_COLOR_ASCII_BLUE
	kernel_video_color_sequence_green db STATIC_COLOR_ASCII_GREEN
	kernel_video_color_sequence_cyan db STATIC_COLOR_ASCII_CYAN
	kernel_video_color_sequence_red db STATIC_COLOR_ASCII_RED
	kernel_video_color_sequence_magenta db STATIC_COLOR_ASCII_MAGENTA
	kernel_video_color_sequence_brown db STATIC_COLOR_ASCII_BROWN
	kernel_video_color_sequence_gray_light db STATIC_COLOR_ASCII_GRAY_LIGHT
	kernel_video_color_sequence_gray db STATIC_COLOR_ASCII_GRAY
	kernel_video_color_sequence_blue_light db STATIC_COLOR_ASCII_BLUE_LIGHT
	kernel_video_color_sequence_green_light db STATIC_COLOR_ASCII_GREEN_LIGHT
	kernel_video_color_sequence_cyan_light db STATIC_COLOR_ASCII_CYAN_LIGHT
	kernel_video_color_sequence_red_light db STATIC_COLOR_ASCII_RED_LIGHT
	kernel_video_color_sequence_magenta_light db STATIC_COLOR_ASCII_MAGENTA_LIGHT
	kernel_video_color_sequence_yellow db STATIC_COLOR_ASCII_YELLOW
	kernel_video_color_sequence_white db STATIC_COLOR_ASCII_WHITE

kernel_video_drain:
	push rax
	push rcx
	push rdi

	call kernel_video_cursor_disable

	mov eax, dword [kernel_video_color_background]
	mov rcx, qword [kernel_video_size_pixel]
	mov rdi, qword [kernel_video_framebuffer]
	rep stosd

	mov qword [kernel_video_cursor], STATIC_EMPTY

	call kernel_video_cursor_set

	call kernel_video_cursor_enable

	pop rdi
	pop rcx
	pop rax

	ret

macro_debug "kernel_video_drain"

kernel_video_matrix:
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r8

	mov ebx, dword [kernel_font_height_pixel]
	mul rbx

	mov rsi, kernel_font_matrix
	add rsi, rax

	mov r8d, dword [kernel_video_color]

.next:
	mov ecx, KERNEL_FONT_WIDTH_pixel - 0x01

.loop:
	bt  word [rsi], cx
	jnc .continue

	mov dword [rdi], r8d

	mov dword [rdi + STATIC_DWORD_SIZE_byte], STATIC_EMPTY

.continue:
	add rdi, STATIC_DWORD_SIZE_byte

	dec cl
	jns .loop
	sub rdi, KERNEL_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift
	add rdi, qword [kernel_video_scanline_byte]

	inc rsi

	dec bl
	jnz .next

	pop r8
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_video_matrix"

kernel_video_char_clean:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	mov ebx, KERNEL_FONT_HEIGHT_pixel

	mov eax, dword [kernel_video_color_background]

.next:
	mov cx, KERNEL_FONT_WIDTH_pixel - 0x01

.loop:
	stosd

.continue:
	dec cl
	jns .loop

	sub rdi, KERNEL_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift
	add rdi, qword [kernel_video_scanline_byte]

	dec bl
	jnz .next

	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_video_char_clean"

kernel_video_cursor_set:
	push rax
	push rcx
	push rdx

	call kernel_video_cursor_disable

	mov  eax, dword [kernel_video_cursor.y]
	mul  qword [kernel_video_scanline_char]
	push rax
	mov  eax, dword [kernel_video_cursor.x]
	mul  qword [kernel_font_width_byte]
	add  qword [rsp], rax
	pop  rax

	add rax, qword [kernel_video_framebuffer]
	mov qword [kernel_video_pointer], rax

	call kernel_video_cursor_enable

	pop rdx
	pop rcx
	pop rax

	ret

macro_debug "kernel_video_cursor_set"

kernel_video_string:
	push rax
	push rbx
	push rcx
	push rdx
	push rsi

	call kernel_video_cursor_disable

	test rcx, rcx
	jz   .end

	xor eax, eax

.loop:
	lodsb

	test al, al
	jz   .end

	cmp al, STATIC_ASCII_BACKSLASH
	jne .no

	cmp rcx, STATIC_ASCII_SEQUENCE_length
	jb  .fail

	push rdi
	push rsi
	push rcx

	dec rsi

	mov ecx, STATIC_ASCII_SEQUENCE_length

.default:
	mov  rdi, kernel_video_color_sequence_default
	call include_string_compare
	jc   .black

	mov dword [kernel_video_color], STATIC_COLOR_default

	jmp .done

.black:
	mov  rdi, kernel_video_color_sequence_black
	call include_string_compare
	jc   .blue

	mov dword [kernel_video_color], STATIC_COLOR_black

	jmp .done

.blue:
	mov  rdi, kernel_video_color_sequence_blue
	call include_string_compare
	jc   .green

	mov dword [kernel_video_color], STATIC_COLOR_blue

	jmp .done

.green:
	mov  rdi, kernel_video_color_sequence_green
	call include_string_compare
	jc   .cyan

	mov dword [kernel_video_color], STATIC_COLOR_green

	jmp .done

.cyan:
	mov  rdi, kernel_video_color_sequence_cyan
	call include_string_compare
	jc   .red

	mov dword [kernel_video_color], STATIC_COLOR_cyan

	jmp .done

.red:
	mov  rdi, kernel_video_color_sequence_red
	call include_string_compare
	jc   .magenta

	mov dword [kernel_video_color], STATIC_COLOR_red

	jmp .done

.magenta:
	mov  rdi, kernel_video_color_sequence_magenta
	call include_string_compare
	jc   .brown

	mov dword [kernel_video_color], STATIC_COLOR_magenta

	jmp .done

.brown:
	mov  rdi, kernel_video_color_sequence_brown
	call include_string_compare
	jc   .gray_light

	mov dword [kernel_video_color], STATIC_COLOR_brown

	jmp .done

.gray_light:
	mov  rdi, kernel_video_color_sequence_gray_light
	call include_string_compare
	jc   .gray

	mov dword [kernel_video_color], STATIC_COLOR_gray_light

	jmp .done

.gray:
	mov  rdi, kernel_video_color_sequence_gray
	call include_string_compare
	jc   .blue_light

	mov dword [kernel_video_color], STATIC_COLOR_gray

	jmp .done

.blue_light:
	mov  rdi, kernel_video_color_sequence_blue_light
	call include_string_compare
	jc   .green_light

	mov dword [kernel_video_color], STATIC_COLOR_blue_light

	jmp .done

.green_light:
	mov  rdi, kernel_video_color_sequence_green_light
	call include_string_compare
	jc   .cyan_light

	mov dword [kernel_video_color], STATIC_COLOR_green_light

	jmp .done

.cyan_light:
	mov  rdi, kernel_video_color_sequence_cyan_light
	call include_string_compare
	jc   .red_light

	mov dword [kernel_video_color], STATIC_COLOR_cyan_light

	jmp .done

.red_light:
	mov  rdi, kernel_video_color_sequence_red_light
	call include_string_compare
	jc   .magenta_light

	mov dword [kernel_video_color], STATIC_COLOR_red_light

	jmp .done

.magenta_light:
	mov  rdi, kernel_video_color_sequence_magenta_light
	call include_string_compare
	jc   .yellow

	mov dword [kernel_video_color], STATIC_COLOR_magenta_light

	jmp .done

.yellow:
	mov  rdi, kernel_video_color_sequence_yellow
	call include_string_compare
	jc   .white

	mov dword [kernel_video_color], STATIC_COLOR_yellow

	jmp .done

.white:
	mov  rdi, kernel_video_color_sequence_white
	call include_string_compare
	jc   .fail

	mov dword [kernel_video_color], STATIC_COLOR_white

.done:
	sub qword [rsp], STATIC_ASCII_SEQUENCE_length - 0x01
	add qword [rsp + STATIC_QWORD_SIZE_byte], STATIC_ASCII_SEQUENCE_length - 0x01

.fail:
	pop rcx
	pop rsi
	pop rdi

	jnc .continue

.no:
	push rcx

	mov  ecx, 1
	call kernel_video_char

	pop rcx

.continue:
	dec rcx
	jnz .loop

.end:
	call kernel_video_cursor_enable

	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_video_string"

kernel_video_char:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	call kernel_video_cursor_disable

	macro_lock kernel_video_semaphore, 0

	mov ebx, dword [kernel_video_cursor]
	mov edx, dword [kernel_video_cursor + STATIC_DWORD_SIZE_byte]

	mov rdi, qword [kernel_video_pointer]

.loop:
	cmp ax, STATIC_ASCII_NEW_LINE
	je  .new_line

	cmp ax, STATIC_ASCII_BACKSPACE
	je  .backspace

	call kernel_video_char_clean

	sub  ax, STATIC_ASCII_SPACE
	call kernel_video_matrix

	inc ebx

	add rdi, qword [kernel_font_width_byte]

	cmp ebx, dword [kernel_video_width_char]
	jb  .continue

	push rax
	push rdx

	mov rax, qword [kernel_font_width_byte]
	mul rbx
	sub rdi, rax
	add rdi, qword [kernel_video_scanline_char]

	pop rdx
	pop rax

	xor ebx, ebx
	inc edx

.row:
	cmp edx, dword [kernel_video_height_char]
	jb  .continue

	dec edx

	sub rdi, qword [kernel_video_scanline_char]

	call kernel_video_scroll

.continue:
	dec rcx
	jnz .loop

	mov dword [kernel_video_cursor], ebx
	mov dword [kernel_video_cursor + STATIC_DWORD_SIZE_byte], edx

	mov qword [kernel_video_pointer], rdi

	mov byte [kernel_video_semaphore], STATIC_FALSE

	call kernel_video_cursor_enable

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
	mul qword [kernel_font_width_pixel]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	sub rdi, rax

	xor ebx, ebx

	add rdi, qword [kernel_video_scanline_char]

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

	mov ebx, dword [kernel_video_width_char]
	dec ebx

	dec edx

	push rax
	push rdx

	sub rdi, qword [kernel_video_scanline_char]
	mov rax, qword [kernel_font_width_byte]
	mul dword [kernel_video_width_char]
	add rdi, rax

	pop rdx
	pop rax

.clear:
	sub rdi, KERNEL_FONT_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift

	call kernel_video_char_clean

	jmp .continue

macro_debug "kernel_video_char"

kernel_video_number:
	push rax
	push rdx
	push rbp
	push r8
	push r9

	call kernel_video_cursor_disable

	and ebx, STATIC_BYTE_mask

	cmp bl, 2
	jb  .error
	cmp bl, 36
	ja  .error

	mov r8, rdx
	sub r8, 0x30

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
	push r8

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
	call kernel_video_char

	jmp .print

.error:
	stc

.end:
	call kernel_video_cursor_enable

	pop r9
	pop r8
	pop rbp
	pop rdx
	pop rax

	ret

macro_debug "kernel_video_number"

kernel_video_scroll:
	push rcx
	push rsi
	push rdi

	call kernel_video_cursor_disable

	mov rcx, qword [kernel_video_size_byte]
	sub rcx, qword [kernel_video_scanline_char]

	mov  rdi, qword [kernel_video_framebuffer]
	mov  rsi, rdi
	add  rsi, qword [kernel_video_scanline_char]
	call kernel_memory_copy

	mov  ecx, dword [kernel_video_height_char]
	dec  ecx
	call kernel_video_line_drain

	call kernel_video_cursor_enable

	pop rdi
	pop rsi
	pop rcx

	ret

macro_debug "kernel_video_scroll"

kernel_video_line_drain:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi

	call kernel_video_cursor_disable

	mov rax, rcx

	mov rcx, qword [kernel_video_scanline_char]
	mul rcx
	add rax, qword [kernel_video_framebuffer]
	mov rdi, rax

	mov eax, STATIC_COLOR_BACKGROUND_default
	shr rcx, KERNEL_VIDEO_DEPTH_shift
	rep stosd

	call kernel_video_cursor_enable

	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_video_line_drain"

kernel_video_cursor_disable:
	inc qword [kernel_video_cursor_lock]

	cmp qword [kernel_video_cursor_lock], STATIC_FALSE
	jne .ready

	call kernel_video_cursor_switch

.ready:
	ret

macro_debug "kernel_video_cursor_disable"

kernel_video_cursor_enable:
	cmp qword [kernel_video_cursor_lock], STATIC_EMPTY
	je  .ready

	dec qword [kernel_video_cursor_lock]

	cmp qword [kernel_video_cursor_lock], STATIC_EMPTY
	jne .ready

	call kernel_video_cursor_switch

.ready:
	ret

macro_debug "kernel_video_cursor_enable"

kernel_video_cursor_switch:
	push rax
	push rcx
	push rdi

	mov rax, qword [kernel_video_scanline_byte]

	mov rcx, KERNEL_FONT_HEIGHT_pixel

	mov rdi, qword [kernel_video_pointer]

.loop:
	not dword [rdi]

	or byte [rdi + 0x03], STATIC_MAX_unsigned

	add rdi, rax

	dec rcx
	jnz .loop

.end:
	pop rdi
	pop rcx
	pop rax

	ret

macro_debug "kernel_video_cursor_switch"
