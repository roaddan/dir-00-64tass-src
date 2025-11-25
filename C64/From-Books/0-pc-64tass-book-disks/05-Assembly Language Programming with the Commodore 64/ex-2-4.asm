;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 2-4
; Turning screen lowercase.
;------------------------------
*=$c000 ; 49152
vic =   $D000
start   lda #$17
        sta vic+$18
        rts
        
        
 