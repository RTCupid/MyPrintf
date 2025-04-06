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
