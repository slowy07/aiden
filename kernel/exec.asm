kernel_exec:
	push rbx
	push rdx
	push rsi
	push rbp
	push r8
	push r11
	push r12
	push r13
	push rax
	push rcx
	push rdi

	mov  rcx, qword [rdi + KERNEL_VFS_STRUCTURE_KNOT.size]
	call include_page_from_size

	mov r12, rcx

	add  rcx, 14
	call kernel_page_secure
	jc   .error

	mov rbp, rcx

	call kernel_memory_alloc_page
	call kernel_page_drain

	inc qword [kernel_page_paged_count]

	mov r11, rdi

	mov  rax, KERNEL_MEMORY_HIGH_VIRTUAL_address
	mov  bx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write | KERNEL_PAGE_FLAG_user
	mov  rcx, r12
	call kernel_page_map_logical
	jc   .error

	shl  r12, KERNEL_PAGE_SIZE_shift
	add  rax, r12
	and  bx, ~KERNEL_PAGE_FLAG_user
	mov  rcx, KERNEL_MEMORY_MAP_SIZE_page
	call kernel_page_map_logical

	mov r13, rax

	mov  rdi, qword [r8]
	and  di, KERNEL_PAGE_mask
	push rdi

	mov rax, STATIC_MAX_unsigned
	mov ecx, (KERNEL_MEMORY_MAP_SIZE_page << KERNEL_PAGE_SIZE_shift) >> STATIC_DIVIDE_BY_QWORD_shift
	rep stosq

	pop  rsi
	mov  rcx, r12
	shr  rcx, KERNEL_PAGE_SIZE_shift
	add  rcx, KERNEL_MEMORY_MAP_SIZE_page
	call kernel_memory_secure

	mov  rax, (KERNEL_MEMORY_HIGH_VIRTUAL_address << STATIC_MULTIPLE_BY_2_shift) - KERNEL_PAGE_SIZE_byte
	or   bx, KERNEL_PAGE_FLAG_user
	mov  rcx, KERNEL_PAGE_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	call kernel_page_map_logical
	jc   .error

	mov  rax, KERNEL_STACK_address
	mov  rbx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  rcx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	call kernel_page_map_logical
	jc   .error

	mov  rsi, qword [kernel_page_pml4_address]
	mov  rdi, r11
	call kernel_page_merge

	mov rdi, qword [r8]
	and di, KERNEL_PAGE_mask
	add rdi, KERNEL_PAGE_SIZE_byte - ( STATIC_QWORD_SIZE_byte * 0x05 )

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

	mov  rdi, SOFTWARE_base_address
	call kernel_vfs_file_read

	mov cr3, rax

	xor   bx, bx
	movzx ecx, byte [rsi + KERNEL_VFS_STRUCTURE_KNOT.length]
	add   rsi, KERNEL_VFS_STRUCTURE_KNOT.name
	call  kernel_task_add
	jc    .error

	add r13, qword [kernel_memory_high_mask]
	mov qword [rdi + KERNEL_TASK_STRUCTURE.map], r13
	mov qword [rdi + KERNEL_TASK_STRUCTURE.map_size], (KERNEL_MEMORY_MAP_SIZE_page << KERNEL_PAGE_SIZE_shift) << STATIC_MULTIPLE_BY_8_shift

	or word [rdi + KERNEL_TASK_STRUCTURE.flags], KERNEL_TASK_FLAG_active

	add qword [kernel_page_free_count], rbp
	sub qword [kernel_page_reserved_count], rbp

	mov qword [rsp + STATIC_QWORD_SIZE_byte], rcx

	jmp .end

.error:
	mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x03], rax

.end:
	pop rdi
	pop rcx
	pop rax
	pop r13
	pop r12
	pop r11
	pop r8
	pop rbp
	pop rsi
	pop rdx
	pop rbx

	ret

macro_debug "kernel_exec"
