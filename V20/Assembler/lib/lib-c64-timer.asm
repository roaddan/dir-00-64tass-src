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

