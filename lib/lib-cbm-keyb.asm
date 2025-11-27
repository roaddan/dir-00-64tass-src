;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
waitstop    .block
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
            lda #0      ;\ Efface le tampon 
            sta 198     ;/  du clavier.
wait        jsr k_stop  ; Cherche la clef [RUN/STOP].
            bne  wait   ;  Elle n'est pas pesée.
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            rts
            .bend

;--------------------------------------------------------------------------------
anykey      .block      ; Attend qu'une touche du clavier soit appuyée/relachée.
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
;            lda #0      ;\ Efface le tampon 
;            sta 198     ;/  du clavier.
nokey       lda 203     ; Lit la matrice de la clef actuelle dans le tampon.     
            cmp #64     ; Si 64 alors aucune clef n'est appuyée.
            beq nokey   ; On attend qu'il y en aie une.
            jsr kbfree  ; On attend que le clavier soit relâché.
;            lda #0      ;\ Efface le tampon 
;            sta 198     ;/  du clavier.
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            rts
            .bend

;--------------------------------------------------------------------------------
kbfree      .block      ; Attend que les touches du clavier soient relâchées.
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
iskey       lda 203     ; Lit la matrice de la clef actuelle dans le tampon.
            cmp #64     ; Si 64 alors aucune clef n'est appuyée.
            bne iskey   ; On attend qu'il y en aie aucune.
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            rts
            .bend

;--------------------------------------------------------------------------------
getkey      .block      ; Retourne une clef appuyée dans Acc.
;--------------------------------------------------------------------------------
            php         ; Sauvegarde les drapeaux.
gkagain     jsr getin   ; Tente de lire une clef.
            cmp #0      ; 0 si aucune.
            beq gkagain ; Aucune, alors on attend.
            php         ; Récupère les drapeaux.
            rts
            .bend

;--------------------------------------------------------------------------------
kbflushbuff .block      
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
            lda #0      ;\ Efface le tampon 
            sta 198     ;/  du clavier.
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            rts
            .bend

;--------------------------------------------------------------------------------
waitkey     .block      ; Attend une clé en particulier donnée dans Acc..
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
            sta thekey  ; Sauvegarde la clef attendue.          
            lda #0      ;\ Efface le tampon 
            sta 198     ;/  du clavier.
nogood      jsr getin   ; Tente de lire une clef. 
            ; jsr chrout  ; L'affiche.
            cmp thekey  ; La compare avec celle attendue.
            bne nogood  ; Boucle si ce l'est pas la bonne. 
            jsr chrout  ; L'affiche quand elle est bonne.
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            rts
            .bend

;--------------------------------------------------------------------------------
waitspace   .block      ; Attend que la touche espace soit appuyée.
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
            lda #0      ;\ Efface le tampon 
            sta 198     ;/  du clavier.
nospace     jsr showregs
            lda #203    ; Lit la matrice du clavier. 
            cmp #60     ; 60 dans la matrice = barre d'espace appuyée. 
            bne nospace    
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            .bend

;--------------------------------------------------------------------------------
waitreturn  .block
;--------------------------------------------------------------------------------
            php         ;\ Sauvegarde les drapeaux 
            pha         ;/  et l'accumulateur.
            lda #0      ;\ Efface le tampon 
            sta 198     ;/  du clavier.
noreturn    lda #203    ; Lit la matrice du clavier. 
            cmp #1      ; 1 dans la matrice = [RETURN] appuyé. 
            php         ; Sauvegarde les drapeaux pour la comparaison.
            lda #0      ;\ Efface le tampon 
            sta 198     ;/  du clavier.
            plp         ; Récupère les drapeaux pour la comparaison.
            bne noreturn   
            pla         ;\ Récupère l'accmulateur et 
            plp         ;/  les drapeaux.
            .bend

thekey      .byte   0
thecount    .byte   $01

; ascii to rom position convertion table
;                     $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
;                     ------------------------------------------------------------------
;        ctrl-          A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
asciitorom  .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d,$00,$00  ;$00
;            ctrl-      P   Q   R   S   T   U   V   W   X   Y   Z    
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$10
;                      _   !   ""  #   $   %   &   '   (   )   *   +   ,   -   .   /
            .byte     $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f  ;$20
;                      0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
            .byte     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f  ;$30
;                      @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O    
            .byte     $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f  ;$40
;                      P   Q   R   S   T   U   V   W   X   Y   Z   [       ]
            .byte     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f  ;$50
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$60
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$70
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$80
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$90
            .byte     $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f  ;$a0
            .byte     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f  ;$b0
            .byte     $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f  ;$c0
            .byte     $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f  ;$d0
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$e0
            .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$f0
