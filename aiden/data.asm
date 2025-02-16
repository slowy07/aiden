aiden_microtime dq 0x0000000000000000
aiden_memory_map_address dd 0x00000000
aiden_graphics_mode_info_block_address dd 0x00000000

align 0x08, db 0x90
aiden_idt_header:
                  dw 0x1000
                  dq AIDEN_IDT_address

align 0x0200
