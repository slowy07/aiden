kernel_init_ps2:
	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_PS2_KEYBOARD_IRQ_number
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  rdi, driver_ps2_keyboard
	call kernel_idt_mount

	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_PS2_KEYBOARD_IRQ_number
	mov  ebx, DRIVER_PS2_KEYBOARD_IO_APIC_register
	call kernel_io_apic_connect
