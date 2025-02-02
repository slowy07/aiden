![aiden banner](.github/banner.png)

simple operating system written with assembly x86_64

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

reference:

- [os dev](https://wiki.osdev.org/Expanded_Main_Page)
- [ascii table](https://www.freecodecamp.org/news/ascii-table-hex-to-ascii-value-character-code-chart-2/)
- [font: canele](addy-dclxvi.github.io)
