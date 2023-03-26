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
                .text          "            pixscrolld (p56)"
                .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
                .byte   $0d,$0d
                .text          "     programmed by Daniel Lafrance."
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
helptext        .text   format(" Prepare to scrool  : SYS%5d",pixscrolld)
                .byte   $0d
                .text   format(" Scroll 1 pixel down: SYS%5d",scrolldown)
                .byte   $0d
                .text   format(" ex.: SYS%5d",pixscrolld)
                .byte   $0d
                .text   format("      for i=0to100:SYS%5d:next",scrolldown)
                .byte   $0d,0
                .bend
*=$4000
pixscrolld      lda vicctrl0v
                and #$f7
                sta vicctrl0v
                lda #$00
                sta byte
                rts
scrolldown      lda vicctrl0v
                and #$f8
                clc
                adc byte
                sta vicctrl0v
                inc byte
                lda byte
                cmp #$08
                beq reset
                rts
reset           lda #$00
                sta byte
                lda vicctrl0v
                and #$f8
                sta vicctrl0v
                lda #$13
                jsr chrout
                lda #$11
                jsr chrout
                lda #$9d
                jsr chrout
                lda #$94
                jsr chrout
                lda #$80
                sta $da
                rts
byte            .byte 0
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
           
 