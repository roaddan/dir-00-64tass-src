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
                lda #bblack
                sta vicbordcol
                sta vicbackcol

                jsr help
                jsr anykey
                jsr slbug64
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
                .text          format("== SL-BUG 64%c",66)
                .byte   $0d
                .text          "          POUR LE COMMODORE 64"
                .byte   $0d
                .text          "    IDEE ORIGINALE DE SERGE LEBLANC"
                .byte   $0d
                .text          "     PORT C64 PAR DANIEL LAFRANCE"
                .byte   $0d,0

headerb         .text          "             SLBUG64 (pxx)"
                .byte   $0d
                .text          "         (c) 2024 D. LAFRANCE"
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
helptext        .text   format(" Lancement de slbug64  : SYS%5d",slbug64)
                .byte   $0d
                .text   format(" ex.: SYS%5d",slbug64)
                .byte   $0d,0
                .bend
;*=$4000

slbug64        .block
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
           
 