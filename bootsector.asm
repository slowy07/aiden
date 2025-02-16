	[BITS 16]

	[ORG 0x7C00]

bootsector:
	cli

	jmp 0x0000:.repair_cs

.repair_cs:
	xor ax, ax
	mov ds, ax
	mov ss, ax

	mov sp, bootsector

	sti

	mov ah, 0x42
	mov si, bootsector_table_disk_address_packet
	int 0x13

	jnc 0x1000

	jmp $

align 0x04

bootsector_table_disk_address_packet:
	db 0x10
	db 0x00
	dw AIDEN_FILE_SIZE_bytes / 0x0200
	dw 0x1000
	dw 0x0000
	dq 0x0000000000000001

	times 510 - ($ - $$) db 0x00
	dw    0xAA55
