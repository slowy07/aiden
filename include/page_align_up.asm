include_page_align_up:
	push rdi

	and di, KERNEL_PAGE_mask

	cmp rdi, qword [rsp]
	je  .end

	add rdi, KERNEL_PAGE_SIZE_byte

.end:
	add rsp, STATIC_QWORD_SIZE_byte

	ret

