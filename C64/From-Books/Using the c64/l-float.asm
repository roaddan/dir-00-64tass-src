;---------------------------------------
; fichier..: l-float.asm (seq)
; Auteur...: Daniel Lafrance
; Version..: 1.0.1 pour T.M.P.
; Revision.: 20251117
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
        jsr fasctf1
        jsr popregs
        .bend
;---------------------------------------
prnfac1
;---------------------------------------
        .block
        jsr pushregs
        jsr ff1tasc
        ldy #$01
        ldx #$00
        lda #$03
        sta kcol
        jsr putsyx
        lda #$01
        sta kcol
        jsr popregs
        rts
        .bend
;---------------------------------------
floattest
        .block
        jsr clrbasbuf
        jsr getfac1
        jsr prnfac1
        rts
        .bend
