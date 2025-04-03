;-------------------------------------------------------------------------------
                Version = "20250402-233301"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none

main           .block
               jsr scrmaninit
               #lowercase
               #disable
;               jsr aide
;               jsr anykey
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
               #print line
               #print line
               #print shortcuts
               #print aidetext
               #print line
               rts  
               .bend                              
;*=$4000

essai01        .block
               pha
;               lda vicbordcol
;               sta byte
;               lda #$10
;               sta vicbordcol
               jsr  cls
               #printcxy uiistatustxt
               jsr  waituiinotbusy
               lda  uiiidenreg
               jsr  putahexfmt

               jsr anykey
;               lda byte
;               sta vicbordcol
               pla
               rts
               .bend

byte           .byte 0
               .include    "./strings_fr.asm"
               .include    "lib-c64-ultimateii.asm"
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
