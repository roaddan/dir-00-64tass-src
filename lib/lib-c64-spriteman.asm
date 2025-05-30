;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
sprt_init       .block
               jsr  pushall
               ldy  sprt_ptr6+1
               ldx  sprt_ptr6
;              jsr  sprt_setimage
               lda  sprt_ptr
               jsr  sprt_loadptr
               jsr  savezp1
               jsr  savezp2
;---------------POKE VIC+$15,4  53269 Sprite enable 76543210
               lda  vic+$15 ; enable sprite 2
               ora  #%00000100
               sta  vic+$15
;---------------POKE 2042,13
               lda  #$0d
               sta  $7fa
;---------------Source ZP2 
               lda  sprt_ptr0
               sta  zpage1
               lda  sprt_ptr0+1
               sta  zpage1+1
;---------------Destination ZP2 832 ou $340
               lda  #$40
               sta  zpage2
               lda  #$03
               sta  zpage2+1
               ldy  #65
               lda  (zpage1),y      ; sprite y offset
               sta  sprt_yoffset
               dey
               lda  (zpage1),y      ; sprite x offset
               sta  sprt_xoffset
               dey
               lda  (zpage1),y      ; sprite color
               sta  $d029
               dey
               ldy  #62     
nextbyte       lda  (zpage1),y
               sta  (zpage2),y
               dey
               bne  nextbyte
;               ldy  #$07
;nexty          tya
;               sta  $d026,y   ; 53287 Sprite 0 color
;               dey
;               bne  nexty
;               sta  $d028   ; 53288 Sprite 1 color
;               lda  #sprt_color
;               sta  $d029   ; 53289 Sprite 2 color
;               sta  $d02a   ; 53290 Sprite 3 color
;               sta  $d02b   ; 53291 Sprite 4 color
;               sta  $d02c   ; 53292 Sprite 5 color
;               sta  $d02d   ; 53293 Sprite 6 color
;               sta  $d02e   ; 53294 Sprite 7 color
               jsr  restzp1
               jsr  restzp2
               jsr  popall
               rts
               .bend
sprt_ptr       .byte   $01 
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_calcpos    .block
               jsr  pushreg
               lda  #0
               sta  sprt_x+1
               sta  sprt_y+1
               lda  js_2pixx+1
               clc
               rol
               rol
               sta  sprt_x+1
               lda  js_2pixx
               clc
               adc  sprt_xoffset
               sta  sprt_x
               bcc  norepx
               lda  sprt_x+1
               ora  #$04
               sta  sprt_x+1
norepx         lda  js_2pixy
               clc
               adc  sprt_yoffset
               sta  sprt_y
               jsr  popreg
               rts
               .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_move       .block
               jsr  pushreg
               jsr  sprt_calcpos
               lda  sprt_x
               sta  vic+$04
               lda  sprt_x+1
               sta  vic+$10
               lda  sprt_y
               sta  vic+$05
               jsr  sprt_showpos
               jsr  popreg
               rts
               .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_showpos    .block
               jsr  push
;---------------la valeur 16 bits de js_sprite
               lda  sprt_x
               jsr  atohex
               lda  a2hexstr 
               sta  sprite_pos+26
               lda  a2hexstr+1 
               sta  sprite_pos+27

               lda  sprt_x+1
               jsr  atohex
               lda  a2hexstr 
               sta  sprite_pos+24
               lda  a2hexstr+1 
               sta  sprite_pos+25
               
               lda  sprt_y
               jsr  atohex
               lda  a2hexstr 
               sta  sprite_pos+32
               lda  a2hexstr+1 
               sta  sprite_pos+33
               
               lda  #0
               jsr  atohex
               lda  a2hexstr 
               sta  sprite_pos+30
               lda  a2hexstr+1 
               sta  sprite_pos+31
               
               ldx  #<sprite_pos
               ldy  #>sprite_pos
               jsr  putscxy
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_loadptr2   .block               
               jsr  push               
               tax
               stx  sprt_ptr
               lda  sprt_ptr0+1
               sta  calcbuff+1
               lda  sprt_ptr0
               sta  calcbuff
               cpx  #0
               beq  addrok
               lda  calcbuff
nextx          clc
               adc  #66
               bcc  nocarry
               inc  calcbuff+1
nocarry        sta  calcbuff
               dex
               bne  nextx
addrok         ldy  calcbuff+1            
               ldx  calcbuff          
               jsr  sprt_setimage
               jsr  pop
               rts
calcbuff        .word   $0
               .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_loadptr    .block               
               jsr  push               
               lda  sprt_ptr
               clc
               rol
               tay
               lda  sprt_ptr0,y
               tax
               lda  sprt_ptr0+1,y
               tay
               jsr  sprt_setimage
               jsr  pop
               rts
calcbuff        .word   $0
               .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_setimage   .block
               jsr  push
               jsr  savezp1
               jsr  savezp2
               sty  zpage1+1
               stx  zpage1
               ldy  #>sprt_image
               sty  zpage2+1
               ldy  #<sprt_image
               sty  zpage2
               ldy  #66
nextbyte       lda  (zpage1),y
               sta  (zpage2),y
               dey
               bne  nextbyte
               jsr  restzp2
               jsr  restzp1
               jsr  pop
               rts
               .bend
sprt_xoffset   .byte     $00               
sprt_yoffset   .byte     $00               
sprt_x         .word     $0000
sprt_y         .word     $0000     
;0     
sprt_image      .fill    66
;1
sprt_crxair    .byte     $00, $00, $00, $00, $00, $00 ; 6
               .byte     $00, $66, $00, $00, $3c, $00 ; 12
               .byte     $00, $18, $00, $00, $00, $00 ; 18
               .byte     $00, $00, $00, $00, $18, $00 ; 24
               .byte     $80, $00, $01, $c0, $18, $03 ; 30
               .byte     $66, $66, $66, $c0, $18, $03 ; 36
               .byte     $80, $00, $01, $00, $18, $00 ; 42
               .byte     $00, $00, $00, $00, $00, $00 ; 48
               .byte     $00, $18, $00, $00, $3c, $00 ; 54
               .byte     $00, $66, $00, $00, $00, $00 ; 60
               .byte     $00, $00, $00, $01, $0c, $28 ; 66, 
; Dans chacun des bloc les 3 drniers octets sont coleur, xoffset et yoffset.
;2               
sprt_mouse     .byte     $80, $00, $00, $e0, $00, $00 ; 6
               .byte     $b8, $00, $00, $ce, $00, $00 ; 12
               .byte     $83, $80, $00, $c0, $e0, $00 ; 18
               .byte     $80, $18, $00, $c0, $3c, $00 ; 24
               .byte     $80, $e0, $00, $c0, $60, $00 ; 30
               .byte     $98, $30, $00, $fc, $18, $00 ; 36
               .byte     $c6, $0c, $00, $03, $06, $00 ; 42
               .byte     $01, $9c, $00, $00, $f0, $00 ; 48
               .byte     $00, $40, $00, $00, $00, $00 ; 54
               .byte     $00, $00, $00, $00, $00, $00 ; 60
               .byte     $00, $00, $00, $01, $18, $31 ; 66
;3               
sprt_pointer   .byte     $00, $7c, $00, $01, $83, $00 ; 6
               .byte     $06, $10, $c0, $08, $00, $30 ; 12
               .byte     $12, $10, $88, $20, $00, $08 ; 18
               .byte     $40, $ba, $04, $40, $6c, $04 ; 24
               .byte     $80, $c6, $02, $aa, $82, $aa ; 30
               .byte     $80, $c6, $02, $40, $6c, $04 ; 36
               .byte     $40, $ba, $04, $20, $00, $08 ; 42
               .byte     $12, $10, $90, $08, $00, $20 ; 48
               .byte     $06, $10, $c0, $01, $83, $00 ; 54
               .byte     $00, $7c, $00, $00, $00, $00 ; 60
               .byte     $00, $00, $00, $01, $0c, $28 ; 66
;4               
sprt_pointer2  .byte     $55, $55, $55, $aa, $aa, $aa ; 6
               .byte     $55, $55, $55, $aa, $aa, $aa ; 12
               .byte     $55, $55, $55, $aa, $aa, $aa ; 18
               .byte     $54, $00, $55, $aa, $00, $2a ; 24
               .byte     $54, $00, $55, $aa, $00, $2a ; 30
               .byte     $54, $00, $55, $aa, $00, $2a ; 36
               .byte     $54, $00, $55, $aa, $00, $2a ; 42
               .byte     $54, $00, $55, $aa, $aa, $aa ; 48
               .byte     $55, $55, $55, $aa, $aa, $aa ; 54
               .byte     $55, $55, $55, $aa, $aa, $aa ; 60
               .byte     $55, $55, $55, $01, $0c, $28 ; 66
;5               
sprt_hand      .byte     $06, $00, $00, $0f, $00, $00 ; 6
               .byte     $19, $80, $00, $10, $80, $00 ; 12
               .byte     $19, $80, $00, $16, $b1, $8c ; 18
               .byte     $10, $ca, $52, $10, $84, $21 ; 24
               .byte     $10, $84, $21, $30, $84, $21 ; 30
               .byte     $50, $84, $21, $90, $84, $21 ; 36
               .byte     $90, $00, $01, $90, $00, $01 ; 42
               .byte     $90, $7f, $c1, $90, $00, $01 ; 48
               .byte     $40, $ff, $e2, $40, $00, $02 ; 54
               .byte     $3c, $00, $04, $02, $00, $08 ; 60
               .byte     $03, $ff, $f8, $01, $12, $31 ; 66
;6               
sprt_ultraman  .byte     $00, $3e, $00, $01, $c1, $c0 ; 6
               .byte     $0e, $3e, $30, $08, $41, $08 ; 12
               .byte     $10, $1c, $04, $10, $22, $04 ; 18
               .byte     $24, $1c, $12, $23, $00, $62 ; 24
               .byte     $20, $08, $02, $47, $c1, $f1 ; 30
               .byte     $6a, $aa, $ab, $47, $c9, $f1 ; 36
               .byte     $20, $08, $02, $20, $14, $02 ; 42
               .byte     $20, $00, $02, $10, $00, $04 ; 48
               .byte     $10, $7f, $04, $08, $00, $08 ; 54
               .byte     $06, $3e, $30, $01, $c1, $c0 ; 60
               .byte     $00, $3e, $00, $01, $0c, $28 ; 66
;7               
sprt_male      .byte     $00, $1c, $00, $00, $3e, $00 ; 6
               .byte     $00, $3e, $00, $00, $3e, $00 ; 12
               .byte     $00, $1c, $00, $00, $08, $00 ; 18
               .byte     $00, $ff, $80, $00, $ff, $80 ; 24
               .byte     $00, $be, $80, $00, $9c, $80 ; 30
               .byte     $00, $88, $80, $00, $be, $80 ; 36
               .byte     $00, $be, $80, $01, $9c, $c0 ; 42
               .byte     $01, $94, $c0, $00, $14, $00 ; 48
               .byte     $00, $14, $00, $00, $14, $00 ; 54
               .byte     $00, $36, $00, $00, $77, $00 ; 60
               .byte     $00, $77 ,$00, $01, $0c, $2f ; 66               
;8               
sprt_robot     .byte     $00, $3c, $00, $00, $24, $00 ; 6
               .byte     $00, $66, $18, $00, $66, $38 ; 12
               .byte     $00, $24, $38, $00, $3c, $10 ; 18
               .byte     $00, $18, $10, $00, $18, $10 ; 24
               .byte     $0f, $ff, $f0, $08, $7e, $00 ; 30
               .byte     $08, $7e, $00, $08, $18, $00 ; 36
               .byte     $1c, $18, $00, $1c, $18, $00 ; 42
               .byte     $18, $3c, $00, $00, $3c, $00 ; 48
               .byte     $00, $24, $00, $00, $24, $00 ; 54
               .byte     $00, $24, $00, $03, $e7, $c0 ; 60
               .byte     $03, $e7, $c0, $01, $0c, $28 ; 66               
;9               
sprt_femme     .byte     $00, $1c, $00, $00, $3e, $00 ; 6
               .byte     $00, $3e, $00, $00, $3e, $00 ; 12
               .byte     $00, $1c, $00, $00, $08, $00 ; 18
               .byte     $00, $7f, $00, $00, $ff, $80 ; 24
               .byte     $00, $be, $80, $00, $9c, $80 ; 30
               .byte     $00, $88, $80, $00, $9c, $80 ; 36
               .byte     $00, $be, $80, $01, $be, $c0 ; 42
               .byte     $01, $be, $c0, $00, $7f, $00 ; 48
               .byte     $00, $7f, $00, $00, $ff, $80 ; 54
               .byte     $00, $36, $00, $00, $77, $00 ; 60
               .byte     $00, $55 ,$00, $01, $0c, $2f ; 66
               
sprt_ptr0      .word     sprt_image + (0*66)                   
sprt_ptr1      .word     sprt_image + (1*66)                   
sprt_ptr2      .word     sprt_image + (2*66)                   
sprt_ptr3      .word     sprt_image + (3*66)                   
sprt_ptr4      .word     sprt_image + (4*66)                   
sprt_ptr5      .word     sprt_image + (5*66)                   
sprt_ptr6      .word     sprt_image + (6*66)                      
sprt_ptr7      .word     sprt_image + (7*66)                      
sprt_ptr8      .word     sprt_image + (8*66)                      
sprt_ptr9      .word     sprt_image + (9*66)                      
testbyte       .byte     255                      
sprt_txtcol    =         vjaune         
sprt_txtbak    =         bkcol0        
sprt_color     =         vwhite               
sprite_pos     .byte     sprt_txtcol,sprt_txtbak,4,14
;                    ;0000000000111111111122222222223333333333                       
;                    ;0123456789012345678901234567890123456789                              
               .null     "Sprite pos. (x,y):($0000,$0000)"
