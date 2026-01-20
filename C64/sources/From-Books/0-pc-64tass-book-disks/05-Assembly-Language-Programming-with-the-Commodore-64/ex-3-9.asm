;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 3-9
; Print ball in color.
;------------------------------
*=$c000 ; 49152
color   =   $02
colmem  =   $dbe7
scrmem  =   $07e7
start   ldy color   ; Fetch color ball
        lda #$51    ; $51 is the screen code for a ball
        sta scrmem  ; Store code uin screen memory
        sty colmem  ; set ball color in memory
        rts