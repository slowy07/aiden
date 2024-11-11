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

DRIVER_PCI_PORT_command equ 0x0CF8
DRIVER_PCI_PORT_data equ 0x0CFC

DRIVER_PCI_REGISTER_vendor_and_device equ 0x00
DRIVER_PCI_REGISTER_status_and_command equ 0x04
DRIVER_PCI_REGISTER_class_and_subclass equ 0x08
DRIVER_PCI_REGISTER_bar0 equ 0x10
DRIVER_PCI_REGISTER_bar1 equ 0x14
DRIVER_PCI_REGISTER_irq equ 0x3C
DRIVER_PCI_REGISTER_FLAG_64_bit equ 00000010b
DRIVER_PCI_CLASS_SUBCLASS_network equ 0x0200

driver_pci_find_vendor_and_device:
  push rbx
  push rcx
  push rdx
  push rax

  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

.next:
  mov eax, DRIVER_PCI_REGISTER_vendor_and_device
  call driver_pci_read

  cmp eax, dword [rsp]
  je .found

  inc edx

  cmp edx, 0x0008
  jb .next

  inc ecx

  xor edx, edx

.next:
  mov eax, DRIVER_PCI_REGISTER_vendor_and_device
  call driver_pci_read

  cmp eax, dword [rsp]
  je .found

  inc edx
  xor edx, edx

  cmp ecx, 0x0020
  jb .next

  inc ebx

  xor ecx, ecx
  cmp ebx, 0x0100
  jb .next

.error:
  stc
  jmp .end

.found:
  mov eax, DRIVER_PCI_REGISTER_bar0
  call driver_pci_read

  mov qword [rsp + STATIC_QWORD_SIZE_byte], rdx
  mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x02], rcx
  mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x03], rbx

  clc

.end:
  pop rax
  pop rdx
  pop rcx
  pop rbx

  ret

driver_pci_find_class_and_subclass:
  push rbx
  push rcx
  push rdx
  push rax

  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

.next:
  mov eax, DRIVER_PCI_REGISTER_class_and_subclass
  call driver_pci_read

  shr eax, STATIC_MOVE_HIGH_TO_AX_shift
  
  cmp ax, word [rsp]
  je .found
  
  inc edx

  cmp edx, 0x008
  jb .next

  inc ecx
  xor edx, edx

  cmp ecx, 0x0020
  jb .next

  inc ebx
  xor ecx, ecx

  cmp ebx, 0x0100
  jb .next

.error:
  stc
  jmp .end

.found:
  mov qword [rsp + STATIC_QWORD_SIZE_byte], rdx
  mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x02], rcx
  mov qword [rsp + STATIC_QWORD_SIZE_byte * 0x03], rbx

  clc

.end:
  pop rax
  pop rdx
  pop rcx
  pop rbx

  ret

driver_pci_read:
  push rbx
  push rcx
  push rdx

  or eax, 0x80000000

  ror eax, 8
  or al, dl

  ror eax, 3
  or al, cl

  ror eax, 5
  or al, bl

  rol eax, 16

  mov dx, DRIVER_PCI_PORT_command
  out dx, eax

  mov dx,DRIVER_PCI_PORT_data
  in eax, dx

  pop rdx
  pop rcx
  pop rbx

  ret

driver_pci_write:
  push rbx
  push rcx
  push rdx
  push rax

  or eax, 0x80000000
  
  ror eax, 8
  or al, dl

  ror eax, 3
  or al, cl

  ror eax, 5
  or al, bl

  rol eax, 16

  mov dx, DRIVER_PCI_PORT_command
  out dx, eax

  pop rax

  mov dx, DRIVER_PCI_PORT_data
  out dx, eax

  pop rdx
  pop rcx
  pop rbx

  ret
