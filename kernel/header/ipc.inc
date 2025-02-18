struc	KERNEL_IPC_STRUCTURE
	.ttl resb	8
	.pid_source resb 8
	.pid_destination resb 8
	.type resb 1
	.reserved resb 7
	.data:
	.size resb 8
	.pointer resb 8
	.other resb 32
	.SIZE:
endstruc

KERNEL_IPC_TYPE_SYSTEM equ 0x00	
KERNEL_IPC_TYPE_KEYBOARD equ 0x01
KERNEL_IPC_TYPE_MOUSE equ 0x02
KERNEL_IPC_TYPE_GRAPHICS equ 0x03	
KERNEL_IPC_TYPE_INTERNAL equ 0x04

KERNEL_IPC_DATA_SYSTEM_kill equ STATIC_EMPTY
