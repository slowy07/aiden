; Initialize video properties and adjust the console window position
mov ax, KERNEL_SERVICE_VIDEO_properties
int KERNEL_SERVICE

shr r8, STATIC_DIVIDE_BY_2_shift ; Divide screen width by 2
shr r9, STATIC_DIVIDE_BY_2_shift ; Divide screen height by 2

; Calculate window's X position and center it
mov rax, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
shr rax, STATIC_DIVIDE_BY_2_shift
sub r8, rax
mov qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.x], r8

; Calculate window's Y position and center it
mov rax, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
shr rax, STATIC_DIVIDE_BY_2_shift
sub r9, rax
mov qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y], r9

; Initialize the unit structure for the console window
mov  rsi, console_window
call include_unit

; Compute the starting address of the terminal buffer
mov rax, qword [console_window.element_terminal + INCLUDE_UNIT_STRUCTURE_ELEMENT_DRAW.element + INCLUDE_UNIT_STRUCTURE_ELEMENT.field + INCLUDE_UNIT_STRUCTURE_FIELD.y]
mul qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.scanline]
add rax, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.address]

mov qword [console_terminal_table + INCLUDE_TERMINAL_STRUCTURE.address], rax

; Initialize the terminal structure
mov  r8, console_terminal_table
call include_terminal

; Render the window and make it visible
mov al, SERVICE_RENDER_WINDOW_update
or  qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.flags], INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush
int SERVICE_RENDER_IRQ
