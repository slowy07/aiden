service_network_checksum:
	; Save registers
	push rbx
	push rcx
	push rdi

	; Clear RBX and exchange RAX with RBX (RAX now holds the initial checksum value, RBX is cleared)
	xor  ebx, ebx
	xchg rbx, rax

.calculate:
	; Load a word (2 bytes) from the memory pointed to by RDI into AX
	mov ax, word [rdi]
	; Rotate the bits in AX left by 8 (swap high and low bytes)
	rol ax, STATIC_REPLACE_AL_WITH_HIGH_shift

	; Add the rotated word to the checksum in RBX
	add rbx, rax

	; Move RDI to the next word (2 bytes) in memory
	add rdi, STATIC_WORD_SIZE_byte

	; Loop until RCX reaches 0
	loop .calculate

	; Fold the 32-bit checksum in RBX into a 16-bit checksum in AX
	mov ax, bx ; Move the lower 16 bits of RBX into AX
	shr ebx, STATIC_MOVE_HIGH_TO_AX_shift ; Shift the upper 16 bits of RBX into BX
	add rax, rbx ; Add the upper 16 bits to AX

	; Take the one's complement of the checksum in AX
	not ax

	; Restore registers
	pop rdi
	pop rcx
	pop rbx

	; Return from the function
	ret

; Debug macro to mark the end of the checksum function
macro_debug "service_network_checksum"

service_network_checksum_part:
	; Save registers
	push rbx
	push rcx
	push rdi

	; Clear RBX
	xor ebx, ebx

.calculate:
	; Load a word (2 bytes) from the memory pointed to by RDI into BX
	mov bx, word [rdi]
	; Rotate the bits in BX left by 8 (swap high and low bytes)
	rol bx, STATIC_REPLACE_AL_WITH_HIGH_shift

	; Add the rotated word to the checksum in RAX
	add rax, rbx

	; Move RDI to the next word (2 bytes) in memory
	add rdi, STATIC_WORD_SIZE_byte

	; Loop until RCX reaches 0
	loop .calculate

	; Restore registers
	pop rdi
	pop rcx
	pop rbx

	; Return from the function
	ret

; Debug macro to mark the end of the partial checksum function
macro_debug "service_network_checksum_part"