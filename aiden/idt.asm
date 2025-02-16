AIDEN_IDT_address equ 0x9000
AIDEN_IDT_TYPE_exception equ 0x8E00
AIDEN_IDT_TYPE_irq equ 0x8F00

struc    AIDEN_STRUCTURE_IDT_HEADER
.limit   resb 2
.address resb 8
endstruc

aiden_idt:
	mov edi, AIDEN_IDT_address

	mov  rax, aiden_idt_default_exception
	mov  bx, AIDEN_IDT_TYPE_exception
	mov  ecx, 32
	call aiden_idt_set

	mov  rax, aiden_idt_clock
	mov  bx, AIDEN_IDT_TYPE_irq
	mov  ecx, 1
	call aiden_idt_set

	mov  rax, aiden_idt_default_interrupt
	mov  ecx, 15
	call aiden_idt_set

	lidt [aiden_idt_header]
	sti

	jmp aiden_idt_end

aiden_idt_default_exception:
	iretq

aiden_idt_default_interrupt:
	push rax

	mov al, 0x20
	out 0x20, al

	pop rax

	iretq

aiden_idt_clock:
	push rax

	inc qword [aiden_microtime]

	mov al, 0x20
	out 0x20, al

	pop rax

	iretq

aiden_idt_set:
	push rcx

.next:
	push rax

	stosw

	mov ax, 0x08
	stosw

	mov ax, bx
	stosw

	mov rax, qword [rsp]

	shr rax, 16
	stosw

	shr rax, 32
	stosd

	xor eax, eax
	stosd

	pop rax

	dec rcx
	jnz .next

	pop rcx

	ret

aiden_idt_end:
