;-------------------------------------------------------------------------------
                Version = "20251017-125301"
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
               #locate  0,0
               jsr  anykey
               ;jsr  help
               jsr  cls
               #mycolor
               #enable
               jsr  $a642
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
                ;jsr showregs
                jsr anykey
                pla
                ;sta vicbackcol
                #locate 0,0
                jsr cls
                ;#db_setvars  top, left, width, height, colour, titre 
                #drawbox  0,0,40,24,cgris1, titre
                inc titre+8                
                #drawbox  1,1,38,5,cjaune+reverse, titre
                inc titre+8
                #drawbox  6,1,19,17,ccyan+reverse, titre
                inc titre+8
                #drawbox  6,20,19,17,cvert, titre
                jsr anykey
                inc titre+8
                #drawbox  5,5,17,5,cgris1+reverse,titre
                inc titre+8
                #drawbox  5,20,17,5,cgris0,titre
                inc titre+8
                #drawbox  9,9,17,5,crose+reverse,titre
                inc titre+8
                #drawbox  11,11,17,5,crouge,titre
                inc titre+8
                #drawbox  13,13,17,5,cmauve+reverse,titre
                inc titre+8
                #drawbox  15,15,17,5,cbleu,titre
                inc titre+8
                #drawbox  17,17,17,5,ccyan+reverse,titre
                inc titre+8
                #drawbox  19,19,17,5,cvert,titre
                jsr anykey
                jsr showregs
                pla
                plp
                rts
                .bend
reverse = 16

help            .block
left = 4
top = 4
color = cblanc
color2 = crose
                jsr pushall      
                jsr cls
                lda #$0d
                jsr putch
                jsr putch
                jsr putch
                jsr putch
                lda #b_rvs_on
                jsr putch
                #drawbox  top,left,32,10,color+reverse,texta
                #print_cxy color, left+1, top+2, textb
                #print_cxy color, left+1, top+3, textc
                #print_cxy color, left+1, top+4, textd
                #print_cxy color, left+1, top+6, texte
                #print_cxy color, left+1, top+7, textf
                #print_cxy color, left+1, top+8, textg

                #drawbox  top+11,left,32,6,color2+reverse,texth
                #print_cxy color2, left+1, top+13, texti
                #print_cxy color2, left+1, top+14, textj
                #print_cxy color2, left+1, top+15, textk


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
                .include    "lib-c64-drawbox.asm"           
 