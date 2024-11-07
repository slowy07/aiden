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

kernel_init_string_video_welcome db "welcome to aiden", STATIC_ASCII_NEW_LINE
kernel_init_string_video_welcome_end:

kernel_init_string_error_memory db "Init: memory map, error."
kernel_init_string_error_memory_end:

kernel_init_string_error_memory_low db "No enough memory."
kernel_init_string_error_memory_low_end:

kernel_init_string_error_acpi db "ACPI table not found."
kernel_init_string_error_acpi_end:

kernel_init_string_error_acpi_2 db "currently support ACPI V1 version"
kernel_init_string_error_acpi_2_end:

kernel_init_string_error_acpi_corrupted db "ACPI table, corrupted"
kernel_init_string_error_acpi_corrupted_end:

kernel_init_string_error_apic db "APIC table not found"
kernel_init_string_error_apic_end:

kernel_init_string_error_ioapic db "I/O APIC table not found"
kernel_init_string_error_ioapoc_end:

kernel_init_apic_semaphore db STATIC_FALSE
kernel_init_ioapic_semaphore db STATIC_FALSE
kernel_init_smp_semaphore db STATIC_FALSE
kernel_init_ap_count db STATIC_EMPTY
kernel_init_apic_id_highest db STATIC_EMPTY
