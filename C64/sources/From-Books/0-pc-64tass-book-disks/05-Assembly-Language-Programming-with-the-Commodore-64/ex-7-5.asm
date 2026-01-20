chrout  =   $ffd2
temp    =   $02
getin   =   $ffe4
*=$c000
test    jsr getbyt
        sta temp
        lda #$20
        jsr chrout
        lda temp
        jsr prbyte
        clv
        bvc test
*=$c800
hexcii  cmp #$0a
        bcc around
        adc #$06
around  adc #$30
        rts
*=$c809
aschex  cmp #$40
        bcc skip
        sbc #$07
skip    sec        
        sbc #$30        
        rts
*=$c813        
prbyte  sta temp        
        lsr        
        lsr
        lsr
        lsr
        jsr hexcii
        jsr chrout
        lda temp
        and #$0f
        jsr hexcii
        jsr chrout
        lda #$20
        jsr chrout
        lda temp
        rts
getbyt  jsr getin        
        beq getbyt        
        tax
        jsr chrout
        txa
        jsr aschex
        asl
        asl
        asl
        asl
        sta temp
loaf    jsr getin
        beq loaf
        tax
        jsr chrout
        txa
        jsr aschex
        ora temp
        rts
        