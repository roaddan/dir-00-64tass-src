;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 3-1
; Using the X register for txfr
;------------------------------
*=$c000 ; 49152
start   ldx #$07
stop    stx $d021
        rts
        
        