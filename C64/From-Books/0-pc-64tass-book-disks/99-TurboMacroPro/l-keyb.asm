;---------------------------------------
; nom du fichier .:
; scripteur ......: daniel lafrance, 
;                   quebec, canada.
; cerniere m.à j. : 
; inspiration ....: 
;---------------------------------------
;---------------------------------------
; Vide le tampon du clavier
clrkbbuf
;---------------------------------------
            .block
            php
            pha
            lda #0
            sta 198
            pla
            plp
            rts
            .bend
;---------------------------------------
waitstop
;---------------------------------------
          .block
          php    ;\ sauve les flags
          pha    ;/  et l'acc.
          jsr clrkbbuf
wait      jsr stop    ; Veri [run/stop]
          bne  wait   ;loop pas pesee.
          pla    ;\ recup. acc et 
          plp    ;/  les flags.
          rts
          .bend
;---------------------------------------
; attend qu'une touche du clavier soit 
; appuyee/relachee.
anykey
;---------------------------------------
        .block
        php     ;\ sauve les flags 
        pha     ;/  et l'acc.
        jsr clrkbbuf
wait    lda 203 ;lit la matrice de 
                ; la clef actuelle 
                ; dans le tampon.    
        cmp #64 ; si 64 alors aucune
                ; clef appuyee.
        beq wait; on attend qu'il y 
                ; en aie une.
        jsr kbfree ; on attend que 
                   ;le clavier soit 
                   ;relache.
        jsr clrkbbuf
        pla     ;\ recup. l'acc et 
        plp     ;/  les flags.
        rts
        .bend
;---------------------------------------
; attend que les touches du clavier 
; soient relachees.
kbfree
;---------------------------------------
            .block
            php     ;\ sauve les flags 
            pha     ;/  et l'acc.
wait        lda 203 ;lit la matrice de 
                    ; la clef actuelle 
                    ; dans le tampon.
            cmp #64 ; si 64 alors aucune
                    ; clef n'est pesee.
            bne wait;on attend qu'il y 
                    ; en aie aucune.
            pla     ;\ recup. l'acc et 
            plp     ;/  les flags.
            rts
            .bend
;---------------------------------------
; retourne une clef appuyee dans acc.
getkey
;---------------------------------------
            .block
            php     ; sauve les flags.
try         jsr getin ;tente de lire 
                      ; une clef.
            cmp #0  ; 0 si aucune.
            beq try ; aucune, on attend.
            plp     ; recup. les flags.
            rts
            .bend
;---------------------------------------
; attend une cle en particulier donnee 
; dans acc..
waitkey
;---------------------------------------
            .block
            php      ;\ sauve les flags 
            pha      ;/  et l'acc.
            sta clef ; sauve cle voulue.          
            jsr clrkbbuf
wait        jsr getin; tente lire clef. 
            ;jsr chrout  ; l'affiche.
            cmp clef ;compare avec clef
            bne wait ;pas la bonne. 
            ;jsr chrout ; l'affiche.
            pla      ;\ recup. l'acc et 
            plp      ;/  les flags.
            rts
            .bend
;---------------------------------------
; attend que la touche  dans acc soit 
; appuyee.
waitspace
;---------------------------------------
            .block
            lda #$20
            jsr waitkey
            jsr clrkbbuf
            rts
            .bend
;---------------------------------------
clef        .byte   0
;---------------------------------------
