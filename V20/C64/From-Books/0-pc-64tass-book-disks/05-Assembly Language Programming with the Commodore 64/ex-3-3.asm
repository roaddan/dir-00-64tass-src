;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 3-3
; Using Y zpage adressing mode
;------------------------------
*=$c000 ; 49152
color   =   $02
scrmem  =   $07e7
colmem  =   $dbe7
start   ldy color
        lda #$51
        sta scrmem
        sty colmem
        rts
        
        