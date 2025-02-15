	; Kernel name
	kernel_init_string_name db KERNEL_name

kernel_init_string_name_end:

	; These strings are used for error reporting during kernel bootup.
	; Each message is null-terminated (STATIC_ASCII_TERMINATOR).
	kernel_init_string_error_video_header db "Error: no graphic mode header in multiboot table", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_memory_header db "Error: no memory map header in multiboot header", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_memory db "Error: memory map damaged", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_memory_low db "Error: not enough memory", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_acpi_header db "Error: RSDP/XSDP not found", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_acpi db "Error: RSDT/XSDT not recognized", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_apic db "Error: APIC not found", STATIC_ASCII_TERMINATOR
	kernel_init_string_error_ioapic db "Error: I/O APIC not found", STATIC_ASCII_TERMINATOR

	; These strings define standard storage device paths for IDE drives.
	; Used for device identification and access.
	kernel_init_string_storage_ide_hd_path db "/dev/hd" ; Base path for IDE hard drives
	kernel_init_string_storage_ide_hd_letter db "a" ; Default device letter

kernel_init_string_storage_ide_hd_end:

	; These variables serve as semaphores (flags) to track the initialization
	; status of key system components (APIC, I/O APIC, SMP, AP processors).
	kernel_init_apic_semaphore   db STATIC_FALSE ; APIC initialization status
	kernel_init_ioapic_semaphore   db STATIC_FALSE ; I/O APIC initialization status
	kernel_init_smp_semaphore   db STATIC_FALSE ; SMP initialization status
	kernel_init_ap_semaphore   db STATIC_FALSE ; AP processor initialization status
	kernel_init_ap_count    db STATIC_EMPTY ; Number of detected APs

	kernel_init_apic_id_highest   db STATIC_EMPTY ; Highest detected APIC ID

	; This table lists the kernel services available at boot time.
	; Each entry consists of:
	; - A 64-bit pointer to the service entry point
	; - A byte indicating the length of the service name
	; - The service name as a null-terminated string
	
	; The list ends with a STATIC_EMPTY marker.

kernel_init_services_list:
	dq service_tresher; Pointer to "tresher" service
	db 7; Length of "tresher"
	db "tresher"
	dq service_render; Pointer to "render" service
	db 6; Length of "render"
	db "render"
	dq service_datea; Pointer to "date" service
	db 4; Length of "date"
	db "date"
	dq STATIC_EMPTY; End of list marker

	; Defines the initial directories available in the virtual file system.
	; Each directory entry consists of:
	; - A byte indicating the length of the directory name
	; - The directory name as a null-terminated string
	
	; The list ends with a STATIC_EMPTY marker.

kernel_init_vfs_directory_structure:
	db 0x04; Length of "/bin"
	db "/bin"
	db 0x04; Length of "/dev"
	db "/dev"

	db STATIC_EMPTY; End of list marker

	; Defines initial files available in the VFS.
	; Each file entry consists of:
	; - A 64-bit pointer to the file data
	; - The file size (calculated as the difference between file start and end)
	; - A byte indicating the length of the file path
	; - The file path as a null-terminated string
	
	; The list ends with a STATIC_EMPTY marker.

kernel_init_vfs_files:
	;dq kernel_init_vfs_file_init
	;dq kernel_init_vfs_file_init_end - kernel_init_vfs_file_init
	;db 9
	;db "/bin/init"

	;dq kernel_init_vfs_file_shell
	;dq kernel_init_vfs_file_shell_end - kernel_init_vfs_file_shell
	;db 10
	;db "/bin/shell"

	;dq kernel_init_vfs_file_hello
	;dq kernel_init_vfs_file_hello_end - kernel_init_vfs_file_hello
	;db 10
	;db "/bin/hello"

	;dq kernel_init_vfs_file_free
	;dq kernel_init_vfs_file_free_end - kernel_init_vfs_file_free
	;db 9
	;db "/bin/free"

	dq kernel_init_vfs_file_console; Pointer to "/bin/console" file
	dq kernel_init_vfs_file_console_end - kernel_init_vfs_file_console
	db 12; Length of "/bin/console"
	db "/bin/console"
	dq STATIC_EMPTY; End of list marker

;kernel_init_vfs_file_init_end:
	; kernel_init_vfs_file_shell incbin "build/shell"

;kernel_init_vfs_file_shell_end:
	; kernel_init_vfs_file_hello incbin "build/hello"

;kernel_init_vfs_file_hello_end:
	; kernel_init_vfs_file_free incbin "build/free"

	; These sections contain the binary data for initial VFS files.
	; The actual files are included from external build artifacts.

kernel_init_vfs_file_free_end:
	kernel_init_vfs_file_console incbin "build/console" ; Include the compiled "console" binary

kernel_init_vfs_file_console_end:

	; This section includes the boot loader binary, used during system startup.

kernel_init_boot_file:
	incbin "build/boot"; Include the compiled boot binary

kernel_init_boot_file_end:
