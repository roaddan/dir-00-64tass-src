*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

                jsr $ff81
                jsr $ff84
                jsr $ff8a
                ldx #$00
                stx $d020           ;black border
                stx $d021           ;black screen
                dex
                stx $0286           ;light grey cursor
                jsr $e544           ;clear screen

                lda #$00
                sta smooth          ;clear var
                sta $f0            
                lda #$30            ;set text start to $3000 (zp $f0+$f1)
                sta $f1

                sei                 ;set up irq
                lda #$01
                sta $d01a
                sta $dc0d
                lda #<irq
                sta $0314
                lda #>irq
                sta $0315
                lda #$1b
                sta $d011
                lda #$fa
                sta $d012
                cli
                jmp *


irq             inc $d019
                jsr scroller      ;scroll
                lda #$1b
                sta $d011
                lda #$fa
                sta $d012
                lda smooth         ;smooth it
                sta $d016
                jmp $ea31

scroller
                lda smooth
                sec
                sbc #$01            ;$01-$07 Higher is faster scroll
                bcc scroll0
                sta smooth
                rts
scroll0         and #$07            ;only 3 bits needed for smooth
                sta smooth
                ldx #$00
move0           lda $0401,x         ;move first $28 characters on top line
                sta $0400,x
                inx
                cpx #$28
                bne move0
                ldy #$00
                lda ($f0),y         ;fetch 1 char from scroll text
                cmp #$ff            ;if value is $ff reset text to $3000
                beq zp0
                inc $f0             ;inc $f0/$f1 to fetch next scrolltext char
                lda $f0
                bne noc0
                inc $f1
noc0            rts
zp0             lda #$00
                sta $f0
                lda #$30
                sta $f1
                rts

smooth          .byte $00