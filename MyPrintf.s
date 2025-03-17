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

            ;push Format                                ; push format string as first arguments

;-----------End--Arguments-of-My-Printf------------------------------------------------------------

            call _MyPrintf                              ; call my function of printf

            mov rax, 0x3C                               ; exit64 (rdi)
            xor rdi, rdi
            syscall

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
; _MyPrintf my function printf version 11.1, write to console string
;           with some arguments that pinned by '%'
; Entry:    addr of format string
;           parametres in stack (type "cdecl")
; Exit:     None
; Destroy:  rax, rbx, rdx, rdi, rsi, rcx
;--------------------------------------------------------------------------------------------------
_MyPrintf:
            xor  rcx, rcx                               ; rcx = 0, rcx = counter symbols
                                                        ; that was read from format string
            xor  rdx, rdx                               ; rdx = 0, rdx = counter symbols
                                                        ; that was write to buffer of printf
            mov  rax, 0x01                              ; write64 (rdi, rsi, rdx)
            mov  rdi, 1                                 ; stdout

            mov  rbx, [Format + rcx]                    ; rbx = symbol from format string
            mov  [Buffer + rdx], rbx                    ; Buffer[rdx] = rbx
            inc  rcx                                    ; rcx++
            inc  rdx                                    ; rdx++

            ;mov  rdx, 3
            mov  rsi, Buffer                            ; pop addr of format string
            ;mov  rdx, FormatLen                         ; len of format string

            syscall

            ret

;--------------------------------------------------------------------------------------------------

section     .data

Format:     db "%d", 0x0a

FormatLen:  equ $ - Format

Buffer:     TIMES 64 db 0

Msg:        db "MeowMeowMeow", 0x0a
MsgLen      equ $ - Msg
