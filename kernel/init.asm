cmp byte [kernel_init_smp_semaphore], STATIC_FALSE
je  .entry

%include "kernel/init/ap.asm"

.entry:
	%include "kernel/init/long_mode.asm"
	%include "kernel/init/panic.asm"
	%include "kernel/init/data.asm"
	%include "kernel/init/multiboot.asm"
	[BITS    64]

	%include "kernel/init/apic.asm"

kernel_init:
	%include "kernel/init/video.asm"
	%include "kernel/init/font.asm"
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
	%include "kernel/init/serial.asm"

	call kernel_init_apic

	mov dword [rsi + KERNEL_APIC_TICR_register], DRIVER_RTC_Hz

	mov dword [rsi + KERNEL_APIC_EOI_register], STATIC_EMPTY

	%include "kernel/init/smp.asm"

.wait:
	mov al, byte [kernel_init_ap_count]
	inc al

	cmp al, byte [kernel_apic_count]
	jne .wait

	mov byte [kernel_init_semaphore], STATIC_FALSE

	jmp clean
