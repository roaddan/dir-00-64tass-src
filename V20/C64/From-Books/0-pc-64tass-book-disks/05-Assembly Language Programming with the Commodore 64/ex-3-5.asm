;--------------------------------
; Assembly Language Programming ;
;    with the commodore 64      ;
;      Marvin L. De Jong        ;
;-------------------------------;
; Example 3-5                   ;
; Initializing SID Registers.   ;
;-------------------------------;
sid     =   $d400
*=$c000 ; 49152
initlz  jsr rstsid
        lda #$0f
stop    sta sid+$18
        lda #$19
        sta sid+$01
        lda #$ee
        sta sid+$05
        lda #$a0
        sta sid+$06
        lda #$21
        sta sid+$04
        rts
        ;(192*256)+29
rstsid  lda #$00        
        tay
nxtsid  sta sid,y
        iny
        cpy #$19
        bne nxtsid
        rts