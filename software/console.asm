%include "software/console/config.asm"

console:
	%include "software/console/init.asm"

	jmp $

%include "software/console/data.asm"
%include "software/console/clear.asm"
%include "include/unit.asm"
%include "include/page_from_size.asm"
