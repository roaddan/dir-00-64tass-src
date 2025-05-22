;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Copie le contenu de chargen à l'adresse spécifiée par $xxyy.
;---------------------------------------------------------------------
charram        .word     $0000
chargen2ram    .block
               jsr  setcharram
               jsr  cpchar2ram
               rts
               .bend
;---------------------------------------------------------------------
; recoit un numéro de caractère et l'adresse $XXYY de sa définition.
;---------------------------------------------------------------------
loadchar       .block
               jmp  push
               pha
               txa
               sta  zpage1+1
               tya
               sta  zpage1
               lda  charram
               sta  zpage2
               lda  charram+1
               sta  zpage2+1
               lda  #$0
               sta  charadd+1
               ldx  #3
               pla
               sta  charadd
nextrol        lda  charadd
               clc
               asl
               sta  charadd  
               lda  charadd+1
               rol
               sta  charadd+1  
               dex
               bne  nextrol
               lda  charram
               sta  addr1
               lda  charram
               sta  addr1+1
               ldy  charadd
               ldy  charadd+1
               jsr  xy2addr
               lda  addr2
               sta  charadd
               lda  addr2+1
               sta  charadd+1

               jmp  pop
               rts
charadd   .word $0000
               .bend               
setcharram     .block
               jsr  push
               sty  charram
               stx  charram+1     
               jsr  pop
               rts
               .bend
               
cpchar2ram     .block
               jsr  push
               lda  cia1+14   ; peek (56334)
               and  #254      ; and 254
               sta  cia1+14   ; poke 56334 
               lda  memmapreg ; peek (1)
               and  #251      ; and %11111011
               sta  memmapreg ; poke 1
               lda  #<chargen ; LSB de chargen
               sta  zpage1    ;
               lda  #>chargen ; MSB de chargen
               sta  zpage1+1  ;
               lda  charram   ; $YYXX Contiennent
               sta  zpage2    ; l'adresse 
               lda  charram+1 ; de destination
               sta  zpage2+1  ; MSB->Y, LDB->X
               ldx  #$08      ; 1 caractère = 8 bytes
nextpage       ldy  #$00      ; 256 caractères
nextbyte       lda  (zpage1),y
               ;eor  #%01111111 ; Pour ajouter sfx au char
               sta  (zpage2),y
               iny
               bne  nextbyte
               inc  zpage1+1
               inc  zpage2+1
               dex  
               bne  nextpage
               lda  memmapreg ; peek (1)
               ora  #4        ; and %00000100
               sta  memmapreg ; poke 1
               lda  cia1+14   ; peek 56334
               ora  #1        ; or 1
               sta  cia1+14   ; poke 56334
               jsr  pop
               rts
               .bend                