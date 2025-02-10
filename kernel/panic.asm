kernel_panic:
	mov ah, 0x0C

	mov edi, 0x000B8000

.loop:
	lodsb

	stosw
	dec ecx
	jnz .loop

	jmp $

macro_debug "kernel_panic"
