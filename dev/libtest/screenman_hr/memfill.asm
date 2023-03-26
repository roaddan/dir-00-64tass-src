;---------------------------------------
blkfill
         .block
         jmp blkfill0
     zp1      .word $00
         ra       .byte $00
         blkfill0 php
         sta ra
         pha
         tya
         pha
         lda zpage1
         sta zp1+1
         lda zpage1+1
         sta zp1+1
         sty zpage1+1
         ldy #$00
         sty zpage1
         lda ra
     blkfill1 sta (zpage1),y
         iny
         bne blkfill1
         lda zp1+1
         sta zpage1+1
         lda zp1
         sta zpage1
         pla
         tay
         pla
         plp
         rts
         .bend
;---------------------------------------
memfill
         .block
         jmp memfill0
         ra       .byte $00
         rx       .byte $00
         memfill0 php
         stx rx
         memfill1 jsr blkfill
         iny
         dex
         bne memfill1
         ldx rx
         plp
         rts
         .bend
