service_render_string_error_memory_low db "RENDER: no enough memory."

service_render_string_error_memory_low_end:

service_render_panic_memory_low:
	mov  ecx, service_render_string_error_memory_low_end - service_render_string_error_memory_low
	mov  rsi, service_render_string_error_memory_low
	call kernel_video_string

	jmp $
