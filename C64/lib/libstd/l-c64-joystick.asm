;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: l-c64-joystick.asm
; Cernière m.à j. : 20261029-000000 Francisation des commentaires,
; Inspiration ....:
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; Lecture de la des manettes de commande numériques.
;------------------------------------------------------------------------------
js2_port       =     cia1pra        ; Définition des constantes  pour accéder
js1_port       =     cia1prb        ; ... et lire les données des ports de
js2_dir        =     cia1ddra       ; ... manette de jeu.
js1_dir        =     cia1ddrb
js_xoffset     =     2
js_yoffset     =     2
js_location    =     0

;------------------------------------------------------------------------------
; Initialisation des ports E/S pour accéder aux manettes de jeu numérique.
;------------------------------------------------------------------------------
js_init        .block
               php                  ; Sauvegarde minimaliste
               pha                  ; ... des registres.
               lda   js1_dir        ; On masque les
               and   #$e0           ; ... bits 4-0 du registre
               sta   js1_dir        ; ... de direction. 1=sortie, 0=entrée.
               lda   js2_dir        ; On masque les
               and   #$e0           ; ... bits 4-0 du registre
               sta   js2_dir        ; ... de direction. 1=sortie, 0=entrée.
               pla                  ; Récupération minimaliste
               plp                  ; ... des registres.
               .bend

;------------------------------------------------------------------------------
; Routine qui effectue le sondage des deux ports jeu.
;------------------------------------------------------------------------------
js_scan        .block
               jsr   js1_scan       ; Sonde le port1.
               jsr   js2_scan       ; Sonde le port2.
               rts
               .bend
;------------------------------------------------------------------------------
; js1_scan sonde et interprète l'entrée du port de jeu #1.
; Port 1 js1_= %000FRLDU
;------------------------------------------------------------------------------
js1_scan       .block
               jsr   pushregs       ; Sauvegarde des rgistres.
               lda   js1_port       ; Récupère la valeur du port #1.
               and   #$1f           ; Masque les bits 5 à 7.
               eor   #$1f           ; Inverse les bits 0 à 4.
               sta   js1_status     ; Sauvegarde le résultat.
               cmp   #$1f           ; Si les ne sont pas tous à 1.
               bne   js1_b0         ; On va voir quel boouton est actionné.
               jmp   port1_out      ; On sort car il n'y a pas d'action.
               ;---------------------------------------------------------------
               ; BOUTON 0, EN-HAUT
               ;---------------------------------------------------------------
js1_b0         clc                  ; 0 dans Carry (C).
               lsr                  ; On decale js1_ bit 0 dans C.
               bcc   js1_b1         ; Est-ce vers le haut (U), C=0. 
               pha                  ; On place la valeur sur la pile.
                                    ; ... pour la prochaine vérification.
               inc   js1_flag       ; On incremente le flag d'action.
               lda   js1_pixy       ; Oui, il s'agit de UP!
               sec                  ; On place la carry a 1 pour 
               sbc   #js_yoffset    ; ... soustraire l'offset à Y.
               cmp   #240           ; Avons nous fait la boucle dans l'octet.
               bcc   sto1ym         ; Non on saute.
               lda   #$00           ; Oui, on place la coordonnées à 0.
sto1ym         sta   js1_pixy       ; Sauvegarde la Coordonnée Y.
               ;---------------------------------------------------------------
               ; BOUTON 1, EN-BAS
               ;---------------------------------------------------------------
js1_b1         pla                  ; On récupère la valeur.
               lsr                  ; On decale js1_ bit 0 dans C.
               bcc   js1_b2         ; Est-ce vers le bas (D), C=0.
               pha                  ; On place la valeur sur la pile
                                    ; ... pour la prochaine vérification.
               inc   js1_flag       ; On incremente le flag d'action.
               lda   js1_pixy       ; Oui, il s'agit de DOWN!
               clc                  ; On place la carry a 0
               adc   #js_yoffset    ; ... additionner l'offset à Y.
               cmp   #199           ; Avons nous dépassé le bas de l'écran?
               bcc   sto1yp         ; Non on saute.
               lda   #199           ; Oui, on place la coordonnées à 199.
sto1yp         sta   js1_pixy       ; Sauvegarde la Coordonnée Y.
               pla                  ; On récupère la valeur.
               ;---------------------------------------------------------------
               ; BOUTON 2, A-GAUCHE  La coordonné X de l'écran est conservée 
               ;                     sur 16 bits.
               ;---------------------------------------------------------------
js1_b2         lsr                  ; On decale js1_ bit 0 dans C.
               bcc   js1_b3         ; Est-ce vers la gauche (L) C=0.
               pha                  ; On place la valeur sur la pile
                                    ; ... pour la prochaine vérification.
               inc   js1_flag       ; On incremente le flag d'action.
               lda   js1_pixx       ; On combine les deux octet de la coordonné
               ora   js1_pixx+1     ; ... pour savoir si nous sommes à 0.
               beq   js1_b2out      ; Oui nous sommes à 0, on saute.
               lda   js1_pixx       ; On charge le LSB de la position X
               sec                  ; On place la carry a 1 pour
                                    ; ... préparer la 
               sbc   #js_xoffset    ; ... soustraction de l'offset.
               sta   js1_pixx       ; Sauvegarde le LSB de X.
               bcs   js1_b2out      ; Si C à 1, il n'y a pas eu d'emprunt.
               lda   js1_pixx+1     ; On charge le MSB de X.
               beq   js1_b2out      ; Si à 0, on ne peut pas emprunter.
               dec   js1_pixx+1     ; On effectue l'emprunt.
js1_b2out      pla                  ; On récupère la valeur.
               ;---------------------------------------------------------------
               ; BOUTON 3 A-DROITE   La coordonné X de l'écran est conservée 
               ;                     sur 16 bits.
               ;---------------------------------------------------------------
js1_b3         lsr                  ; On decale js1_ bit 0 dans C
               bcc   js1_b4         ; Est-ce vers la droite (R)
               pha                  ; On place la valeur sur la pile
                                    ; ... pour la prochaine vérification.
               inc   js1_flag       ; On incremente le flag d'action.
               lda   js1_pixx+1     ; On charge le MSB de la position X.
               beq   incj1x         ; S'il est à 0, c'est que noous sommes à 
                                    ; moins de 256 pixel de la gauche de 
                                    ; ... l'écran et nous ne sommes donc pas 
                                    ; ... dans la portion de droite de l'écran,
                                    ; ... alors nous pouvons encore tasser la 
                                    ; ... coordonné X vers la droite.
               lda   js1_pixx       ; On charge le LSB de la position X.
               cmp   #$2b-js_xoffset; Comme nous sommes à 256 pixels et plus
                                    ; ... sur la droite, On compare avec 297 
                                    ; ... pour savoir si nous pouvons encore 
                                    ; ... aller vers la droite.
               bmi   incj1x         ; Si c'est moins, on tasse vers la droite.
               jmp   js1_b3out      ; Si non on sort.
incj1x         clc                  ; On prepare le carry (0) pour l'addition.
               lda   js1_pixx       ; On charge le LSB de la position X.
               adc   #js_xoffset    ; On augmente d'un offset.
               sta   js1_pixx       ; On sauvegarde le LSB.
               bcc   js1_b3out      ; Si on a un report ...
               inc   js1_pixx+1     ; ... On l'ajoute au MSB car sur 16 bits.
js1_b3out      pla                  ; On récupère la valeur.
               ;---------------------------------------------------------------
               ; BOUTON 4 FIRE
               ;---------------------------------------------------------------
js1_b4         lsr                  ; Estce le bbouton fire (F)
               bcc   port1_out      ; Oui!
               inc   js1_flag       ; On incremente le flag d'action.
               inc   js1_fire       ; On augmente le nombre de tir
js1_rel        lda   js1_port       ; Lecture du port
               and   #%00010000     ; On masque avec %00010000
               beq   js1_rel        ; On attend le relachement du bouton FIRE.
port1_out      lda   js1_flag       ; On regarte su une action est à faire.
               beq   out            ; Non on sort.
               jsr   js1_correct    ; On effectue les correction des témoins.
               lda   #0             ; On signale en plaçant un 0 que l'action
               sta   js1_flag       ; ... est terminée.
out            jsr   popregs        ; Récupère les registres.
               .bend

;------------------------------------------------------------------------------
; js2_scan sonde et interprète l'entrée du port de jeu #2.
; Port 2 js1_= %000FRLDU
;------------------------------------------------------------------------------
js2_scan       .block
               jsr   pushregs       ; Sauvegarde des rgistres.
               lda   js2_port       ; Récupère la valeur du port #1.
               and   #$1f           ; Masque les bits 5 à 7.
               eor   #$1f           ; Inverse les bits 0 à 4.
               sta   js2_status     ; Sauvegarde le résultat.
               cmp   #$1f           ; Si les ne sont pas tous à 1.
               bne   js2_b0         ; On va voir quel boouton est actionné.
               jmp   port2_out      ; On sort car il n'y a pas d'action.
               ;---------------------------------------------------------------
               ; BOUTON 0, EN-HAUT
               ;---------------------------------------------------------------
js2_b0         clc                  ; 0 dans Carry (C).
               lsr                  ; On decale js2_ bit 0 dans C.
               bcc   js2_b1         ; Est-ce vers le haut (U), C=0. 
               pha                  ; On place la valeur sur la pile.
                                    ; ... pour la prochaine vérification.
               inc   js2_flag       ; On incremente le flag d'action.
               lda   js2_pixy       ; Oui, il s'agit de UP!
               sec                  ; On place la carry a 1 pour 
               sbc   #js_yoffset    ; ... soustraire l'offset à Y.
               cmp   #240           ; Avons nous fait la boucle dans l'octet.
               bcc   sto1ym         ; Non on saute.
               lda   #$00           ; Oui, on place la coordonnées à 0.
sto1ym         sta   js2_pixy       ; Sauvegarde la Coordonnée Y.
               ;---------------------------------------------------------------
               ; BOUTON 1, EN-BAS
               ;---------------------------------------------------------------
js2_b1         pla                  ; On récupère la valeur.
               lsr                  ; On decale js2_ bit 0 dans C.
               bcc   js2_b2         ; Est-ce vers le bas (D), C=0.
               pha                  ; On place la valeur sur la pile
                                    ; ... pour la prochaine vérification.
               inc   js2_flag       ; On incremente le flag d'action.
               lda   js2_pixy       ; Oui, il s'agit de DOWN!
               clc                  ; On place la carry a 0
               adc   #js_yoffset    ; ... additionner l'offset à Y.
               cmp   #199           ; Avons nous dépassé le bas de l'écran?
               bcc   sto1yp         ; Non on saute.
               lda   #199           ; Oui, on place la coordonnées à 199.
sto1yp         sta   js2_pixy       ; Sauvegarde la Coordonnée Y.
               pla                  ; On récupère la valeur.
               ;---------------------------------------------------------------
               ; BOUTON 2, A-GAUCHE  La coordonné X de l'écran est conservée 
               ;                     sur 16 bits.
               ;---------------------------------------------------------------
js2_b2         lsr                  ; On decale js2_ bit 0 dans C.
               bcc   js2_b3         ; Est-ce vers la gauche (L) C=0.
               pha                  ; On place la valeur sur la pile
                                    ; ... pour la prochaine vérification.
               inc   js2_flag       ; On incremente le flag d'action.
               lda   js2_pixx       ; On combine les deux octet de la coordonné
               ora   js2_pixx+1     ; ... pour savoir si nous sommes à 0.
               beq   js2_b2out      ; Oui nous sommes à 0, on saute.
               lda   js2_pixx       ; On charge le LSB de la position X
               sec                  ; On place la carry a 1 pour
                                    ; ... préparer la 
               sbc   #js_xoffset    ; ... soustraction de l'offset.
               sta   js2_pixx       ; Sauvegarde le LSB de X.
               bcs   js2_b2out      ; Si C à 1, il n'y a pas eu d'emprunt.
               lda   js2_pixx+1     ; On charge le MSB de X.
               beq   js2_b2out      ; Si à 0, on ne peut pas emprunter.
               dec   js2_pixx+1     ; On effectue l'emprunt.
js2_b2out      pla                  ; On récupère la valeur.
               ;---------------------------------------------------------------
               ; BOUTON 3, A-DROITE  La coordonné X de l'écran est conservée 
               ;                     sur 16 bits.
               ;---------------------------------------------------------------
js2_b3         lsr                  ; On decale js2_ bit 0 dans C
               bcc   js2_b4         ; Est-ce vers la droite (R)
               pha                  ; On place la valeur sur la pile
                                    ; ... pour la prochaine vérification.
               inc   js2_flag       ; On incremente le flag d'action.
               lda   js2_pixx+1     ; On charge le MSB de la position X.
               beq   incj1x         ; S'il est à 0, c'est que noous sommes à 
                                    ; moins de 256 pixel de la gauche de 
                                    ; ... l'écran et nous ne sommes donc pas 
                                    ; ... dans la portion de droite de l'écran,
                                    ; ... alors nous pouvons encore tasser la 
                                    ; ... coordonné X vers la droite.
               lda   js2_pixx       ; On charge le LSB de la position X.
               cmp   #$2b-js_xoffset; Comme nous sommes à 256 pixels et plus
                                    ; ... sur la droite, On compare avec 297 
                                    ; ... pour savoir si nous pouvons encore 
                                    ; ... aller vers la droite.
               bmi   incj1x         ; Si c'est moins, on tasse vers la droite.
               jmp   js2_b3out      ; Si non on sort.
incj1x         clc                  ; On prepare le carry (0) pour l'addition.
               lda   js2_pixx       ; On charge le LSB de la position X.
               adc   #js_xoffset    ; On augmente d'un offset.
               sta   js2_pixx       ; On sauvegarde le LSB.
               bcc   js2_b3out      ; Si on a un report ...
               inc   js2_pixx+1     ; ... On l'ajoute au MSB car sur 16 bits.
js2_b3out      pla                  ; On récupère la valeur.
               ;---------------------------------------------------------------
               ; BOUTON FIRE
               ;---------------------------------------------------------------
js2_b4         lsr                  ; Estce le bbouton fire (F)
               bcc   port2_out      ; Oui!
               inc   js2_flag       ; On incremente le flag d'action.
               inc   js2_fire       ; On augmente le nombre de tir
js2_rel        lda   js2_port       ; Lecture du port
               and   #%00010000     ; On masque avec %00010000
               beq   js2_rel        ; On attend le relachement du bouton FIRE.
port2_out      lda   js2_flag       ; On regarte su une action est à faire.
               beq   out            ; Non on sort.
               jsr   js2_correct    ; On effectue les correction des témoins.
               lda   #0             ; On signale en plaçant un 0 que l'action
               sta   js2_flag       ; ... est terminée.
out            jsr   popregs        ; Récupère les registres.
               .bend

;------------------------------------------------------------------------------
; Effectue l'interprétation des données de la pseudo souris.
;------------------------------------------------------------------------------
js_corrector   .block
               php                  ; Sauvegarde minimale
               pha                  ; ... des registres.
js1_check      lda   js1_flag       ; Doit-on traiter une action sur le port 1. 
               beq   js2_check      ; Non, on passe au port 2.  
               jsr   js1_correct    ; Oui, on effectue le traitement.
               lda   #0             ; Par un 0 on signale que 
               sta   js1_flag       ; ... le traitement est terminé.
js2_check      lda   js2_flag       ; Doit-on traiter une action sur le port 2.
               beq   no_update      ; Non, Rien à traiter, on sort.
               jsr   js2_correct    ; Oui, on effectue le traitement.
               lda   #0             ; Par un 0 on signale que 
               sta   js2_flag       ; ... le traitement est terminé.
no_update      pla                  ; Récupération minimale
               plp                  ; ... des registres.
               rts
               .bend
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
js1_correct    .block
               php
               pha
               ;---------------------------------------------------------------
               ; Port 1 X
               ;---------------------------------------------------------------
               lda   js1_pixx
               sta   vallsb
               lda   js1_pixx+1
               ror                  ; ex = %0000000100000001 = 257 pixel
               ror   vallsb         ; Cnnnnnnn      On divise par 8 pc les
               lsr   vallsb         ; 0Cnnnnnn      caracteres de 8 pixels
               lsr   vallsb         ; 00Cnnnnn
               lda   vallsb         ; devient = %00100000 = 32
               sta   js1_x
               ;---------------------------------------------------------------
               ; Port 1 Y
               ;---------------------------------------------------------------
               lda   js1_pixy
               sta   vallsb
               lsr   vallsb         ; Cnnnnnnn     On divise par 8 pc les
               lsr   vallsb         ; 0Cnnnnnn     caracteres de 8 pixels
               lsr   vallsb         ; 00Cnnnnn
               lda   vallsb         ; devient = %00100000 = 32
               sta   js1_y
               pla
               plp
               rts
vallsb         .byte 0
regx           .byte 0
               .bend
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
js2_correct    .block
               php
               pha
               ;---------------------------------------------------------------
               ; Port 2 X
               ;---------------------------------------------------------------
               lda   js2_pixx
               sta   vallsb
               lda   js2_pixx+1
               ror                  ; ex = %0000000100000001 = 257 pixel
               ror   vallsb         ; Cnnnnnnn     On divise par 8 pc les
               lsr   vallsb         ; 0Cnnnnnn     caracteres de 8 pixels
               lsr   vallsb         ; 00Cnnnnn
               lda   vallsb         ; devient = %00100000 = 32
               sta   js2_x
               ;---------------------------------------------------------------
               ; Port 2 Y
               ;---------------------------------------------------------------
               lda   js2_pixy
               sta   vallsb
               lsr   vallsb         ; Cnnnnnnn     On divise par 8 pc les
               lsr   vallsb         ; 0Cnnnnnn     caracteres de 8 pixels
               lsr   vallsb         ; 00Cnnnnn
               lda   vallsb         ; devient = %00100000 = 32
               sta   js2_y
               pla
               plp
               rts
vallsb         .byte 0
regx           .byte 0
               .bend
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
js_showvals    .block
               ;jsr   js1_showvals
               jsr   js2_showvals
               rts
               .bend
;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
js1_showvals   .block
               jsr   push
               lda   js1_x          ; La valeur 8 bits de js1_ X
               jsr   a2hex
               lda   a2hexstr+1
               sta   js1_val8+19
               lda   a2hexstr+2
               sta   js1_val8+20
               lda   js1_pixx       ; La valeur 16 bits de js1_ X
               jsr   a2hex
               lda   a2hexstr+1
               sta   js1_val16+14
               lda   a2hexstr+2
               sta   js1_val16+15
               lda   js1_pixx+1
               jsr   a2hex
               lda   a2hexstr+1
               sta   js1_val16+12
               lda   a2hexstr+2
               sta   js1_val16+13
               lda   js1_y          ; La valeyr 8 bits de js1_ Y
               jsr     a2hex
               ;lda  a2hexstr
               ;sta  js1_val+21
               lda   a2hexstr+1
               sta   js1_val8+23
               lda   a2hexstr+2
               sta   js1_val8+24
               lda   js1_pixy       ; La valeur 16 bits de js1_ Y
               jsr   a2hex
               lda   a2hexstr+1
               sta   js1_val16+20
               lda   a2hexstr+2
               sta   js1_val16+21
               lda   #0
               jsr   a2hex
               lda   a2hexstr+1
               sta   js1_val16+18
               lda   a2hexstr+2
               sta   js1_val16+19
               lda   js1_fire       ; Le bouton fire de js1_
               jsr   a2hex
               lda   a2hexstr+2
               sta   js1_val8+33
               ldx   #<js1_val8
               ldy   #>js1_val8
               jsr   putscxy
               ldx   #<js1_val16
               ldy   #>js1_val16
               jsr   putscxy
               jsr   pop
               rts
               .bend

js_updatecurs  .block
               jsr   pushregs
               ;lda   js_oldx
               ;cmp   #$ff
               ;beq   running
               ;ldx   js2_x
               ;ldy   js2_y
               ;stx   js_oldx
               ;sty   js_oldy
               ;jsr   js_eoraddrxy

running        lda   js2_x          ; on réécrit l'ancien caractèere àa sa place
               cmp   js_x
               beq   chky
               sta   js_x
               inc   flag
chky           lda   js2_y
               cmp   js_y
               beq   chkflag
               sta   js_y
               inc   flag
chkflag        lda   flag
               beq   showit
               ldx   js_oldx
               ldy   js_oldy
               jsr   js_eoraddrxy
               ldx   js_x
               ldy   js_y
               jsr   js_eoraddrxy
               lda   js_x
               sta   js_oldx
               lda   js_y
               sta   js_oldy
showit         lda   #0
               sta   flag
               sta   addr1
               lda   #$04
               sta   addr1+1
               ldx   js_x
               ldy   js_y
               jsr   xy2addr
               ldy   addr2
               ldx   addr2+1
               ;jsr   showregs
               jsr   popregs
               rts
flag           .byte   0
               .bend

js_eoraddrxy   .block
               jsr   pushall
               ;jsr   showregs
               jsr   savezp2
               lda   #$04
               sta   addr1+1
               lda   #0
               sta   addr1
               jsr   xy2addr
               ldy   addr2
               sty   zpage2
               ldx   addr2+1
               stx   zpage2+1
               ldy   #0
               lda   (zpage2),y
               eor   #%01000000
               sta   (zpage2),y
               jsr   restzp2
               jsr   popall
               rts
               .bend

;------------------------------------------------------------------------------
; Affiche les valeurs des joystick et les valeurs calculées.
;------------------------------------------------------------------------------
js2_showvals   .block
               jsr   push                   ; stack : y, x, a, flg
               lda   js2_x          ; La valeur 8 bits de js2_ X
               jsr   a2hex
               lda   a2hexstr
               sta   js2_val8+19
               lda   a2hexstr+1
               sta   js2_val8+20
               ;lda   js2_pixx      ; La valeur 16 bits de js2_ X
               lda   js2_clickx
               jsr   a2hex
               lda   a2hexstr
               sta   js2_val16+14
               lda   a2hexstr+1
               sta   js2_val16+15
               ;lda   js2_pixx+1
               lda   js2_clickx+1
               jsr   a2hex
               lda   a2hexstr
               sta   js2_val16+12
               lda   a2hexstr+1
               sta   js2_val16+13
               lda   js2_y          ; La valeur 8 bits de js2_ Y
               jsr   a2hex
               lda   a2hexstr
               sta   js2_val8+23
               lda   a2hexstr+1
               sta   js2_val8+24
               ;lda   js2_pixy      ; La valeur 16 bits de js2_ Y
               lda   js2_clicky
               jsr   a2hex
               lda   a2hexstr
               sta   js2_val16+20
               lda   a2hexstr+1
               sta   js2_val16+21
               lda   #0
               jsr   a2hex
               lda   a2hexstr
               sta   js2_val16+18
               lda   a2hexstr+1
               sta   js2_val16+19
               lda   js2_fire       ; Le bouton fire de js2_
               jsr   a2hex
               lda   a2hexstr+1
               sta   js2_val8+33
               ldx   #<js2_val8     ; On affiche les données
               ldy   #>js2_val8
               jsr   putscxy
               ldx   #<js2_val16a
               ldy   #>js2_val16a
               jsr   putscxy
               ldx   #<js2_val16
               ldy   #>js2_val16
               jsr   putscxy
               jsr   pop
               rts
               .bend


js_x           .byte 0              ; J1 Variable coordonnée X actuelle.
js_y           .byte 0              ; J1 Variable coordonnée Y actuelle.
js_oldx        .byte $ff            ; J1 Variable ancienne coordonnée X.
js_oldy        .byte $ff            ; J1 Variable ancienne coordonnée Y.
;------------------------------------------------------------------------------
; js1_pixx et js1_pixy serviront de coordonnées pour positionner un éventuel
; ... sprite qui pourras représenter une souris.
;------------------------------------------------------------------------------
js1_pixx       .word 0              ; J1 Coord. X en pixel.
js1_pixy       .byte 0              ; J1 Coord. Y en pixel.
;------------------------------------------------------------------------------
; js1_x et js1_y permette de savoir quel position de caractère correspond
; ... à la coordonnée Pixel X,Y du curseur joystick.
;------------------------------------------------------------------------------
js1_x          .byte 0              ; J1 Coord. X en position caractère.
js1_y          .byte 0              ; J1 Coord. Y en position caractère.
js1_fire       .byte 0              ; J1 Compteur du boouton Feu.
js1_flag       .byte 0              ; J1 Drapeau du bouton Feu.
js1_clickx     .word 0              ; J1 Coord. X où le bouton feu est pesé.
js1_clicky     .byte 0              ; J1 Coord. Y où le bouton feu est pesé.
js1_events     .byte 0              ; J1 Évenement.

js2_pixx       .word 0              ; J2 Coord. X en pixel.
js2_pixy       .byte 0              ; J2 Coord. Y en pixel.
js2_x          .byte 0              ; J2 Coord. X en position caractère.
js2_y          .byte 0              ; J2 Coord. Y en position caractère.
js2_fire       .byte 0              ; J2 Compteur du boouton Feu.
js2_flag       .byte 0              ; J2 Drapeau du bouton Feu.
js2_clickx     .word 0              ; J2 Coord. X où le bouton feu est pesé.
js2_clicky     .byte 0              ; J2 Coord. Y où le bouton feu est pesé.
js2_events     .byte 0              ; J2 Évenement.

js_txtcol      =     vcyan
js_txtbak      =     bkcol0
js1_val8       .byte js_txtcol,js_txtbak,4,5
                     ;      111111111122222222223333
                     ;456789012345678901234567890123
               .text "Port 1 (x,y):($00,$00) Fire:(0)"
               .byte 0
                     ;      111111111122
                     ;456789012345678901
js1_val16      .byte js_txtcol,js_txtbak,11,7
               .text "(x,y):($0000,$0000)"
               .byte 0
                     ;      111111111122222222223333
                     ;456789012345678901234567890123
js2_val8       .byte js_txtcol,js_txtbak,4,10
               .text "CarPos (x,y):($00,$00) Fire:(0)"
               .byte 0
js2_val16a     .byte vblanc,js_txtbak,4,12
               .text "Click pos."
               .byte 0
js2_val16      .byte js_txtcol,js_txtbak,16,12
               .text "(x,y):($0000,$0000)"
               .byte 0

js1_status     .byte 0
js2_status     .byte 0

               