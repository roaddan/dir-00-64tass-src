;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: l-c64-sid.asm
; Type fichier....: Librairie 
; Creation........: 20251208 
; Version.........: 0.1.0
; Révisions.......: 20261118-000000 Francisation des commentaires,
;------------------------------------------------------------------------------;-----------------------------------------------------------------------------
; Joue un BEEP sur le SID.
;-----------------------------------------------------------------------------
;                  reg,valeur
sid_v1offset     =  0
sid_v2offset     =  7
sid_v3offset     =  14
vic_son        .byte sid_v1offset + 24,  15        ; sid+24=54296,  15 Volume.
               .byte sid_v1offset +  5,  190       ; sid+ 5=54277, 190 A.D.S = 0.
               .byte sid_v1offset +  6,  248       ; sid+ 6=54278, 248 S=Max, r=15
               .byte sid_v1offset +  1,  $10       ; 
               .byte sid_v1offset +  0,  $c4       ; 
               .byte sid_v1offset +  4,  %00010001 ; sid+ 4=54276,  17 V1S = Triangle.
               .byte $ff,  $ff
                   
vic_son2       .byte sid_v2offset + 4,   15        ; sid+24=54296,  15 Volume.
               .byte sid_v2offset + 5,  190        ; sid+ 5=54277, 190 A.D.S = 0.
               .byte sid_v2offset + 6,  248        ; sid+ 6=54278, 248 S=Max, r=15
               .byte sid_v2offset + 1,  $15        ; sid+ 1=54273,  20 Frequence = 40 * 256
               .byte sid_v2offset + 0,  $20        ; sid+ 1=54273,  20 Frequence = 40 * 256
               .byte sid_v2offset + 4,  %00100001  ; sid+ 4=54276,  17 V1S = Triangle.
               .byte $ff,  $ff
               
vic_son3       .byte sid_v3offset + 4,   15        ; sid+24=54296,  15   Volume.
               .byte sid_v3offset + 5,  190        ; sid+ 5=54277, 190   A.D.S = 0.
               .byte sid_v3offset + 6,  248        ; sid+ 6=54278, 248   S=Max, r=15
               .byte sid_v3offset + 1,  $19        ; sid+ 1=54273,  20   Frequence = 40 * 256
               .byte sid_v3offset + 0,  $1f        ; sid+ 1=54273,  20   Frequence = 40 * 256
               .byte sid_v3offset + 4,  %01000001  ; sid+ 4=54276,  17   V1S = Triangle.
               .byte   $ff,  $ff

; Place une note dans le 
sid_note       .macro voix,freq
               php
               pha
               .if \voix=2 
                     lda   #<\freq
                     sta   sid+7
                     lda   #>\freq
                     sta   sid+8
               .elif \voix=3
                     lda   #<\freq
                     sta   sid+14
                     lda   #>\freq
                     sta   sid+15
               .else
                     lda   #<\freq
                     sta   sid+0
                     lda   #>\freq
                     sta   sid+1
               .endif               
               pla
               plp
               .endm

sid_prog       .macro xyimm
               jsr push
               ldx #<\xyimm
               ldy #>\xyimm
               jsr sid_progdata
               jsr pop
               .endm

sid_progtest   .block
               jsr push
               ldx #<vic_son
               ldy #>vic_son
               jsr sid_progdata
               jsr pop
               rts                  ; Môman, c'est fini.
               .bend

;-----------------------------------------------------------------------------
; Programme et configure le sid en fonction de données en mémoire.
; Les données se termines par un couple de $FF.
; x (LSB) et Y(MSB) contiennet l'adresse du début des couples de données.
;-----------------------------------------------------------------------------
sid_progdata   .block
               jsr   pushall        ; Sauvegarde tous les registres et zp.
               stx   $fb            ; Place X sur le LSB de ZP1.
               sty   $fc            ; Place Y sur le MSB de ZP1.
               lda   #$00           ; Place 0 dans
               tax                  ; ... X et 
               tay                  ; ... Y.
               ; On programme le SID pour le son.
sid_progcmd    lda   ($fb),y        ; On charge le couple de données 
               tax                  ; ... Le no du registre dans X
               iny                  ; ... et puis 
               lda   ($fb),y        ; ... la donnée dans A. 
               iny                  ; On se prépare pour le prochain couple.
               cpx   #$ff           ; Sommes nous à la fin des données?
               beq   sid_progout    ; Oui on sort.
               sta   sid,x          ; Non, on ecrit la donnée dans le registre.
               jmp   sid_progcmd    ; On retourne voir le prochain couple.
sid_progout    jsr   popall         ; Récupère zp et tous les registres.
               rts                  ; Môman, c'est fini.
               .bend

;-----------------------------------------------------------------------------
; clearsid : Remet à 0 tous les registres du SID.
;-----------------------------------------------------------------------------
sid_clear      .block
               jsr   push           ; Sauvegarde les registres.
               lda   #$00           ; Charge 0 dans A.
               ldy   #$1c           ; Le sit occupe 28 registres. (0 à 1c)
sidclrreg      sta   sid,y          ; On les met à O de $1c à %00.
               dey                  ; on décrémente l'offset.
               bpl   sidclrreg      ; si Y > 0, on continue.
               jsr   pop            ; Récupère les registres.
               rts                  ; Môman, c'est fini.
               .bend

;-----------------------------------------------------------------------------
; Inhibe l'oscillateur de la voix 1.
;-----------------------------------------------------------------------------
sid_v1off      .block               
               php                  ; Sauvegarde le status et 
               pha                  ; ... accumulateur
               lda   #%00010000     ; Bit3 = 1, inhibe l'oscillateur.
               sta   sidregctl1     ; Place dans le registre de contrôle.
               pla                  ; Récupère l'accumulateur et
               plp                  ; ... le status.
               rts                  ; Môman, c'est fini.
               .bend

;-----------------------------------------------------------------------------
; Inhibe l'oscillateur de la voix 2.
;-----------------------------------------------------------------------------
sid_v2off      .block
               php                  ; Sauvegarde le status et 
               pha                  ; ... accumulateur
               lda   #%00010000     ; Bit3 = 1, inhibe l'oscillateur.
               sta   sidregctl2     ; Place dans le registre de contrôle.
               pla                  ; Récupère l'accumulateur et
               plp                  ; ... le status.
               rts                  ; Môman, c'est fini.
               .bend

;-----------------------------------------------------------------------------
; Inhibe l'oscillateur de la voix 3.
;-----------------------------------------------------------------------------
sid_v3off      .block
               php                  ; Sauvegarde le status et 
               pha                  ; ... accumulateur
               lda   #%00010000     ; Bit3 = 1, inhibe l'oscillateur.
               sta   sidregctl3     ; Place dans le registre de contrôle.
               pla                  ; Récupère l'accumulateur et
               plp                  ; ... le status.
               rts                  ; Môman, c'est fini.
               .bend

sid_alloff      .block
               php                  ; Sauvegarde le status et 
               pha                  ; ... accumulateur
               lda   #%00010000     ; Bit3 = 1, inhibe l'oscillateur.
               sta   sidregctl1     ; Place dans le registre de contrôle.
               lda   #%00010000     ; Bit3 = 1, inhibe l'oscillateur.
               sta   sidregctl2     ; Place dans le registre de contrôle.
               lda   #%00010000     ; Bit3 = 1, inhibe l'oscillateur.
               sta   sidregctl3     ; Place dans le registre de contrôle.
               pla                  ; Récupère l'accumulateur et
               plp                  ; ... le status.
               rts                  ; Môman, c'est fini.
               .bend  

sid_tada       .block
               #sid_prog vic_son    ; On programme le SID.
               #sid_note 1,re4      ; On joue un ré (D) 4ième octave
               jsr ti_dcroche       ; ... pendant le temps d'une demi croche.
               #sid_note 1,mi4      ; On joue un mi (E) 4ième octave
               jsr ti_dcroche       ; ... pendant le temps d'une demi croche.
               #sid_note 1,fa4      ; On joue un fa (F) 4ième octave
               jsr ti_dcroche       ; ... pendant le temps d'une demi croche.
               #sid_note 1,sol4      ; On joue un sol (G) 4ième octave
               jsr ti_dcroche       ; ... pendant le temps d'une demi croche.
               #sid_note 1,la4      ; On joue un la (A) 4ième octave
               jsr ti_dcroche       ; ... pendant le temps d'une demi croche.
               #sid_note 1,si4      ; On joue un si (B) 4ième octave
               jsr ti_dcroche       ; ... pendant le temps d'une demi croche.
               #sid_note 1,do5      ; On joue un do (C) 4ième octave
               #sid_prog vic_son2   ; On programme les autres 
               #sid_prog vic_son3   ; ... voix.
               jsr ti_noirepnt      ; On maintien pendant une noire.
               jsr sid_alloff       ; On les éteint tous.
               rts                  ; Môman, c'est fini.
               .bend

sid_guitar     .block
               #sid_prog vic_son2
               jsr ti_croche
               #sid_note 2,mi3
               jsr ti_croche
               #sid_note 2,la3
               jsr ti_croche
               #sid_note 2,re4
               jsr ti_croche
               #sid_note 2,sol4
               jsr ti_croche
               #sid_note 2,si4
               jsr ti_croche
               #sid_note 2,mi5
               jsr ti_noirepnt
               jsr sid_alloff
               rts                  ; Môman, c'est fini.
               .bend

sid_guitar2     .block
               #sid_prog vic_son3
               jsr ti_dcroche
               #sid_note 3,mi3
               jsr ti_dcroche
               #sid_note 3,la3
               jsr ti_dcroche
               #sid_note 3,re4
               jsr ti_dcroche
               #sid_note 3,sol4
               jsr ti_dcroche
               #sid_note 3,si4
               jsr ti_dcroche
               #sid_note 3,mi5
               jsr ti_noirepnt
               jsr sid_alloff
               rts                  ; Môman, c'est fini.
               .bend

sid_lib_vector .word   sid_v1off,sid_v2off,sid_v3off

ti_dcroche     .block
               php
               pha
               txa
               pha
               ldx #$10
               jsr delai
               pla
               tax
               pla
               plp
               rts                  ; Môman, c'est fini.
               .bend

ti_croche      .block
               jsr ti_dcroche
               jsr ti_dcroche
               rts                  ; Môman, c'est fini.
               .bend

ti_noire       .block
               jsr ti_croche
               jsr ti_croche
               rts                  ; Môman, c'est fini.
               .bend

ti_noirepnt    .block
               jsr ti_croche
               jsr ti_croche
               jsr ti_croche
               rts                  ; Môman, c'est fini.
               .bend


ti_blanche     .block
               jsr ti_noire
               jsr ti_noire
               rts                  ; Môman, c'est fini.
               .bend

ti_blanchepnt  .block
               jsr ti_noire
               jsr ti_noire
               jsr ti_noire
               rts                  ; Môman, c'est fini.
               .bend

ti_ronde       .block
               jsr ti_blanche
               jsr ti_blanche
               rts                  ; Môman, c'est fini.
               .bend


ti_vector      .byte   $20, <ti_dcroche,>ti_dcroche
               .byte   $20, <ti_croche,>ti_croche
               .byte   $20, <ti_noire,>ti_noire
               .byte   $20, <ti_blanche,>ti_blanche
               .byte   $20, <ti_ronde,>ti_ronde
               jsr ti_vector
