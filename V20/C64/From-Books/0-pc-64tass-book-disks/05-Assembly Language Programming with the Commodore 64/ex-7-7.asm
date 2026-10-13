chrout  =   $ffd2
temp    =   $02
getin   =   $ffe4
hours   =   $dc0b
minuts  =   $dc0a
secnds  =   $dc09
tenths  =   $dc08
*=$c000
tod     jsr settime
        sta tenths    
more    lda hours    
        and #$1f    
        jsr prbyte
        jsr colon
        lda minuts
        jsr prbyte
        jsr colon
        lda secnds
        jsr prbyte
        jsr colon
        lda tenths
        jsr prbyte
        ldy #$0b
loop    lda #$9d        
        jsr chrout
        dey
        bne loop
        beq more
        brk
colon   pha
        ;lda #$9d        
        ;jsr chrout
        lda #":"
        jsr chrout
        pla
        rts
        
settime pha
        lda #$10 
        sta hours 
        lda #$37
        sta minuts
        lda #$00
        sta secnds
        sta tenths
        pla
        rts
 
        
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
        ;lda #$20
        ;jsr chrout
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
        