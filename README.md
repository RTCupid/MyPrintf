# My Printf
## Contents
- [0. Introduction](#introduction)
- [1. Supporting fastcall and cdecl calling conventions](#supporting-fastcall-and-cdecl-calling-conventions)
- [2. Processing specifiers](#processing-specifiers)
- [3. Example of calling my printf from C program](#example-of-calling-my-printf-from-с-program)

## Introduction
My function printf. Project in assembly language NASM. It based on two calling conventions: cdecl and fastcall. The program include my cdecl version of printf that handles specifiers: %c, %s, %d, %x, %o, %b. Also it have trampoline for transition from fastcall version to cdecl version of my printf. The selection of the code that will process the specifier is made using the Jump Table.

## Supporting fastcall and cdecl calling conventions
My function can be called from C program. For support fastcall calling convention I made trampoline to cdecl version. My version of trampoline you can see in block of code.
``` Asm
_MyFastCallPrintf:
            pop  rax                                    ; rax = return address to main

            push r9                                     ;------------------------------------------
            push r8                                     ; Push                                    |
            push rcx                                    ;    FastCall                             |
            push rdx                                    ;           Parameters                    |
            push rsi                                    ;                    to Stack             |
            push rdi                                    ;------------------------------------------

            push rax                                    ; Push "return address to main" to stack

            jmp _MyPrintf                               ; call cdecl version of my printf and
                                                        ; return to main from it
;-----------End-_MyFastCallPrintf-----------------------------------------------------------------
```
## Processing specifiers
The selection of the code that will process the specifier is made using the Jump Table.

I process specifiers %b, %o, %x using masks, %d using instruction 'div', %c - symbol just puts into the buffer. The outputs are buffered first to reduce the number of syscalls. If specifier is %s, I will compare len of string with len of buffer and with number of free places in buffer, and I output it depending on the results. Example of processing %c you can see in next block of code.
``` Asm
;--------------------------------------------------------------------------------------------------
;           Symbol Handler                                                                        |
;--------------------------------------------------------------------------------------------------
case_3:                                                 ; handler %c
            mov  rbx, [rsp + OfsStrtArgInStk + 8 * r9]  ; rbx = some argument from stack
            inc  r9                                     ; r9++ <=> next argument

            mov  [Buffer + rdx], rbx                    ; Buffer[rdx] = rbx
            inc  rdx                                    ; rdx++

            ret
```
<a id="example-of-calling-my-printf-from-с-program"></a> 
## Example of calling my printf from C program
You can see example of calling my printf from C program in next block of code.
``` C
#include <stdio.h>

extern "C" void _MyFastCallPrintf (const char* format, ...);

int main ()
{
    _MyFastCallPrintf ("%o\n%d %s %x\n", -1, -1, "love", 3802);
    return 0;
}
```
