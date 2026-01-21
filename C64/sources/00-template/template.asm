;-------------------------------------------------------------------------------
                Version = "20241122-125638"
;-------------------------------------------------------------------------------                
               ;.include "l-c64-bashead-c000.asm"
               ;.include "l-c64-bashead-e000.asm"
               .include "l-c64-bashead.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    "none"
main           .block
               #outcar locase
               #disable
               #c64col
               #outcar 147
               jsr aide

               ;jsr anykey
               ;jsr template
               #enable
               #printptr16bin unmot
               #outcar 13
               #printval16bin unmot
               rts
               .bend
unmot .word $0812 

aide           .block      
               #outcar 14
               #outcar 147
               #print dashline
               #print headera
               #print headerb
               #print shortcuts
               #print aidetext
               #print dashline
               rts  
               .bend      

template       .block
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
                       
headera                       ;0123456789012345678901234567890123456789
               .byte   $01
               .text          "       UN LIVRE SUR LE COMMODORE "
               .byte   $0d
               .text          "     POUR LE COMMODORE 64 OU VIC 20"
               .byte   $0d 
               .text          "       Livre ecrit par un Auteur"
               .byte   $0d
               .text          "           ISBN 0-7156-1899-7"
               .byte   $0d,0

headerb        .text          "            template (pxx)"
               .byte   $0d
               .text          "       (c) 2026 nom du Programmeur"
               .byte   $0d
               .text          "        Code par Daniel Lafrance."
               .byte   $0d
               .text   format('        Version: %s.', Version)
               .byte   $0d,0

shortcuts      .byte   $0d
               .text          " -------- R A C C O U R C I S ---------"
               .byte   $0d, $0d
               .text   format(" template.: SYS%5d ($%04X)",main, main)
               .byte   $0d
               .text   format(" aide.....: SYS%5d ($%04X)",aide, aide)
               .byte   $0d,0
aidetext       .text   format(" Lancement: SYS%5d ($%04X)",template, template)
               .byte   $0d, $0d
               .text   format("    ex.: SYS%5d",template)
               .byte   $0d
               .text   format("    for i=0to100:SYS%5d:next",template)
               .byte   $0d,0
dashline       .text          " --------------------------------------"
               .byte   $0d,0
;*=$4000

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
               .include "m-c64-ultimateii.asm"
               .include "m-c64-utils.asm"
               .include "e-c64-basic2.asm"
               .include "e-c64-float.asm"
               .include "e-c64-kernal.asm"
               .include "e-c64-map.asm"
               .include "e-c64-sid-notes-ntsc.asm"
               .include "e-c64-sid.asm"
               .include "e-c64-varsc000.asm"
               .include "e-c64-vicii.asm"
               .include "l-c64-bitmap.asm"
               .include "l-c64-conv.asm"
               .include "l-c64-disk.asm"
               .include "l-c64-drawbox.asm"
               .include "l-c64-float.asm"
               .include "l-c64-keyb.asm"
               .include "l-c64-hex.asm"
               .include "l-c64-math.asm"
               .include "l-c64-mem.asm"
               .include "l-c64-opcodes.asm"
               .include "l-c64-opcycles.asm"
               .include "l-c64-oplenght.asm"
               .include "l-c64-opmneumo.asm"
               .include "l-c64-opmodes.asm"
               .include "l-c64-push.asm"
               .include "l-c64-screen.asm"
               .include "l-c64-showregs.asm"
               .include "l-c64-string.asm"
               .include "l-c64-vectors.asm"
;-------------------------------------------------------------------------------