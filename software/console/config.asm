%include "kernel/config.asm"
%include "config.asm"

CONSOLE_WINDOW_WIDTH_pixel equ 120
CONSOLE_WINDOW_HEIGHT_pixel equ 66

CONSOLE_WINDOW_BACKGROUND_color equ 0x00000000

	[BITS 64]

	[DEFAULT REL]
	[ORG     SOFTWARE_base_address]
