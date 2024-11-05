%include "config.asm"
%include "kernel/config.asm"

[BITS 32]
[ORG KERNEL_BASE_address]

kernel:
  jmp $

end:
