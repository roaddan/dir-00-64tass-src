*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
.include    "stdio.asm"
main        jmp init
scradr      .word $0400
scrcol      .byte %00000010
zp1ptr      .byte $00,$00
zp2ptr      .byte $00,$00
init        jsr savezps
            lda #%00001011
            sta BORDER
            lda #$05
            jsr bputch
            lda #%00000000
            sta BACKGRND
            lda #$93
            jsr bputch
            ;On replace notre PTR
maina       jsr ahome   
            ldx #39
            ldy #1
            jsr agotoxy
            lda #$e0
            jsr aputch  
            jsr d250ms
            ldx #15
            ldy #0
            clc
            jsr PLOT
            jsr restzps
            rts
;-------------------------------------------------


bputch      php
            jsr CHROUT
            plp
            rts
;-------------------------------------------------
aputch      jmp aputch0
aputchra    .byte 0
aputch0     php
            sta aputchra
            pha
            txa
            pha
            tya
            pha
            jsr scp2zp2
            ldy #$00
            lda aputchra
            sta (ZP2),y
            ;Ici on ne touche pas a nos registres
            ; de position de curseurs.
            ;On transdorme l'adresse d'écran ...
            lda ZP2+1  ; $0400 -> $D800
            and #%11111011
            ora #%11011000
            ; ... en adresse de couleur
            sta ZP2+1
            ; ... et on place la couleur
            lda scrcol
            sta (ZP2),y
            ;On avance ls pointeur de un
            lda #$01
            jsr scptrad
            pla
            tay
            pla
            tax
            pla
            plp
            rts
;-------------------------------------------------
d250ms      php
            pha
            txa
            pha
            tya
            pha
            ldx #250
            ldy #0
loopy       iny
            bne loopy
            inx
            bne loopy
            pla
            tay
            pla
            tax
            pla
            plp
            rts
;-------------------------------------------------
ahome       php
            pha
            lda #$00
            sta scradr
            lda #$04
            sta scradr+1
            pla
            plp
            rts
;-------------------------------------------------
agotoxy     php
            pha
            txa
            pha
            tya
            pha
            jsr ahome
            cpy #$00
            beq agotoxyx
            lda #40
agotoxyy    jsr scptrad
            dey 
            bpl agotoxyy
agotoxyx    cpx #$00
            beq agotoxyout
            txa            
            jsr scptrad
agotoxyout  pla
            tay
            pla
            tax
            pla
            plp
            rts
;-------------------------------------------------
scptrad     jmp scptrad0
scptradra  .byte 0
scptrad0    php
            sta scptradra
            pha
            lda scradr
            clc
            adc scptradra
            sta scradr
            bcc scptrada
            inc scradr+1
scptrada    pla
            plp
            rts
;-------------------------------------------------
scp2zp1     php
            pha
            lda scradr
            sta ZP1
            lda scradr+1
            sta ZP1+1
            pla
            plp
            rts
;-------------------------------------------------
scp2zp2     php
            pha
            lda scradr
            sta ZP2
            lda scradr+1
            sta ZP2+1
            pla
            plp
            rts
;-------------------------------------------------
savezp1     php
            pha
            lda ZP1
            sta zp1ptr
            lda ZP1+1
            sta zp1ptr+1
            pla
            plp
            rts
;-------------------------------------------------
savezp2     php
            pha
            lda ZP2
            sta zp2ptr
            lda ZP2+1
            sta zp2ptr+1
            pla
            plp
            rts
;-------------------------------------------------
savezps     jsr savezp1            
            jsr savezp2            
            rts
;-------------------------------------------------
restzp1     php
            pha
            lda zp1ptr
            sta ZP1
            lda zp1ptr+1
            sta ZP1+1
            pla
            plp
            rts
;-------------------------------------------------
restzp2     php
            pha
            lda zp2ptr
            sta ZP2
            lda zp2ptr+1
            sta ZP2+1
            pla
            plp
            rts
;-------------------------------------------------
restzps     jsr restzp1            
            jsr restzp2            
            rts
;-------------------------------------------------
inczp2      php
            pha
            lda ZP2
            clc
            adc #$01
            sta ZP2
            bcc inczp2a
            inc ZP2+1
inczp2a     pla
            plp
            rts
;-------------------------------------------------
pushpull    php
            pha
            txa
            pha
            tya
            pha
            pla
            tay
            pla
            tax
            pla
            plp
            rts

