kernel_init_vfs:
	call kernel_memory_alloc_page
	jc   kernel_init_panic_low_memory

	call kernel_page_drain
	mov  qword [kernel_vfs_magicknot + KERNEL_STRUCTURE_VFS_MAGICKNOT.root], rdi

	mov rdi, kernel_vfs_magicknot

	mov  rsi, rdi
	call kernel_vfs_dir_symlinks
