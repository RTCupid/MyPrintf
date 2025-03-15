;------------------------------------------------------------------------------
;                                  MyPrintf
;                         (c) 2025 Muratov Artyom
;------------------------------------------------------------------------------
; Compilation with:                     Flags:
; nasm -f elf64 -l 1-nasm.lst 1-nasm.s  -w+orphan-labels
; Linker:
; ld -s -o 1-nasm 1-nasm.o

section     .text

global _start                  ; predefined entry point name for linker

_start:     mov rax, 0x01      ; write64 (rdi, rsi, rdx) ... r10, r8, r9
            mov rdi, 1         ; stdout
            mov rsi, Msg
            mov rdx, MsgLen    ; strlen (Msg)
            syscall

            mov rax, 0x3C      ; exit64 (rdi)
            xor rdi, rdi
            syscall

;------------------------------------------------------------------------------
; MyPrintf  my function printf version 11.1, write to console string
;           with some arguments that pinned by '%'
; Entry:    parametres in stack (type "cdecl")
; Exit:
; Destroy:
;------------------------------------------------------------------------------
;MyPrintf    proc


;            ret
;MyPrintf    endp

section     .data

Msg:        db "MeowMeowMeow", 0x0a
MsgLen      equ $ - Msg
