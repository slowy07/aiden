kernel_init_semaphore db STATIC_TRUE

kernel_init_exec db "/bin/init"

kernel_init_exec_end:

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING
	kernel_gdt_header     dw KERNEL_PAGE_SIZE_byte
	dq    STATIC_EMPTY

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING
	kernel_gdt_tss_bsp_selector    dw STATIC_EMPTY
	kernel_gdt_tss_cpu_selector    dw STATIC_EMPTY

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

kernel_gdt_tss_table:
	dd    STATIC_EMPTY
	dq    KERNEL_STACK_pointer
	times 92 db STATIC_EMPTY

kernel_gdt_tss_table_end:

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

kernel_idt_header:
	dw KERNEL_PAGE_SIZE_byte
	dq STATIC_EMPTY

	macro_debug "kernel_data"
