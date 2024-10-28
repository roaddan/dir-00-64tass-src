; getin key values
arrowleft      =    $5f
ctrl_al        =    $06
escape         =    $5f
ctrl_escape    =    $06
pound          =    $a9
home           =    $13
clear          =    $93
uparrow        =    $5e
pisign         =    $de
runstop        =    $03
cursd          =    $11
cursu          =    $91
cursr          =    $1d
cursl          =    $9d
key_f1         =    $85
key_f3         =    $86
key_f5         =    $87
key_f7         =    $88
key_f2         =    $89
key_f4         =    $8a
key_f6         =    $8b
key_f8         =    $8c
enter          =    $0d
comd_enter     =    $8d
key_a          =    $41
key_b          =    $42
key_c          =    $43
key_d          =    $44
key_e          =    $45
key_f          =    $46
key_g          =    $47
key_h          =    $48
key_i          =    $49
key_j          =    $4a
key_k          =    $4b
key_l          =    $4c
key_m          =    $4d
key_n          =    $4e
key_o          =    $4f
key_p          =    $50
key_q          =    $51
key_r          =    $52
key_s          =    $53
key_t          =    $54
key_u          =    $55
key_v          =    $56
key_w          =    $57
key_x          =    $58
key_y          =    $59
key_z          =    $5a
shift_a        =    $c1
shift_b        =    $c2
shift_c        =    $c3
shift_d        =    $c4
shift_e        =    $c5
shift_f        =    $c6
shift_g        =    $c7
shift_h        =    $c8
shift_i        =    $c9
shift_j        =    $ca
shift_k        =    $cb
shift_l        =    $cc
shift_m        =    $cd
shift_n        =    $ce
shift_o        =    $cf
shift_p        =    $d0
shift_q        =    $d1
shift_r        =    $d2
shift_s        =    $d3
shift_t        =    $d4
shift_u        =    $d5
shift_v        =    $d6
shift_w        =    $d7
shift_x        =    $d8
shift_y        =    $d9
shift_z        =    $da
ctrl_a         =    $01
ctrl_b         =    $02
ctrl_c         =    $03
ctrl_d         =    $04
ctrl_e         =    $05
ctrl_f         =    $06
ctrl_g         =    $07
ctrl_h         =    $08
ctrl_i         =    $09
ctrl_j         =    $0a
ctrl_k         =    $0b
ctrl_l         =    $0c
ctrl_m         =    $0d
key_enter      =    $0d
ctrl_n         =    $0e
ctrl_o         =    $0f
ctrl_p         =    $10
ctrl_q         =    $11
ctrl_r         =    $12
ctrl_s         =    $13
ctrl_t         =    $14
ctrl_u         =    $15
ctrl_v         =    $16
ctrl_w         =    $17
ctrl_x         =    $18
ctrl_y         =    $19
ctrl_z         =    $1a
comd_a         =    $b0    
comd_b         =    $bf    
comd_c         =    $bc    
comd_d         =    $ac    
comd_e         =    $b1    
comd_f         =    $bb    
comd_g         =    $a5    
comd_h         =    $b4    
comd_i         =    $a2    
comd_j         =    $b5    
comd_k         =    $a1    
comd_l         =    $b6    
comd_m         =    $a7    
comd_n         =    $aa    
comd_o         =    $b9    
comd_p         =    $af    
comd_q         =    $ab    
comd_r         =    $b2    
comd_s         =    $ae    
comd_t         =    $a3    
comd_u         =    $b8    
comd_v         =    $be    
comd_w         =    $b3    
comd_x         =    $bd    
comd_y         =    $b7    
comd_z         =    $ad    

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
again          jsr  getin
               cmp  #0
               beq  again
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

