service_network_checksum:
	push rbx
	push rcx
	push rdi

	xor  ebx, ebx
	xchg rbx, rax

.calculate:
	mov ax, word [rdi]
	rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift

	add rbx, rax

	add rdi, STATIC_WORD_SIZE_byte

	loop .calculate

	mov ax, bx
	shr ebx, STATIC_MOVE_HIGH_TO_AX_shift
	add rax, rbx

	not ax

	pop rdi
	pop rcx
	pop rbx

	ret

macro_debug "service_network_checksum"

service_network_checksum_part:
	push rbx
	push rcx
	push rdi

	xor ebx, ebx

.calculate:
	mov bx, word [rdi]
	rol bx, STATIC_REPLACE_AL_WITH_HIGH_shift

	add rax, rbx

	add rdi, STATIC_WORD_SIZE_byte

	loop .calculate

	pop rdi
	pop rcx
	pop rbx

	ret

macro_debug "service_network_checksum_part"
