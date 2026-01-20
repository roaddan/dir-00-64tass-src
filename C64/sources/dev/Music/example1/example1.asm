;--- Example code fragment, start ---

        !to "tiny.o", cbm   ; set output file and format
        * = $c000       ; set program counter

    CLEAR = 147     ; a global symbol definition
!addr   basout = $ffd2      ; another one, marked as an address

        ; a string output loop:
        ldx #0
        beq +           ; enter loop

-           jsr basout  ; output character
            inx     ; advance pointer
+           lda .string, x  ; get character
            bne -       ; check whether last
        rts
.string     !pet "Dumb example", 13, 0

;--- Example code fragment, end ---
