;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 5-8b
; Adding showing seconds.
;------------------------------
*=$c000 ; 49152
clkths      =   $dc08
clksec      =   $dc09
clkmin      =   $dc0a
clkhrs      =   $dc0b
chrout      =   $ffd2
clock       lda clkhrs  ;49152
            jsr prnradec 
            lda #":"
            jsr chrout            
            lda clkmin
            jsr prnradec
            lda #":"
            jsr chrout
            lda clksec
            jsr prnradec
            lda clkths
            rts
        
initclk     lda #$08    ; 49184
            sta clkhrs
            lda #$59    
            sta clkmin
            lda #$50
            sta clksec
            lda #$00
            sta clkths
            lda clkths            
            rts
prnradec    pha     
            lsr     
            lsr
            lsr
            lsr
            and #$07
            clc
            adc #$30
            jsr chrout
            pla
            and #$0f
            clc
            adc #$30
            jsr chrout
            rts
        