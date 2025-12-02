;---------------------------------------
; nom du fichier .:
; scripteur ......: daniel lafrance, 
;                   quebec, canada.
; cerniere m.à j. : 
; inspiration ....: 
;---------------------------------------
;---------------------------------------
waitstop
;---------------------------------------
            .block
            php   ;\ sauve les flags
            pha   ;/  et l'acc.
            jsr clrkbbuf
wait        jsr k_stop;cherche la clef
                      ; [run/stop].
            bne  wait ;loop pas pesee.
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
wait        lda 203 ;lit la matrice de 
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
            php     ; recup. les flags.
            rts
            .bend
;---------------------------------------
clrkbbuf
;---------------------------------------
            .block
            php     ;\ sauve les flags 
            pha     ;/  et l'acc.
            lda #0  ;\ efface le tampon 
            sta 198 ;/  du clavier.
            pla     ;\ recup. l'acc et 
            plp     ;/  les flags.
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
            jsr chrout ; l'affiche.
            pla      ;\ recup. l'acc et 
            plp      ;/  les flags.
            rts
            .bend
;---------------------------------------
; attend la touche espace appuyee.
waitspace
;---------------------------------------
            .block
            php     ;\ sauve les flags 
            pha     ;/  et l'acc.
            lda #0  ;\ efface le tampon 
            sta 198 ;/  du clavier.
nospace     lda #203; lit la matrice. 
            cmp #60 ;60 = espace pesee 
            bne nospace    
            pla     ;\ recup. l'acc et 
            plp     ;/  les flags.
            .bend

;---------------------------------------
waitreturn
;---------------------------------------
            .block
            php     ;\ sauve les flags 
            pha     ;/  et l'acc.
            lda #0  ;\ efface le tampon 
            sta 198 ;/  du clavier.
wait        lda #203; lit la matrice
            cmp #1  ; 1  = [return]. 
            php     ; sauve les flags 
                    ; pour comparaison
            lda #0  ;\ efface le tampon 
            sta 198 ;/  du clavier.
            plp     ;recup. les flags 
                    ; pour comparaison
            bne wait   
            pla     ;\ recup. l'acc et 
            plp     ;/  les flags.
            .bend
;---------------------------------------
clef        .byte   0
thecount    .byte   $01
;---------------------------------------
