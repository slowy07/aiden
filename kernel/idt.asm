KERNEL_IDT_IRQ_offset equ 0x20

KERNEL_IDT_TYPE_exception equ 0x8E00
KERNEL_IDT_TYPE_irq equ 0x8F00
KERNEL_IDT_TYPE_isr equ 0xEF00

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

kernel_idt_exception_default:
	xchg bx, bx
	nop
	iretq

kernel_idt_exception_general_protection_fault:
	xchg bx, bx
	nop
	nop
	iretq

kernel_idt_exception_page_fault:
	xchg bx, bx
	nop
	nop
	nop
	iretq

kernel_idt_interrupt_hardware:
	push rdi
	mov  rdi, qword [kernel_apic_base_address]
	mov  dword [rdi + KERNEL_APIC_EOI_register], STATIC_EMPTY
	pop  rdi
	iretq

kernel_idt_interrupt_software:
	or word [rsp + KERNEL_STRUCTURE_TASK_IRETQ.eflags], KERNEL_TASK_EFLAGS_cf
	iretq

kernel_idt_spurious_interrupt:
	iretq
