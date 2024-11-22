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

KERNEL_IDT_IRQ_offset equ 0x20
KERNEL_IDT_TYPE_exception equ 0x8E00
KERNEL_IDT_TYPE_irq equ 0x8F00
KERNEL_IDT_TYPE_isr equ 0xEF00

kernel_idt_mount:
  push rax
  push rbx
  push rcx
  push rdi

  xchg rax, rdi

  shl rdi, STATIC_MULTIPLE_BY_16_shift
  add rdi, qword [kernel_idt_header + KERNEL_STRUCTURE_IDT_HEADER.address]

  mov rcx, 1
  call kernel_idt_update
  pop rdi
  pop rcx
  pop rbx
  pop rax

  ret
  macro_debug "kernel_idt_mount"

kernel_idt_update:
  push rax

.next:
  push rax
  sotsw

  mov ax, KERNEL_STRUCTURE_GDT.cs_ring0
  stosw

  mov ax, bx
  stosw

  mov rax, qword [rsp]
  shr rax, STATIC_MOVE_HIGH_TO_AX_shift
  stosw
  
  shr rax, STATIC_MOVE_HIGH_TO_EAX_shift
  stosd

  xor eax, eax
  stosd

  pop rax

  dec rcx
  jnz .next

  pop rcx
  ret
  macro_debug "kernel_idt_update"

kernel_idt_exception_default:
  xchg bx, bx
  nop

  iretq
  macro_debug "kernel_idt_exception_default"

kernel_idt_exception_general_protection_fault:
  xchg bx, bx
  nop
  nop
  iretq
  macro_debug "kernel_idt_exception_general_protection_fault"

kernel_idt_exception_page_fault:
  xchg bx, bx

  nop
  nop
  nop
  iretq
  macro_debug "kernel_idt_exception_page_fault"

kernel_idt_interrupt_hardware:
  push rdi
  mov rdi, qword [kernel_apic_base_address]
  mov dword [rdi + KERNEl_APIC_EOI_register], STATIC_EMPTY

  pop rdi
  iretq
  macro_debug "kernel_idt_interrupt_hardware"

kernel_idt_interrupt_software:
  or word [rsp + KERNEL_STRUCTURE_TASK_IRETQ.eflags], KERNEL_TASK_EFLAGS_cf
  iretq
  macro_debug "kernel_idt_interrupt_software"

kernel_idt_spurious_interrupt:
  iretq
  macro_debug "kernel_idt_spurious_interrupt"
