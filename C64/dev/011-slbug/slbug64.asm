;-------------------------------------------------------------------------------
                Version = "20250924-000001"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                
                .include    "header-c64.asm"

;-------------------------------------------------------------------------------
               .enc    "none"
main           .block
               jsr  scrmaninit
               #tolower
               #disable
               lda  #cvert
               sta  vicbordcol
               lda  #cbleu
               sta  vicbackcol
               lda  #cblanc
               sta  bascol
               jsr  cls
               jsr  help
               jsr  slbug64
               rts
               .bend     


slbug64         .block
                php
                pha
                jsr anykey
                lda vicbordcol
                pha
                lda #$10
                sta vicbordcol
                ;jsr anykey
                pla
                sta vicbordcol
                pla
                plp
                rts
                .bend

help            .block
                jsr pushall      
                jsr cls
                #print line
                #print headera
                #print line
                #print headerb
                #print line
                #print headerc
                #print line
                #print shortcuts
;                #print helptext
                #print line
                jsr popall
                rts                                
               .bend
*=$8000
                .include    "chaines_fr.asm"
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$c000        
                .include    "macros-64tass.asm"
                .include    "map-c64-kernal.asm"
                .include    "map-c64-vicii.asm"
                .include    "map-c64-basic2.asm"
                .include    "lib-c64-vicii.asm"
                .include    "lib-c64-basic2.asm"
                .include    "lib-cbm-pushpop.asm"
                .include    "lib-cbm-mem.asm"
                .include    "lib-cbm-hex.asm"
                .include    "lib-cbm-keyb.asm"
           
 