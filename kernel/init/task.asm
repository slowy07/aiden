
kernel_init_task:

	movzx	ecx,	byte [kernel_init_apic_id_highest]
	inc	cx

	shl	ecx,	STATIC_MULTIPLE_BY_8_shift

	call	include_page_from_size

	call	kernel_memory_alloc
	jc	kernel_init_panic_low_memory

	mov	qword [kernel_task_active_list],	rdi

	mov	rsi,	rdi

	call	kernel_memory_alloc_page
	jc	kernel_init_panic_low_memory

	call	kernel_page_drain

	mov	qword [kernel_task_address],	rdi

	mov	qword [rdi + STATIC_STRUCTURE_BLOCK.link],	rdi

	call	kernel_apic_id_get

	shl	rax,	STATIC_MULTIPLE_BY_8_shift
	mov	qword [rsi + rax],	rdi

	mov	ebx,	KERNEL_TASK_FLAG_active | KERNEL_TASK_FLAG_daemon | KERNEL_TASK_FLAG_secured | KERNEL_TASK_FLAG_processing
	mov	r11,	qword [kernel_page_pml4_address]
	call	kernel_task_add

	mov	rax,	KERNEL_APIC_IRQ_number
	mov	bx,	KERNEL_IDT_TYPE_irq
	mov	rdi,	kernel_task
	call	kernel_idt_mount
