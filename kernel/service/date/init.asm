service_date_init:
	;   Check if the service render semaphore is set to false
	cmp byte [service_render_semaphore], STATIC_FALSE
	je  service_date_init; If false, wait for it to be set

	;   Initialize the workbench window structure
	mov rsi, service_date_window_workbench

	;   Load kernel video properties
	mov rax, qword [kernel_video_width_pixel]; Get screen width in pixels
	mov rbx, qword [kernel_video_height_pixel]; Get screen height in pixels
	mov rcx, qword [kernel_video_size_byte]; Get total video memory size
	;   Store the video properties into the workbench window structure
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.width], rax
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.field + SERVICE_RENDER_STRUCTURE_FIELD.height], rbx
	mov qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.size], rcx

	;    Allocate memory for the workbench window
	call include_page_from_size; Get required page size
	call kernel_memory_alloc; Allocate memory
	;    Store address
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi

	;   Set background color for the workbench
	mov eax, SERVICE_DATE_WINDOW_WORKBENCH_BACKGROUND_color
	mov rcx, qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.size]
	shr rcx, STATIC_DIVIDE_BY_DWORD_shift; Convert size to DWORD count
	rep stosd; Fill allocated memory with background color

	;    Generate a new render object ID and store it
	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx

	;    Insert the workbench into the render system
	call service_render_object_insert
	;    Initialize the taskbar window
	mov  rsi, service_date_window_taskbar

	;   Adjust taskbar position to bottom of the screen
	sub rbx, SERVICE_DATE_WINDOW_TASKBAR_HEIGHT_pixel; Align taskbar at the bottom
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y], rbx

	;   Set taskbar width to match screen width
	mov rax, qword [kernel_video_width_pixel]
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width], rax

	;   Adjust clock position on the taskbar (right-aligned)
	sub rax, qword [service_date_window_taskbar.element_label_clock + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	mov qword [service_date_window_taskbar.element_label_clock + INCLUDE_UNIT_STRUCTURE_ELEMENT_LABEL.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.x], rax

	;   Compute taskbar memory size
	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	shl rax, KERNEL_VIDEO_DEPTH_shift; Adjust for video depth
	mul qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]; Compute total size

	;    Allocate memory for the object based on its required size
	mov  rcx, rax; Set RCX to the calculated size of the object
	call include_page_from_size; Compute the required number of pages
	call kernel_memory_alloc; Allocate memory for the object

	;    Store the allocated address in the render object structure
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi
	;    Initialize the unit (window or UI component)
	call include_unit

	;    Generate a new unique object ID for the render object
	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx

	;    Insert the render object into the system's render list
	call service_render_object_insert
	;    Move to initializing the menu window
	mov  rsi, service_date_window_menu
	;    Set up the elements of the menu window
	call include_unit_elements_specification

	;   Assign the width and height values from registers
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width], r8
	mov qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height], r9

	;   Calculate the total memory required for the menu window
	mov rax, qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
	shl rax, KERNEL_VIDEO_DEPTH_shift
	mul qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]

	;    Allocate memory for the menu window
	mov  rcx, rax
	call include_page_from_size
	call kernel_memory_alloc
	;    Store the allocated address for the menu window
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.address], rdi
	;    Initialize the menu window as a unit
	call include_unit
	;    Generate a new unique ID for the menu window object
	call service_render_object_id_new
	mov  qword [rsi + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.id], rcx
	;    Insert the menu window render object into the render list
	call service_render_object_insert
	;    Synchronize the modification timestamps between service date and service render
	mov  rax, qword [service_render_object_list_modify_time]
	mov  qword [service_date_window_taskbar_modify_time], rax
