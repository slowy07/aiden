kernel_init_smp:
	cmp word [kernel_apic_count], STATIC_TRUE
	jbe .finish

	mov eax, 0x7000
	mov bx, KERNEL_PAGE_FLAG_available | KERNEL_PAGE_FLAG_write
	mov ecx, kernel_init_boot_file_end - kernel_init_boot_file
	mov r11, qword [kernel_page_pml4_address]
	call include_page_from_size
	call kernel_page_map_physical

	mov ecx, kernel_init_boot_file_end - kernel_init_boot_file
	mov rsi, kernel_init_boot_file
	mov rdi, 0x7000
	rep movsb

	mov byte [kernel_init_smp_semaphore], STATIC_TRUE

	mov rdi, qword [kernel_apic_base_address]
	mov eax, dword [rdi + KERNEL_APIC_ID_register]
	shr eax, 24

	mov dl, al

	mov rsi, kernel_apic_id_table

	mov cx, word [kernel_apic_count]

.init:
	dec cx
	js  .init_done

	lodsb

	cmp al, dl
	je  .init

	shl eax, 24
	mov dword [rdi + KERNEL_APIC_ICH_register], eax
	mov eax, 0x00004500
	mov dword [rdi + KERNEL_APIC_ICL_register], eax

.init_wait:
	bt dword [rdi + KERNEL_APIC_ICL_register], KERNEL_APIC_ICL_COMMAND_COMPLETE_bit
	jc .init_wait

	jmp .init

.init_done:
	mov rax, qword [driver_rtc_microtime]
	add rax, 10

.init_wait_for_ipi:
	cmp rax, qword [driver_rtc_microtime]
	ja  .init_wait_for_ipi

	mov rsi, kernel_apic_id_table

	mov cx, word [kernel_apic_count]

.start:
	dec cx
	js  .finish

	lodsb

	cmp al, dl
	je  .start

	shl eax, 24
	mov dword [rdi + KERNEL_APIC_ICH_register], eax
	mov eax, 0x00004607
	mov dword [rdi + KERNEL_APIC_ICL_register], eax

.start_wait:
	bt dword [rdi + KERNEL_APIC_ICL_register], KERNEL_APIC_ICL_COMMAND_COMPLETE_bit
	jc .start_wait

	jmp .start

.finish:
