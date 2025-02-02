include_string_word_next:
	push rax
	push rcx

	test rcx, rcx
	jz   .not_found

.find:
	cmp byte [rsi], STATIC_ASCII_TERMINATOR
	je  .not_found

	cmp byte [rsi], STATIC_ASCII_NEW_LINE
	je  .leave

	cmp byte [rsi], STATIC_ASCII_SPACE
	je  .leave

	cmp byte [rsi], STATIC_ASCII_TAB
	jne .char

.leave:
	inc rsi

	dec rcx
	jnz .find

	jmp .not_found

.char:
	push rsi

	xor rax, rax

.count:
	cmp byte [rsi], STATIC_ASCII_TERMINATOR
	je  .ready

	cmp byte [rsi], STATIC_ASCII_NEW_LINE
	je  .ready

	cmp byte [rsi], STATIC_ASCII_SPACE
	je  .ready

	cmp byte [rsi], STATIC_ASCII_TAB
	je  .ready

	inc rsi

	inc rax

	dec rcx
	jnz .count

.ready:
	pop rsi

	mov rbx, rax

	clc

	jmp .end

.not_found:
	stc

.end:
	pop rcx
	pop rax

	ret

macro_debug "include_string_word_next"
