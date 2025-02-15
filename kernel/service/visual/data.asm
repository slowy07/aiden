	; Main semaphore to control rendering service execution
	service_render_semaphore db STATIC_FALSE
	; Stores the Process ID (PID) associated with the rendering service
	service_render_pid dq STATIC_EMPTY

	; Object control semaphores
	service_render_object_semaphore db STATIC_FALSE ; Controls access to rendering objects
	service_render_object_arbiter_semaphore db STATIC_FALSE ; Controls arbitration among rendering objects
	service_render_fill_semaphore db STATIC_FALSE ; Controls filling operations in the render process
	service_render_zone_semaphore db STATIC_FALSE ; Controls zoning operations in the render process

  ; Keyboard alt semaphore
  service_render_keyboard_alt_left_semaphore db STATIC_FALSE
	; Mouse button semaphores
	service_render_mouse_button_left_semaphore db STATIC_FALSE ; Left mouse button state
	service_render_mouse_button_right_semaphore db STATIC_FALSE ; Right mouse button state

	; Object ID control
	service_render_object_id_semaphore db STATIC_FALSE ; Ensures unique object ID assignment
	service_render_object_id dq 0x01 ; Initial object ID, incremented as new objects are registered

	;     Memory alignment for next data block
	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	; Object management pointers
	service_render_object_selected_pointer dq STATIC_EMPTY ; Pointer to currently selected render object
	service_render_object_privileged_pid dq STATIC_EMPTY ; PID of the privileged render object

	; Render object list management
	service_render_object_list_address dq STATIC_EMPTY ; Address of the render object list in memory
	servide_render_object_list_size_page dq 1 ; Number of pages allocated for the object list
	service_render_object_list_records dq STATIC_EMPTY ; Number of active object records
	; Number of free object slots in the list
	service_render_object_list_records_free dq KERNEL_PAGE_SIZE_byte / (SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE)
	service_render_object_list_modify_time dq STATIC_EMPTY ; Timestamp of last modification to the object list

	; Render fill and zone management
	service_render_fill_list_address dq STATIC_EMPTY ; Address of the render fill list
	service_render_zone_list_address dq STATIC_EMPTY ; Address of the render zone list
	service_render_zone_list_records dq STATIC_EMPTY ; Number of active zones in the list

	; Inter-process Communication (IPC) Data

service_render_ipc_data:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY; Allocate space for IPC communication data

	; Framebuffer Object

service_render_object_framebuffer:
	dq 0; Object X coordinate
	dq 0; Object Y coordinate
	dq STATIC_EMPTY; Object width
	dq STATIC_EMPTY; Object height
	dq STATIC_EMPTY; Pointer to framebuffer data

.extra:
	dq STATIC_EMPTY; Additional attributes
	dq STATIC_EMPTY; Reserved space

	; Cursor Object

service_render_object_cursor:
	dq 0; Cursor X coordinate
	dq 0; Cursor Y coordinate
	dq 12; Cursor width (12 pixels)
	dq 19; Cursor height (19 pixels)
	dq service_render_object_cursor.data; Pointer to cursor image data

.extra:
	;  Size of cursor data
	dq service_render_object_cursor.end - service_render_object_cursor.data
	;  Cursor flags
	dq SERVICE_RENDER_OBJECT_FLAG_pointer | SERVICE_RENDER_OBJECT_FLAG_flush | SERVICE_RENDER_OBJECT_FLAG_visible
	dq STATIC_EMPTY; Reserved field

.data:
	incbin "kernel/service/visual/gfx/cursor.data"; Include cursor image binary data

.end:
