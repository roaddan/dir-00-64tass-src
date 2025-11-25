;--------------------------------
; Assembly Language Programming ;
;    with the commodore 64      ;
;      Marvin L. De Jong        ;
;-------------------------------;
; Example 3-4                   ;
; Using A register in ZP mode   ;
;-------------------------------;
port    =   $01
*=$c000
origin  lda #$01
stop    sta port
        rts
        
        