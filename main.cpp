#include <stdio.h>

extern "C" void _MyFastCallPrintf (const char* format, ...);

int main ()
{

    _MyFastCallPrintf ("ABCD %d\n", -1);

    return 0;
}

// ld -s -o build/bin/MyPrintf build/obj/main.o build/obj/MyPrintf.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -fsanitize=address
