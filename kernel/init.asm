cmp byte [kernel_init_smp_semaphore], STATIC_FALSE
je  kernel_init

	%include "kernel/init/data.asm"
	%include "kernel/init/apic.asm"

kernel_init:
  	%include "kernel/init/serial.asm"
	%include "kernel/init/video.asm"
	%include "kernel/init/memory.asm"
	%include "kernel/init/acpi.asm"
	%include "kernel/init/page.asm"
	%include "kernel/init/gdt.asm"
	%include "kernel/init/idt.asm"
	%include "kernel/init/rtc.asm"
	%include "kernel/init/ps2.asm"
	%include "kernel/init/ipc.asm"
	%include "kernel/init/vfs.asm"
	%include "kernel/init/storage.asm"
	%include "kernel/init/network.asm"
	%include "kernel/init/task.asm"
	%include "kernel/init/services.asm"

	call kernel_init_apic

	mov dword [rdi + KERNEL_APIC_TICR_register], DRIVER_RTC_Hz
	
	mov dword [rdi + KERNEL_APIC_EOI_register], STATIC_EMPTY
	mov byte [kernel_init_semaphore], STATIC_FALSE

	jmp clean
