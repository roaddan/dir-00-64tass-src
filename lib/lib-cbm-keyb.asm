;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------





waitstop       .block
               jsr  push
wait           jsr  k_stop
               bne  wait
               jsr  pop
               rts
               .bend

anykey         .block
               php
               pha
nokey          lda 203
               cmp #64
               beq nokey
               jsr releasekey
               pla
               plp
               rts
               .bend

releasekey     .block
               php
               pha 
keypressed     lda 203
               cmp #64
               bne keypressed
               pla
               plp
               rts
               .bend


getkey         .block
gkagain        jsr  getin
               cmp  #0
               beq  gkagain
               rts
               .bend

kbflushbuff    .block
               php
               pha
again          jsr  getin
               cmp  #0
               bne  again
               pla
               plp
               rts
               .bend


waitkey        .block
               jsr  push
               sta  thekey                
nope           jsr  getin
               jsr  chrout
               cmp  thekey
               bne  nope
               jsr  chrout
               jsr  pop
               rts
               .bend

waitspace      .block
               jsr  push
wait           lda  #$7f  ;%01111111 
               sta  $dc00 
               lda  $dc01 
               and  #$10  ;mask %00010000 
               bne  wait
               jsr  pop
               .bend

waitsstop      .block
               jsr  push
wait           jsr  k_stop  ;%01111111 
               bne  wait
               jsr  pop
               .bend

waitreturn     .block
               jsr  push
               lda  thecount
               sta  scrnram
               lda  #$02     
               sta  colorram
nope           jsr  getin
;               cmp  #0
;               beq  nohex
;               ;jsr  chrout
;               ;jsr  putahex
nohex          cmp  #$0d
               bne  nope
               inc  thecount
               jsr  pop
               rts
               .bend
thekey         .byte   0
thecount       .byte   $01

; ascii to rom position convertion table
;                        $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
;                        ------------------------------------------------------------------
;              ctrl-          A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
asciitorom     .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0d,$00,$00  ;$00
;              ctrl-      P   Q   R   S   T   U   V   W   X   Y   Z    
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$10
;                         _   !   ""  #   $   %   &   '   (   )   *   +   ,   -   .   /
               .byte     $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f  ;$20
;                         0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
               .byte     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f  ;$30
;                         @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O    
               .byte     $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f  ;$40
;                         P   Q   R   S   T   U   V   W   X   Y   Z   [       ]
               .byte     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f  ;$50
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$60
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$70
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$80
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$90
               .byte     $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f  ;$a0
               .byte     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f  ;$b0
               .byte     $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f  ;$c0
               .byte     $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f  ;$d0
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$e0
               .byte     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ;$f0
