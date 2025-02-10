KERNEL_IO_APIC_ioregsel equ 0x00
KERNEL_IO_APIC_iowin equ 0x10
KERNEL_IO_APIC_iowin_low equ 0x00
KERNEL_IO_APIC_iowin_high equ 0x01

KERNEL_IO_APIC_TRIGER_MODE_level equ 1000000000000000b

kernel_io_apic_base_address dq STATIC_EMPTY

kernel_io_apic_connect:
	push rax
	push rbx
	push rdi

	mov rdi, qword [kernel_io_apic_base_address]

	add ebx, KERNEL_IO_APIC_iowin_low
	mov dword [rdi + KERNEL_IO_APIC_ioregsel], ebx

	mov dword [rdi + KERNEL_IO_APIC_iowin], eax

	add ebx, KERNEL_IO_APIC_iowin_high - KERNEL_IO_APIC_iowin_low
	mov dword [rdi + KERNEL_IO_APIC_ioregsel], ebx

	shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
	mov dword [rdi + KERNEL_IO_APIC_iowin], eax

	pop rdi
	pop rbx
	pop rax

	ret

macro_debug "kernel_io_apic_connect"
