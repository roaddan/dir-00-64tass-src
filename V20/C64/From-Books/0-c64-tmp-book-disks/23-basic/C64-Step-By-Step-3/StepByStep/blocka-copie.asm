			*=49152
start	
               .byte 0,0,0,0,0,0,0
               .byte 0,0,0,0,0,0,0
               .byte 0,0,0,0,0,0,0
               .byte 0,0,0,0,0,0,0
               .byte 0,0,0,0,0,0,0
               .byte 0,0,0,0,0
               jsr $0079
               jsr $aefd
               jsr $ad8a
               jsr $b1bf
               ldx $64
               ldy $65
               rts
a3             jsr $c028
               sty $3f
               sty $14
               stx $40
               stx $15
               jsr $a613
               lda $5f
               sec
               sbc #$01
               sta $41
               lda $60
               sbc #$00
               sta $42
               rts
a1             lda #$08
               ora $d018
               sta $d018
               lda #$20
               ora $d011
               sta $d011
               rts
a2             lda #$f7
               and $d018
               sta $d018
               lda #$df
               and $d011
               sta $d011
               rts
a4             lda #$08
               ldy #$01
               sta ($2b),y
               jsr $a533
               lda $22
               sta $2d
               sta $2f
               sta $31
               lda $23
               sta $2e
               sta $30
               sta $32
               rts
a5             jsr $0079
               jsr $aefd
               lda #$00
               sta $0a
               jsr $e102
l003           lda $2d
               sbc #$02
               sta $2b
               lda $2e
               sbc #$00
               sta $2c
               lda #$00
               sta $b9
               ldx $2b
               ldy $2c
               jsr $ffd5
               bcs l001
               stx $2d
               sty $2e
               jsr $a533
               pla
               sta $2c
               pla
               sta $2b
               rts
l001           tax
               cmp #$04
               bne l002
               ldy $ba
               dey
               beq l003
l002           pla
               sta $2c
               pla
               sta $2b
               clc
               jmp ($0300)
               cpx #$02
               bcs l004
               cpx #$01
               bcs l005
               rts
l005           cpy #$40
l004           rts
               sec
               txa
               bne l006
               tya
               cmp #$c8
l006           rts
               adc #$00
               sta $2e
               sta $30
               sta $32
               rts 
	.byte	0,0,0,0,0,0,0,0,0,0
_lc100         lda $c008
               pha
               and #$07
               sta $c001
               pla
               and #$f8
               sta $fd
               lda $c00c
               pha
               and #$07
               sta $c002
               pla
               and #$f8
               pha
               lsr
               lsr
               lsr
               sta $c003
               lsr
               lsr
               clc
               adc $c003
               sta $c003
               pla
               asl
               asl
               asl
               ora $c002
               clc
               adc $fd
               sta $fd
               lda $c003
               adc $c009
               clc
               adc #$20
               sta $fe
               lda #$80
               ldx $c001
               inx
_lc147         dex
               beq _lc14e
               lsr
               sec
               bcs _lc147
_lc14e         sta $c000
               rts
_lc152         lda $c01a
               and #$f8
               sta $c01a
               clc
               ror $c01b
               ror $c01a
               ror $c01b
               ror $c01a
               ror $c01b
               ror $c01a
               lda #$00
               sta $fc
               lda $c01c
               lsr
               lsr
               lsr
               sta $c004
               asl
               asl
               clc
               adc $c004
               asl
               asl
               rol $fc
               asl
               rol $fc
               clc
               adc $c01a
               sta $fb
               lda #$04
               adc $fc
               adc $c01b
               sta $fc
               rts
_lc197         jsr $c028
               sty $c005
               lda #$20
               sta $fc
               lda #$00
               sta $fb
               lda $fc
               cmp #$3f
               bne ($06)
               lda $fb
               #valeur!
               beq ($0d)
               ldx #$00
               txa
               sta ($fb,x)
               inc $fb
               bne ($eb)
               inc $fc
               bne ($e7)
               lda #$04
               sta $fc
               lda #$00
b1             sta $fb
               lda $fc
               cmp #$07
               bne ($06)
               lda $fb
               cmp #$e8
               beq ($0f)
               ldx #$00
               lda $c005
               sta ($fb,x)
               inc $fb
               bne ($e9)
               inc $fc
               bne ($e5)
               rts
b2             jsr $c028
               jsr $c0e0
               bcc ($07)
               jsr $a906
               jsr $a8fb
               rts
_lc1f1         stx $c01b
               sty $c01a
               jsr $c028
               jsr $c0ec
               bcs ($eb)
               sty $c01c
               jsr $c028
               sty $c005
               jsr $c152
               ldy #$00
               lda $c005
               sta ($fb),y
               rts                