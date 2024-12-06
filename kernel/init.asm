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

  cmp byte [kernel_init_semaphore], STATIC_FALSE
  je .entry

  %include "kernel/init/ap.asm"

.entry:
  %include "kernel/init/long_mode.asm"
  %include "kernel/init/panic.asm"
  %include "kernel/init/data.asm"
  %include "kernel/init/multiboot.asm" 

[BITS 64]
  %include "kernel/init/apic.asm"

kernel_init:
  %include "kernel/init/video.asm"
  %include "kernel/init/memory.asm"
  %include "kernel/init/acpi.asm"
  %include "kernel/init/page.asm"
  %include "kernel/init/gdt.asm"
  %include "kernel/init/idt.asm"
  %include "kernel/init/rtc.asm"
  %include "kernel/init/ps2.asm"
  %include "kernel/init/ipc.asm"
  %include "kernel/init/network.asm"
  %include "kernel/init/task.asm"
  %include "kernel/init/services.asm"

  call kernel_init_apic
  mov dword [rsi + KERNEL_APIC_TICR_register], DRIVER_RTC_Hz
  mov dword [rsi + KERNEL_APIC_EOI_register], STATIC_EMPTY
  sti

  %include "kernel/init/smp.asm"

.wait:
  mov al, byte [kernel_init_ap_count]
  inc al
  cmp al, byte [kernel_apic_count]
  jne .wait

  jmp clean
