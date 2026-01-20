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
colmem  =   $dbe7-40
scrmem  =   $07e7-40
start   ldy #40
more    lda #$51        ; $51 is the screen code for a ball
        sta scrmem,y    ; Store code uin screen memory
        lda color       ; Fetch color ball
        sta colmem,y    ; set ball color in memory
        dey
        bne more
        rts