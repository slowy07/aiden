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