;--------------------------------
; Assembly Language Programming ;
;    with the commodore 64      ;
;      Marvin L. De Jong        ;
;-------------------------------;
; Example 3-6                   ;
; Initializing Sprite Data.     ;
;-------------------------------;
vic     =   $d000
addr    =   $0340

*=$c000 ; 49152  
main    jsr drwsprt   
        jsr initlz
        rts
        
initlz  lda #$0d    ; Sprite to #0 memory pointer
stop    sta $07f8
        lda #$01    ; Turn on Sptite #0 on VIC.
        sta vic+$15
        lda #$07    ; Select a Yellow Background.
        sta vic+$21
        lda #$06    ; Select Blue for the sprite.
        sta vic+$27
        sta vic+$20 ; Select Blue border color.
        ldx #$80    ; $80=128 for X coordinate
        stx vic+$00 ;  of sprite #0
        ldy #$80    ; $80=128 for Y coordinate
        sty vic+$01 ;  of sprite #0
        rts

drwsprt lda #$aa
        ldy #$00
more    sta addr,y
        eor #$f0
        iny
        cpy #$64
        bne more
        rts