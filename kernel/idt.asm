KERNEL_IDT_IRQ_offset equ 0x20

KERNEL_IDT_TYPE_exception equ 0x8E00
KERNEL_IDT_TYPE_irq equ 0x8F00
KERNEL_IDT_TYPE_isr equ 0xEF00

kernel_idt_string_exception_default db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_RED_LIGHT, "IDT: exception default", STATIC_ASCII_NEW_LINE

kernel_idt_string_exception_default_end:
	kernel_idt_string_exception_gpf  db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_RED_LIGHT, "IDT: exception general protection fault", STATIC_ASCII_NEW_LINE

kernel_idt_string_exception_gpf_end:
	kernel_idt_string_exception_page_fault db STATIC_ASCII_NEW_LINE, STATIC_COLOR_ASCII_RED_LIGHT, "IDT: exception page fault", STATIC_ASCII_NEW_LINE

kernel_idt_string_exception_page_fault_end:

kernel_idt_mount:
	push rax
	push rbx
	push rcx
	push rdi

	xchg rax, rdi

	shl rdi, STATIC_MULTIPLE_BY_16_shift
	add rdi, qword [kernel_idt_header + KERNEL_STRUCTURE_IDT_HEADER.address]

	mov  rcx, 1
	call kernel_idt_update

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

macro_debug "kernel_idt_mount"

kernel_idt_update:
	push rcx

.next:
	push rax

	stosw

	mov ax, KERNEL_STRUCTURE_GDT.cs_ring0
	stosw

	mov ax, bx
	stosw
	mov rax, qword [rsp]

	shr rax, STATIC_MOVE_HIGH_TO_AX_shift
	stosw

	shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
	stosd

	xor eax, eax
	stosd

	pop rax

	dec rcx
	jnz .next

	pop rcx

	ret

macro_debug "kernel_idt_update"

kernel_idt_exception_default:
	jmp kernel_debug

macro_debug "kernel_idt_exception_default"

kernel_idt_exception_general_protection_fault:
	mov  ecx, kernel_idt_string_exception_gpf_end - kernel_idt_string_exception_gpf
	mov  rsi, kernel_idt_string_exception_gpf
	call kernel_video_string

	xchg bx, bx

	nop
	nop

	jmp $

macro_debug "kernel_idt_exception_general_protection_fault"

kernel_idt_exception_page_fault:
	push rcx
	push rsi

	mov  ecx, kernel_idt_string_exception_page_fault_end - kernel_idt_string_exception_page_fault
	mov  rsi, kernel_idt_string_exception_page_fault
	call kernel_video_string

	xchg bx, bx

	nop
	nop
	nop

	jmp $

macro_debug "kernel_idt_exception_page_fault"

kernel_idt_interrupt_hardware:
	push rdi

	mov rdi, qword [kernel_apic_base_address]
	mov dword [rdi + KERNEL_APIC_EOI_register], STATIC_EMPTY

	pop rdi

	iretq

	macro_debug "kernel_idt_interrupt_hardware"

kernel_idt_interrupt_software:
	or word [rsp + KERNEL_TASK_STRUCTURE_IRETQ.eflags], KERNEL_TASK_EFLAGS_cf

	iretq

	macro_debug "kernel_idt_interrupt_software"

kernel_idt_spurious_interrupt:
	iretq

	macro_debug "kernel_idt_spurious_interrupt"
