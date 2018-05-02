AS = nasm
INC = ./
ASFLAGS = -f bin $(INC:%=-I %)

all : boot.bin

boot.bin : boot_s1.bin boot_s2.bin
	cat boot_s1.bin boot_s2.bin > boot.bin

%.bin : %.asm
	$(AS) $(ASFLAGS) -o $@ $<

clean :
	rm boot_s1.bin boot_s2.bin
