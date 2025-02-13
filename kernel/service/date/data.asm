service_date_clock_last_state dq STATIC_EMPTY
service_date_clock_colon db STATIC_ASCII_SPACE

service_date_event_console_file db "/bin/console"

service_date_event_console_file_end:

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

service_date_ipc_data:
	times KERNEL_IPC_STRUCTURE.SIZE db STATIC_EMPTY

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	service_date_window_workbench  dq 0
	dq 0
	dq STATIC_EMPTY
	dq STATIC_EMPTY
	dq STATIC_EMPTY

.extra:
	dq STATIC_EMPTY
	dq INCLUDE_UNIT_WINDOW_FLAG_fixed_xy | INCLUDE_UNIT_WINDOW_FLAG_fixed_z | INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush
	dq STATIC_EMPTY
	dq STATIC_EMPTY

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	service_date_window_taskbar  dq 0
	dq STATIC_EMPTY
	dq STATIC_EMPTY
	dq SERVICE_DATE_WINDOW_TASKBAR_HEIGHT_pixel
	dq STATIC_EMPTY

.extra:
	dq STATIC_EMPTY
	dq INCLUDE_UNIT_WINDOW_FLAG_fixed_xy | INCLUDE_UNIT_WINDOW_FLAG_fixed_z | INCLUDE_UNIT_WINDOW_FLAG_arbiter | INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush | INCLUDE_UNIT_WINDOW_FLAG_unregistered
	dq STATIC_EMPTY
	dq STATIC_EMPTY

.elements:

	.element_chain_0:   dd INCLUDE_UNIT_ELEMENT_TYPE_chain
	dq INCLUDE_UNIT_STRUCTURE_ELEMENT_CHAIN.SIZE
	dq STATIC_EMPTY

	.element_label_clock:   dd INCLUDE_UNIT_ELEMENT_TYPE_label
	dq .element_label_clock_end - .element_label_clock
	dq 0
	dq 0
	dq INCLUDE_UNIT_FONT_WIDTH_pixel * (.element_label_clock_end - .element_label_clock_string_hour)
	dq INCLUDE_UNIT_FONT_HEIGHT_pixel
	dq STATIC_EMPTY
	db .element_label_clock_end - .element_label_clock_string_hour
	.element_label_clock_string_hour: db "00"
	.element_label_clock_char_colon: db ":"
	.element_label_clock_string_minute: db "00"

.element_label_clock_end:

	dd STATIC_EMPTY

service_date_window_taskbar_end:

	align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING

	service_date_window_menu  dq 160
	dq 80
	dq STATIC_EMPTY
	dq STATIC_EMPTY
	dq STATIC_EMPTY

.extra:
	dq STATIC_EMPTY
	dq INCLUDE_UNIT_WINDOW_FLAG_fragile | INCLUDE_UNIT_WINDOW_FLAG_unregistered
	dq STATIC_EMPTY
	dq STATIC_EMPTY

.elements:
	.element_header:   dd INCLUDE_UNIT_ELEMENT_TYPE_header
	dq .element_header_end - .element_header
	dq 0
	dq 0
	dq STATIC_EMPTY
	dq INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel
	dq STATIC_EMPTY
	db .element_header_end - .element_header_string
	.element_header_string:   db "Menu"

.element_header_end:
	.element_label_0:   dd INCLUDE_UNIT_ELEMENT_TYPE_label
	dq .element_label_0_end - .element_label_0
	dq 0
	dq INCLUDE_UNIT_ELEMENT_HEADER_HEIGHT_pixel
	dq ((.element_label_0_end - .element_label_0_string) * INCLUDE_UNIT_FONT_WIDTH_pixel)
	dq INCLUDE_UNIT_FONT_HEIGHT_pixel
	dq service_date_event_console
	db .element_label_0_end - .element_label_0_string
	.element_label_0_string:  db " Console "

.element_label_0_end:
	dd STATIC_EMPTY

service_date_window_menu_end:
