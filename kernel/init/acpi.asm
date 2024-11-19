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

ACPI_MADT_ENTRY_lapic equ 0x00
ACPI_MADT_ENTRY_ioapic equ 0x01
ACPI_MADT_ENTRY_iso equ 0x02
ACPI_MADT_ENTRY_x2apic equ 0x09
ACPI_MADT_APIC_FLAG_ENABLED_bit equ 0

struc ACPI_STRUCTURE_RSDP
  .signature resb 8
  .checksum resb 1
  .oem_id resb 6
  .revision resb 1
  .rsdt_address resb 4
  .SIZE:
endstruc

struc ACPI_STRUCTURE_XSDP
  .rsdp resb ACPI_STRUCTURE_RSDP.SIZE
  .length resb 4
  .xsdt_address resb 8
  .checksum resb 1
  .reserved resb 3
  .SIZE:
endstruc

struc ACPI_STRUCTURE_RSDT_or_XSDT
  .signature resb 4
  .length resb 4
  .revision resb 1
  .checksum resb 1
  .oem_id resb 6
  .oem_table_id resb 8
  .oem_revision resb 4
  .creator_id resb 4
  .creator_revision resb 4
  .SIZE:
endstruc

struc ACPI_STRUCTURE_MADT
  .signature resb 4
  .length resb 4
  .revision resb 1
  .checksum resb 1
  .oem_id resb 6
  .oem_table_id resb 8
  .oem_revision resb 4
  .creator_id resb 4
  .creator_revision resb 4
  .apic_address resb 4
  .flags resb 4
  .SIZE:
endstruc

struc ACPI_STRUCTURE_MADT_entry
  .type resb 1
  .length resb 1
endstruc

struc ACPI_STRUCTURE_MADT_APIC
  .type resb 1
  .length resb 1
  .cpu_id resb 1
  .apic_id resb 1
  .flags resb 4
  .SIZE:
endstruc

struc ACPI_STRUCTURE_MADT_IOAPIC
  .type resb 1
  .length resb 1
  .ioapic_id resb 1
  .reserved resb 1
  .base_address resb 4
  .gsib resb 4
  .SIZE:
endstruc

struc ACPI_STRUCTURE_MADT_NMI
  .type resb 1
  .length resb 1
  .acpi_id resb 1
  .flags resb 2
  .lint resb 1
  .SIZE:
endstruc

kernel_init_acpi:
  mov rbx, "RSD PTR "
  movzx esi, word [0x040E]
  shl esi, STATIC_MULTIPLE_BY_16_shift
  mov r8b, STATIC_TRUE

.rsdp_search:
  lodsq
  cmp rax, rbx
  je .rsdp_found
  
  cmp esi, 0x000FFFFF
  jb .rsdp_search

  mov ecx, kernel_init_string_error_acpi_end - kernel_init_string_error_acpi
  mov rsi, kernel_init_string_error_acpi

.error:
  jmp kernel_panic

.rsdp_found:
  push rsi
  xor al, al
  mov ecx, ACPI_STRUCTURE_RSDP.SIZE
  sub rsi, ACPI_STRUCTURE_RSDP.checksum

.checksum:
  add al, byte [rsi]
  inc rsi

  loop .checksum

  pop rsi

  test al, al
  jnz .rsdp_search

.rsdp_or_xsdp:
  sub rsi, ACPI_STRUCTURE_RSDP.checksum
  cmp byte [rsi + ACPI_STRUCTURE_RSDP.revision], 0x00
  jne .extended

  mov edi, dword [rsi + ACPI_STRUCTURE_RSDP.rsdt_address]
  jmp .standard

.extended:
  mov rdi, qword [rsi + ACPI_STRUCTURE_XSDP.xsdt_address]
  mov r8d, STATIC_FALSE

.standard:
  mov ecx, kernel_init_string_error_corrupted_end - kernel_init_string_error_corrupted
  mov rsi, kernel_init_string_error_acpi_corrupted

  cmp qword [rdi + ACPI_STRUCTURE_RSDT_or_XSDT.signature], "RSDT"
  je .found

  cmp dword [rdi + ACPI_STRUCTURE_RSDT_or_XSDT.signature], "XSDT"
  jne .error

.found:
  mov ecx, dword [rdi + ACPI_STRUCTURE_RSDT_or_XSDT.length]
  sub ecx, ACPI_STRUCTURE_RSDT_or_XSDT.SIZE

  add rdi, ACPI_STRUCTURE_RSDT_or_XSDT.SIZE
  
  cmp r8b, STATIC_TRUE
  je .rsdt_pointers

.xsdt_pointers:
  shr ecx, STATIC_DIVIDE_BY_QWORD_shift

.xsdt_pointers_loop:
  mov rsi, qword [rdi]
  call .header

  add rdi, STATIC_QWORD_SIZE_byte
  dec ecx
  jnz .xsdt_pointers_loop

  jmp .summary

.rsdt_pointers:
  shr ecx, STATIC_DIVIDE_BY_DWORD_shift

.rsdt_pointers_loop:
  mov esi, dword [rdi]
  call .header
  add rdi, STATIC_DWORD_SIZE_byte

  dec ecx
  jnz .rsdt_pointers_loop
  
.summary:
  mov ecx, kernel_init_string_error_apic_end - kernel_init_string_error_apic
  mov rsi, kernel_init_string_error_apic

  cmp byte [kernel_apic_count], STATIC_EMPTY
  je .error

  mov ecx, kernel_init_string_error_ioapic_end - kernel_init_string_error_ioapic
  mov rsi, kernel_init_string_error_ioapic

  cmp byte [kernel_init_ioapic_semaphore], STATIC_FALSE
  je .error

  jmp .end

.header:
  cmp dword [rsi + ACPI_STRUCTURE_MADT.signature], "APIC"
  je .madt

  ret

.madt:
  push rcx
  push rsi
  push rdi

  mov eax, dword [rsi + ACPI_STRUCTURE_MADT.apic_address]
  mov dword [kernel_apic_base_addres], eax

  mov ecx, dword [rsi + ACPI_STRUCTURE_MADT.length]
  mov dword [kernel_apic_size], ecx

  sub ecx, ACPI_STRUCTURE_MADT.SIZE
  add rsi, ACPI_STRUCTURE_MADT.SIZE

  mov rdi, kernel_apic_id_table

.madt_loop:
  cmp byte [rsi + ACPI_STRUCTURE_MADT_entry.type], ACPI_MADT_ENTRY_ioapic
  je .madt_ioapic

  cmp byte [rsi + ACPI_STRUCTURE_MADT_entry.type], ACPI_MADT_ENTRY_ioapic
  je .madt_ioapic


.madt_next_entry:
  movzx eax, byte [rsi + ACPI_STRUCTURE_MADT_entry.length]
  add rsi, rax

  sub rcx, rax
  jnz .madt_loop

  pop rdi
  pop rsi
  pop rcx

  ret

.madt_apic:
  bt word [rsi + ACPI_STRUCTURE_MADT_APIC.flags], ACPI_MADT_APIC_FLAG_ENABLED_bit
  jnc .madt_next_entry

  inc word [kernel_apic_count]
  
  mov al, byte [rsi + ACPI_STRUCTURE_MADT_APIC.cpu_id]
  stosb

  cmp al, byte [kernel_init_apic_id_highest]
  jbe .madt_next_entry
  
  mov byte [kernel_init_apic_id_highest], al

  jmp .madt_next_entry

.madt_ioapic:
  cmp byte [kernel_init_ioapic_semaphore], STATIC_TRUE
  je .madt_next_entry

  mov eax, dword [rsi + ACPI_STRUCTURE_MADT_IOAPIC.gsib]
  test al, al
  jnz .madt_next_entry

  mov eax, dword [rsi + ACPI_STRUCTURE_MADT_IOAPIC.base_address]
  mov dword [kernel_io_apic_base_address], eax

  mov byte [kernel_init_ioapic_semaphore], STATIC_TRUE
  jmp .madt_next_entry
.end:
