;---------------------------------------
; Nom fichier..: l-float.asm
; Type fichier.: (seq) code pour T.M.P.
; Auteur.......: Daniel Lafrance
; Version......: 1.0.1 pour T.M.P.
; Revision.....: 20251117
;---------------------------------------
clrbasbuf   
;---------------------------------------
        .block
        php
        pha
        tya
        pha
        lda #$00
        ldy #$59
again   sta $0200,y
        dey
        bne again
        pla
        tay
        pla
        plp
        rts
        .bend
;---------------------------------------
getfac1
;---------------------------------------
        .block
        jsr pushregs 
        jsr clrbasbuf
        jsr prompt
        stx $7a
        sty $7b
        jsr chrget
        jsr fasctf1 ;conv. ascii->float
        jsr popregs
        rts
        .bend
;---------------------------------------
prnfac1
;---------------------------------------
        .block
        jsr pushall
        jsr ff1tasc
        ldy >#fascii
        ldx <#fascii
        jsr putsyx
        jsr popall
        rts
        .bend
;---------------------------------------
