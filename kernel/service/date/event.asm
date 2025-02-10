service_date_event_console:
	push	rcx
	push	rsi

	mov	ecx,	kernel_init_vfs_files.console_end - kernel_init_vfs_files.console
	mov	rsi,	kernel_init_vfs_files.console
	call	kernel_vfs_path_resolve
	call	kernel_vfs_file_find
	call	kernel_exec

	pop	rsi
	pop	rcx

	ret
