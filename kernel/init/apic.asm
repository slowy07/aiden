kernel_init_apic:
	mov rsi, qword [kernel_apic_base_address]

	mov dword [rsi + KERNEL_APIC_TP_register], STATIC_EMPTY

	mov dword [rsi + KERNEL_APIC_DF_register], KERNEL_APIC_DF_FLAG_flat_mode

	mov dword [rsi + KERNEL_APIC_LD_register], KERNEL_APIC_LD_FLAG_target_cpu

	mov eax, dword [rsi + KERNEL_APIC_SIV_register]
	or  eax, KERNEL_APIC_SIV_FLAG_enable_apic | KERNEL_APIC_SIV_FLAG_spurious_vector
	mov dword [rsi + KERNEL_APIC_SIV_register], eax

	mov eax, dword [rsi + KERNEL_APIC_LVT_TR_register]
	and eax, ~KERNEL_APIC_LVT_TR_FLAG_mask_interrupts
	mov dword [rsi + KERNEL_APIC_LVT_TR_register], eax

	mov dword [rsi + KERNEL_APIC_LVT_TR_register], KERNEL_APIC_IRQ_number

	mov dword [rsi + KERNEL_APIC_TDC_register], KERNEL_APIC_TDC_divide_by_16

	ret
