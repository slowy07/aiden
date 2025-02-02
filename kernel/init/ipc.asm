kernel_init_ipc:
	mov  ecx, KERNEL_IPC_SIZE_page_default
	call kernel_memory_alloc

	call kernel_page_drain_few

	mov qword [kernel_ipc_base_address], rdi

	mov qword [rdi + STATIC_STRUCTURE_BLOCK.link], rdi
