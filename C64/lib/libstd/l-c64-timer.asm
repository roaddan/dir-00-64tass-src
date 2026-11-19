;-----------------------------------------------------------------------------
; delai
;-----------------------------------------------------------------------------
delai          .block
               jsr   push
               tax
delaix         ldy   #$ff
delaiy         nop                  
               nop
               nop
               nop
               nop
               nop
               dey
               bne   delaiy
               dex
               bne   delaix
               jsr   pop
               rts           
               .bend

