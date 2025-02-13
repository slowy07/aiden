service_date_event_console:
	push rcx
	push rsi

	mov  ecx, service_date_event_console_file_end - service_date_event_console_file
	mov  rsi, service_date_event_console_file
	call kernel_vfs_path_resolve
	call kernel_vfs_file_find
	call kernel_exec

	pop rsi
	pop rcx

	ret
