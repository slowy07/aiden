%include "kernel/service/date/config.asm"

service_date:
	%include "kernel/service/date/init.asm"

.loop:
	call service_date_ipc
	call service_date_taskbar
	call service_date_clock

	jmp .loop

%include "kernel/service/date/data.asm"
%include "kernel/service/date/clock.asm"
%include "kernel/service/date/ipc.asm"
%include "kernel/service/date/event.asm"
%include "kernel/service/date/taskbar.asm"

%include "include/unit.asm"
%include "include/font.asm"
