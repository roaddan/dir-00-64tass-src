;-------------------------------------------------------------------------------
Version = "20230321-080800-a"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                .include "header-c64.asm"
                .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    none
main            .block
                jsr scrmaninit
                jsr help
                rts
                .bend

help            .block      
                jsr cls
                #print line
                #print header
                #print line
                #print shortcuts
                #print line
                #print helptext
                #print line
                rts                                
header                        ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d,$0d
                .text          "            pixscrolll (p38)"
                .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
                .byte   $0d,$0d
                .text          "     Programmed by Daniel Lafrance."
                .byte   $0d
                .text   format("       Version: %s.",Version)
                .byte   $0d,0

shortcuts       .text          " -------- S H O R T - C U T S ---------"
                .byte   $0d
                .text   format(" run=SYS%5d, help=SYS%5d",main, help)
                .byte   $0d
                .text   format(" cls=SYS%5d",cls)
                .byte   $0d,0
line            .text          " --------------------------------------"
                .byte   $0d,0
helptext        .text   format(" pixscrolll  : SYS%5d",pixscrolll)
                .byte   $0d
                .text   format(" ex.: for i=0to320:SYS%5d:next",pixscrolll)
                .byte   $0d,0
                .bend
pixscrolll      .block
                lda vicctrl1h
                and #$f8
                clc
                adc mem1
                sta vicctrl1h
                dec mem1
                lda mem1
                cmp #$ff
                beq branch1
                rts
branch1         lda vicctrl1h
                and #$f8
                clc
                adc #$07
                sta vicctrl1h
                lda #$07
                sta mem1
                jsr branch2
                rts
branch2         lda #$06
                sta tpbuff+8
                ldx #$00
                ldy #$00
a1034           lda viciiscn0+1,x
                sta viciiscn0,x
                lda viciiscn1+1,x
                sta viciiscn1,x
                lda viciiscn2+1,x
                sta viciiscn2,x
                lda viciiscn3+1,x
                sta viciiscn3,x
                inx
                iny
                cpy #$27
                bne a1034
                inx
                ldy #$00
                dec tpbuff+8
                bne a1034
finish          rts
mem1            .byte 0
                .bend  
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
           
 