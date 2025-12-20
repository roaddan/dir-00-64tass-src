;---------------------------------------
; fichier......: l-math.asm (seq)
; type fichier.: equates
; auteur.......: Daniel Lafrance
; version......: 0.0.2
; revision.....: 20151210
;---------------------------------------
;$(yyxx) = pointeur sur le mot
;acc     = valeur a ajouter.
;rep     = $yyxx
addatoyx 
        .block
        php
        pha
        sty reponse+1
        stx reponse
        clc
        adc reponse
        bcc norep
        inc reponse+1
norep   sta reponse
        ldy reponse+1
        ldx reponse
        pla
        plp
        rts
        .bend
;---------------------------------------
;$(yyxx) = pointeur sur le mot
;acc     = valeur a soustraire.
;rep     = $yyxx
subatoyx 
        .block
        php
        pha
        sty reponse+1
        stx reponse
        sec
        sbc reponse
        bcs noemp
        dec reponse+1
noemp   sta reponse
        ldy reponse+1
        ldx reponse
        pla
        plp
        rts
        .bend
;---------------------------------------
; rol reponse sur 16 bits
; nombre de rol dans a
rolword
        .block
        jsr pushregs
        tay
again   clc
        rol reponse
        rol reponse+1
        dey
        bne again
        jsr popregs
        rts
        .bend
;---------------------------------------
