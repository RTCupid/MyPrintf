run:
	nasm -f elf64 -l build/obj/MyPrintf.lst MyPrintf.s -o build/obj/MyPrintf.o

	ld -s -o build/bin/MyPrintf build/obj/MyPrintf.o
