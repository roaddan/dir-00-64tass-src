;-------------------------------------------------------------------------------
                Version = "20230331-212716"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                
                .include    "header-c64.asm"
                .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    none
main            .block
                jsr scrmaninit
                jsr help
                jsr anykey
                jmp b_warmstart
                .bend
                 
help            .block      
                jsr cls
                #print line
                #print headera
                #print headerb
                #print shortcuts
                #print helptext
                #print line
                rts                                
headera                       ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d
                .text          "          ISBN 0-7156-1899-7"
                .byte   $0d,0

headerb         .text          "            spritechar (p68)"
                .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
                .byte   $0d
                .text          "     programmed by Daniel Lafrance."
                .byte   $0d
                .text   format("        Version: %s.",Version)
                .byte   $0d,0


shortcuts       .text          " -------- S H O R T - C U T S ---------"
                .byte   $0d
                .text   format(" run=SYS%5d, help=SYS%5d",main, help)
                .byte   $0d
                .text   format(" cls=SYS%5d",cls)
                .byte   $0d,0
line            .text          " --------------------------------------"
                .byte   $0d,0
helptext        .text   format(" spritechar  : SYS%5d",spritechar)

                .byte   $0d,0
                .bend
*=$4000
spritechar      .block
                lda vicsprt0x   ; $d000, 53248 Sprt 0 Horizontal position (X)
                sec
                sbc #$18        ; 24
                tax
                lda vicspxmsb   ; $D010, 53264 MSb for sprites hor. position.
                cmp #$01
                bne more
                ldx vicsprt0x   ; $d000, 53248 Sprt 0 Horizontal position (X)
more            lda vicsprt0y   ; $d001, 53249 Sprt 0 Vertical position (Y)
                sec
                sbc #$3a        ; 58
                tay
                stx x1store     ; x1
                sty y1store     ; y1
                tya
                lsr a
                lsr a
                lsr a           ; y2=y1/8
                clc
                adc #$01
                sta y2store
                txa
                lsr a
                lsr a
                lsr a           ; x2=x1/8
                sta x2store
                lda vicspxmsb   ; $D010, 53264 MSb for sprites hor. position.
                cmp #$01
                bne more1
                lda x2store
                clc
                adc #$1d        ; 29
                sta x2store
more1           lda y2store
                sta number1
                lda #$28        ; 40
                sta number2
                jsr multiply
                lda x2store
                adc result
                sta result
                lda result+1
                adc #$00
                sta result+1
                lda result+1
                clc
                adc #$04
                sta result+1
;Character location in result ans result+1
                lda result
                sta zpage1
                lda result+1
                sta zpage1+1
                ldy #$00
                lda ($fb),y
                sta tbuffer         ;$33c,828-1019 Cassette i/o buffer
                rts
multiply        lda #$00
                sta result
                ldx #$08
loop            lsr number1
                bcc noadd
                clc
                adc number2
noadd           ror a
                ror result
                dex
                bne loop
                sta result+1
                rts
                .bend
result          .word   $00
number1         .byte   $00
number2         .byte   $00
x1store         .byte   $00
x2store         .byte   $00
y1store         .byte   $00
y2store         .byte   $00

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
                .include "map-c64-kernal.asm"
                .include "map-c64-vicii.asm" 
                .include "map-c64-basic2.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 