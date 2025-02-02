	[BITS 16]
	[ORG  0x8000]

boot:
	cli

	jmp 0x0000:.repair_cs

.repair_cs:
	xor ax, ax
	mov ds, ax
	mov es, ax

	cld

	lgdt [boot_header_gdt_32bit]

	mov eax, cr0
	bts eax, 0
	mov cr0, eax

	jmp long 0x0008:boot_protected_mode

	[BITS 32]

boot_protected_mode:
	mov ax, 0x10
	mov ds, ax
	mov es, ax

	jmp 0x00100000

align 0x10

boot_table_gdt_32bit:
	dq 0x0000000000000000
	dq 0000000011001111100110000000000000000000000000001111111111111111b
	dq 0000000011001111100100100000000000000000000000001111111111111111b

boot_table_gdt_32bit_end:

boot_header_gdt_32bit:
	dw boot_table_gdt_32bit_end - boot_table_gdt_32bit - 0x01
	dd boot_table_gdt_32bit

boot_end:
