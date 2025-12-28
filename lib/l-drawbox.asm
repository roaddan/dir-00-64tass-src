;---------------------------------------
;Nom du fichier ..: l-drawbox.asm
;Scripteur .......: Daniel Lafrance
;Version .........: 0.1.0
;Dernière m.à j. .: 20250926-165220
;Inspiration  ....: 
;---------------------------------------
;lib-c64-drawbox.asm - 
;Fonctions d'affichage de boites par 
;l'utilisation des routines du kernal 
;du Commodores 64 et 64c. 
;
;Note: Compatibilité avec le Vic-20 à 
;vérifier.
;---------------------------------------
;Pour l'utilisation de ce fichier dans 
;Turbo-macro-pro ou avec 64tass 
;utilisez la syntaxes ... 
;Dépendances:
;---------------------------------------
;---------------------------------------
;Macro: drawbox
;Description: 
;Macro qui initialise les paramètres de
;la boite à être dessinée et appelle 
;la fonction qui dessine la fenêtre.
;Paramêtres d'entrée: 
; 1,2) top et left: 
;  Le coin supp. droit de la boite
; 3,4) width et height: La largeur et 
;      la hauteur de la fenêtre.
; 5) colour: La couleur de la fenêtre. 
;      >16=inverse.
; 6) titre: Titre de la fenêtre.
;---------------------------------------
drawbox .block  ;tp,lf,wd,ht,co,titre
        jsr pushall
        sty zp1+1
        stx zp1
        ldy #$00       
        lda (zp1),y
        jsr inczp1
        sta dbleft  ;Initialise gauche
        lda (zp1),y 
        jsr inczp1
        sta dbtop   ;initialise top
        sta dbclin  ;position de ligne
        lda (zp1),y ;
        jsr inczp1
        sta dbwdth  ;Initialise width. 
        lda (zp1),y 
        jsr inczp1
        sta dbhght  ;Initialise height.
        lda kcol
        sta curcol
        lda (zp1),y ;Initialise couleur.
        sta kcol
        sta dbcoul
        jsr inczp1
        jsr dbdraw  ;Dessine la fenêtre.
                    ;Affiche le titre.
        ldx dbleft
        inx
        inx
        ldy dbtop
        jsr gotoxy
        jsr puts
        lda curcol
        sta kcol

        jsr popall
        rts
        .bend
;---------------------------------------
;Fonction: dbtline
;Description:  
;Fonction qui dessine la ligne supp.
;d'une boite texte 
;---------------------------------------
dbtline
        .block
        php         ;Sauve registres.
        pha
        lda #tleft  ;Coin supp gauche.
        sta cleft
        lda #hline  ;Ligne horizontale.
        sta cmid
        lda #tright ;Coin supp droit.
        sta cright
        plp         ;Récup registres.
        pla
        jsr dbdrawline
        rts
        .bend          
;---------------------------------------
;Fonction: dbbline
;Description:  
;Fonction qui dessine la ligne inf.
;d'une boite texte.
;---------------------------------------
dbbline 
        .block
        php         ;Sauve registres
        pha
        lda #bleft  ;Coin inf. gauche.
        sta cleft
        lda #hline  ;Ligne horizontale.
        sta cmid
        lda #bright ;Coin inf. droit.
        sta cright
        plp         ;Récup registres
        pla
        jsr dbdrawline
        rts
        .bend
;---------------------------------------
;Fonction: dbeline
;Description:  
;Fonction qui dessine une ligne vide 
;d'une boite texte.
;---------------------------------------
dbeline 
        .block
        php         ;Sauve registres
        pha
        lda #vline  ;Ligne verticale.
        sta cleft
        lda #space  ;Carac espace.
        sta cmid
        lda #vline  ;Ligne verticale.
        sta cright
        plp         ;Récup registres
        pla
        jsr dbdrawline
        rts
        .bend
;---------------------------------------
;Fonction: dbmline
;Description:  
;Fonction qui dessine une ligne 
;horizontale d'une boite texte.
;---------------------------------------
dbhline        
        .block
        php         ;Sauve registres
        pha
        lda #hleft  ;Ex. gauche médian
        sta cleft
        lda #hline  ;Ligne horizontale
        sta cmid
        lda #hright ;Ex. droite médian
        sta cright
        plp         ;Récup registres
        pla
        jsr dbdrawline
        rts
        .bend

;---------------------------------------
;Fonction: dbdrawline
;Description:  
;Fonction qui dessine une ligne 
;horizontale d'une boite texte.
;
;Note :  
;Appelé par les fonction suivantes:
; dbtline, dbbline, dbeline et dbhline
;---------------------------------------
dbdrawline     
        .block
        jsr pushregs;Sauve registres
        lda kcol    ;Sauvegarde de la-
        sta curcol ;-couleur basic.
        lda dbcoul  ;Sélect. couleur-     
        sta kcol    ;-fenêtre.
        cmp #$10    ;Couleur inverse?
        bmi norev   ;Non ...
        lda #18     ;Oui place en inv.
        jsr chrout 
norev   ldx dbclin  ;posit curseur au-
        ldy dbleft  ;-coin supp-gauche-
        clc         ;-de la fenêtre.
        jsr plot
        lda cleft   ;dessine 1er car.
        jsr chrout
        lda cmid    ;dessine ligne hor-
        ldx dbwdth  ;-selon largeur-
        dex         ;-fenêtre moins-
        dex         ;-2 car extrémité.
        jsr putnch
        lda cright  ;dess. dernier car
        jsr chrout
        lda #146    ;fin inverse vidéo
        jsr chrout
        lda curcol ;replace la couleur
        sta kcol    ;basic.
        inc dbclin;ligne suivante.
        jsr popregs ;Récup registres
        rts
        .bend

;---------------------------------------
;Fonction: dbdraw
;Description:  
;Fonction qui dessine une boite texte;
;Note :  Appelé par la macro drawbox.
;        
;Utilise les fonctions : 
;dbtline, dbbline, dbeline et dbhline.
;---------------------------------------
dbdraw      
        .block
        jsr pushregs;Sauve registres
        ldx dbhght  ;recup hautr boite
        jsr dbtline ;Dessine ligne sup
        dex         ;-2 pour les ...
        dex         ;lignes supp/inf
        beq linfin  ;Si 0 ligne vide.
boucle  jsr dbeline ;Dessine ligne vide
        dex         ;
        bne boucle  ;prochaine si reste
linfin  jsr dbbline ;Dessine ligne inf.
        jsr popregs ;Récup registres
        rts
        .bend
;---------------------------------------
;Variables globales des paramètres de 
;dessin de boite texte.
;---------------------------------------
cleft   .byte   0   ;Carac Gauche lin 
cright  .byte   0   ;Carac droit lin
cmid    .byte   0   ;Carac centr lin
dbtop   .byte   0   ;Coord haut boite.
dbleft  .byte   0   ;Coord gauche boîte
dbwdth  .byte   0   ;Larg de la boîte.
dbhght  .byte   0   ;Haut de la boîte.
dbcoul  .byte   0   ;Coul de la boîte.
dbclin  .byte   0   ;No ligne courante
;---------------------------------------
