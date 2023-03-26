; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b�lint t�th
;
; hellow.asm - example assembly source file
;   prints "hello world!" message using kernal routine
; ===================================================================
* = 16500               ; start address (use sys16500 to start)
; main program: simply calls "print"

main    jsr clear
        jsr hellow
        rts

hellow  lda #<_text
                ldy #>_text
                jsr print       ; the print routine itself is in an include file
                rts
        ; the text to be printed:
_text   .text "bonjour tout le monde v2!" ; this will be all upcase in pet-ascii!
        .byte 0

clear   lda #<_clstxt
        ldy #>_clstxt
        jsr print
        rts
        ; the text to be printed:
_clstxt .text "effacer l'ecran." ; this will be all upcase in pet-ascii!
        .byte 0

.include "print.asm"      ; include the print routine
