SERVICE_RENDER_OBJECT_NAME_length equ 8

SERVICE_RENDER_OBJECT_FLAG_visible equ 1 << 0
SERVICE_RENDER_OBJECT_FLAG_flush equ 1 << 1
SERVICE_RENDER_OBJECT_FLAG_fixed_xy equ 1 << 2
SERVICE_RENDER_OBJECT_FLAG_fixed_z equ 1 << 3
SERVICE_RENDER_OBJECT_FLAG_fragile equ 1 << 4
SERVICE_RENDER_OBJECT_FLAG_pointer equ 1 << 5
SERVICE_RENDER_OBJECT_FLAG_arbiter equ 1 << 6

SERVICE_RENDER_FILL_LIST_limit equ (KERNEL_PAGE_SIZE_byte / SERVICE_RENDER_STRUCTURE_FILL.SIZE) - 0x01
SERVICE_RENDER_ZONE_LIST_limit equ (KERNEL_PAGE_SIZE_byte / SERVICE_RENDER_STRUCTURE_ZONE.SIZE) - 0x01

SERVICE_RENDER_IPC_MOUSE_BUTTON_LEFT_press equ 0
SERVICE_RENDER_IPC_MOUSE_BUTTON_RIGHT_press equ 1

struc     SERVICE_RENDER_STRUCTURE_IPC
.type     resb 1
.reserved resb 7
.id       resb 8
.value0   resb 8
.value1   resb 8
endstruc

struc   SERVICE_RENDER_STRUCTURE_FIELD
.x      resb 8
.y      resb 8
.width  resb 8
.height resb 8

.SIZE:
	endstruc

	struc    SERVICE_RENDER_STRUCTURE_OBJECT
	.field   resb SERVICE_RENDER_STRUCTURE_FIELD.SIZE
	.address resb 8

.SIZE:
	endstruc

	struc  SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA
	.size  resb 8
	.flags resb 8
	.id    resb 8
	.pid   resb 8

.SIZE:
	endstruc

	struc   SERVICE_RENDER_STRUCTURE_FILL
	.field  resb SERVICE_RENDER_STRUCTURE_FIELD.SIZE
	.object resb 8

.SIZE:
	endstruc

	struc   SERVICE_RENDER_STRUCTURE_ZONE
	.field  resb SERVICE_RENDER_STRUCTURE_FIELD.SIZE
	.object resb 8

.SIZE:
	endstruc
