include_string_cut:
	push rsi
	push rcx

.loop:
	cmp byte [rsi], STATIC_ASCII_TERMINATOR
	je  .end

	cmp byte [rsi], al
	je  .end

	inc rsi

	dec rcx
	jnz .loop

.end:
	sub qword [rsp], rcx

	pop rcx
	pop rsi

	ret

