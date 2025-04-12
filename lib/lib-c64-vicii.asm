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
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
; Set VICII in normal character mode.
;-------------------------------------------------------------------------------
vicbmpclear    .block
               jsr  push
               jsr  cls                 ; Efface la mémoire caractères qui est 
                                        ; devenu la mémoire couleur. 
               lda  #<8192              ; Place le LSB de 8192 ...
               sta  zpage1              ; ... dans le lsb de zpage1.
               lda  #>8192              ; Place le MSB de 8192 ...
               sta  zpage1+1            ; ... dans le Msb de zpage1.
               setloop $0000+(8191)
               ldy  #$00
next           lda  #$01           
               sta  (zpage1),y
               jsr  inczpage1
               jsr  loop
               bne  next
               jsr  pop
               rts
               .bend