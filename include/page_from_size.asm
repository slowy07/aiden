include_page_from_size:
	push rcx

	and cx, KERNEL_PAGE_mask

	cmp rcx, qword [rsp]
	je  .ready

	add rcx, KERNEL_PAGE_SIZE_byte

.ready:
	shr rcx, STATIC_DIVIDE_BY_PAGE_shift

	add rsp, STATIC_QWORD_SIZE_byte

	ret
