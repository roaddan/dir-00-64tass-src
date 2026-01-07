;---------------------------------------
; nom fichier..: l-bitmap.asm (seq)
; type fichier.: source pour t.m.p.
; auteur.......: daniel lafrance
; version......: 20151207
; revision.....: 0.0.1
;---------------------------------------
bmapinit
         .block
         php
         pha
         lda vic+$18
         ora #$08
         sta vic+$18
         lda vic+$11
         ora #$20
         sta vic+$11
         pla
         plp
         rts
         .bend
;---------------------------------------
bmapclr
         .block
         jsr pushall
         lda #<vidstart
         sta zp1
         lda #>vidstart
         sta zp1+1
         ldy #$00
more     lda #$00
         sta (zp1),y
         jsr inczp1
         lda zp1+1
         cmp #$3f
         bne more
         lda zp1
         cmp #$3f
         bne more
         jsr popall
         rts
         .bend
;---------------------------------------
bmpfillbk
         .block
         jsr pushall
         lda #<bakmem
         sta zp1
         lda #>bakmem
         sta zp1+1
         ldx #$08
         ldy #$00
         lda #$01
more     sta (zp1),y
         jsr inczp1
         cpx zp1+1
         bne more
         jsr popall
         rts
         .bend
;---------------------------------------
