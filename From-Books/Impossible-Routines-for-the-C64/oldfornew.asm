;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Old for new
; Book Page.: 53
;---------;---------;---------;---------;---------;---------;---------;---------
; Description : Restore Basic program erased with the NEW command. 
;---------;---------;---------;---------;---------;---------;---------;---------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
                .include "c64_map.asm"
main            jsr   oldfornew  
                rts  
*=$012c
oldfornew       lda     $2b
                ldy     $2c
                sta     $22
                sty     $23
nexty           iny
                lda     ($22),y
                bne     nexty
                iny
                tya
                clc
                adc     $22
                ldy     #$00
                sta     ($2b),y
                lda     $23
                iny
                sta     ($2b),y
                dey
f014c           ldx     #$03
f014e           inc     $22
                bne     f0154
                inc     $23
f0154           lda     ($22),y
                bne     f014c
                dex
                bne     f014e
                lda     $22
                adc     #$02
                sta     $2d
                sta     $23
                adc     #$00
                sta     $2e
                jmp     $a663