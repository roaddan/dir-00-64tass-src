;-------------------------------------------------------------------------------
                Version = "220230527-222511"
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
                jsr graph
                jsr anykey
                jsr nrm
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

headerb         .text          "              graph (p78)"
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
helptext        .text   format(" Prepare to graph  : SYS%5d",graph)
                .byte   $0d
                .text   format(" graph: SYS%5d",graph)
                .byte   $0d
                .text   format(" ex.: SYS%5d",graph)
                .byte   $0d
                .text   format("      for i=0to100:SYS%5d:next",graph)
                .byte   $0d,0
                .bend
*=$c000

graph        .block
                pha
                lda #$16
                sta cia2pra   ;56576
                lda #8
                sta vicmemptr ;53272
                lda vicctrl0v ; 53265
                ora #32
                sta vicctrl0v ; 53265
                pla
                rts
                .bend
byte            .byte 0
nrm             .block
                pha
                lda #21
                sta vicmemptr ; 53272
                lda #27
                sta vicctrl0v ; 53265
                lda #23
                sta cia2pra   ;56576
                pla
                rts
                .bend




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
           
 