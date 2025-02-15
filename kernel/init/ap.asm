lgdt [kernel_gdt_header]

mov eax, 1010100000b
mov cr4, eax

mov eax, dword [kernel_page_pml4_address]
mov cr3, eax

mov ecx, 0xC0000080
rdmsr
or  eax, 100000000b
wrmsr

mov eax, cr0
or  eax, 0x80000001
mov cr0, eax

	jmp 0x0008:.long_mode

	[BITS 64]

.long_mode:
	mov rax, qword [kernel_apic_base_address]
	mov dword [rax + KERNEL_APIC_TP_register], STATIC_EMPTY
	mov eax, dword [rax + KERNEL_APIC_ID_register]
	shr eax, 24

	shl eax, STATIC_MULTIPLE_BY_16_shift
	add ax, word [kernel_gdt_tss_bsp_selector]
	mov word [kernel_gdt_tss_cpu_selector], ax
	ltr word [kernel_gdt_tss_cpu_selector]

	lidt [kernel_idt_header]

.wait:
	mov  al, STATIC_TRUE
	lock xchg byte [kernel_init_ap_semaphore], al
	test al, al
	jz   .wait

	mov rsp, KERNEL_STACK_TEMPORARY_pointer

	call kernel_memory_alloc_page
	jc   kernel_panic_memory

	call kernel_page_drain

	inc qword [kernel_page_paged_count]

	mov  rax, KERNEL_STACK_address
	mov  ebx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov  ecx, KERNEL_STACK_SIZE_byte >> STATIC_DIVIDE_BY_PAGE_shift
	mov  r11, rdi
	xor  ebp, ebp
	call kernel_page_map_logical

	mov  rsi, qword [kernel_page_pml4_address]
	call kernel_page_merge

	mov rax, rdi
	mov cr3, rax

	mov rsp, KERNEL_STACK_pointer

	mov byte [kernel_init_ap_semaphore], STATIC_FALSE

	call kernel_init_apic

	cld

	call kernel_apic_id_get

	mov rbx, rax
	shl rbx, STATIC_MULTIPLE_BY_8_shift
	mov rsi, qword [kernel_task_active_list]

	mov rdi, qword [kernel_task_address]

	inc byte [kernel_init_ap_count]

	jmp kernel_task.ap_entry
