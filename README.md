![aiden banner](.github/banner.png)

simple operating system written with assembly x86_64

## requirements system
- cpu with dual core
- 2MiB RAM
- 3MiB storage

run test:

```
nasm -f bin kernel/init/boot.asm -o build/boot
nasm -f bin kernel/kernel asm -o build/kernel -dMULTIBOOT_VIDEO_WIDTH_pixel=640 -dMULTIBOOT_VIDEO_HEIGHT_pixel=480
nasm -f bin aiden/aiden -o build/disk.raw -dMULTIBOOT_VIDEO_WIDTH_pixel=640 -dMULTIBOOT_VIDEO_HEIGHT_pixel=480
```

running on qemu:
```
qemu-system-x86_64 -drive file=build/disk.raw,media=disk,format=raw -m 2
```

running qemu with configuration 2MiB RAM, 2 logic processor, and disk connected to AHCI controller in port 0
```
qemu-system-x86_64  -m 2 -smp 2 -rtc base=localtime -drive file=build/disk.raw,if=none,id=sata0,format=raw -device ich9-ahci,id=ahci -device ide-drive,drive=sata0,bus=ahci.0
```

running qemu with configuration 2MiB RAM, 2 logic processor, and IDE controller
```
qemu-system-x86_64 -hda file=build/disk.raw -m 2 -smp 2 -rtc base=localtime
```


reference:

- [os dev](https://wiki.osdev.org/Expanded_Main_Page)
- [ascii table](https://www.freecodecamp.org/news/ascii-table-hex-to-ascii-value-character-code-chart-2/)
- [font: canele](addy-dclxvi.github.io)
