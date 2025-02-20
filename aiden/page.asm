	[BITS 16]

aiden_page_align_up:
	push edi

	and edi, 0xF000

	cmp edi, dword [esp]
	je  .end

	add edi, 0x1000

.end:
	add esp, 0x04

	ret
