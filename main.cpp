#include <stdio.h>

extern "C" void _MyFastCallPrintf (const char* format, ...);

int main ()
{

    _MyFastCallPrintf ("%o\n%d %s %x %d%%%c%b\n%d %s %x %d%%%c%b", -1, -1, "love", 3802, 100, 33, 127,
                                                                 -1, "love", 3802, 100, 33, 127);

    _MyFastCallPrintf ("%o\n%d %s %x %d%%%c%b\n%d %s %x %d%%%c%b", -1, -1, "love", 3802, 100, 33, 127,
                                                                 -1, "love", 3802, 100, 33, 127);



    return 0;
}

// ld -s -o build/bin/MyPrintf build/obj/main.o build/obj/MyPrintf.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -fsanitize=address
