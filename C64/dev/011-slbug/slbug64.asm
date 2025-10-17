;-------------------------------------------------------------------------------
            Version = "20251017-125301"
;-------------------------------------------------------------------------------            .include    "header-c64.asm"
            .include    "header-c64.asm"
;-------------------------------------------------------------------------------
            .enc    "none"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main        .block
            jsr scrmaninit  ; Met en place la gestion d'écran.
            #tolower        ; Place en mode police minuscule/majuscule.
            #disable        ; Interdit le changement de police [C=]+[SHIFT].
            #mycolor        ; Texte blanc, fond bleu, bordure verte.
            jsr cls         ; Efface l'écran.
            jsr help        ; Affiche le menu d'aide.
            jsr anykey      ; Attend une clef et vide le tampon clavier.
            jsr slbug64     ; Lance la fonction principale.
            #locate 0,0     ; Place le curseur au coin suppérieur gauche.
            jsr anykey      ; Attend une clef et vide le tampon clavier.
            jsr help        ; Affiche l'écran d'aide.
            jsr anykey      ; Attend une clef et vide le tampon clavier.
            jsr cls         ; Efface l'écran.
            #c64col         ; Texte blanc, fond bleu, bordure bleue pâle.
            #enable         ; Permet le changement de police [C=]+[SHIFT].
            #toupper        ; Place en mode police majuscule/graphique.
            rts
            .bend     

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
slbug64     .block
            php
            pha
            lda vicbackcol
            pha
            lda #cnoir      ; \
            sta vicbackcol  ;  > Bordure et fond en noir.
            sta vicbordcol  ; /
            jsr anykey      ; Attend une clef et vide le tampon clavier.
            pla
            #locate 0,0
            jsr cls
            #tolower        ; Place en mode police minuscule/majuscule.
            #disable        ; Interdit le changement de police [C=]+[SHIFT].
            ;#db_setvars  top, left, width, height, colour, titre 
            #drawbox 0,0,40,24,cgris1, titre
            #drawbox 1,1,38,5,cjaune+reverse, titre
            #drawbox 6,1,19,17,ccyan+reverse, titre
            #drawbox 6,20,19,17,cvert, titre
            jsr anykey      ; Attend une clef et vide le tampon clavier.
            #drawbox 5,5,20,5,cgris1+reverse,titre
            #drawbox 7,7,20,5,cgris0,titre
            #drawbox 9,9,20,5,crose+reverse,titre
            #drawbox 11,11,20,5,crouge,titre
            #drawbox 13,13,20,5,cmauve+reverse,titre
            #drawbox 15,15,20,5,cbleu,titre
            #drawbox 17,17,20,5,ccyan+reverse,titre
            #drawbox 19,19,20,5,cvert,titre
            jsr anykey      ; Attend une clef et vide le tampon clavier.
            jsr showregs
            pla
            plp
            rts
            .bend
reverse = 16
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
help        .block
            jsr pushall      
            jsr cls
            #tolower        ; Place en mode police minuscule/majuscule.
            #disable        ; Interdit le changement de police [C=]+[SHIFT].
            lda #$0d
            jsr putch
            jsr putch
            jsr putch
            jsr putch
            lda #b_rvs_on
            jsr putch

            #drawbox top,left,32,10,color+reverse,texta
            #print_cxy color, left+1, top+2, textb
            #print_cxy color, left+1, top+3, textc
            #print_cxy color, left+1, top+4, textd
            #print_cxy color, left+1, top+6, texte
            #print_cxy color, left+1, top+7, textf
            #print_cxy color, left+1, top+8, textg

            #drawbox top+11,left,32,6,color2+reverse,texth
            #print_cxy color2, left+1, top+13, texti
            #print_cxy color2, left+1, top+14, textj
            #print_cxy color2, left+1, top+15, textk
            lda #b_rvs_off
            jsr putch
            #print_cxy cblanc, 39-24, 24, textl
            jsr popall
            rts                        
left = 4
top = 4
color = cblanc
color2 = crose
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
 