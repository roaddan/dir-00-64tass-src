;-----------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-Basic2.asm
; Type fichier....: Variables
; Creation........: 20151208 
; Version.........: 0.0.1
; Révision........:
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Variables publiques.
;-------------------------------------------------------------------------------
bmnum0         .word $0000
bmnum1         .word $0000
bmnum2         .word $0000
bmovfl         .byte $00

;-------------------------------------------------------------------------------
; Ajout de l'accumulateur à une case mémoire 16 bits.
;-------------------------------------------------------------------------------
bmaddacc       .block
               php                  ; Sauvegarde minimaliste 
               pha                  ; ... des registres.
               lda   #$00           ; On place 0 dans 
               sta   bmovfl         ; ... la variable de débordement.
               pla                  ; On récupère Acc
               pha                  ; Pour pouvoir sortir sans altération.
               clc                  ; Report à 0.
               adc   bmnum0         ; Ajoute Acc à LSB du nombre 16 bit. 
               sta   bmnum0         ; ... et l'enregistre.
               bcc   norep          ; Si carry est vide, pas de report à faire.
               inc   bmnum0+1       ; On fait le report.
norep          bcc   norep2         ; Si carry est vide, pas de débordement. 
               inc   bmovfl         ; On augmente l'octet de débordement de 1.     
norep          pla                  ; Récupération minimaliste
               plp                  ; ... des registres.
               rts
               .bend


bmtester       .block
               jsr  pushreg
               lda  #1
               jsr  bmaddacc
               ldy  bmnum0
               ldx  bmnum0+1
               lda  bmovfl
               jsr  showregs
               jsr  popreg  
               rts
               .bend

;-------------------------------------------------------------------------------
; add2word
; adresse   = XXYY X=MSB, Y=LSB
; valeur    = A
;-------------------------------------------------------------------------------
add2word       .block 
               jsr  pushall
               sty  zpage1+1
               stx  zpage1
               jsr  popall
               rts
               .bend 
    
add2word2      .block
               jsr  pushreg
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
addsamepage    ;brk
               pla
               clc
adddo          adc $ffff
adddo2         sta $ffff
               bcc addnorep
addrep         inc $ffff
addnorep       jsr pop
               rts
               .bend


;----------------------------------------
; sub2word
; adresse   = XXYY X=MSB, Y=LSB
; valeur    = A
;----------------------------------------
sub2word2      .block
               jsr pushreg
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
subsamepage    brk
               pla
               sec
subdo          lda $ffff       ; LSB-1
               sbc #$ff
subdo2         sta $ffff
               bcc subnorep
subrep         lda $ffff
               sbc #$00        ; MSB-1
subrep2        sta $ffff
subnorep       ldx memcount+1
               ldy memcount
               jsr popreg
               rts
memcount       .word $00
            .bend
