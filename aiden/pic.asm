aiden_pic:
    mov al, 0x11
    out 0x20, al
    out 0xA0, al

    mov al, 0x20
    out 0x21, al

    mov al, 0x28
    out 0xA1, al

    mov al, 4
    out 0x21, al

    mov al, 2
    out 0xA1, al

    mov al, 1
    out 0x21, al
    out 0xA1, al

    mov al, 11111111b
    out 0xA1, al
    
    mov al, 11011110b
    out 0x21, al

    jmp aiden_pic_end

aiden_pic_disable:
    mov al, 0xFF
    out 0x00A1, al
    out 0x0021, al

    ret

aiden_pic_end: