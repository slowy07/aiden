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

kernel_init_network:
  mov eax, DRIVER_PIC_CLASS_SUBCLASS_network
  call driver_pci_find_class_and_subclass
  jc .end

  mov eax, DRIVER_PCI_REGISTER_vendor_and_device
  call driver_pci_read

  cmp eax, DRIVER_NIC_I82540EM_VENDOR_AND_DEVICE
  jne .end

  call driver_nic_i82540em

  call kernel_memory_alloc_page
  jc kernel_panic

  call kernel_page_drain
  mov qword [service_netwokr_port_table], rdi

  call kernel_memory_alloc_page
  jc kernel_panic

  call kernel_page_drain
  mov qword [service_network_stack_address], rdi
.end:
