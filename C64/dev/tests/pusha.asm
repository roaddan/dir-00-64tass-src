pusha   php
        stx     pusha_x
        ldx     sptr
        sta     stack,x
        dec     sptr
        ldx     pusha_x
        plp
        rts
        
pulla   php
        stx     pusha_x
        inc     sptr
        ldx     sptr
        lda     stack,x
        ldx     pusha_x
        plp
        rts
pusha_x .byte   0

