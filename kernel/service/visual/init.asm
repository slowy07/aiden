call kernel_task_active_pid
mov  qword [service_render_pid], rax

mov  ecx, service_render_object_cursor.end - service_render_object_cursor.data
mov  rsi, service_render_object_cursor.data
call include_color_alpha_invert

mov rbx, qword [kernel_video_width_pixel]
mov rcx, qword [kernel_video_size_byte]
mov rdx, qword [kernel_video_height_pixel]

mov qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.size], rcx
mov qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width], rbx
mov qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.height], rdx

mov rdi, qword [kernel_video_base_address]

mov qword [service_render_object_framebuffer + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi

call kernel_memory_alloc_page
call kernel_page_drain
mov  qword [service_render_object_list_address], rdi

call kernel_memory_alloc_page
call kernel_page_drain
mov  qword [service_render_fill_list_address], rdi

call kernel_memory_alloc_page
call kernel_page_drain
mov  qword [service_render_zone_list_address], rdi

mov  rax, SERVICE_RENDER_IRQ
mov  bx, KERNEL_IDT_TYPE_isr
mov  rdi, service_render_irq
call kernel_idt_mount

mov byte [service_render_semaphore], STATIC_TRUE

.wait:
	cmp qword [service_render_object_list_records], STATIC_EMPTY
	je  .wait
