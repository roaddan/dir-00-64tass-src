vic =   $d000
*=$c000
        lda #$0d        ; sprite 0 memory pointer
        sta $07f8       
        lda #$01        ; turn on sprite 0 on the vic
        sta vic + $15
        lda #$07        ; select yellow background
        sta vic + $21
        lda #$06        ; select blue for the sprite
        sta vic + $27
        sta vic + $20   ; select blue border colour
        ldx #$80        ; $80 = 128 will be the X coordinate
        stx vic
        ldy #$80        ; $80 = 128 will be the X coordinate
        sty vic + $01
        ;
        ;
down    inc vic + $01   ; move trhe sprite down     
        jsr delay       ; slow down sprite movement
        lda vic + $01   ; fetch the y coordinate
        cmp #$e5        ; is sprite at boundery
        bcc down        ; no? branch backward to move down
up      dec vic + $01   ; yes start moving up
        jsr delay
        lda vic + $01
        cmp #$32
        bcs up
        bcc down
        ;
        ;
delay   ldx #$00
loop    dex
        bne loop
        rts