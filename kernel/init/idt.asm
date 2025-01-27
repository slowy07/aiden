struc    KERNEL_STRUCTURE_IDT_HEADER
.limit   resb 2
.address resb 8
endstruc

kernel_init_idt:
	call kernel_memory_alloc_page
	jc   kernel_init_panic_low_memory

	call kernel_page_drain
	mov  qword [kernel_idt_header + KERNEL_STRUCTURE_IDT_HEADER.address], rdi

	mov  rax, kernel_idt_exception_default
	mov  bx, KERNEL_IDT_TYPE_exception
	mov  ecx, 32
	call kernel_idt_update

	mov  rax, 255
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  rdi, kernel_idt_spurious_interrupt
	call kernel_idt_mount

	lidt [kernel_idt_header]
