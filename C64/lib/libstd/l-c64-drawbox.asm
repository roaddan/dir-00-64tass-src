;------------------------------------------------------------------------------
; Scripteur .......: Daniel Lafrance, Québec, canada.
; Nom du fichier ..: l-c64-drawbox.asm
; Type fichier.....: Librairie
; Creation.........: 20250610-223618
; Version..........: 0.1.0
; Dernière m.à j. .: 20250926-165220
;                    20261101-105644 Francisation des commentaires.  
;------------------------------------------------------------------------------
; lib-c64-drawbox.asm - Fonctions d'affichage de fenetres par l'utilisation des 
; routines du rom BASIC du Commodores 64 et 64c. 
;
; Note: Compatibilité avec le Vic-20 à vérifier.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass utilisez
; la syntaxes ... 
;
; Dépendances:
; 
;              .include    "map-c64-kernal.asm"
;              .include    "map-c64-basic2.asm"
;              .include    "lib-c64-basic2.asm"
;                       [putnch]
;              .include    "lib-c64-drawbox.asm"
;              .include    "macros-64tass.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire 
; que votre programme ou d'accès de vos librairies.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Macro: drawbox
; Description: Macro qui initialise les paramètres de la fenetre à être 
;              dessinée et appelle la fonction qui dessine la fenêtre.
; Paramêtres d'entrée: 
;              1,2) top et left....: Le coin suppérieur droit de la fenëtre.
;              3,4) width et height: La largeur et la hauteur de la fenêtre.
;              5) colour...........: La couleur de la fenêtre. >16=inverse.
;              6) titre............: Titre de la fenêtre.
;------------------------------------------------------------------------------
drawbox        .macro top, left, width, height, colour, title
               php                  ; Sauvegarde minimaliste
               pha                  ; ... des registres.
               lda   #\top          ; Initialise le paramètre 
               sta   drawbox_top    ; ... top et la
               sta   drawbox_curline; ... position de la ligne à traiter.
               lda   #\left         ; Initialise le 
               sta   drawbox_left   ; ... paramètre left.
               lda   #\width        ; Initialise le 
               sta   drawbox_width  ; ... paramètre width.
               lda   #\height       ; Initialise le
               sta   drawbox_height ; ... paramètre height.
               lda   #\colour       ; Initialise le paramètre colour.
               sta   drawbox_colour ; ... paramètre colour.
               pla                  ; Récupération minimaliste 
               plp                  ; ... des registres.
               jsr   db_drawbox     ; Dessine la fenêtre.
                                    ; Affiche le titre.
               .if \colour < 16 
                  lda #18           ; le titre zzzzzz
                  jsr chrout
                  #print_cxy \colour,\left+1,\top,\title
                  lda #146
                  jsr chrout
               .else                    
                  #print_cxy \colour,\left+1,\top,\title
               .endif
               .endm

;------------------------------------------------------------------------------
; Fonction: db_tline
; Description:  Fonction qui dessine la ligne suppérieur d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;------------------------------------------------------------------------------
db_tline       .block
               php                  ; Sauvegarde minimaliste
               pha                  ; ... des registres.
               lda   #tleft         ; Coin suppérieur gauche.
               sta   db_left
               lda   #hline         ; Ligne horizontale.
               sta   db_mid
               lda   #tright        ; Coin suppérieur droit.
               sta   db_right
               pla                  ; Récupération minimaliste 
               plp                  ; ... des registres.
               jsr   db_drawline
               rts
               .bend          

;------------------------------------------------------------------------------
; Fonction: db_bline
; Description:  Fonction qui dessine la ligne inférieure d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;------------------------------------------------------------------------------
db_bline       .block
               php                  ; Sauvegarde minimaliste
               pha                  ; ... des registres.
               lda   #bleft         ; Coin inférieur gauche.
               sta   db_left
               lda   #hline         ; Ligne horizontale.
               sta   db_mid
               lda   #bright        ; Coin inférieur droit.
               sta   db_right
               pla                  ; Récupération minimaliste 
               plp                  ; ... des registres.
               jsr   db_drawline
               rts
               .bend

;------------------------------------------------------------------------------
; Fonction: db_eline
; Description:  Fonction qui dessine une ligne vide d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;------------------------------------------------------------------------------
db_eline       .block
               php                  ; Sauvegarde minimaliste
               pha                  ; ... des registres.
               lda   #vline         ; Ligne verticale.
               sta   db_left
               lda   #space         ; Caractère espace.
               sta   db_mid
               lda   #vline         ; Ligne verticale.
               sta   db_right
               pla                  ; Récupération minimaliste 
               plp                  ; ... des registres.
               jsr   db_drawline
               rts
               .bend

;------------------------------------------------------------------------------
; Fonction: db_mline
; Description:  Fonction qui dessine une ligne horozontale d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;------------------------------------------------------------------------------
db_hline       .block
               php                  ; Sauvegarde minimaliste
               pha                  ; ... des registres.
               lda   #hleft         ; Extrémité gauche d'une ligne médianne.
               sta   db_left
               lda   #hline         ; Ligne horizontale.
               sta   db_mid
               lda   #hright        ; Extrémité droite d'une ligne médianne.
               sta   db_right
               pla                  ; Récupération minimaliste 
               plp                  ; ... des registres.
               jsr   db_drawline
               rts
               .bend

;------------------------------------------------------------------------------
; Fonction: db_drawline
; Description:  Fonction qui dessine une ligne horozontale d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;
; Note :  Appelé par les fonction suivantes:
;         db_tline, db_bline, db_eline ou db_hline
;------------------------------------------------------------------------------
db_drawline     .block
               jsr   push           ; Sauvegarde les registres.
               lda   bascol         ; Sauvegarde de la ...
               sta   drawbox_bascol ; ... couleur basic.
               lda   drawbox_colour ; Sélectionne la couleur...     
               sta   bascol         ; ... de la fenêtre.
               cmp   #$10           ; Couleur inverse vidéo?
               bmi   noreverse      ; Non ...
               lda   #18            ; Oui on place basic en inverse ...
               jsr   chrout         ; Vidéo.
noreverse      ldx   drawbox_curline; On positionne le curseur au ...
               ldy   drawbox_left   ; ... coin suppérieur gauche ...
               clc                  ; ... de la fenêtre.
               jsr   plot
               lda   db_left        ; On dessine le premier caractère.
               jsr   chrout
               lda   db_mid         ; On dessine la ligne horizontale ...
               ldx   drawbox_width  ; ... selon la largeur voulue ...
               dex                  ; ... de la fenêtre moins les ...
               dex                  ; ... deux caractères d'extrémité.
               jsr   putnch
               lda   db_right       ; On dessine le dernier caractère.
               jsr   chrout
               lda   #146           ; On met fin à l'inverse vidéo.
               jsr   chrout
               lda   drawbox_bascol ; On récupère et replace la ...
               sta   bascol         ; ... couleur de basic.
               inc   drawbox_curline; Passe à la ligne suivante.
               jsr   pop            ; Récupère les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Fonction: db_drawbox
; Description:  Fonction qui dessine une ligne horozontale d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;
; Note :  Appelé par la macro drawbox.
;         
; Utilise les fonctions : db_tline, db_bline, db_eline ou db_hline
;------------------------------------------------------------------------------
db_drawbox      .block
               jsr   push        ; Sauvegarde les registres.
               ldx   drawbox_height ; Récupère la hauteur de la fenètre.
               jsr   db_tline       ; Dessine la ligne suppérieure.
               dex                  ; Soustrait 2 pour tenir compte des ...
               dex                  ; lignes suppérieures et inférieures.
               beq   lastline       ; Si 0 pas de ligne vide dans la fenètre.
moreline       jsr   db_eline       ; Dessine une ligne vide de la boîte.
               dex                  ; Une ligne de moins à faire.
               bne   moreline       ; On passe à la prochaine s'il en reste.
lastline       jsr   db_bline       ; Dessine la ligne inférieure.
               jsr   pop         ; Récupère les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Constantes pour fichier l-c64-drawbox.asm.
; Constantes des caractères de dessin de boîte disponnible dans tous les modes
; de caractères (majuscule et minuscule).
;------------------------------------------------------------------------------
;tleft          =     176            ; Coin suppérieur gauche.
;tright         =     174            ; Coin suppérieur droit.
;bleft          =     173            ; Coin inférieur gauche.
;bright         =     189            ; Coin inférieur droit.
;hleft          =     171            ; Extrémité gauche d'une ligne médianne.
;hright         =     179            ; Extrémité droite d'une ligne médianne.
;vline          =     221            ; Ligne verticale.
;hline          =     192            ; Ligne horizontale.
;space          =     32             ; Caractère espace.

