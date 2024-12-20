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

DRIVER_RTC_IRQ_number equ 0x08
DRIVER_RTC_IO_APIC_register equ KERNEL_IO_APIC_iowin + (DRIVER_RTC_IRQ_number * 0x02)
DRIVER_RTC_PORT_command equ 0x0070
DRIVER_RTC_PORT_data equ 0x0071
DRIVER_RTC_PORT_second equ 0x00
DRIVER_RTC_PORT_minute equ 0x02
DRIVER_RTC_PORT_hour equ 0x04
DRIVER_RTC_PORT_weekday equ 0x06
DRIVER_RTC_PORT_day_of_month equ 0x07
DRIVER_RTC_PORT_month equ 0x08
DRIVER_RTC_PORT_year equ 0x09
DRIVER_RTC_PORT_STATUS_REGISTER_A equ 0x0A
DRIVER_RTC_PORT_STATUS_REGISTER_B equ 0x0B
DRIVER_RTC_PORT_STATUS_REGISTER_A_rate equ 00000110b
DRIVER_RTC_PORT_STATUS_REGISTER_A_divider equ 00100000b
DRIVER_RTC_PORT_STATUS_REGISTER_A_update_in_progress equ 10000000b
DRIVER_RTC_PORT_STATUS_REGISTER_B_daylight_savings equ 00000001b
DRIVER_RTC_PORT_STATUS_REGISTER_B_24_hour_mode equ 00000010b
DRIVER_RTC_PORT_STATUS_REGISTER_B_binary_mode equ 00000100b
DRIVER_RTC_PORT_STATUS_REGISTER_B_periodic_interrupt equ 01000000b
DRIVER_RTC_PORT_STATUS_REGISTER_C equ 0x0C
DRIVER_RTC_Hz equ 1024

struc DRIVER_RTC_STRUCTURE_TIME
  .second resb 1
  .minute resb 1
  .hour resb 1
  .day resb 1
  .month resb 1
  .year resb 1
  .day_of_week resb 1
endstruc

driver_rtc_semaphore db STATIC_FALSE
driver_rtc_microtime dq STATIC_EMPTY
driver_rtc_time dq STATIC_EMPTY

driver_rtc:
  push rax
  inc qword [driver_rtc_microtime]
  in al, DRIVER_RTC_PORT_data

  mov ax, qword [kernel_apic_base_address]
  mov dword [rax + KERNEL_APIC_EOI_register], STATIC_EMPTY
  pop rax

  iretq

driver_rtc_get_date_and_time:
  push rax

  mov al, DRIVER_RTC_PORT_second
  out DRIVER_RTC_PORT_command
  in al, DRIVER_RTC_PORT_data

  mov byte [driver_rtc_time + DRIVER_RTC_STRUCTURE_TIME.second], al

  mov al, DRIVER_RTC_PORT_minute
  out DRIVER_RTC_PORT_command, al
  in al, DRIVER_RTC_PORT_data

  mov byte [driver_rtc_time + DRIVER_RTC_STRUCTURE_TIME.minute], al
  mov al, DRIVER_RTC_PORT_hour
  out DRIVER_RTC_PORT_command, al
  in al, DRIVER_RTC_PORT_data

  mov byte [driver_rtc_time + DRIVER_RTC_STRUCTURE_TIME.hour], al
  pop rax

  ret
