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
        jsr pushall
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
        jsr popall
        rts
        .bend
;---------------------------------------        
zp2tozp1
        .block
        jsr pushall
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
        jsr popall
        rts
        .bend
;---------------------------------------        
setcarptr 
        .block
        jsr pushregs
        lda #<scrtxt
        sta zp1
        lda #>scrtxt
        sta zp1+1
        lda #<scrncar
        sta zp2
        lda #>scrncar
        sta zp2+1
        jsr popregs
        rts
        .bend
;---------------------------------------        
setcolptr 
        .block
        jsr pushregs
        lda #<scrcol
        sta zp1
        lda #>scrcol
        sta zp1+1
        lda #<scrncol
        sta zp2
        lda #>scrncol
        sta zp2+1
        jsr popregs
        rts
        .bend
;---------------------------------------
fillscreen
          .block
          jsr pushall
          ldx #$03
          ldy #$00
          lda #102
again     sta scrtxt,y
          sta scrtxt+256,y
          pha
          txa
          sta scrcol,y
          sta scrcol+256,y
          pla
          iny
          bne again
          jsr popall
          rts
          .bend