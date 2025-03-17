;--------------------------------------------------------------------------------------------------
;                                  MyPrintf
;                         (c) 2025 Muratov Artyom
;--------------------------------------------------------------------------------------------------
; Compilation with:                     Flags:
; nasm -f elf64 -l 1-nasm.lst 1-nasm.s  -w+orphan-labels
; Linker:
; ld -s -o 1-nasm 1-nasm.o

section     .text

global _start                                           ; predefine entry point name for linker

_start:
            call _Meow                                  ; write "MeowMeowMeow" to consol

;-----------Push-Arguments-of-My-Printf------------------------------------------------------------

            push Format                                ; push format string as first arguments

;-----------End--Arguments-of-My-Printf------------------------------------------------------------

            call _MyPrintf                              ; call my function of printf

            mov rax, 0x3C                               ; exit64 (rdi)
            xor rdi, rdi
            syscall
;--------------------------------------------------------------------------------------------------
;           Exit from program
;--------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------
; _MyPrintf my function printf version 11.1, write to console string
;               with some arguments that pinned by '%'
; Entry:  --STACK (cdecl)--------------------------------
;         | ...                                         |
;         | ...                                         |
;         | ...                                         |
;         | arg2                      ...               |
;         | arg1                      <-- rsp + 16      |
;         | Format string             <-- rsp + 8       |
;         | return address to main    <-- rsp           |
;         -----------------------------------------------
; Exit:     None
; Destroy:  rax, rbx, rdx, rdi, rsi, rcx
;--------------------------------------------------------------------------------------------------
_MyPrintf:
            xor  rcx, rcx                               ; rcx = 0, rcx = counter symbols
                                                        ;   that was read from format string
            xor  rdx, rdx                               ; rdx = 0, rdx = counter symbols
                                                        ;   that was write to buffer of printf
;-----------Start-of-Read-Format-String------------------------------------------------------------

            mov  r8, 8[rsp]                             ; r8 = format string from stack

RdFrmtStrng:

            xor  rbx, rbx                               ; rbx = 0, register for symbols from format

            mov  bl, [r8 + rcx]                         ; rbx = symbol from format string
            inc  rcx                                    ; rcx++

            cmp  bl, '%'                                ; if (rbx != '%') {
            jne  NotSpecificator                        ; goto NotSpecificator }
                                                        ; else
            push rdx                                    ; save rdx in stack
            push rcx                                    ; save rcx in stack

            call ProcessSpecificator                    ; Process specificator next after '%';

            pop  rcx                                    ; back rcx from stack
            pop  rdx                                    ; back rdx from stack

            inc  rcx                                    ; rcx++

            jmp SpecificatorIsProccessed                ; goto SpecificatorIsProccessed

NotSpecificator:
            mov  [Buffer + rdx], rbx                    ; Buffer[rdx] = rbx
            inc  rdx                                    ; rdx++

SpecificatorIsProccessed:

;-----------Check-condition-of-end-reading-format-string-------------------------------------------
            cmp  rcx, FormatLen                         ; if (rcx == FormatLen) {
            je   EndRdFrmtStrng                         ;   goto EndRdFrmtStrng }
;-----------End-check------------------------------------------------------------------------------

;-----------Check-Buffer-Overflow------------------------------------------------------------------
            cmp  rdx, 64                                ; hardcode, 64 - magic circles len of buff
                                                        ; if (rdx != 64) {
            jb   NoOverflowBuffer                       ;   goto NoOverflowBuffer  }
            call WriteBuf                               ; write symbols from buffer
                                                        ;   to console and clear buffer
;-----------End-check------------------------------------------------------------------------------

NoOverflowBuffer:

            jmp RdFrmtStrng                             ; goto RdFrmtStrng

;-----------End-of-Read-Format-String--------------------------------------------------------------

EndRdFrmtStrng:
                                                        ;------------------------------------
            mov  rsi, Buffer                            ; rsi = addr of buffer              |
                                                        ; rdx = number of symbols to write  |
                                                        ;------------------------------------
            call WriteBuf                               ; func to write symbols from buffer
                                                        ;   to console and clear buffer
            ret

;--------------------------------------------------------------------------------------------------
; ProcessSpecificator function to check and process the specificator
; Entry:    r8  = Format string
;           rcx = index of specificator   in format string
;           rdx = index of next free cell in buffer
; Exit:     rdx = index of next free cell in buffer (changed)
; Destroy:  rbx, rsi, rax, rdi, rdx, rcx
;--------------------------------------------------------------------------------------------------
; need to process %(c,   s,   d,   x,   o,   b) and %%
; HEX               63h  73h  64h  78h  6Fh  62h

ProcessSpecificator:
            xor  rbx, rbx                               ; rbx = 0, register for symbols from format

            mov  bl, [r8 + rcx]                         ; bl = char of specificator

SwitchPrcssSpcfctr:
;-----------Count-index-for-cases------------------------------------------------------------------

            sub  bl, 60h                                ; rbx -= 60h to switch counter for cases

            cmp  bl, 18h                                ; if (rbx > 18h) {
            ja   case_def

;-----------Switch---------------------------------------------------------------------------------
            xor  rsi, rsi                               ; rsi = 0, register to addr of case

            movsxd rsi, [JumpTable + (rbx - 1) * 4]     ; take address from jump table
            jmp  rsi
case_2:                                                 ; handler %b
            call _Meow
            ret
case_3:                                                 ; handler %c

            ret
case_4:                                                 ; handler %d

            ret
case_F:                                                 ; handler %o

            ret
case_13:                                                ; handler %s

            ret
case_18:                                                ; handler %x

            ret
case_def:                                               ; default handler

            ret

;--------------------------------------------------------------------------------------------------
; WriteBuf  function to write to console buffer
; Entry:    rsi = Buffer
;           rdx = number of symbols to write
; Exit:     rsi = Buffer
;           rdx = 0
; Destroy:  rax, rdx, rdi
;--------------------------------------------------------------------------------------------------
WriteBuf:
            mov  rax, 0x01                              ; write64 (rdi, rsi, rdx)
            mov  rdi, 1                                 ; stdout

            syscall

            xor  rdx, rdx                               ; rdx = 0, to "clear" buffer

            ret

;--------------------------------------------------------------------------------------------------
; _Meow     my function write to console Meow
; Entry:    None
; Exit:     None
; Destroy:  rax, rdi, rsi, rdx, rcx
;--------------------------------------------------------------------------------------------------
_Meow:
            mov rax, 0x01                               ; write64 (rdi, rsi, rdx) ... r10, r8, r9
            mov rdi, 1                                  ; stdout
            mov rsi, Msg
            mov rdx, MsgLen                             ; strlen (Msg)
            syscall                                     ; destroy rcx :(

            ret

;--------------------------------------------------------------------------------------------------
section     .data
            align  8                                 ; align of 8 address in table
JumpTable:
            dd case_def                              ; case 1  default
            dd case_2                                ; case 2  (%b)
            dd case_3                                ; case 3  (%c)
            dd case_4                                ; case 4  (%d)
            dd case_def                              ; case 5  default
            dd case_def                              ; case 6  default
            dd case_def                              ; case 7  default
            dd case_def                              ; case 8  default
            dd case_def                              ; case 9  default
            dd case_def                              ; case A  default
            dd case_def                              ; case B  default
            dd case_def                              ; case C  default
            dd case_def                              ; case D  default
            dd case_def                              ; case E  default
            dd case_F                                ; case F  (%o)
            dd case_def                              ; case 10 default
            dd case_def                              ; case 11 default
            dd case_def                              ; case 12 default
            dd case_13                               ; case 13 (%s)
            dd case_def                              ; case 14 default
            dd case_def                              ; case 15 default
            dd case_def                              ; case 16 default
            dd case_def                              ; case 17 default
            dd case_18                               ; case 18 (%x)
            dd case_def                              ; case    default

Format:     db "d%bMeowMeowMeowGGG", 0x0a

FormatLen:  equ $ - Format

Buffer:     TIMES 64 db 0

Msg:        db "MeowMeowMeow", 0x0a
MsgLen      equ $ - Msg
