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

KERNEL_APIC_ID_register equ 0x0020
KERNEL_APIC_TP_register equ 0x0080
KERNEL_APIC_EOI_register equ 0x00B0
KERNEL_APIC_LD_register equ 0x00D0
KERNEL_APIC_LD_FLAG_target_cpu equ 0x01000000
KERNEL_APIC_DF_register equ 0x00E0
KERNEL_APIC_SIV_register equ 0x00F0
KERNEL_APIC_SIV_FLAG_enable_apic equ 00000000000000000000000100000000b
KERNEL_APIC_SIV_FLAG_spurious_vector equ 00000000000000000000000011111111b
KERNEL_APIC_ICL_register equ 0x0300
KERNEL_APIC_ICL_COMMAND_COMPLETE_bit equ 12
KERNEL_APIC_ICH_register equ 0x0310
KERNEL_APIC_LVT_TR_register equ 0x0320
KERNEL_APIC_LVT_TR_FLAG_mask_interrupts equ 00000000000000010000000000000000b
KERNEL_APIC_TICR_register equ 0x0380
KERNEL_APIC_TDC_register equ 0x03E0
KERNEL_APIC_TDC_divide_by_1 equ 0x0B
KERNEL_APIC_TDC_divide_by_16 equ 0x03
KERNEL_APIC_IRQ_number equ 0x20
kernel_apic_base_address dq STATIC_EMPTY
kernel_apic_size dq STATIC_EMPTY

kernel_apic_count db STATIC_EMPTY
kernel_apic_id_table times 0x0100 db STATIC_EMPTY

kernel_apic_id_get:
  macro_apic_id_get
  ret
