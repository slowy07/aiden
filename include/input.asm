include_input:
	push rax
	push rbx
	push rsi
	push rcx

	cmp rbx, STATIC_EMPTY
	je  .loop

	mov  rcx, rbx
	call kernel_video_string

	mov rcx, qword [rsp]

	sub rcx, rbx

	add rsi, rbx

.loop:
	call driver_ps2_keyboard_read
	jz   .loop

	cmp ax, STATIC_ASCII_BACKSPACE
	je  .key_backspace

	cmp ax, STATIC_ASCII_ENTER
	je  .key_enter

	cmp ax, STATIC_ASCII_ESCAPE
	je  .empty

	cmp rax, STATIC_ASCII_SPACE
	jb  .loop
	cmp rax, STATIC_ASCII_TILDE
	ja  .loop

	cmp rcx, STATIC_EMPTY
	je  .loop

	mov byte [rsi + rbx], al

	inc rbx

	dec rcx

.print:
	push rcx

	mov  ecx, 0x01
	call kernel_video_char

	pop rcx

	jmp .loop

.key_backspace:
	test rbx, rbx
	jz   .loop

	dec rbx

	inc rcx

	jmp .print

.key_enter:
	test rbx, rbx
	jz   .empty

	mov qword [rsp], rbx

	clc

	jmp .end

.empty:
	stc

.end:
	pop rcx
	pop rsi
	pop rbx
	pop rax

	ret

macro_debug "include_input"
