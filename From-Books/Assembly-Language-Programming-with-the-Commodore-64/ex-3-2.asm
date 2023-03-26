;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 3-2
; Using the Y register for txfr
;------------------------------
*=$c000 ; 49152
start   ldy #$06
stop    sty $d020
        rts
        
        