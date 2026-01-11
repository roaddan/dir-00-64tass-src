;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
.include "c64map.asm"
main    
        lda #$30 ;0
        sta $0400
        lda #$31 ;1
        sta $0401
        lda #$30 ;0
        sta $0402
        lda #$30 ;0
        sta $0403
        lda #$20 ; " "
        sta $0404
        lda #$30 ;0
        sta $0405
        lda #$30 ;0
        sta $0406
        lda #$30 ;0
        sta $0407
        lda #$31 ;1
        sta $0408
        rts
        
        