kernel_exec:
	push rax
	push rbx
	push rdx
	push rsi
	push rbp
	push r8
	push r11
	push rcx
	push rdi

	mov  rcx, qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.size]
	call include_page_from_size

	add  rcx, 14
	call kernel_page_secure

	mov rbp, rcx

	call kernel_memory_alloc_page
	call kernel_page_drain

	mov r11, rdi

	mov  rax, KERNEL_MEMORY_HIGH_VIRTUAL_address
	mov  ebx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write | KERNEL_PAGE_FLAG_user
	call kernel_page_map_logical

	mov  rax, (KERNEL_MEMORY_HIGH_VIRTUAL_address << STATIC_MULTIPLE_BY_2_shift) - KERNEL_PAGE_SIZE_byte
	mov  rcx, KERNEL_PAGE_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	call kernel_page_map_logical

	mov  rax, KERNEL_STACK_address
	mov  rbx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  rcx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	call kernel_page_map_logical

	mov  rsi, qword [kernel_page_pml4_address]
	mov  rdi, r11
	call kernel_page_merge

	mov rdi, qword [r8]
	and di, KERNEL_PAGE_mask
	add rdi, KERNEL_PAGE_SIZE_byte - (STATIC_QWORD_SIZE_byte * 0x05)

	mov rax, KERNEL_MEMORY_HIGH_REAL_address
	stosq

	mov rax, KERNEL_STRUCTURE_GDT.cs_ring3 | 0x03
	stosq

	mov rax, KERNEL_TASK_EFLAGS_default
	stosq

	mov rax, STATIC_EMPTY
	stosq

	mov rax, KERNEL_STRUCTURE_GDT.ds_ring3 | 0x03
	stosq

	mov rsi, qword [rsp]

	mov rax, cr3
	mov cr3, r11

	mov  rdi, SOFTWARE_BASE_address
	call kernel_vfs_file_read

	mov cr3, rax

	mov  ebx, KERNEL_TASK_FLAG_active
	call kernel_task_add

	add qword [kernel_page_free_count], rbp
	sub qword [kernel_page_reserved_count], rbp

	mov qword [rsp + STATIC_QWORD_SIZE_byte], rcx

	pop rdi
	pop rcx
	pop r11
	pop r8
	pop rbp
	pop rsi
	pop rdx
	pop rbx
	pop rax

	ret
