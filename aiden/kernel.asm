aiden_kernel:
    call aiden_pic_disable

    cli

    mov ebx, dword [aiden_memory_map_address]

    mov edx, dword [aiden_graphics_mode_info_block_address]
    
    xor eax, eax
    xor ecx, ecx
    xor esi, esi
    xor edi, edi

    jmp 0x0000000000100000