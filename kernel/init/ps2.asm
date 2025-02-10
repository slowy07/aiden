kernel_init_ps2:
	call driver_ps2_check_dummy_answer_or_dump

	mov  al, DRIVER_PS2_COMMAND_CONFIGURATION_GET
	call driver_ps2_send_command_receive_answer

	push rax

	mov  al, DRIVER_PS2_COMMAND_CONFIGURATION_SET
	call driver_ps2_send_command

	bts word [rsp], DRIVER_PS2_CONTROLLER_CONFIGURATION_BIT_SECOND_PORT_INTERRUPT
	btr word [rsp], DRIVER_PS2_CONTROLLER_CONFIGURATION_BIT_SECOND_PORT_CLOCK

	pop rax

	call driver_ps2_send_answer_or_ask_device

	mov  al, DRIVER_PS2_COMMAND_PORT_SECOND_BYTE_SEND
	call driver_ps2_send_command
	mov  al, DRIVER_PS2_DEVICE_RESET
	call driver_ps2_send_answer_or_ask_device

	call driver_ps2_receive_answer
	cmp  al, DRIVER_PS2_ANSWER_COMMAND_ACKNOWLEDGED
	jne  .error

	call driver_ps2_receive_answer

	cmp al, DRIVER_PS2_ANSWER_SELF_TEST_SUCCESS
	jne .error

	call driver_ps2_receive_answer
	mov  byte [driver_ps2_mouse_type], al

	mov  al, DRIVER_PS2_COMMAND_PORT_SECOND_BYTE_SEND
	call driver_ps2_send_command
	mov  al, DRIVER_PS2_DEVICE_SET_DEFAULT
	call driver_ps2_send_answer_or_ask_device
	call driver_ps2_receive_answer

	cmp al, DRIVER_PS2_ANSWER_COMMAND_ACKNOWLEDGED
	jne .error

	mov  al, DRIVER_PS2_COMMAND_PORT_SECOND_BYTE_SEND
	call driver_ps2_send_command
	mov  al, DRIVER_PS2_DEVICE_PACKETS_ENABLE
	call driver_ps2_send_answer_or_ask_device
	call driver_ps2_receive_answer

	cmp al, DRIVER_PS2_ANSWER_COMMAND_ACKNOWLEDGED
	je  .done

.error:
	jmp $

.done:
	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_PS2_MOUSE_IRQ_number
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  rdi, driver_ps2_mouse
	call kernel_idt_mount

	mov eax, KERNEL_IDT_IRQ_offset + DRIVER_PS2_MOUSE_IRQ_number

	mov  ebx, DRIVER_PS2_MOUSE_IO_APIC_register
	call kernel_io_apic_connect

	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_PS2_KEYBOARD_IRQ_number
	mov  bx, KERNEL_IDT_TYPE_irq
	mov  rdi, driver_ps2_keyboard
	call kernel_idt_mount

	mov  eax, KERNEL_IDT_IRQ_offset + DRIVER_PS2_KEYBOARD_IRQ_number
	mov  ebx, DRIVER_PS2_KEYBOARD_IO_APIC_register
	call kernel_io_apic_connect
