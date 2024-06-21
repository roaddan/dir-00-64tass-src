; sets env colors
;-------------------------------------------------------------------------------
            Version = "20240619-080814"
;-------------------------------------------------------------------------------
            .include    "header-c64.asm"
            .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------

main        .block
            jsr scrmaninit
            jsr setsenvcolors
            jsr help
;           jsr anykey
            jmp b_warmstart
            .bend

setsenvcolors
            .block
            php
            pha   
            lda #cbleu
            sta vicbackcol
            lda #ccyan
            sta vicbordcol
            lda #cblanc
            sta bascol
            lda #147
            jsr chrout
            lda #19
            jsr chrout
            pla
            plp
            rts
            .bend
                 
help            .block      
                jsr cls
                lda #14
                jsr $ffd2
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

headerb         .text          "         setsenvcolors (p79)"
          .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
          .byte   $0d
                .text          "     programmed by Daniel Lafrance."
          .byte   $0d
                .text   format("        Version: %s.",Version)
          .byte   $0d,0

shortcuts .text          " -------- S H O R T - C U T S ---------"
          .byte   $0d
          .text   format(" run=SYS%5d, help=SYS%5d",main, help)
          .byte   $0d
          .text   format(" cls=SYS%5d",cls)
          .byte   $0d,0
line      .text          " --------------------------------------"
          .byte   $0d,0
helptext  .text   format(" setsenvcolors: SYS%5d",setsenvcolors)
          .byte   $0d
          .text   format(" ex.: SYS%5d",setsenvcolors)
          .byte   $0d,0
                .bend


;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
            .include "map-c64-kernal.asm"
            .include "map-c64-vicii.asm"
            .include "map-c64-sid.asm" 
            .include "map-c64-basic2.asm"
            .include "map-c64-sid-notes-ntsc.asm"
            .include "lib-c64-basic2.asm"
            .include "lib-cbm-pushpop.asm"
            .include "lib-cbm-mem.asm"
            .include "lib-cbm-hex.asm"
            .include "lib-cbm-keyb.asm"
            