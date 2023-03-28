;-------------------------------------------------------------------------------
                Version = "20230327-214534-a"
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
                jsr template
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
                .text          "            Template (pxx)"
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
helptext        .text   format(" Prepare to scrool  : SYS%5d",template)
                .byte   $0d
                .text   format(" Scroll 1 pixel down: SYS%5d",template)
                .byte   $0d
                .text   format(" ex.: SYS%5d",template)
                .byte   $0d
                .text   format("      for i=0to100:SYS%5d:next",template)
                .byte   $0d,0
                .bend
;*=$4000

template        .block
                pha
                lda vicbordcol
                sta byte
                lda #$10
                sta vicbordcol
                jsr anykey
                lda byte
                sta vicbordcol
                pla
                rts
                .bend
byte            .byte 0
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
           
 