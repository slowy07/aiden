service_date_taskbar:
	;   Load the last modification time of the service render object list
	mov rax, qword [service_render_object_list_modify_time]
	;   Compare it with the stored modification time of the taskbar window
	cmp qword [service_date_window_taskbar_modify_time], rax
	je  .end; If they are equal, no update is needed, so exit

	; Acquire a lock on the service render object semaphore to ensure thread safety
	macro_lock service_render_object_semaphore, 0

	;   Reset the semaphore to indicate that the taskbar update is complete
	mov byte [service_render_object_semaphore], STATIC_FALSE

.end:
	ret
