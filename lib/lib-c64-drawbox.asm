;-------------------------------------------------------------------------------
; Scripteur .......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier ..: lib-c64-drawbox.asm
; Version .........: 20250925-143216
; Dernière m.à j. .: 20250926-165220
; Inspiration  ....: 
;-------------------------------------------------------------------------------
; lib-c64-drawbox.asm - Fonctions d'affichage de fenetres par l'utilisation des 
; routines du rom BASIC du Commodores 64 et 64c. 
;
; Note: Compatibilité avec le Vic-20 à vérifier.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass utilisez
; la syntaxes ... 
;
; Dépendances:
; 
;           .include    "map-c64-kernal.asm"
;           .include    "map-c64-basic2.asm"
;           .include    "lib-c64-basic2.asm"
;                       [putnch]
;           .include    "lib-c64-drawbox.asm"
;           .include    "macros-64tass.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme ou d'accès de vos librairies.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Macro: drawbox
; Description: Macro qui initialise les paramètres de la fenetre à être 
;              dessinée et appelle la fonction qui dessine la fenêtre.
; Paramêtres d'entrée: 
;              1,2) top et left....: Le coin suppérieur droit de la fenëtre.
;              3,4) width et height: La largeur et la hauteur de la fenêtre.
;              5) colour...........: La couleur de la fenêtre. >16=inverse.
;              6) titre............: Titre de la fenêtre.
;-------------------------------------------------------------------------------
drawbox         .macro top, left, width, height, colour, title
                php                 ; Sauvegarde les registres.
                pha
                lda #\top           ; Initialise le paramètre top et la ...
                sta drawbox_top
                sta drawbox_curline ; ... position de la ligne à traiter.
                lda #\left          ; Initialise le paramètre left.
                sta drawbox_left
                lda #\width         ; Initialise le paramètre width.
                sta drawbox_width
                lda #\height        ; Initialise le paramètre height.
                sta drawbox_height
                lda #\colour        ; Initialise le paramètre colour.
                sta drawbox_colour
                pla                 ; Récupère les registres.
                plp
                jsr db_drawbox      ; Dessine la fenêtre.
                                    ; Affiche le titre.

                #print_cxy \colour,\left+1,\top,\title
                .endm

;-------------------------------------------------------------------------------
; Fonction: db_tline
; Description:  Fonction qui dessine la ligne suppérieur d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;-------------------------------------------------------------------------------
db_tline        .block
                php                 ; Sauvegarde les registres.
                pha
                lda #tleft          ; Coin suppérieur gauche.
                sta db_left
                lda #hline          ; Ligne horizontale.
                sta db_mid
                lda #tright         ; Coin suppérieur droit.
                sta db_right
                plp                 ; Récupère les registres.
                pla
                jsr db_drawline
                rts
                .bend          

;-------------------------------------------------------------------------------
; Fonction: db_bline
; Description:  Fonction qui dessine la ligne inférieure d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;-------------------------------------------------------------------------------
db_bline        .block
                php                 ; Sauvegarde les registres.
                pha
                lda #bleft          ; Coin inférieur gauche.
                sta db_left
                lda #hline          ; Ligne horizontale.
                sta db_mid
                lda #bright         ; Coin inférieur droit.
                sta db_right
                plp                 ; Récupère les registres.
                pla
                jsr db_drawline
                rts
                .bend

;-------------------------------------------------------------------------------
; Fonction: db_eline
; Description:  Fonction qui dessine une ligne vide d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;-------------------------------------------------------------------------------
db_eline        .block
                php                 ; Sauvegarde les registres.
                pha
                lda #vline          ; Ligne verticale.
                sta db_left
                lda #space          ; Caractère espace.
                sta db_mid
                lda #vline          ; Ligne verticale.
                sta db_right
                plp                 ; Récupère les registres.
                pla
                jsr db_drawline
                rts
                .bend

;-------------------------------------------------------------------------------
; Fonction: db_mline
; Description:  Fonction qui dessine une ligne horozontale d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;-------------------------------------------------------------------------------
db_hline        .block
                php                 ; Sauvegarde les registres.
                pha
                lda #hleft          ; Extrémité gauche d'une ligne médianne.
                sta db_left
                lda #hline          ; Ligne horizontale.
                sta db_mid
                lda #hright         ; Extrémité droite d'une ligne médianne.
                sta db_right
                plp                 ; Récupère les registres.
                pla
                jsr db_drawline
                rts
                .bend

;-------------------------------------------------------------------------------
; Fonction: db_drawline
; Description:  Fonction qui dessine une ligne horozontale d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;
; Note :  Appelé par les fonction suivantes:
;         db_tline, db_bline, db_eline ou db_hline
;-------------------------------------------------------------------------------
db_drawline     .block
                jsr pushreg         ; Sauvegarde les registres.
                lda bascol          ; Sauvegarde de la ...
                sta drawbox_bascol  ; ... couleur basic.
                lda drawbox_colour  ; Sélectionne la couleur...     
                sta bascol          ; ... de la fenêtre.
                cmp #$10            ; Couleur inverse vidéo?
                bmi noreverse       ; Non ...
                lda #18             ; Oui on place basic en inverse ...
                jsr chrout          ; Vidéo.
noreverse       ldx drawbox_curline ; On positionne le curseur au ...
                ldy drawbox_left    ; ... coin suppérieur gauche ...
                clc                 ; ... de la fenêtre.
                jsr plot
                lda db_left         ; On dessine le premier caractère.
                jsr chrout
                lda db_mid          ; On dessine la ligne horizontale ...
                ldx drawbox_width   ; ... selon la largeur voulue ...
                dex                 ; ... de la fenêtre moins les ...
                dex                 ; ... deux caractères d'extrémité.
                jsr putnch
                lda db_right        ; On dessine le dernier caractère.
                jsr chrout
                lda #146            ; On met fin à l'inverse vidéo.
                jsr chrout
                lda drawbox_bascol  ; On récupère et replace la ...
                sta bascol          ; ... couleur de basic.
                inc drawbox_curline ; Passe à la ligne suivante.
                jsr popreg          ; Récupère les registres.
                rts
                .bend

;-------------------------------------------------------------------------------
; Fonction: db_drawbox
; Description:  Fonction qui dessine une ligne horozontale d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
;
; Note :  Appelé par la macro drawbox.
;         
; Utilise les fonctions : db_tline, db_bline, db_eline ou db_hline
;-------------------------------------------------------------------------------
db_drawbox      .block
                jsr pushreg         ; Sauvegarde les registres.
                ldx drawbox_height  ; Récupère la hauteur de la fenètre.
                jsr db_tline        ; Dessine la ligne suppérieure.
                dex                 ; Soustrait 2 pour tenir compte des ...
                dex                 ; lignes suppérieures et inférieures.
                beq lastline        ; Si 0 pas de ligne vide dans la fenètre.
moreline        jsr db_eline        ; Dessine une ligne vide de la boîte.
                dex                 ; Une ligne de moins à faire.
                bne moreline        ; On passe à la prochaine s'il en reste.
lastline        jsr db_bline        ; Dessine la ligne inférieure.
                jsr popreg          ; Récupère les registres.
                rts
                .bend

;-------------------------------------------------------------------------------
; Constantes des caractères de dessin de boîte disponnible dans tous les modes
; de caractères (majuscule et minuscule).
;-------------------------------------------------------------------------------
tleft           =       176         ; Coin suppérieur gauche.
tright          =       174         ; Coin suppérieur droit.
bleft           =       173         ; Coin inférieur gauche.
bright          =       189         ; Coin inférieur droit.
hleft           =       171         ; Extrémité gauche d'une ligne médianne.
hright          =       179         ; Extrémité droite d'une ligne médianne.
vline           =       221         ; Ligne verticale.
hline           =       192         ; Ligne horizontale.
space           =       32          ; Caractère espace.

;-------------------------------------------------------------------------------
; Variables globales des paramètres de dessin de fenetre texte.
;-------------------------------------------------------------------------------
db_left         .byte   0           ; Caractère Gauche de la ligne courante. 
db_right        .byte   0           ; Caractère droit de la ligne courante.
db_mid          .byte   0           ; Caractère central de la ligne courante.
drawbox_top     .byte   0           ; Coordonné du haut de la boite.
drawbox_left    .byte   0           ; Coordonné de la gauche de la boîte.
drawbox_width   .byte   0           ; Largeur de la boîte.
drawbox_height  .byte   0           ; Hauteur de la boîte.
drawbox_colour  .byte   0           ; Couleur de la boîte.
drawbox_curline .byte   0           ; No de la ligne courante à dessiner.
drawbox_bascol  .byte   0           ; Case de mémorisation de la couleur Basic.   