kernel_init_rtc:
	mov al, DRIVER_RTC_PORT_STATUS_REGISTER_A
	out DRIVER_RTC_PORT_command, al
	in  al, DRIVER_RTC_PORT_data

	test al, DRIVER_RTC_PORT_STATUS_REGISTER_A_update_in_progress
	jne  kernel_init_rtc

	mov al, DRIVER_RTC_PORT_STATUS_REGISTER_A
	out DRIVER_RTC_PORT_command, al
	mov al, DRIVER_RTC_PORT_STATUS_REGISTER_A_rate | DRIVER_RTC_PORT_STATUS_REGISTER_A_divider
	out DRIVER_RTC_PORT_data, al

	mov al, DRIVER_RTC_PORT_STATUS_REGISTER_B
	out DRIVER_RTC_PORT_command, al
	mov al, DRIVER_RTC_PORT_STATUS_REGISTER_B_24_hour_mode | DRIVER_RTC_PORT_STATUS_REGISTER_B_binary_mode | DRIVER_RTC_PORT_STATUS_REGISTER_B_periodic_interrupt
	out DRIVER_RTC_PORT_data, al

	mov al, DRIVER_RTC_PORT_STATUS_REGISTER_C
	out DRIVER_RTC_PORT_command, al

	in al, DRIVER_RTC_PORT_data

	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_RTC_IRQ_number
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  rdi, driver_rtc
	call kernel_idt_mount

	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_RTC_IRQ_number
	mov  ebx, DRIVER_RTC_IO_APIC_register
	call kernel_io_apic_connect

	sti
