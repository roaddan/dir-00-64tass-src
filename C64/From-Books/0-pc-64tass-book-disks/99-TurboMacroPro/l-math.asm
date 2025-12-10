;---------------------------------------
;$(yyxx) = pointeur sur le mot
;acc     = valeur a ajouter.
;rep     = $yyxx
addatoyx .block
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
reponse .word $00       
        .bend