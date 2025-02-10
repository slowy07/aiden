include_string_to_integer:
	push rbx
	push rcx
	push rdx
	push rsi
	push r8
	push rax

	mov ebx, 1

	xor r8, r8

.loop:
	movzx eax, byte [rsi + rcx - 0x01]
	sub   al, STATIC_ASCII_DIGIT_0
	mul   rbx

	add r8, rax

	mov eax, 10
	mul rbx
	mov rbx, rax

	dec rcx
	jnz .loop

	mov qword [rsp], r8

	pop rax
	pop r8
	pop rsi
	pop rdx
	pop rcx
	pop rbx

	ret

