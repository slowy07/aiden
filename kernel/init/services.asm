struc    KERNEL_INIT_STRUCTURE_SERVICE
.pointer resb 8
.length  resb 1

.name:
	endstruc

kernel_init_services:
	mov rsi, kernel_init_services_list

.loop:
	call kernel_memory_alloc_page
	jc kernel_panic_memory

	call kernel_page_drain

	mov  rax, KERNEL_STACK_address
	mov  rbx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  rcx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	mov  r11, rdi
	call kernel_page_map_logical

	mov rdi, qword [r8]
	and di, KERNEL_PAGE_mask
	add rdi, KERNEL_PAGE_SIZE_byte - ( STATIC_QWORD_SIZE_byte * 0x05 )

	mov rax, qword [rsi + KERNEL_INIT_STRUCTURE_SERVICE.pointer]
	stosq

	mov rax, KERNEL_STRUCTURE_GDT.cs_ring0
	stosq

	mov rax, KERNEL_TASK_EFLAGS_default
	stosq

	mov rax, KERNEL_STACK_pointer
	stosq

	mov rax, KERNEL_STRUCTURE_GDT.ds_ring0
	stosq

	push rsi

	mov  rsi, qword [kernel_page_pml4_address]
	mov  rdi, r11
	call kernel_page_merge

	pop rsi

	mov   bx, KERNEL_TASK_FLAG_active | KERNEL_TASK_FLAG_service | KERNEL_TASK_FLAG_secured
	movzx ecx, byte [rsi + KERNEL_INIT_STRUCTURE_SERVICE.length]
	add   rsi, KERNEL_INIT_STRUCTURE_SERVICE.name
	push  rcx
	call  kernel_task_add

	pop rcx
	add rsi, rcx
	cmp qword [rsi], STATIC_EMPTY
	jne .loop
