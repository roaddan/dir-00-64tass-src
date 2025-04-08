;-------------------------------------------------------------------------------
                Version = "20250405-231555"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
               .include     "strings_fr.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    'none'

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr scrmaninit
               #lowercase
               #disable
               jsr aide
               jsr anykey
               mycolor
               jsr libtest01
               #enable
               #uppercase
               jsr  cls
               #mycolor
;               jmp b_warmstart
               .bend
                 
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
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
;*=$4001

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
libtest01        .block
               php
               pha
               jsr  cls
               #printcxy    dataloc
               #color crose
               lda #$55
               jsr  putabinfmt
               pha  
               lda #' '
               jsr putch
               pla
               jsr putahexfmt
               pha  
               lda #' '
               jsr putch
               pla
               jsr putadec

               jsr  anykey
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
               .include  "map-c64-kernal.asm"
               .include  "map-c64-vicii.asm" 
               .include  "map-c64-basic2.asm"
               .include  "lib-c64-basic2.asm"
               .include  "lib-cbm-pushpop.asm"
               .include  "lib-cbm-mem.asm"
               .include  "lib-cbm-hex.asm"
               .include  "lib-cbm-keyb.asm"
               .include  "lib-c64-showregs.asm"
