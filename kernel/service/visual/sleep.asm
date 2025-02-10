service_render_sleep:
	cmp qword [service_render_object_list_records], STATIC_EMPTY
	je  .end

	jmp service_render_sleep

.end:
	ret

macro_debug "service RENDER sleep"
