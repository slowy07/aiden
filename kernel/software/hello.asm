%include "config.asm"
%include "kernel/config.asm"

[BITS 64]
[DEFAULT REL]
[ORG SOFTWARE_base_address]

hello:
  mov ax, KERNEL_SERVICE_VIDEO_string
  mov ecx, hello_string_end - hello_string
  mov rsi, hello_string
  int KERNEL_SERVICE

  xor ax, ax
  int KERNEL_SERVICE

hello_string db "wello aiden"
hello_string_end:
