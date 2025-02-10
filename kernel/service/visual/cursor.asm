service_render_cursor:
	push rsi

	test qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], SERVICE_RENDER_OBJECT_FLAG_flush
	jz   .no

	mov  rsi, service_render_object_cursor
	call service_render_fill_insert_by_object
	call service_render_fill

	and qword [service_render_object_cursor + SERVICE_RENDER_STRUCTURE_OBJECT.SIZE + SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags], ~SERVICE_RENDER_OBJECT_FLAG_flush

.no:
	pop rsi

	ret

macro_debug "service_render_cursor"
