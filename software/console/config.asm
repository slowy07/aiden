%include "kernel/config.asm"
%include "config.asm"

	; Define console window dimensions based on font size
	CONSOLE_WINDOW_WIDTH_pixel equ INCLUDE_FONT_WIDTH_pixel * 40
	CONSOLE_WINDOW_HEIGHT_pixel equ INCLUDE_FONT_HEIGHT_pixel * 12

	; Define console window background color
	CONSOLE_WINDOW_BACKGROUND_color equ 0x00000000

	[BITS 64]; Set 64-bit mode

	;        Using relative addressing for position-independent code
	[DEFAULT REL]
	;        Set origin to software base address
	[ORG     SOFTWARE_base_address]
