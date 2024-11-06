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
