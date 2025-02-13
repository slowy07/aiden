%include "software/console/config.asm"

console:
	%include "software/console/init.asm"

	jmp $

%include "software/console/data.asm"
%include "include/unit.asm"
%include "include/font.asm"
%include "include/page_from_size.asm"
%include "include/terminal.asm"
