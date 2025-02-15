	;     Aligns the following data to a multiple of `STATIC_QWORD_SIZE_byte`
	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

console_ipc_data:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	; This section defines the main properties of the console window

console_window:
	dq STATIC_EMPTY; Placeholder for window instance reference
	dq STATIC_EMPTY; Reserved for future use
	dq CONSOLE_WINDOW_WIDTH_pixel; Width of the console window in pixels
	dq CONSOLE_WINDOW_HEIGHT_pixel; Height of the console window in pixels
	dq STATIC_EMPTY; Reserved for additional data

.extra:
	dq STATIC_EMPTY; Reserved for future use
	;  Reserved for additional settings
	dq INCLUDE_UNIT_WINDOW_FLAG_header | INCLUDE_UNIT_WINDOW_FLAG_border
	dq STATIC_EMPTY; Reserved for additional settings
	;  Window title length (in bytes)
	db 7
	db "Console                "; Window title (padded with spaces for alignment)
	dq STATIC_EMPTY; Reserved field for additional configurations

.elements:
.element_header:
	dd INCLUDE_UNIT_ELEMENT_TYPE_header; Element type: Header
	dq .element_header_end - .element_header; Size of the header element
	dq 0; X position (aligned to the left)
	dq 0; Y position (aligned to the top)
	dq STATIC_EMPTY; Reserved field
	dq INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel; Height of the header
	dq STATIC_EMPTY; Reserved field
	db .element_header_end - .element_header_string; Length of the header text

	; Header Text

.element_header_string:
	db "Console"; Text displayed in the header

.element_header_end:

.element_terminal:
	dd INCLUDE_UNIT_ELEMENT_TYPE_draw; Element type: Drawable area (Terminal)
	dq .element_terminal_end - .element_terminal; Size of the terminal element
	dq 0; X position (aligned to the left)
	dq INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel; Y position (below the header)
	dq CONSOLE_WINDOW_WIDTH_pixel; Width of the terminal area
	dq CONSOLE_WINDOW_HEIGHT_pixel - INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel; Height of the terminal area
	dq STATIC_EMPTY; Reserved field

.element_terminal_end:
	dd STATIC_EMPTY; Reserved for future expansion

console_window_end:

	; This section defines the terminal’s properties and rendering attributes.

console_terminal_table:
	dq CONSOLE_WINDOW_WIDTH_pixel; Width of the console window
	dq CONSOLE_WINDOW_HEIGHT_pixel - INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel; Height excluding the header
	;  Total framebuffer size in bytes (Width * Height * Video Depth)
	dq (CONSOLE_WINDOW_WIDTH_pixel * (CONSOLE_WINDOW_HEIGHT_pixel - INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel)) << KERNEL_VIDEO_DEPTH_shift
	dq CONSOLE_WINDOW_WIDTH_pixel << KERNEL_VIDEO_DEPTH_shift; Bytes per scanline
	dq STATIC_EMPTY; Reserved field
	dq STATIC_EMPTY; Reserved field
	dq STATIC_EMPTY; Reserved field
	dq STATIC_EMPTY; Reserved field
	dq STATIC_EMPTY; Reserved field
	dq STATIC_EMPTY; Reserved field
	dq 0x00F5F5F5; Foreground color (light gray)
	dq 0x00000000; Background color (black)
