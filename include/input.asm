	; Read input from the keyboard and store in a buffer parameter
	; - rbx: initial buffer size
	; - rbx: pointer to the buffer where input will be stored

include_input:
	;    Save register
	push rax
	push rbx
	push rsi
	push rcx

	;   Clear eax (used for comparison)
	xor eax, eax

	;   Check if the buffer is empty
	cmp rbx, STATIC_EMPTY
	je  .loop; If empty jump the input loop

	mov  rcx, rbx; Store buffer size in rcx
	call include_terminal_string; Print the current input buffer to terminal

	;   Load buffer size from stack
	mov rcx, qword [rsp]
	;   Calculate remaining buffer space
	sub rcx, rbx
	;   Adjust buffer pointer to the end of input
	add rsi, rbx

.loop:
	mov ax, KERNEL_SERVICE_KEYBOARD_key; Request keyboard input
	int KERNEL_SERVICE; Call system service
	jz  .loop; If not pressed, keep wait

	cmp ax, STATIC_ASCII_BACKSPACE; Check if backspace pressed
	je  .key_backspac

	cmp ax, STATIC_ASCII_ENTER; Check if enter was pressed
	je  .key_enter

	cmp ax, STATIC_ASCII_ESCAPE; Check if escape was pressed
	je  .empty

	cmp ax, STATIC_ASCII_SPACE; Ignore constrol characters
	jb  .loop
	cmp ax, STATIC_ASCII_TILDE; Ignore non printable characters
	ja  .loop

	cmp rcx, STATIC_EMPTY; Check if buffer is full
	je  .loop

	;   Store input character in buffer
	mov byte [rsi + rbx], al
	;   Increase character count
	inc rbx
	;   Decrease remaining buffer space
	dec rcx

.print:
	push rcx

	mov  ecx, 1
	;    Check if buffer is empty
	call include_terminal_char

	pop rcx

	jmp .loop

.key_backspace:
	;    Check if buffer is empty
	test rbx, rbx
	jz   .loop

	dec rbx; Remove last character
	inc rcx; Increase available buffer space
	jmp .print; Reflect change on screen

.key_enter:
	test rbx, rbx; Check if anything was typed
	jz   .empty

	mov qword [rsp], rbx; Store final buffer length
	;   Clear carry flag
	clc

	jmp .end

.empty:
	; Set carry flag (buffer empty)
	stc

.end:
	;   Restore registers
	pop rcx
	pop rsi
	pop rbx
	pop rax

	; Return to caller
	ret
