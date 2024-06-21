;---------------------------------------
mmove
         .block
         mmove0   php
         pla
         sta flags
         pla        ;pc+1
         sta retour
         pla        ;pc
         sta retour+1
         pla        ;dst+1
         sta dst+1
         pla        ;dst
         sta dst
         pla        ;src+1
         sta src+1
         pla        ;src
         sta src
         pla        ;count
         jsr bputch

         lda retour+1
         pha
         lda retour
         pha
         lda flags
         pha
         plp
         rts
         flags    .byte $00
     retour   .word $00
     src      .word $00
     dst      .word $00
     zp1      .word $00
     zp2      .word $00
     count    .word $00

         .bend
         