;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
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

