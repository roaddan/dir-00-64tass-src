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
