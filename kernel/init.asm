%include "kernel/init/long_mode.asm"
%include "kernel/init/panic.asm"
%include "kernel/init/data.asm"
%include "kernel/init/multiboot.asm"

[BITS 64]

kernel_init_long_mode:
  %include "kernel/init/video.asm"
  %include "kernel/init/memory.asm"
  %include "kernel/init/acpi.asm"
  %include "kernel/init/page.asm"
  %include "kernel/init/gdt.asm"
