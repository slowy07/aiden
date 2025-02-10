kernel_thread:
	push rax
	push rbx
	push rcx
	push rdx
	push rdi
	push r8
	push r11

	call kernel_memory_alloc_page
	jc   .end

	call kernel_page_drain

	mov  rax, KERNEL_STACK_address
	mov  ebx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  ecx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	mov  r11, rdi
	call kernel_page_map_logical

	mov rdi, qword [r8]
	and di, KERNEL_PAGE_mask
	add rdi, KERNEL_PAGE_SIZE_byte - ( STATIC_QWORD_SIZE_byte * 0x05 )

	mov rax, qword [rsp + STATIC_QWORD_SIZE_byte * 0x02]
	stosq

	mov rax, KERNEL_STRUCTURE_GDT.cs_ring0
	stosq

	mov rax, KERNEL_TASK_EFLAGS_default
	stosq

	mov rax, KERNEL_STACK_pointer
	stosq

	mov rax, KERNEL_STRUCTURE_GDT.ds_ring0
	stosq

	mov qword [rdi - STATIC_QWORD_SIZE_byte * 0x0B], rsi

	mov  rsi, cr3
	mov  rdi, r11
	call kernel_page_merge

	mov  bx, KERNEL_TASK_FLAG_active | KERNEL_TASK_FLAG_thread | KERNEL_TASK_FLAG_secured
	call kernel_task_add

.end:
	pop rdi
	pop r8
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_thread"
