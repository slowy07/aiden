aiden_memory:
    xor ebx, ebx

    mov edx, 0x534D4150

    mov edi, aiden_end
    call aiden_page_align_up

    mov dword [aiden_memory_map_address], edi

.loop:
    mov eax, 0xE820
    mov ecx, 0x14
    int 0x15

.error:
    jc .error
    add edi, 0x14
    
    test ebx, ebx
    jnz .loop

    xor al, al
    rep stosb