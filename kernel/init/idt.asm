struc    KERNEL_STRUCTURE_IDT_HEADER
.limit   resb 2
.address resb 8
endstruc

kernel_init_idt:
	call kernel_memory_alloc_page
  jc kernel_panic_memory

	call kernel_page_drain
	mov  qword [kernel_idt_header + KERNEL_STRUCTURE_IDT_HEADER.address], rdi

	mov  rax, kernel_idt_exception_default
	mov  bx, KERNEL_IDT_TYPE_exception
	mov  ecx, 32
	call kernel_idt_update

	mov  rax, kernel_idt_interrupt_hardware
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  ecx, 16
	call kernel_idt_update

	mov  rax, kernel_idt_interrupt_software
	mov  bx, KERNEL_IDT_TYPE_isr
	mov  ecx, 208
	call kernel_idt_update

	mov eax, 0x0D
	mov bx, KERNEL_IDT_TYPE_exception
	mov rdi, kernel_idt_exception_general_protection_fault

	mov eax, 0x0E
	mov bx, KERNEL_IDT_TYPE_exception
	mov rdi, kernel_idt_exception_page_fault

	mov  eax, 0x40
	mov  bx, KERNEL_IDT_TYPE_isr
	mov  rdi, kernel_service
	call kernel_idt_mount

	mov  eax, 0xFF
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  rdi, kernel_idt_spurious_interrupt
	call kernel_idt_mount

	lidt [kernel_idt_header]
