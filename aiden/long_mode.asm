AIDEN_LONG_MODE_PML4_address equ 0xA000
AIDEN_LONG_MODE_PAGE_FLAG_available equ 00000001b
AIDEN_LONG_MODE_PAGE_FLAG_writeable equ 00000010b
AIDEN_LONG_MODE_PAGE_FLAG_2MiB_size equ 10000000b
AIDEN_LONG_MODE_PAGE_FLAG_default equ AIDEN_LONG_MODE_PAGE_FLAG_available | AIDEN_LONG_MODE_PAGE_FLAG_writeable

aiden_long_mode:
	xor eax, eax
	mov ecx, (0x1000 * 0x06) / 0x04
	mov edi, AIDEN_LONG_MODE_PML4_address
	rep stosd

	mov dword [AIDEN_LONG_MODE_PML4_address], AIDEN_LONG_MODE_PML4_address + 0x1000 + AIDEN_LONG_MODE_PAGE_FLAG_default

	mov dword [AIDEN_LONG_MODE_PML4_address + 0x1000], AIDEN_LONG_MODE_PML4_address + (0x1000 * 0x02) + AIDEN_LONG_MODE_PAGE_FLAG_default
	mov dword [AIDEN_LONG_MODE_PML4_address + 0x1000 + 0x08], AIDEN_LONG_MODE_PML4_address + (0x1000 * 0x03) + AIDEN_LONG_MODE_PAGE_FLAG_default
	mov dword [AIDEN_LONG_MODE_PML4_address + 0x1000 + 0x10], AIDEN_LONG_MODE_PML4_address + (0x1000 * 0x04) + AIDEN_LONG_MODE_PAGE_FLAG_default
	mov dword [AIDEN_LONG_MODE_PML4_address + 0x1000 + 0x18], AIDEN_LONG_MODE_PML4_address + (0x1000 * 0x05) + AIDEN_LONG_MODE_PAGE_FLAG_default

	mov eax, AIDEN_LONG_MODE_PAGE_FLAG_default + AIDEN_LONG_MODE_PAGE_FLAG_2MiB_size
	mov ecx, 512 * 0x04
	mov edi, AIDEN_LONG_MODE_PML4_address + (0x1000 * 0x02)

.next:
	stosd

	add edi, 0x04

	add eax, 0x00200000

	dec ecx
	jnz .next

	lgdt [aiden_long_mode_header_gdt_64bit]

	mov eax, 1010100000b
	mov cr4, eax

	mov eax, AIDEN_LONG_MODE_PML4_address
	mov cr3, eax

	mov ecx, 0xC0000080
	rdmsr
	or  eax, 100000000b
	wrmsr

	mov eax, cr0
	or  eax, 0x80000001
	mov cr0, eax

	jmp 0x0008:aiden_long_mode_entry

align 0x08

aiden_long_mode_table_gdt_64bit:
	dq 0x0000000000000000
	dq 0000000000100000100110000000000000000000000000000000000000000000b
	dq 0000000000100000100100100000000000000000000000000000000000000000b

aiden_long_mode_table_gdt_64bit_end:

aiden_long_mode_header_gdt_64bit:
	dw aiden_long_mode_table_gdt_64bit_end - aiden_long_mode_table_gdt_64bit - 0x01
	dd aiden_long_mode_table_gdt_64bit

	[BITS 64]

aiden_long_mode_entry:
