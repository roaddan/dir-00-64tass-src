;-----------------------------------------------------------------------------
; delai
;-----------------------------------------------------------------------------
delai       .block
            tya
            pha
 delaix     ldy #$ff
 delaiy     nop
            nop
            nop
            nop
            nop
            nop
            dey
            bne delaiy
            dex
            bne delaix
            pla
            tay
            rts           
            .bend

ti_croche   .block
            php
            pha
            txa
            pha
            ldx #$20
            jsr delai
            pla
            tax
            pla
            plp
            rts
            .bend

ti_noire    .block
            jsr ti_croche
            jsr ti_croche
            rts
            .bend

ti_blanche  .block
            jsr ti_noire
            jsr ti_noire
            rts
            .bend

ti_ronde    .block
            jsr ti_blanche
            jsr ti_blanche
            rts
            .bend
