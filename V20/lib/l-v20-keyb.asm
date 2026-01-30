;--------------------------------------
; Fichier......: l-keyb.asm (seq)
; Type fichier.: code pour T.M.P.
; Auteur.......: daniel lafrance, 
; version......: 0.0.1 
; revision.....: 20151119 
;--------------------------------------
;--------------------------------------
; Vide le tampon du clavier
clrkbbuf
;--------------------------------------
          .block
          php
          pha
          lda #0
          sta 198
          jsr $ffe1
          pla
          plp
          rts
          .bend
;--------------------------------------
waitstop
;--------------------------------------
          .block
          php    ;\ sauve les flags
          pha    ;/  et l'acc.
          jsr clrkbbuf
wait      jsr stop ; Veri [run/stop]
          bne wait ;loop pas pesee.
          pla    ;\ recup. acc et 
          plp    ;/  les flags.
          rts
          .bend
;--------------------------------------
; attend qu'une touche du clavier soit 
; appuyee/relachee.
anykey
;--------------------------------------
          .block
          php         
          pha        
          jsr clrkbbuf
wait      lda 203    ;lit la matrice de 
          cmp #64    ; 64 = aucune clef
          beq wait   ; on en attend une.
          jsr kbfree ; Clavier relache.
          jsr clrkbbuf
          pla         
          plp
          rts
          .bend
;--------------------------------------
; attend que les touches du clavier 
; soient relachees.
kbfree
;--------------------------------------
        .block
        php 
        pha
wait    lda 203    ; lit la matrice 
        cmp #64    ; 64 = aucune clef
        bne wait   ; attend la relache
        pla
        plp
        rts
        .bend
;--------------------------------------
; retourne une clef appuyee dans acc.
getkey
;--------------------------------------
        .block
        php
        jsr $ffe1
try     jsr getin  ;tente de lire 
        cmp #0     ; 0 si aucune.
        beq try    ; on reessaye
        plp
        rts
        .bend
;--------------------------------------
; attend une cle en particulier donnee 
; dans acc..
waitkey
;--------------------------------------
        .block
        php  
        pha 
        sta clef   ;Sauve clef voulue          
        jsr clrkbbuf
wait    jsr getin  ;Sonde le clavier 
        cmp clef   ;Compare avec clef
        bne wait   ;Pas la bonne. 
        pla 
        plp
        rts
        .bend
;--------------------------------------
; attend que la touche dans acc soit 
; appuyee.
waitspace
;--------------------------------------
          .block
          lda #$20
          jsr waitkey
          jsr clrkbbuf
          rts
          .bend
;--------------------------------------
showkey 
        .block
        jsr pushregs
        sec
        jsr plot
        stx curx
        sty cury
        #locate 0,22
        jsr chrout
        jsr showra
        clc
        ldy cury
        ldx curx
        jsr plot
        jsr popregs
        rts
        .bend
;--------------------------------------
