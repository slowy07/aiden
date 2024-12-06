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

align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING
kernel_gdt_header dw KENREL_PAGE_SIZE_byte
                  dq STATIC_EMPTY

align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING
kernel_gdt_tss_bsp_selector dw STATIC_EMPTY
kernel_gdt_tss_cpu_selector dw STATIC_EMPTY

align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING
kernel_gdt_tss_table:
                      dd STATIC_EMPTY
                      dq KERNEL_STACK_pointer
  times 92            db STATIC_EMPTY
kernel_gdt_tss_table_end:

align STATIC_QWORD_SIZE_byte, db STATIC_NOTHING
kernel_idt_header:
                    dw KERNEL_PAGE_SIZE_byte
                    dq STATIC_EMPTY

kernel_string_space db STATIC_ASCII_SPACE
kernel_string_new_line db STATIC_ASCII_NEW_LINE
kernel_string_dot db STATIC_ASCII_DOT
kernel_string_welcome db STATIC_COLOR_ASCII_BLUE_LIGHT, "wello!", STATIC_ASCII_NEW_LINE
