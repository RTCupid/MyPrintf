#include <stdio.h>

extern "C" void _MyPrintf (const char* format, ...);

int main ()
{

    _MyPrintf ("ABCD");

    return 0;
}

// ld -s -o build/bin/MyPrintf build/obj/main.o build/obj/MyPrintf.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -fsanitize=address
