
all: fr.full.gba
	./test.sh

%.o : %.s
	arm-none-eabi-as -o $@ $<

%.elf : %.o
	arm-none-eabi-ld -Ttext=0x8000000 -o $@ $<

%.gba : %.elf
	arm-none-eabi-objcopy -O binary $< $@

fr.full.s: fr.gba fr.s
	rm -f fr.full.s
	cp fr.s fr.full.s
	./put_end.sh fr.gba fr.full.s


#	arm-none-eabi-as fr.s
#	arm-none-eabi-ld -Ttext=0x8000000 -o fr.elf a.out
#	arm-none-eabi-objcopy -O binary fr.elf fr.gba
#	./test.sh


