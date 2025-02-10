service_date_init:
	cmp byte [service_render_semaphore], STATIC_FALSE
	je  service_date_init

	mov rsi, service_date_window_workbench

	mov rax, qword [kernel_video_width_pixel]
	mov rbx, qword [kernel_video_height_pixel]
	mov rcx, qword [kernel_video_size_byte]
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width], rax
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.height], rbx
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.size], rcx

	call include_page_from_size
	call kernel_memory_alloc

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi

	mov eax, SERVICE_DATE_WINDOW_WORKBENCH_BACKGROUND_color
	mov rcx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.size]
	shr rcx, STATIC_DIVIDE_BY_DWORD_shift
	rep stosd

	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx

	call service_render_object_insert

	mov rsi, service_date_window_taskbar

	sub rbx, SERVICE_DATE_WINDOW_TASKBAR_HEIGHT_pixel
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y], rbx

	mov rax, qword [kernel_video_width_pixel]
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width], rax

	sub rax, qword [service_date_window_taskbar.element_label_clock + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
  mov qword [service_date_window_taskbar.element_label_clock + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x], rax

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	mul qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]

	mov  rcx, rax
	call include_page_from_size
	call kernel_memory_alloc

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi

	call include_unit

	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx

	call service_render_object_insert

	mov rsi, service_date_window_menu

	call include_unit_elements_specification

	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width], r8
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height], r9

	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	mul qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]

	mov  rcx, rax
	call include_page_from_size
	call kernel_memory_alloc

	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi

	call include_unit

	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx

	call service_render_object_insert
