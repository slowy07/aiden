KERNEL_INIT_MEMORY_MULTIBOOT_FLAG_video equ 12

kernel_init_video:
	push rbx

	bt  dword [ebx + MULTIBOOT_HEADER.flags], KERNEL_INIT_MEMORY_MULTIBOOT_FLAG_video
	jnc kernel_panic

	mov edi, dword [ebx + MULTIBOOT_HEADER.framebuffer_addr]
	mov qword [kernel_video_base_address], rdi

	mov eax, dword [ebx + MULTIBOOT_HEADER.framebuffer_width]
	mov qword [kernel_video_width_pixel], rax
	mov eax, dword [ebx + MULTIBOOT_HEADER.framebuffer_height]
	mov qword [kernel_video_height_pixel], rax

	mul qword [kernel_video_width_pixel]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	mov qword [kernel_video_size_byte], rax

	mov rax, qword [kernel_video_width_pixel]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	mov qword [kernel_video_scanline_byte], rax

	pop rbx
