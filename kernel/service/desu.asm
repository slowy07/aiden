%include "kernel/service/visual/config.asm"

service_render:
	%include "kernel/service/visual/init.asm"

.loop:
	call service_render_object
	call service_render_event
	call service_render_zone
	call service_render_fill
	call service_render_cursor

	jmp .loop
%include "kernel/service/visual/data.asm"
%include "kernel/service/visual/zone.asm"
%include "kernel/service/visual/cursor.asm"
%include "kernel/service/visual/object.asm"
%include "kernel/service/visual/fill.asm"
%include "kernel/service/visual/event.asm"
%include "kernel/service/visual/service.asm"
%include "kernel/service/visual/ipc.asm"

service_render_end:
