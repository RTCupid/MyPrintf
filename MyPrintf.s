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
;           with some arguments that pinned by '%'
; Entry:    head = format string
;           parametres in stack (type "cdecl")
; Exit:     None
; Destroy:  rax, rbx, rdx, rdi, rsi, rcx
;--------------------------------------------------------------------------------------------------
_MyPrintf:
            xor  rcx, rcx                               ; rcx = 0, rcx = counter symbols
                                                        ;   that was read from format string
            xor  rdx, rdx                               ; rdx = 0, rdx = counter symbols
                                                        ;   that was write to buffer of printf
;-----------Start-of-Read-Format-String------------------------------------------------------------

            pop  r8                                     ; r8 = format string
            ;mov  r8, Format

RdFrmtStrng:

            mov  rbx, [r8 + rcx]                        ; rbx = symbol from format string
            inc  rcx                                    ; rcx++

            cmp  rbx, '%'                               ; if (rbx != '%') {
            jne  NotSpecificator                        ; goto NotSpecificator }
                                                        ; else
            call ProcessSpecificator                    ; Process specificator next after '%';


NotSpecificator:
            mov  [Buffer + rdx], rbx                    ; Buffer[rdx] = rbx
            inc  rdx                                    ; rdx++




;-----------Check-condition-of-end-reading-format-string-------------------------------------------
            cmp  rcx, FormatLen                         ; if (rcx == FormatLen) {
            je   EndRdFrmtStrng                         ;   goto EndRdFrmtStrng }
;-----------Check-Buffer-Overflow------------------------------------------------------------------
            cmp  rdx, 64                                ; hardcode, 64 - magic circles len of buff
                                                        ; if (rdx != 64) {
            jb   NoOverflowBuffer                       ;   goto NoOverflowBuffer  }
            call WriteBuf                               ; write symbols from buffer
                                                        ;   to console and clear buffer





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
; Entry:    rsi = Buffer
;           rcx = index of specificator in format string
; Exit:     rsi = Buffer
;           rdx = 0
; Destroy:  rax, rdx, rdi
;--------------------------------------------------------------------------------------------------
ProcessSpecificator:
            mov  rbx, [Format + rcx]                    ; rbx = symbol from format string



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
; Destroy:  rax, rdi, rsi, rdx
;--------------------------------------------------------------------------------------------------
_Meow:
            mov rax, 0x01                               ; write64 (rdi, rsi, rdx) ... r10, r8, r9
            mov rdi, 1                                  ; stdout
            mov rsi, Msg
            mov rdx, MsgLen                             ; strlen (Msg)
            syscall

            ret

;--------------------------------------------------------------------------------------------------

section     .data

Format:     db "dMeowMeowMeowGGG", 0x0a

FormatLen:  equ $ - Format

Buffer:     TIMES 64 db 0

Msg:        db "MeowMeowMeow", 0x0a
MsgLen      equ $ - Msg
