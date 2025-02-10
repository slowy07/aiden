service_render_semaphore db STATIC_FALSE
service_render_pid dq STATIC_EMPTY

service_render_object_semaphore db STATIC_FALSE
service_render_object_arbiter_semaphore db STATIC_FALSE
service_render_fill_semaphore db STATIC_FALSE
service_render_zone_semaphore db STATIC_FALSE

service_render_mouse_button_left_semaphore db STATIC_FALSE
service_render_mouse_button_right_semaphore db STATIC_FALSE

service_render_object_id_semaphore db STATIC_FALSE
service_render_object_id dq 0x01

align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

service_render_object_selected_pointer dq STATIC_EMPTY
service_render_object_privileged_pid dq STATIC_EMPTY

service_render_object_list_address dq STATIC_EMPTY
servide_render_object_list_size_page dq 1
service_render_object_list_records dq STATIC_EMPTY
service_render_object_list_records_free dq KERNEL_PAGE_SIZE_byte / (SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.SIZE)

service_render_fill_list_address dq STATIC_EMPTY

service_render_zone_list_address dq STATIC_EMPTY
service_render_zone_list_records dq STATIC_EMPTY

service_render_ipc_data:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY

	service_render_object_framebuffer:   dq 0
	dq 0
	dq STATIC_EMPTY
	dq STATIC_EMPTY
	dq STATIC_EMPTY

.extra:
	dq STATIC_EMPTY
	dq STATIC_EMPTY

	service_render_object_cursor:    dq 0
	dq 0
	dq 12
	dq 19
	dq service_render_object_cursor.data

.extra:
	dq service_render_object_cursor.end - service_render_object_cursor.data
	dq SERVICE_RENDER_OBJECT_FLAG_pointer | SERVICE_RENDER_OBJECT_FLAG_flush | SERVICE_RENDER_OBJECT_FLAG_visible
	dq STATIC_EMPTY

.data:
	incbin "kernel/service/visual/gfx/cursor.data"

.end:
