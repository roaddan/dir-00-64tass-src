;---------------------------------------        
scrnsave
        .block
        jsr pushall
        jsr setcarptr
        jsr zp1tozp2
        jsr setcolptr
        jsr zp1tozp2
        jsr popall
        rts
        .bend
;---------------------------------------        
scrnrest
        .block
        jsr pushall
        jsr setcarptr
        jsr zp2tozp1
        jsr setcolptr
        jsr zp2tozp1
        jsr popall
        rts
        .bend

;---------------------------------------        
zp1tozp2
        .block
        ldx #>scrlen
        ldy #<scrlen
nextcar lda (zp1),y
        sta (zp2),y
        iny
        bne nextcar
        inc zp1+1
        inc zp2+1
        dex
        bne nextcar
        rts
        .bend
;---------------------------------------        
zp2tozp1
        .block
        ldx #>scrlen
        ldy #<scrlen
nextcar lda (zp2),y
        sta (zp1),y
        iny
        bne nextcar
        inc zp1+1
        inc zp2+1
        dex
        bne nextcar
        rts
        .bend
;---------------------------------------        
setcarptr 
        .block
        lda #<scrtxt
        sta zp1
        lda #>scrtxt
        sta zp1+1
        lda #<scrncar
        sta zp2
        lda #>scrncar
        sta zp2+1
        rts
        .bend
;---------------------------------------        
setcolptr 
        .block
        lda #<scrcol
        sta zp1
        lda #>scrcol
        sta zp1+1
        lda #<scrncol
        sta zp2
        lda #>scrncol
        sta zp2+1
        rts
        .bend
;---------------------------------------
fillscreen
        .block
        jsr pushall
        ldx #$01
        ldy #$00
again   sta scrtxt,y
        sta scrtxt+256,y
        pha
        inc col
        lda col
        and #$7f
        and #$07
        ora #$18
        sta scrcol,y
        sta scrcol+256,y
        pla
        iny
        bne again
        jsr popall
        rts
col     .byte 0
        .bend