[BITS 16]
[ORG 0x1000]

aiden:
    %include "aiden/memory.asm"
    %include "aiden/graphics.asm"
    %include "aiden/protected_mode.asm"
    %include "aiden/long_mode.asm"
    %include "aiden/idt.asm"
    %include "aiden/pic.asm"
    %include "aiden/storage.asm"
    %include "aiden/pit.asm"
    %include "aiden/kernel.asm"
    %include "aiden/driver/storage/ide.asm"
    %include "aiden/page.asm"
    %include "aiden/data.asm"