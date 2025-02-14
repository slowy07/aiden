	; Define number of windows managed by service date system
	; this determine how many UI element
	SERVICE_DATE_WINDOW_count equ 3

	; Define the background color of the Workbench window in ARGB format.
	; The workbench acts as the primary desktop background and holds
	; other UI components like icons and menus.

	; 0x00101010 represents:
	; - Alpha (opacity): 0x00 (fully transparent in some systems)
	; - Red:   0x10 (dim dark gray)
	; - Green: 0x10 (dim dark gray)
	; - Blue:  0x10 (dim dark gray)

	; This results in a nearly black but slightly visible dark gray background.
	SERVICE_DATE_WINDOW_WORKBENCH_BACKGROUND_color equ 0x00101010

	; Define the height of the taskbar in pixels.
	; The taskbar serves as a system status bar, usually displaying
	; open applications, system tray, and time.
	
	; This height is determined by the font height to ensure proper
	; text rendering and alignment of elements.
	SERVICE_DATE_WINDOW_TASKBAR_HEIGHT_pixel equ INCLUDE_FONT_HEIGHT_pixel
