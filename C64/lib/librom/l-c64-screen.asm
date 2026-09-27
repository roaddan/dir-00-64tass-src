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
        ldx #$04
        ldy #$00
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
        ldx #$04
        ldy #$00
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
        lda #$00
        sta zp1
        lda #$04
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
        lda #$00
        sta zp1
        lda #$d8
        sta zp1+1
        lda #<scrncol
        sta zp2
        lda #>scrncol
        sta zp2+1
        rts
        .bend
;---------------------------------------