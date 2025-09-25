;-------------------------------------------------------------------------------
; Scripteur .......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier ..: lib-c64-drawbox.asm
; Version .........: 20250925-143216
; Dernière m.à j. .: 20250925-143216
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
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Fonction: db_tline
; Description:  Fonction qui dessine la ligne suppérieur d'une boite texte en 
;               utilisant les caractères graphiques disponnible dand les modes
;               majuscule et minuscule.
; Paramêtres d'entrée: 
; 
;-------------------------------------------------------------------------------
drawbox  .macro top, left, width, height, colour, titre
            php
            pha
            lda #\top
            sta drawbox_top
            sta drawbox_curline
            lda #\left
            sta drawbox_left
            lda #\width
            sta drawbox_width
            lda #\height
            sta drawbox_height
            lda #\colour
            sta drawbox_colour
            pla
            plp
            jsr db_drawbox
            #print_cxy \colour,\left+1,\top,\titre

            .endm
db_tline    .block
            php
            pha
            lda #tleft
            sta db_left
            lda #hline
            sta db_mid
            lda #tright
            sta db_right
            plp
            pla
            jsr db_drawline
            rts
            .bend          

db_bline    .block
            php
            pha
            lda #bleft
            sta db_left
            lda #hline
            sta db_mid
            lda #bright
            sta db_right
            plp
            pla
            jsr db_drawline
            rts
            .bend

db_eline    .block
            php
            pha
            lda #vline
            sta db_left
            lda #$20
            sta db_mid
            lda #vline
            sta db_right
            plp
            pla
            jsr db_drawline
            rts
            .bend

db_mline    .block
            php
            pha
            lda #mleft
            sta db_left
            lda #hline
            sta db_mid
            lda #mright
            sta db_right
            plp
            pla
            jsr db_drawline
            rts
            .bend


db_drawline .block
            jsr pushreg
            ; On sélectionne la couleur
            lda bascol
            sta drawbox_bascol
            lda drawbox_colour           
            sta bascol
            cmp #$10
            bmi noreverse
            lda #18
            jsr chrout
noreverse   ; On positionne le curseur à gauche de la boite
            ldx drawbox_curline
            ldy drawbox_left
            clc 
            jsr plot
            ; On dessine le premier caractère.
            lda db_left
            jsr chrout
            ; On dessine la ligne horizontale. 
            lda db_mid
            ldx drawbox_width
            dex
            dex
            jsr putnch
            lda db_right
            jsr chrout
            lda #146
            jsr chrout
            lda drawbox_bascol
            sta bascol
            jsr popreg
            rts
            .bend
db_drawbox  .block
            jsr pushreg
            ldx drawbox_height
            dex
            jsr db_tline
            dex
            beq lastline
moreline    inc drawbox_curline
            jsr db_eline
            dex
            bne moreline
lastline    inc drawbox_curline
            jsr db_bline

            jsr popreg
            rts
            .bend

tleft       =   176
tright      =   174
bleft       =   173
bright      =   189
mleft       =   171
mright      =   179
vline       =   221
hline       =   192
db_left         .byte   0
db_right        .byte   0
db_mid          .byte   0
drawbox_top     .byte   0
drawbox_left    .byte   0
drawbox_width   .byte   0
drawbox_height  .byte   0
drawbox_curline .byte   0
drawbox_colour  .byte   0
drawbox_bascol  .byte   0