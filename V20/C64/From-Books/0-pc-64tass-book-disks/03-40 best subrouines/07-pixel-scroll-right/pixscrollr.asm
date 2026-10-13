;-------------------------------------------------------------------------------
Version = "20230325-153900-a"
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
                .text          "            pixscrollr (p38)"
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
helptext        .text   format(" pixscrollr  : SYS%5d",pixscrollr)
                .byte   $0d
                .text   format(" ex.: for i=0to320:SYS%5d:next",pixscrollr)
                .byte   $0d,0
                .bend
*=$1000
pixscrollr      .block
                lda vicctrl1h
                and #$f8
                clc
                adc byte
                sta vicctrl1h
                inc byte
                lda byte
                cmp #$08
                beq reset
                rts
reset           lda #$00
                sta byte
                lda vicctrl1h
                and #$f8
                sta vicctrl1h
                jsr charscroll
                rts
charscroll      ldx #38
loop            lda viciiscn0,x
                sta viciiscn0+1,x
                lda viciiscn0+40,x
                sta viciiscn0+40+1,x
                lda viciiscn0+80,x
                sta viciiscn0+80+1,x
                lda viciiscn0+120,x
                sta viciiscn0+120+1,x
                lda viciiscn0+160,x
                sta viciiscn0+160+1,x
                lda viciiscn0+200,x
                sta viciiscn0+200+1,x
                lda viciiscn0+240,x
                sta viciiscn0+240+1,x
                lda viciiscn0+280,x
                sta viciiscn0+280+1,x
                lda viciiscn0+320,x
                sta viciiscn0+320+1,x
                lda viciiscn0+360,x
                sta viciiscn0+360+1,x
                lda viciiscn0+400,x
                sta viciiscn0+400+1,x
                lda viciiscn0+440,x
                sta viciiscn0+440+1,x
                lda viciiscn0+480,x
                sta viciiscn0+480+1,x
                lda viciiscn0+520,x
                sta viciiscn0+520+1,x
                lda viciiscn0+560,x
                sta viciiscn0+560+1,x
                lda viciiscn0+600,x
                sta viciiscn0+600+1,x
                lda viciiscn0+640,x
                sta viciiscn0+640+1,x
                lda viciiscn0+680,x
                sta viciiscn0+680+1,x
                lda viciiscn0+720,x
                sta viciiscn0+720+1,x
                lda viciiscn0+760,x
                sta viciiscn0+760+1,x
                lda viciiscn0+800,x
                sta viciiscn0+800+1,x
                lda viciiscn0+840,x
                sta viciiscn0+840+1,x
                lda viciiscn0+880,x
                sta viciiscn0+880+1,x
                lda viciiscn0+920,x
                sta viciiscn0+920+1,x
                lda viciiscn0+960,x
                sta viciiscn0+960+1,x
                dex
                cpx #$ff
                beq fin
                jmp loop
fin             rts
byte            .byte 0
                .bend  
;-------------------------------------------------------------------------------
;
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
           
 