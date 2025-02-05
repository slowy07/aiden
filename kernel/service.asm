kernel_service:
	cmp al, KERNEL_SERVICE_PROCESS
	je  .process

	cmp al, KERNEL_SERVICE_VIDEO
	je  .video

.end:
	iretq

.process:
	cmp ax, KERNEL_SERVICE_PROCESS_exit
	je  kernel_task_kill

	jmp kernel_service.end

.video:
	cmp ax, KERNEL_SERVICE_VIDEO_string
	jne .video_no_string

	call kernel_video_string

	jmp kernel_service.end

.video_no_string:
	jmp kernel_service.end
