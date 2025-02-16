aiden_storage:
    call driver_ide_init

    mov eax, ((aiden_end - aiden) + 0x200) / 0x200
    xor ebx, ebx

    mov ecx, 1

    mov edx, (KERNEL_FILE_SIZE_byte / 0x200)

    mov edi, 0x00100000

.loop:
    call driver_ide_read
    inc eax
    
    add rdi, 0x0200
    
    dec edx
    jnz .loop