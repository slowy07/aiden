;MIT License
;
;Copyright (c) 2024 arfy slowy
;
;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all
;copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;SOFTWARE.

KERNEL_IO_APIC_ioregsel equ 0x00
KERNEL_IO_APIC_iowin equ 0x10
KERNEL_IO_APIC_iowin_low equ 0x00
KERNEL_IO_APIC_iowin_high equ 0x01

KERNEL_IO_APIC_TRIGER_MODE_level equ 1000000000000000b

kernel_io_apic_base_address dq STATIC_EMPTY

kernel_io_apic_connect:
  push rax
  push rbx
  push rdi

  mov rdi, qword [kernel_io_apic_base_address]
  add ebx, KERNEL_IO_APIC_iowin_low
  mov dword [rdi + KERNEL_IO_APIC_ioregsel], ebx

  mov dword [rdi + KERNEL_IO_APIC_iowin], eax

  add ebx, KERNEL_IO_APIC_iowin_high - KERNEL_IO_APIC_iowin_low
  mov dword [rdi + KERNEL_IO_APIC_ioregsel], ebx

  shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
  mov dword [rdi + KERNEL_IO_APIC_iowin], eax

  pop rdi
  pop rbx
  pop rax

  ret
