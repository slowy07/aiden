mov ax, KERNEL_SERVICE_VIDEO_properties
int KERNEL_SERVICE

shr r8, STATIC_DIVIDE_BY_2_shift
shr r9, STATIC_DIVIDE_BY_2_shift

mov rax, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.width]
shr rax, STATIC_DIVIDE_BY_2_shift
sub r8, rax
mov qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.x], r8

mov rax, qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.height]
shr rax, STATIC_DIVIDE_BY_2_shift
sub r9, rax
mov qword [console_window + INCLUDE_UNIT_STRUCTURE_WINDOW.field + INCLUDE_UNIT_STRUCTURE_FIELD.y], r9

mov  rsi, console_window
call include_unit

call console_clear

mov al, SERVICE_RENDER_WINDOW_update
or  qword [rsi + INCLUDE_UNIT_STRUCTURE_WINDOW.SIZE + INCLUDE_UNIT_STRUCTURE_WINDOW_EXTRA.flags], INCLUDE_UNIT_WINDOW_FLAG_visible | INCLUDE_UNIT_WINDOW_FLAG_flush
int SERVICE_RENDER_IRQ
