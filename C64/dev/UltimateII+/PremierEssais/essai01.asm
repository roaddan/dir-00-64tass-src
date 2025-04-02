;-------------------------------------------------------------------------------
                Version = "20241122-125638"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none
main           .block
               jsr scrmaninit
               #disable
               jsr aide
               jsr anykey
               jsr essai01
               #enable
               #uppercase
               jsr  cls
               #graycolor
;               jmp b_warmstart
               .bend
                 
aide           .block      
               #lowercase
               jsr cls
               #print line
               #print headera
               #print headerb
               #print shortcuts
               #print aidetext
               #print line
               rts                                
headera                       ;0123456789012345678901234567890123456789
               .text          " 1541 Ultimate II + Gestion de fichiers"
               .byte   $0d  
               .text          " Cartouche et API par Gideon Zweijtzer"
               .byte   $0d
               .text          "     API Version 1.0, 1er Feb 2013"
               .byte   $0d,0

headerb        .text          "               essai01 "
               .byte   $0d
               .text          "       (c) 2025 Daniel Lafrance"
               .byte   $0d
               .text   format("         Version: %s.",Version)
               .byte   $0d,0

shortcuts      .byte   $0d
               .text          " -------- S H O R T - C U T S ---------"
               .byte   $0d, $0d
               .text   format(" essai01..: SYS%05d ($%04X)",main, main)
               .byte   $0d
               .text   format(" aide.....: SYS%05d ($%04X)",aide, aide)
               .byte   $0d
               .text   format(" cls......: SYS%05d ($%04X)",cls, cls)
               .byte   $0d,0
aidetext       .text   format(" Lancement: SYS%05d ($%04X)",essai01, essai01)
               .byte   $0d, $0d
               .text   format("    ex.: SYS%05d",essai01)
               .byte   $0d
               .text   format("    for i=0to100:SYS%05d:next",essai01)
               .byte   $0d,0
line           .text          " --------------------------------------"
               .byte   $0d,0
               .bend
;*=$4000

essai01        .block
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
byte           .byte 0
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
