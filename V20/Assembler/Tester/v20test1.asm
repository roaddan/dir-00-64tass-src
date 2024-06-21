.include "header-v20ex.asm"

SCREEN=$1000
COLMEM=$9400
SCRBRD=36879
CARCOL=646
ZP2=$fd
main:
            lda #$02
            ora #$08
            sta SCRBRD          
            lda 147
            jsr $ffd2
            lda #1
            sta CARCOL
            ldx #0
     
     
            ldx #0
put         lda chr
            sta SCREEN,x
            txa
            and #$07
            cmp #0
            bne go
            clc
            adc #$81
go          sta COLMEM,x
            inc chr
            inx
            bne put
            lda #$02
            sta CARCOL
            lda 147
            jsr $ffd2
            rts

chr       .byte     0
col       .byte     0
row       .byte     0
lin       .byte     0
adress    .byte     0     
add2word            