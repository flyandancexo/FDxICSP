# FDxICSP 
## New High Speed AVR MCU programmer - AVR910 SK500
![FDxICSP10](https://github.com/flyandancexo/FDxICSP/assets/66555404/50b710b1-f020-4c94-acfa-292883ed979f)

The Juno FDxICSP 1 is a self-programmable programmer that is created with the best hardware and software in a tiny beautifully-craft PCB. A world's fastest bootloader has been developed for it that covers the self-programmable part; The firmware for programmer is also probably the world's fastest and most sophisticated; In comparison, the very popular USBasp claims to have 5kB/s write, but in reality only can write at less than 2.5kB/s.

A bootloader can be anything, and it's implemented with a self-programmable mechanism to upload new code to the application section of the MCU; FDxboot v1.61 is the name of the firmware for the bootloader, and it has achieved a maximum speed of 36.1kB/s upload (write) and 51.1kB/s read; 2, A programmer is the hardware responsible to write to (program) another MCU, and it's also the application of being the programmer. FDxICSP v1.81 is the name of the firmware for that, and it has achieved a maximum speed of 28.3kB/s write and 32.2kB/s read; In short, there are 2 mini systems in one chip both coded near perfection. The bootloader can update the programmer(application), and the programmer can update another external MCU all using the same USB cable, so FDxICSP 1 is an egg and a chicken at the same time. They co-exist on the same chip.

PS. Technically, the maximum write speed on a 256-byte page MCU is about 36.1kB/s, but FDxICSP is still probably the world's fastest AVR programmer at 28.3kB/s.

![V181](https://github.com/flyandancexo/FDxICSP/assets/66555404/94a58e6b-7433-484b-8ffe-f9fc552a3f44)

## Features for FDxICSP v1 (Hardware):
- Tinniest size PCB with expertly hand-draw trace (40mm x 16mm board size)
- CH340G supports up to 2Mbps ( 500kbps default for bootloader; 1Mbps default for programmer )
- Support 5V and 3V option with 2 jumpers
- A large RBG LED and a reset button
- Self-Programmable, target-programmable and more

## Features for FDxICSP v1.81 (Firmware):
- Universally support all AVR MCU with 128kB or less that use SPI Memory Programming
- Expertly written firmware with a lot of hidden features, error free at 4MHz
- Support write and read to EEPROM, fuses, calibration, and signature bytes
- Upload speed absolute Maximum @28.3kB/s on an Atmega128 with 4MHz SCK
- Support target MCU with 16MHz-1.9kHz system clock speed, all clock range basically
- Seamless Auto Maximum SCK from 4MHz-488Hz True SPI Hardware + Good SPI Software
- Support SCK over-ridding with extended option using -x devcode (#1-7:8-14) (Auto SCK:0x11)
- Compatible with AVRdude, fully tested on v6.3 and v7.2 loosely based on AVR910
- RBG LED to show different stage: blue for write flash, teal for write EEPROM, pink for read back

### More detail
AVR910 Protocol is actually very bad and buggy, so able to create a programmer that can support 90+% of all AVR MCU is almost a miracle. A lot of tricks are used to make that possible that most people probably never heard of. The first limitation is that AVR910 only can send a 16-bit word-address, so maximum flash memory supported is 2^16*2=131072 bytes or 128k bytes. The second limitation is something call the devcode or device-code. It's an arbitrary 1-byte code designated to simplify the longer 3-byte signature code. What this means is that by definition, only 127 maximum MCUs can be supported, but in reality only fewer than 30 MCUs were given a devcode, so the number of supported MCU for AVR910 is very low. FDxICSP resolves this bug by ignoring the devcode completely and actually getting the required information from the signature bytes using a decoder instead. Not only that, FDxICSP has hacked the devcode and uses it to implement SCK over-ridding functionality. Essentially, when AVR910 gave out a bunch of lemons, FDxICSP makes delicious lemonade out of them.

### More about upload speed
Upload speed depends on many factors. The actual file size, the page size of the target MCU and the maximum system clock of the target MCU all affect the attainable maximum upload speed. Writing speed is normally slower than read speed because writing to flash memory requires a fixed period of waiting time, whereas reading doesn't need to wait, but to actually improve readback stability, FDxICSP lowers the readback SCK to next step, so reading can be slower than writing if the system clock is slower than 8MHz.

Since memory is written one page at a time and the timing for that is similar across all MCUs, MCUs with a larger page size write faster. FDxICSP uses an algorithm to automatically select the maximum SCK for the target MCU, but this SCK still depends on the target MCU's own system clock. A target MCU clocked-in with 16MHz supports maximum 4MHz SPI SCK. This is also a very big speed factor. Finally, the larger the file, the faster speed can be attained. If you sell ice-cream in big buckets, you would sell them faster than in tiny cups. It's more efficient with larger portion.

![speed](https://github.com/flyandancexo/FDxICSP/assets/66555404/b0f4b514-4a0b-49d1-a41a-fc230f789b71)

Note: Atmega8 and Atiny13 are tested using 2MHz SCK. Atiny13 is slow, but keep in mind that it only has 1k bytes, so at 6.0 kB/s, it took milliseconds to upload its maximum size.

### Why upload speed is important?

The job of a programmer is to write code to a MCU, so the quality of a programmer can only be defined by its maximum upload speed. Faster upload speed means higher quality, but it can also save you a lot of time. An AVR MCU can be reprogrammed 10k times. The time to just upload 100k bytes to an atmega128 10k times using my FDxICSP would be about 100/28.3*10000=35335 seconds or 588 minutes or 9.8 hours; Same task using an USBasp with maximum upload speed of 2 kB/s would be 100/2*10000=500000 seconds or 8333 minutes or 138 hours. You would save 138-9.8=128.2 hours or 5.34 days. Holy molly, right? And this is only assuming you do that verification.

PS. My bootloader is much faster than my programmer because bootloader is faster by definition, so for developing with MCU with larger than 32kB memory, using a good bootloader is still recommended. The same task with my FDxboot would be about 100/36.1*10000=27700 seconds or 461 minutes or 7.7 hours.

### What is next?

Since the hardware for FDxICSP v1 is self-programmable, it will be used to develop my own better and best communication protocol, and a firmware written very loosely based on either SK500 or SK500v2 will be made available soon, but for now, FDxICSP v1.81 (firmware) is fast, 99.99% probably the fastest, bug-free, error-free, sophisticated, very usable and enjoyable to use.

## How to use

The bootloader has been locked to make sure that it doesn't over-write itself. The bootloader can be removed or updated by connecting the SS jumper near the 6-pin ICSP, and new code can be programmed using those 6 pins, but this should rarely need to be done and updating the bootloader requires another programmer.

What you can do with this board:
1, You can use this just as a programmer (FDxICSP v1.81 is pretty good already)
2, You can use this to develop your own programmer, since the board is self-programmable.
3, You can use this as a development board. It has 4 programmable IO pins and 3 LEDs.
4, You can reprogram this as a SPI reader for your computer.
5, It can be a universal programmer for other type of chips.

FDxboot is loosely based on AVR109 (bootloader) with default 500kbps baud rate, and FDxICSP is loosely based on AVR910 (programmer) with default 1Mbps baud rate. FDxboot is harder to remove, on the other hand FDxICSP can be easily removed or updated.

![V181b](https://github.com/flyandancexo/FDxICSP/assets/66555404/778c7f44-72f6-4a45-817a-63c9ae407923)

### Potential Problems

The USB cable and USB port can be very critical. The USB-to-Serial CH340G is actually a solid serious serial chip, but if you can't install the driver properly, try to use older driver. For example, on one of my computers, CH341SER v3.4 is the only driver version that works, but on my other computer, all version works fine.

### Firmware Variations

FDxICSP Firmware Variations: The default baud rate is 1Mbps, but in case if this is not stable on your computer, you can change the firmware to 500kbps. If this is also not stable, get a new computer; FDxICSP is loosely based on AVR910, but AVR910 is broken and buggy, to get it to work properly that supports all MCU, the signature bytes are decoded to extract critical information. It's possible for a MCU to work properly, but with its signature bytes corrupted. FDxICSP requires these signature bytes to function properly, thus 4 variation are available to deal with MCUs with corrupted signature bytes: 1-2kB, 4-8kB, 16-32kB and 64-128kB. Thus if signature bytes are corrupted, the firmware needs to be swapped to properly program that range of MCU. Any of the 4 variations works perfectly fine with MCU with intact signature bytes.

PS. Programmer ID is hacked to display the SCK number and the actual auto-selected SCK rate, but when over-ridding is used, it will not display the over-rode SCK value. With AVRdude 7.2, using -v switch to display additional information.

### Firmware Update

```
###To upload new firmware for the programmer, then enter the following command, and press the reset button:
avrdude.exe -c avr109 -p m88 -b 500000 -P COM3 -U flash:w:"newFirmware.hex":i
```

### Using the programmer

Extended switch -x devcode=(0x1-0x11) or 1-17 are reserved for FDxICSP, as these numbers are not assigned to anything. Use 0x11 as default, and this is the auto SCK option.

```
###To upload new code to a target MCU using the programmer, plug in and enter the following command:
avrdude.exe -c AVR910 -p TARGET_MCU_PART_NAME -b 1000000 -x devcode=0x11 -P COM3 -U flash:w:"newCode.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x11 -P COM3 -U flash:w:"newCode.hex":i
```

### SPI SCK over-ridding

SCK overriding is possible using a hack with extended switch -x devcode=(#1-7:8-14); Using SCK over-ridding with FDxICSP v1.81 is a little meaningless since the auto-SCK selector is rock solid, but it is possible that auto SCK on some MCU is not stable, and simply lowering the SCK to next step would solve that stability problem. It's not possible to use 4MHz SCK on slower target MCU, but you can try, but it's highly not recommended, as it could potentially corrupt your MCU. Therefore SCK overriding should only be used if readback is not stable.

```
###Devcode from 1-7:8-14[SCK:4M,2M,1M,500K,250K,125K,62K]{31k,15k,7.8k,3.9k,1.9k,976,488}
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x1 -P COM3 -U flash:w:"newCode_4M.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x2 -P COM3 -U flash:w:"newCode_2M.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x3 -P COM3 -U flash:w:"newCode.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x4 -P COM3 -U flash:w:"newCode.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x5 -P COM3 -U flash:w:"newCode.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x6 -P COM3 -U flash:w:"newCode_125K.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x7 -P COM3 -U flash:w:"newCode_62K.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x8 -P COM3 -U flash:w:"newCode_31K.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=13 -P COM3 -U flash:w:"newCode_976Hz.hex":i
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=14 -P COM3 -U flash:w:"newCode_488Hz.hex":i

###Devcode from 0x0F-0x11 (15-17) == auto select maximum SCK 
avrdude.exe -c AVR910 -p m328p -b 1000000 -x devcode=0x11 -P COM3 -U flash:w:"newCode.hex":i
```

### Create New Programmer in AVRdude

To simplify the command line, following entrances can be added to the avrdude.conf file:

```

#------------------------------------------------------------
# FDxICSP - FDxICSP1M
#------------------------------------------------------------
programmer
  id    = "FDxICSP1M";
  desc  = "Flyandance High Speed ISP at 1Mbps";
  type  = "avr910";
  baudrate = 1000000;
  prog_modes = PM_ISP;
  connection_type = serial;
;

#------------------------------------------------------------
# FDxICSP - 500kbps
#------------------------------------------------------------
programmer
  id    = "FDxICSP500K";
  desc  = "Flyandance High Speed ISP at 500kbps";
  type  = "avr910";
  baudrate = 500000;
  prog_modes = PM_ISP;
  connection_type = serial;
;

#######################################################
### New command to use the new programmer 
#######################################################

avrdude.exe -c FDxICSP1M -p m328p -x devcode=0x11 -P COM3 -U flash:w:"newCode.hex":i
avrdude.exe -c FDxICSP500K -p m328p -x devcode=0x11 -P COM3 -U flash:w:"newCode.hex":i
```


To support the creation of more quality project, do donate whatever amount that you are comfortable with.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/flyandance?country.x=US&locale.x=en_US)

