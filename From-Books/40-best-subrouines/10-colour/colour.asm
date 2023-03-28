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
                .text          "              Colour (p62)"
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
helptext        .text   format(" Colour:SYS%5d,screen,back,text,1,2,3",colour)
                .byte   $0d
                .text   format(" ex.: SYS%5d,15,11,0,10,11,12",colour)
                .byte   $0d,0
                .bend
;*=$4000

colour          .block
                jsr $aefd
                jsr param
                sta 53281

                jsr $aefd
                jsr param
                sta 53280
                
                jsr $aefd
                jsr param
                sta 646
                
                jsr $aefd
                jsr param
                sta 53282
                
                jsr $aefd
                jsr param
                sta 53283
                
                jsr $aefd
                jsr param
                sta 53284
                rts
param           jsr $b79e
                txa
                rts
iqerr           jmp $b248                


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
           
 