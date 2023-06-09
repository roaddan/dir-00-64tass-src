;-------------------------------------------------------------------------------
                Version = "20230402-083239"
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

headerb         .text          "            listafter (p84)"
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
helptext        .text   format(" listafter: SYS%5d",listafter)
                .byte   $0d
                .text   format(" ex.: SYS%5d",listafter)
                .byte   $0d,0
                .bend
*=$033c
listafter        .block
ibsout          =   $0326
                jsr b_chk4comma ; $aefd : Check for coma.
                jsr b_getacc1lsb; $b79e ; Get Acc#1 LSB in x.
                stx column
                lda ibsout
                sta oldout
                lda ibsout+1
                sta oldout+1
                lda <#main
                sta ibsout
                lda >#main
                sta ibsout+1
                rts
main            cmp #13
                beq docr
                dec count
                bne naddcr
                jsr newprt
docr            lda column
                sta count
                lda #13
naddcr          jsr newprt
                rts
newprt          jmp (oldout)
column          .byte   80
oldout          .word   $0000
count           .byte   $00                                
                .bend

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$c000        
                .include "map-c64-kernal.asm"
                .include "map-c64-vicii.asm" 
                .include "map-c64-basic2.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 