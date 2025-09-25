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
               jsr  anykey
               jsr  slbug64
               rts
               .bend     


slbug64         .block
                php
                pha
                lda vicbackcol
                pha
                lda #$10
                sta vicbackcol
                jsr anykey
                pla
                sta vicbordcol
                pla
                plp
                rts
                .bend

help            .block
left = 4
top = 5
color = ccyan
                jsr pushall      
                jsr cls
                lda #$0d
                jsr putch
                jsr putch
                jsr putch
                jsr putch
                lda #b_rvs_on
                jsr putch
                #print_cxy color, left, top+0, line
                #print_cxy color, left, top+1, texta
                #print_cxy color, left, top+2, textb
                #print_cxy color, left, top+3, textg
                #print_cxy color, left, top+4, line
                #print_cxy color, left, top+5, textc
                #print_cxy color, left, top+6, textd
                #print_cxy color, left, top+7, line
                #print_cxy color, left, top+8, texte
                #print_cxy color, left, top+9, textf
                #print_cxy color, left, top+10, line
;                #print_cxy color, left, top+10, texth
                #print_cxy color, left, top+11, texti
                #print_cxy color, left, top+12, textj
                #print_cxy color, left, top+13, textk
;                #print_cxy color, left, top+14, textl
                #print_cxy color, left, top+14, line
                lda #b_rvs_off
                jsr putch
                jsr popall
                rts                                
               .bend
;*=$8000
                .include    "chaines_fr.asm"
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
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
           
 