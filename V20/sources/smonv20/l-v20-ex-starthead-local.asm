;--------------------------------------
; nom fichier..: l-bashead-v20exm.asm
; type fichier.: code pour t.m.p.
; auteur.......: daniel lafrance
; version......: 0.0.1
; revision.....: 20261011
;--------------------------------------
; entete pour demarrage basic 2 c64
;--------------------------------------
         *= basstart+1
bcmd1    .word $120c ;adresse de la pro-
                     ; chaine commande.
         .word $0a   ;no. ligne basic.
                     ; 10 dans ce cas.
         .byte $9e   ;jeton pour la
                     ; commande sys.
                     ;Adresse du debut
                     ; du programme en
                     ; decimal/ascii.
         .text format("%5d", 40960)
         .byte $00   ;fin de cmd basic.
bcmd2    .word $00   ;adresse de la pro-
                     ; chaine commande.
                     ; $00 si aucune.
;--------------------------------------
;pour faciliter la creation de progrm
; la premiere action est de sauter vers
; une routine nommee "main".
;cette methode permet d'utiliser le meme
; entete pour tous les programme.
;la routine "main" doit se terminer par
; un "rts" pour assurer un retour
; adequat a basic.
;--------------------------------------
bhstart   jsr bhscrini
basnold   jmp 40960
          rts
;--------------------------------------
bhscrini
        .block
        php
        pha
        lda #(128+4)
        sta vic0
bord    lda $900f    ;place la couleur
        and #%00001000
        ora #%00010101    
        sta $900f   
text    lda #$00    ;place la couleur
        sta $0286   ; du texte.
        lda #$93    ;efface l'ecran par
        jsr $ffd2   ; chrout du kernal.
        pla
        plp
        rts
        .bend
