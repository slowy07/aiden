	; Maximum length of the name assigned to a render object
	; This defines the storage space allocated for object names
	SERVICE_RENDER_OBJECT_NAME_length equ 23

	; The following flags define properties and behaviors of render objects.
	; These flags are used in the `SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA.flags` field
	SERVICE_RENDER_OBJECT_FLAG_visible equ 1 << 0 ; Object is visible on screen
	SERVICE_RENDER_OBJECT_FLAG_flush equ 1 << 1 ; Object requires screen refresh
	SERVICE_RENDER_OBJECT_FLAG_fixed_xy equ 1 << 2 ; Object has a fixed position in X/Y space
	SERVICE_RENDER_OBJECT_FLAG_fixed_z equ 1 << 3 ; Object has a fixed Z-depth (layering)
	SERVICE_RENDER_OBJECT_FLAG_fragile equ 1 << 4 ; Object is volatile and may be removed easily
	SERVICE_RENDER_OBJECT_FLAG_pointer equ 1 << 5 ; Object acts as a pointer (e.g., mouse cursor)
	SERVICE_RENDER_OBJECT_FLAG_arbiter equ 1 << 6 ; Object has arbitration control over rendering

	; Maximum number of entries for fill and zone lists, determined by the available page size.
	SERVICE_RENDER_FILL_LIST_limit equ (KERNEL_PAGE_SIZE_byte / SERVICE_RENDER_STRUCTURE_FILL.SIZE) - 0x01
	SERVICE_RENDER_ZONE_LIST_limit equ (KERNEL_PAGE_SIZE_byte / SERVICE_RENDER_STRUCTURE_ZONE.SIZE) - 0x01

	; Inter-Process Communication mouse button codes
	; These constants define the codes used for IPC messages related to mouse button actions
	SERVICE_RENDER_IPC_MOUSE_BUTTON_LEFT_press equ 0 ; Left mouse button press event
	SERVICE_RENDER_IPC_MOUSE_BUTTON_RIGHT_press equ 1 ; Right mouse button press event

	; IPC structure

	;         Structure representing an IPC (Inter-Process Communication) event for the render service
	struc     SERVICE_RENDER_STRUCTURE_IPC
	.type     resb 1; IPC event type (1 byte)
	.reserved resb 7; Reserved bytes for alignment (7 bytes)
	.id       resb 8; Unique identifier of the IPC event (8 bytes)
	.value0   resb 8; First value associated with the event (8 bytes)
	.value1   resb 8; Second value associated with the event (8 bytes)
	endstruc

	;       This structure defines the basic properties of a render object, including its position and dimensions
	struc   SERVICE_RENDER_STRUCTURE_FIELD
	.x      resb 8; X-coordinate position (8 bytes)
	.y      resb 8; Y-coordinate position (8 bytes)
	.width  resb 8; Width of the object (8 bytes)
	.height resb 8; Height of the object (8 bytes)

.SIZE:
	endstruc

	;        Render object structure
	;        Structure representing a graphical render object in memory.
	struc    SERVICE_RENDER_STRUCTURE_OBJECT
	.field   resb SERVICE_RENDER_STRUCTURE_FIELD.SIZE; Field structure containing object properties
	.address resb 8; Memory address of the object's framebuffer

.SIZE:
	endstruc

	;       This structure holds additional metadata for render objects, including flags and identifiers
	struc   SERVICE_RENDER_STRUCTURE_OBJECT_EXTRA
	.size   resb 8; Total size of the object (8 bytes)
	.flags  resb 8; Flags defining object properties (8 bytes)
	.id     resb 8; Unique identifier of the object (8 bytes)
	.length resb 1; Length of the object name (1 byte)
	.name   resb SERVICE_RENDER_OBJECT_NAME_length; Name of the object (23 bytes)
	.pid    resb 8; Process ID associated with the object (8 bytes)

.SIZE:
	endstruc

	;       Fill structure
	;       Structure defining a fill operation in the render service
	struc   SERVICE_RENDER_STRUCTURE_FILL
	.field  resb SERVICE_RENDER_STRUCTURE_FIELD.SIZE; Field structure defining the fill region
	.object resb 8; Reference to the object being filled

.SIZE:
	endstruc

  ; Zone structure
  ; Structure defining a render zone, used for region-based rendering
	struc   SERVICE_RENDER_STRUCTURE_ZONE
	.field  resb SERVICE_RENDER_STRUCTURE_FIELD.SIZE ; Field structure defining the zone dimensions
	.object resb 8 ; Reference to the associated object

.SIZE:
	endstruc
