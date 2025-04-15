;-------------------------------------------------------------------------------
; Disable screen view to accelerate access.
;-------------------------------------------------------------------------------
screendis      .block
               php
               pha
               lda  $d011
               and  #%11101111
               sta  $d011
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
; Enable screen view.
;-------------------------------------------------------------------------------
screenena      .block
               php
               pha
               lda  $d011
               ora  #%00010000
               sta  $d011
               pla
               plp
               rts
               .bend

;*******************************************************************************
; Corriger les fonctions graphiques pour utiliser une autre page mémoire
;*******************************************************************************
bmpram = 8192
;-------------------------------------------------------------------------------
; Set VICII in high resolution Graphic mode. (BMP) 320x200
;-------------------------------------------------------------------------------
victohighres   .block
               php
               pha
               lda  vicmiscfnc
               ora  #%00100000     ; 32
               sta  vicmiscfnc
               lda  vicmemptr
               ora  #%00001000     ; $08
               sta  vicmemptr
               ; Cetting Basic top of ram at $1fff; 8191
               lda  #$ff           ; 255
               sta  $0037
               lda  #$1f           ; 31
               sta  $0038  
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
; Set VICII in normal character mode.
;-------------------------------------------------------------------------------
victonormal   .block
               php
               pha
               lda  vicmiscfnc
               and  #%11011111     ; 233
               sta  vicmiscfnc
               lda  vicmemptr
               and  #%11110111     ; $08
               sta  vicmemptr
               ; Setting Basic top of ram at $a000; 40960
               lda  #$00
               sta  $0037
               lda  #$a0
               sta  $0038
               jsr  cls
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
; Set VICII in normal character mode.
;-------------------------------------------------------------------------------
vicbmpclear    .block
               jsr  push
               lda  #cmauve
               jsr  setvicbmpbkcol
               lda  #<8192              ; Place le LSB de 8192 ...
               sta  zpage1              ; ... dans le lsb de zpage1.
               lda  #>8192              ; Place le MSB de 8192 ...
               sta  zpage1+1            ; ... dans le Msb de zpage1.
               setloop $0000+(8191)
               ldy  #$00
next           lda  #$00           
               sta  (zpage1),y
               jsr  inczpage1
               jsr  loop
               bne  next
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
; Set VICII bitmap backgroundcolor.
;-------------------------------------------------------------------------------
setvicbmpbkcol .block
               jsr  push
               and  #$0f
               sta  vicbmpbkcol
               ldy  #<1024              ; Place le LSB de 8192 ...
               sty  zpage1              ; ... dans le lsb de zpage1.
               ldy  #>1024              ; Place le MSB de 8192 ...
               sty  zpage1+1            ; ... dans le Msb de zpage1.
               setloop $0000+(1024)
               ldy  #$00  
next           lda  (zpage1),y
               and  #$f0
               ora  vicbmpbkcol
               sta  (zpage1),y
               jsr  inczpage1
               jsr  loop
               bne  next
               jsr  pop
               rts
vicbmpbkcol    .byte     $00
               .bend

;-------------------------------------------------------------------------------
; Calcul des coordonnées pour écrire im point sur l'écran em bitmap.
; Y contien la ligne (0-199), AX contient la colonne (0-299)
;-------------------------------------------------------------------------------
bmphrcalccoords  .block
               jsr  push
               clc       ; On met Carry à 0
               ror       ; le bit 0 de a dans carry  ?/2
               txa       ; x dans a
               lsr       ; ?/4
               lsr       ; ?/8 a = (ax)/8
               sta  bmphrcol
               tya       ; Y dans a
               lsr       ; ?/2
               lsr       ; ?/4
               lsr       ; ?/8 a=Y/8
               sta  bmphrrow
               pha
               tya
               jsr  pop
               rts
               .bend

bmphrrow       .byte     $00
bmphrcol       .byte     $00
bmphrmask      .byte     $00



















