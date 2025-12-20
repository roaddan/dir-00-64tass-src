;---------------------------------------
; fichier......: memdump.asm (seq)
; type fichier.: code pour T.M.P.
; auteur.......: Daniel Lafrance
; version......: 0.0.1
; revision.....: 20151220
;---------------------------------------
;--------------------------------------- 
; Affiche le contenue memoire a la 
; maniere de supermon par ligne 8
; octets.
; $yyxx contiennent l'adresse de depart
; acc. contien le nombre de ligne a 
; afficher.      
memdump 
        .block
        jsr pushregs
        sta nligne ;sauve ligne
        sta loops  ;init boucle
        #styxptr dumpadr
        lda dumpadr+1
        pha
        lda dumpadr
        pha
again   #ldyxptr dumpadr
        lda #$08
        #outcar $0d
        jsr bytestohex
        jsr yxtoptr
        jsr incptr8
        jsr ptrtoyx
        #styxptr dumpadr       
        dec loops
        bne again
        pla
        sta dumpadr
        pla
        sta dumpadr+1
        jsr popregs
        rts
nligne  .byte $16
        .bend
dumpadr .word $f000
;---------------------------------------
putahexdec
        .block
        jsr pushregs
        #outcar kjaune
        jsr putahex
        #outcar $20
        #outcar kcyan
        tax
        lda #$00
        jsr fiaxtf1
        jsr popregs
        rts
        .bend
;---------------------------------------
