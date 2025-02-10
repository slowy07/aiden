include_input:
	push rax
	push rbx
	push rsi
	push rcx

	cmp rbx, STATIC_EMPTY
	je  .loop

	mov ax, KERNEL_SERVICE_VIDEO_string
	mov rcx, rbx
	int KERNEL_SERVICE

	mov rcx, qword [rsp]

	sub rcx, rbx

	add rsi, rbx

.loop:
	mov ax, KERNEL_SERVICE_KEYBOARD_key
	int KERNEL_SERVICE
	jz  .loop

	cmp ax, STATIC_ASCII_BACKSPACE
	je  .key_backspace

	cmp ax, STATIC_ASCII_ENTER
	je  .key_enter

	cmp ax, STATIC_ASCII_ESCAPE
	je  .empty

	cmp ax, STATIC_ASCII_SPACE
	jb  .loop
	cmp ax, STATIC_ASCII_TILDE
	ja  .loop

	cmp rcx, STATIC_EMPTY
	je  .loop

	mov byte [rsi + rbx], al

	inc rbx

	dec rcx

.print:
	push rcx

	mov  edx, KERNEL_SERVICE_VIDEO_char
	xchg dx, ax
	mov  ecx, 1
	int  KERNEL_SERVICE

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
