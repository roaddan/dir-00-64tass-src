; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b�lint t�th
;
; main.asm - example assembly source file
;   includes all other example source files
; ===================================================================

* = $4000               ; start address (use sys16384 to start)
                        ; (use load"",1,1 to load the compiled program)

.include "system.asm"
.include "print.asm"
.include "mirror.asm"
.include "rotatel.asm"
.include "hellow.asm"    ; this also includes system.asm, but no problem
                       ; it compiles from *=16500 so it will leaves some gap
                       ;  after rotatel.asm
.include "ifgoto.asm"    ; no code just some dummy data not used anywhere

main    jsr hellow      ; prints hello world!
        jsr mirror      ; no visible result, just changing some bytes in memory
        jsr rotatel     ;   -- " --
        rts

; now include all the invoked routines:

