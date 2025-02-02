include_string_trim:
	push rcx
	push rsi

	test rcx, rcx
	jz   .error

.prefix:
	cmp byte [rsi], STATIC_ASCII_SPACE
	je  .prefix_found

	cmp byte [rsi], STATIC_ASCII_TAB
	je  .prefix_found

	cmp byte [rsi], STATIC_EMPTY
	jne .prefix_ready

.prefix_found:
	inc rsi

	dec rcx
	jnz .prefix

	jmp .error

.prefix_ready:
	add rsi, rcx

.suffix:
	cmp byte [rsi - STATIC_BYTE_SIZE_byte], STATIC_ASCII_SPACE
	je  .suffix_found

	cmp byte [rsi - STATIC_BYTE_SIZE_byte], STATIC_ASCII_TAB
	je  .suffix_found

	cmp byte [rsi - STATIC_BYTE_SIZE_byte], STATIC_EMPTY
	jne .suffix_ready

.suffix_found:
	dec rsi

	dec rcx
	jnz .suffix

	jmp .error

.suffix_ready:
	sub rsi, rcx

	mov qword [rsp], rsi
	mov qword [rsp + STATIC_QWORD_SIZE_byte], rcx

	clc

	jmp .end

.error:
	stc

.end:
	pop rsi
	pop rcx

	ret

macro_debug "include_string_trim"
