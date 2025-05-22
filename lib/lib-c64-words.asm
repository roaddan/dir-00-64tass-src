;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; add2word
; adresse   = XXYY X=MSB, Y=LSB
; valeur    = A
;----------------------------------------
add2word    .block 
            jsr push 
            sty zpage1+1
            stx zpage1
            
            jsr pop
            rts
            .bend 
    
add2word2   .block
            jsr push
            sty adddo+1     ; LSB
            sty adddo2+1    ; LSB
            sty addrep+1    ; LSB
            stx adddo+2     ; MSB
            stx adddo2+2    ; MSB
            stx addrep+2    ; MSB
            pha             ; Sauve  
            clc
            lda #$01
            adc addrep+1    ; LSB+1
            sta addrep+1
            bcc addsamepage 
            inc addrep+2    ; MSB+1
addsamepage ;brk
            pla
            clc
adddo       adc $ffff
adddo2      sta $ffff
            bcc addnorep
addrep      inc $ffff
addnorep    jsr pop
            rts
            .bend
;----------------------------------------
; sub2word
; adresse   = XXYY X=MSB, Y=LSB
; valeur    = A
;----------------------------------------
sub2word2    .block
            jsr push
            sty subdo+1     ; LSB
            sty subdo2+1    ; LSB
            sty subrep+1    ; LSB
            sty subrep2+1   ; LSB
            stx subdo+2     ; MSB
            stx subdo2+2    ; MSB
            stx subrep+2    ; MSB
            stx subrep2+2   ; MSB
            sta subdo+4     ; Sauve  
            clc
            lda #$01
            adc subrep+1    ; LSB+1
            sta subrep+1
            sta subrep2+1
            bcc subsamepage
            inc subrep+2    ; MSB+1
            lda subrep+2
            sta subrep2+2
subsamepage brk
            pla
            sec
subdo       lda $ffff       ; LSB-1
            sbc #$ff
subdo2      sta $ffff
            bcc subnorep
subrep      lda $ffff
            sbc #$00        ; MSB-1
subrep2     sta $ffff
subnorep    ldx memcount+1
            ldy memcount
            brk
            jsr pop
            rts
            .bend
            