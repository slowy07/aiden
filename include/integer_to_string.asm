include_integer_to_string:
	push rax
	push rcx
	push rdx
	push rdi
	push rbp
	push r9

	cmp rbx, 2
	jb  .error
	cmp rbx, 36
	ja  .error

	mov r9, rdx

	xor rdx, rdx

	mov rbp, rsp

.loop:
	div rbx

	add  rdx, STATIC_ASCII_DIGIT_0
	push rdx

	dec rcx

	xor rdx, rdx

	test rax, rax
	jnz  .loop

	cmp rcx, STATIC_EMPTY
	jle .return

.prefix:
	push r9

	dec rcx
	jnz .prefix

.return:
	cmp rsp, rbp
	je  .end

	pop rax

	cmp al, 0x3A
	jb  .no

	add al, 0x07

.no:
	stosb

	jmp .return

.error:
	stc

.end:
	pop r9
	pop rbp
	pop rdi
	pop rdx
	pop rcx
	pop rax

	ret
