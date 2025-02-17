	[BITS 16]

	[ORG 0x7000]

boot:
	xchg bx, bx
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

align 0x10
boot_table_gdt_32bit:
	dq 0x0000000000000000
	dq 0000000011001111100110000000000000000000000000001111111111111111b
	dq 0000000011001111100100100000000000000000000000001111111111111111b
boot_table_gdt_32bit_end:

boot_header_gdt_32bit:
	dw boot_table_gdt_32bit_end - boot_table_gdt_32bit - 0x01
	dd boot_table_gdt_32bit

[BITS 32]

boot_protected_mode:
	mov ax, 0x10
	mov ds, ax
	mov es, ax

	lgdt [boot_header_gdt_64bit]

	mov eax, 1010100000b
	mov cr4, eax

	mov eax, 0x0000A000
	mov cr3, eax

	mov ecx, 0xC0000080
	rdmsr
	or eax, 100000000b
	wrmsr

	mov eax, cr0
	or eax, 0x80000001
	mov cr0, eax

	jmp 0x0008:boot_long_mode

align 0x10
boot_table_gdt_64bit:
	dq 0x0000000000000000
	dq 0000000000100000100110000000000000000000000000000000000000000000b
	dq 0000000000100000100100100000000000000000000000000000000000000000b
boot_table_gdt_64bit_end:

boot_header_gdt_64bit:
	dw boot_table_gdt_64bit_end - boot_table_gdt_64bit - 0x01
	dd boot_table_gdt_64bit

[BITS 64]

boot_long_mode:
	jmp 0x0000000000100000

boot_end: