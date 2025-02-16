aiden_protected_mode:
    cli

    lgdt [aiden_protected_mode_header_gdt_32bit]

    mov eax, cr0
    bts eax, 0
    mov cr0, eax

    jmp long 0x0008:aiden_protected_mode_entry

align 0x10
aiden_protected_mode_table_gdt_32bit:
    dq 0x0000000000000000
    dq 0000000011001111100110000000000000000000000000001111111111111111b
    dq 0000000011001111100100100000000000000000000000001111111111111111b
aiden_protected_mode_table_gdt_32bit_end:

aiden_protected_mode_header_gdt_32bit:
    dw aiden_protected_mode_table_gdt_32bit_end - aiden_protected_mode_table_gdt_32bit - 0x01
    dd aiden_protected_mode_table_gdt_32bit

[BITS 32]

aiden_protected_mode_entry:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax