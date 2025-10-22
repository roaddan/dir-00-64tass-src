;-----------------------------------------------------------------------------
; delai
;-----------------------------------------------------------------------------
delai       .block
            php
            pha
            txa
            pha
            tya
            pha
            ldx #$40
 delaix     ldy #$ff
 delaiy     nop
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
            pla
            tax
            pla
            plp
            rts           
            .bend
