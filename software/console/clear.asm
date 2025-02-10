console_clear:
	push rax
	push rcx
	push rdx
	push rdi

	mov rdi, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.address]

	mov rax, qword [console_window.element_draw_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT_DRAW.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
	mul qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.scanline]
	add rdi, rax

	mov rax, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.scanline]
	mul qword [console_window.element_draw_0 + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
	shr rax, KERNEL_VIDEO_DEPTH_shift

	mov rcx, rax
	mov eax, CONSOLE_WINDOW_BACKGROUND_color
	rep stosd

	pop rdi
	pop rdx
	pop rcx
	pop rax

	ret
