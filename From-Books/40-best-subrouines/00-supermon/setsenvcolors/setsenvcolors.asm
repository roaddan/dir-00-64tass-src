; sets env colors
screen  =       53281
border  =       53280
texte   =       646
setcolors       php
                pha   
                lda     #$0
                sta     screen
                sta     border
                lda     #$07
                sta     texte
                lda     #147
                jsr     $ffd2
                lda     #19
                jsr     $ffd2
                pla
                plp
                rts
                