kernel_init_video:
	call kernel_video_dump
	mov  ecx, kernel_init_string_video_welcome_end - kernel_init_string_video_welcome
	mov  rsi, kernel_init_string_video_welcome
	call kernel_video_string
