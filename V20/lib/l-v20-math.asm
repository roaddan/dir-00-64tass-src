;--------------------------------------
; fichier......: l-math.asm (seq)
; type fichier.: equates
; auteur.......: Daniel Lafrance
; version......: 0.0.2
; revision.....: 20151210
;--------------------------------------
;$(yyxx) = pointeur sur le mot
;acc     = valeur a ajouter.
;rep     = $yyxx
addtoword
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
;--------------------------------------
;$(yyxx) = pointeur sur le mot
;acc     = valeur a soustraire.
;rep     = $yyxx
subtoword
subatoyx 
        .block
        php
        pha
        sta freevar
        sty reponse+1
        stx reponse
        sec
        lda reponse
        sbc freevar
        sta reponse
        lda reponse+1
        sbc #$00
        sta reponse+1
        ldy reponse+1
        ldx reponse
        pla
        plp
        rts
        .bend
;---------------------------------------
