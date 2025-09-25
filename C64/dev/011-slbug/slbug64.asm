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
               jsr  help
               #mycolor
               rts
               .bend     


slbug64         .block
                php
                pha
                lda vicbackcol
                pha
                lda #cnoir
                sta vicbackcol
                sta vicbordcol
                jsr showregs
                jsr anykey
                pla
                ;sta vicbackcol
                #locate 0,0
                pla
                plp
                rts
                .bend

help            .block
left = 4
top = 3
color = cjaune
                jsr pushall      
                jsr cls
                lda #$0d
                jsr putch
                jsr putch
                jsr putch
                jsr putch
                lda #b_rvs_on
                jsr putch
                #print_cxy color, left, top+0, tline
                #print_cxy color, left+1, top+0, texta

                #print_cxy color, left, top+1, eline
                #print_cxy color, left, top+2, eline
                #print_cxy color, left+1, top+2, textb

                #print_cxy color, left, top+3, eline
                #print_cxy color, left+1, top+3, textg

                #print_cxy color, left, top+4, eline
                #print_cxy color, left, top+4, eline

                #print_cxy color, left, top+5, eline
                #print_cxy color, left+1, top+5, textc

                #print_cxy color, left, top+6, eline
                #print_cxy color, left+1, top+6, textd
                #print_cxy color, left, top+7, eline

                #print_cxy color, left, top+8, eline
                #print_cxy color, left+1, top+8, texte

                #print_cxy color, left, top+9, eline
                #print_cxy color, left+1, top+9, textf

   
                #print_cxy color, left, top+10, eline
                #print_cxy color, left, top+11, bline



                #print_cxy color, left, top+13, tline
                #print_cxy color, left+1, top+13, texth

                #print_cxy color, left, top+14, eline
                #print_cxy color, left, top+15, eline
                #print_cxy color, left+1, top+15, texti

                #print_cxy color, left, top+16, eline
                #print_cxy color, left+1, top+16, textj

                #print_cxy color, left, top+17, eline
                #print_cxy color, left+1, top+17, textk

                #print_cxy color, left, top+18, bline
                lda #b_rvs_off
                jsr putch
                #print_cxy cblanc, 39-24, 24, textl
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
                .include    "lib-c64-std-showregs.asm"
           
 