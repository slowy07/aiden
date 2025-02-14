	; Store the last state of the clock
	service_date_clock_last_state dq STATIC_EMPTY
	; Character to be displayed as the clock colon, initially set to space
	service_date_clock_colon db STATIC_ASCII_SPACE
	; Path to the event console binary file
	service_date_event_console_file db "/bin/console"

service_date_event_console_file_end:
	;     Align memory to ensure proper structure placement
	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	; Define IPC (Inter-Process Communication) data structure

service_date_ipc_data:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY
	;     Align memory again for correct struct alignment
	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	;  Define main workbench window properties
	service_date_window_workbench  dq 0 ; Window pointer
	dq 0; Reserved field
	dq STATIC_EMPTY; Placeholder for additional properties
	dq STATIC_EMPTY; Placeholder for additional properties
	dq STATIC_EMPTY; Placeholder for additional properties

.extra:
	dq STATIC_EMPTY; Reserved extra data
	;  Window flag
	dq INCLUDE_UNIT_WINDOW_FLAG_fixed_xy | INCLUDE_UNIT_WINDOW_FLAG_fixed_z | INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush
	dq STATIC_EMPTY; Placeholder for additional properties
	dq STATIC_EMPTY; Placeholder for additional properties

	;     Align memory for correct struct alignment
	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	; add window taskbar date
	service_date_window_taskbar_modify_time dq STATIC_EMPTY

	;  Define taskbar window properties
	service_date_window_taskbar  dq 0 ; Taskbar window pointer
	dq STATIC_EMPTY; Placeholder for additional properties
	dq STATIC_EMPTY; Placeholder for additional properties
	dq SERVICE_DATE_WINDOW_TASKBAR_HEIGHT_pixel; Taskbar height
	dq STATIC_EMPTY; Placeholder for additional properties

	; Extra window properties for taskbar

.extra:
	dq STATIC_EMPTY
	dq INCLUDE_UNIT_WINDOW_FLAG_fixed_xy | INCLUDE_UNIT_WINDOW_FLAG_fixed_z | INCLUDE_UNIT_WINDOW_FLAG_arbiter | INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush | INCLUDE_UNIT_WINDOW_FLAG_unregistered
	dq STATIC_EMPTY
	dq STATIC_EMPTY

	; UI elements for taskbar

.elements:
	;  Chain Element (Placeholder for additional elements)
	.element_chain_0:   dd INCLUDE_UNIT_ELEMENT_TYPE_chain  ; Element type: Chain
	dq INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.SIZE; Size of the chain element structure
	dq STATIC_EMPTY; Placeholder

	;  Clock Label Element
	.element_label_clock:   dd INCLUDE_UNIT_ELEMENT_TYPE_label ; Element type: Label
	dq .element_label_clock_end - .element_label_clock; Element size
	dq 0; X position (relative)
	dq 0; Y position (relative)
	;  Width in pixels
	dq INCLUDE_FONT_WIDTH_pixel * (.element_label_clock_end - .element_label_clock_string_hour)
	dq INCLUDE_FONT_HEIGHT_pixel; Height in pixels
	dq STATIC_EMPTY; Reserved field
	db .element_label_clock_end - .element_label_clock_string_hour; String length
	;  Clock Time Display (HH:MM)
	.element_label_clock_string_hour: db "00" ; Initial hour value
	.element_label_clock_char_colon: db ":" ; Separator
	.element_label_clock_string_minute: db "00" ; Initial minute value

.element_label_clock_end:

	dd STATIC_EMPTY

service_date_window_taskbar_end:

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	; Window Menu Configuration

service_date_window_menu:
	dq 160; Window width
	dq 80; Window height
	dq STATIC_EMPTY; Placeholder
	dq STATIC_EMPTY; Placeholder
	dq STATIC_EMPTY; Placeholder

.extra:
	dq STATIC_EMPTY; Placeholder for future settings
	;  Flags for fragile & unregistered window behavior
	dq INCLUDE_UNIT_WINDOW_FLAG_fragile | INCLUDE_UNIT_WINDOW_FLAG_unregistered
	dq STATIC_EMPTY; Reserved field
	dq STATIC_EMPTY; Reserved field

	; UI Elements for Menu Window

.elements:
	; Header Element

.element_header:
	dd INCLUDE_UNIT_ELEMENT_TYPE_header; Element type: Header
	dq .element_header_end - .element_header; Element size
	dq 0; X position (relative)
	dq 0; Y position (relative)
	dq STATIC_EMPTY; Placeholder width
	dq INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel; Height in pixels
	dq STATIC_EMPTY; Reserved field
	db .element_header_end - .element_header_string; String length
	.element_header_string:   db "Menu" ; Header text

.element_header_end:
	; Console Label Element

.element_label_0:
	;  Element type: Label
	dd INCLUDE_UNIT_ELEMENT_TYPE_label
	dq .element_label_0_end - .element_label_0; Element size
	dq 0; X position (relative)
	dq INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel; Y position below header
	;  Width in pixels
	dq ((.element_label_0_end - .element_label_0_string) * INCLUDE_FONT_WIDTH_pixel)
	dq INCLUDE_FONT_HEIGHT_pixel; Height in pixels
	dq service_date_event_console; Associated event handler
	db .element_label_0_end - .element_label_0_string; String length
	.element_label_0_string:  db " Console " ; Label text

.element_label_0_end:
	dd STATIC_EMPTY; End of label element

service_date_window_menu_end:
