%define KERNEL_name "Aiden"; Name of the kernel
%define KERNEL_version "1"; Kernel major version
%define KERNEL_revision "3"; Kernel minor revision
%define KERNEL_architecture "x86_64"; Target system architecture

	; Base memory address where the kernel is loaded
	KERNEL_BASE_address equ 0x0000000000100000

	; Stack Memory Configuration
	KERNEL_STACK_address equ KERNEL_MEMORY_HIGH_VIRTUAL_address - KERNEL_STACK_SIZE_byte ; Stack start address
	KERNEL_STACK_pointer equ KERNEL_MEMORY_HIGH_VIRTUAL_address - KERNEL_PAGE_SIZE_byte ; Stack pointer location
	KERNEL_STACK_SIZE_byte equ KERNEL_PAGE_SIZE_byte * 0x02 ; Stack size (2 pages)

	; Temporary Stack Pointer used during early initialization
	KERNEL_STACK_TEMPORARY_pointer equ 0x8000 + KERNEL_PAGE_SIZE_byte

	; High Memory Addressing
	KERNEL_MEMORY_HIGH_mask equ 0xFFFF000000000000 ; Mask for high memory access
	KERNEL_MEMORY_HIGH_REAL_address equ 0xFFFF800000000000 ; Real address mapping for high memory
	; Virtual high memory address
	KERNEL_MEMORY_HIGH_VIRTUAL_address equ KERNEL_MEMORY_HIGH_REAL_address - KERNEL_MEMORY_HIGH_mask

	; Video Configuration
	KERNEL_VIDEO_DEPTH_shift equ 2 ; Shift value for video depth calculations
	KERNEL_VIDEO_DEPTH_byte equ 4 ; Video depth in bytes (4 bytes per pixel)
	KERNEL_VIDEO_DEPTH_bit equ 32 ; Video depth in bits (32-bit color)

	; Kernel Service Interrupt Number
	KERNEL_SERVICE equ 0x40 ; Interrupt number for kernel services

	; Process Management Services
	KERNEL_SERVICE_PROCESS equ 0x0000
	KERNEL_SERVICE_PROCESS_exit equ 0x0000 + KERNEL_SERVICE_PROCESS ; Exit a process
	KERNEL_SERVICE_PROCESS_run equ 0x0100 + KERNEL_SERVICE_PROCESS ; Start a new process
	KERNEL_SERVICE_PROCESS_check equ 0x0200 + KERNEL_SERVICE_PROCESS ; Check process status
	; Allocate memory for a process
	KERNEL_SERVICE_PROCESS_memory_alloc equ 0x0300 + KERNEL_SERVICE_PROCESS

	KERNEL_SERVICE_PROCESS_ipc_receive equ 0x0400 + KERNEL_SERVICE_PROCESS
	KERNEL_SERVICE_PROCESS_pid equ 0x0500 + KERNEL_SERVICE_PROCESS

	; Video Services
	KERNEL_SERVICE_VIDEO equ 0x0001
	KERNEL_SERVICE_VIDEO_properties equ 0x0000 + KERNEL_SERVICE_VIDEO

	; Virtual File System (VFS) Services
	KERNEL_SERVICE_VFS equ 0x0003
	KERNEL_SERVICE_VFS_exist equ 0x0000 + KERNEL_SERVICE_VFS

	; System Services
	KERNEL_SERVICE_SYSTEM equ 0x0004
	; Get system memory information
	KERNEL_SERVICE_SYSTEM_memory equ 0x0000 + KERNEL_SERVICE_SYSTEM

	struc KERNEL_IPC_STRUCTURE
	.ttl  resb 8
	.pid_source resb 8
	.pid_destination resb 8

.data:
	.size    resb 8
	.pointer resb 8
	.other   resb 24

.SIZE:
	endstruc

	; Error Codes
	KERNEL_ERROR_memory_low equ 0x0001

	SERVICE_RENDER_IPC_KEYBOARD equ 0
	SERVICE_RENDER_IPC_MOUSE_BUTTON_LEFT_press equ 1
	SERVICE_RENDER_IPC_MOUSE_BUTTON_RIGHT_press equ 2

	struc     SERVICE_RENDER_STRUCTURE_IPC
	.type     resb 1
	.reserved resb 7
	.id       resb 8
	.value0   resb 8
	.value1   resb 8
	endstruc
