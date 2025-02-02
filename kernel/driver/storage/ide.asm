DRIVER_IDE_PORT_PRIMARY equ 0x01F0
DRIVER_IDE_PORT_SECONDARY equ 0x0170

DRIVER_IDE_REGISTER_data equ 0x0000
DRIVER_IDE_REGISTER_error equ 0x0001
DRIVER_IDE_REGISTER_sector_count_0 equ 0x0002
DRIVER_IDE_REGISTER_lba0 equ 0x0003
DRIVER_IDE_REGISTER_lba1 equ 0x0004
DRIVER_IDE_REGISTER_lba2 equ 0x0005
DRIVER_IDE_REGISTER_drive_OR_head equ 0x0006
DRIVER_IDE_REGISTER_command_OR_status equ 0x0007
DRIVER_IDE_REGISTER_sector_count_1 equ 0x0008
DRIVER_IDE_REGISTER_lba3 equ 0x0009
DRIVER_IDE_REGISTER_lba4 equ 0x000A
DRIVER_IDE_REGISTER_lba5 equ 0x000B
DRIVER_IDE_REGISTER_control_OR_alstatus equ 0x000C
DRIVER_IDE_REGISTER_device_address equ 0x000D
DRIVER_IDE_REGISTER_device_control_OR_alstatus equ 0x0206

DRIVER_IDE_COMMAND_ATAPI_eject equ 0x01B
DRIVER_IDE_COMMAND_read_pio equ 0x20
DRIVER_IDE_COMMAND_read_pio_extended equ 0x24
DRIVER_IDE_COMMAND_read_dma_extended equ 0x25
DRIVER_IDE_COMMAND_write_pio equ 0x30
DRIVER_IDE_COMMAND_packet equ 0xA0
DRIVER_IDE_COMMAND_identify_packet equ 0xA1
DRIVER_IDE_COMMAND_ATAPI_read equ 0x0A8
DRIVE_IDE_COMMAND_read_dma equ 0xC8
DRIVER_IDE_COMMAND_write_dma equ 0xCA
DRIVER_IDE_COMMAND_cache_flush equ 0xE7
DRIVER_IDE_COMMAND_cache_flush_extended equ 0xEA
DRIVER_IDE_COMMAND_identify equ 0xEC

DRIVER_IDE_STATUS_error equ 00000001b
DRIVER_IDE_STATUS_index equ 00000010b
DRIVER_IDE_STATUS_corrected_data equ 00000100b
DRIVER_IDE_STATUS_data_ready equ 00001000b
DRIVER_IDE_STATUS_seek_complete equ 00010000b
DRIVER_IDE_STATUS_write_fault equ 00100000b
DRIVER_IDE_STATUS_ready equ 01000000b
DRIVER_IDE_STATUS_busy equ 10000000b
DRIVER_IDE_ERROR_no_address_mark equ 00000001b
DRIVER_IDE_ERROR_track_0_not_found equ 00000010b
DRIVER_IDE_ERROR_command_aborted equ 00000100b
DRIVER_IDE_ERROR_media_change_request equ 00001000b
DRIVER_IDE_ERROR_id_mark_not_found equ 00010000b
DRIVER_IDE_ERROR_media_changed equ 00100000b
DRIVER_IDE_ERROR_uncorrectble_data equ 01000000b
DRIVER_IDE_ERROR_bad_block equ 10000000b
DRIVER_IDE_REGISTER_device_control_OR_altstatus_nIEN equ 00000010b

driver_ide_init:
	push rax
	push rdx

	mov eax, DRIVER_IDE_REGISTER_device_control_OR_altstatus_nIEN

	xchg bx, bx

	mov dx, DRIVER_IDE_PORT_PRIMARY + DRIVER_IDE_REGISTER_device_control_OR_alstatus
	out dx, al

	mov  dx, DRIVER_IDE_PORT_PRIMARY
	call driver_ide_pool

	mov  dx, DRIVER_IDE_PORT_SECONDARY
	call driver_ide_pool

	mov dx, DRIVER_IDE_PORT_SECONDARY + DRIVER_IDE_REGISTER_device_control_OR_alstatus
	out dx, al

	mov  dx, DRIVER_IDE_PORT_SECONDARY
	call driver_ide_pool

	pop rdx
	pop rax

	ret

driver_ide_pool:
	push rax
	push rcx
	push rdx

	mov cl, 0x04

	add dx, DRIVER_IDE_REGISTER_device_control_OR_alstatus

.busy:
	in   al, dx
	loop .busy

	.wait
	pop rdx
	pop rcx
	pop rax

	ret
