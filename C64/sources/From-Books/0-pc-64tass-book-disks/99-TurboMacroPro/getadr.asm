;---------------------------------------
; fichier......: getadr.asm (seq)
; type fichier.: code pour T.M.P.
; auteur.......: Daniel Lafrance
; version......: 0.0.1
; revision.....: 20151220
;---------------------------------------
;---------------------------------------
getadr  .block
        jsr pushall
        jsr scrnsave
        ldy #>boxa
        ldx #<boxa
        jsr drawbox
        #printboxt boxat1,#boxac
        #printboxt boxat2,#boxac
        ldy #$05
        lda #$00
        sta hexptr
more0   sta hexadr,y
        dey
        bpl more0
        lda #$04
        sta counter
hexread jsr getkey
        ;jsr showkey
        cmp #$0d
        beq out
        cmp #$14        ; touche bkspc
        beq bkspc
        cmp #$5f        ; touche esc
        beq out
        cmp #$30        ;<0
        bcc hexread     ; less than
        cmp #$a7        ;>F
        bcs hexread     ; greater than   
        cmp #$3a        ;>9
        bcc ok
        cmp #$41        ;
        bcc hexread
ok      jsr chrout
        ldy hexptr
        sta hexadr,y
        inc hexptr
        dec counter
        beq out
        jmp hexread
bkspc   lda hexptr
        beq nothing
        #outcar 157
        #outcar 32
        #outcar 157
        inc counter
        dec hexptr
        ldy hexptr
        lda #$00
        sta hexadr,y
nothing jmp hexread
out     jsr scrnrest
        #ldyximm hexadr
        jsr strhexval
        bcs nogood
        txa
        and #$f0
        sta dumpadr
        sty dumpadr+1
        ;jsr putsxy
nogood  ;jsr getkey
        ;jsr scrnrest
        jsr popall
        rts
hexpos .byte 3,24        
hexadr .byte 0,0,0,0,0
hexptr .byte $00
counter .byte $00 
        .bend
