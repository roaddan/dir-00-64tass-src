;-------------------------------------------------------------------------------
; version : 20231105-22550021
;-------------------------------------------------------------------------------
               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .include "localmacro.asm"

               .enc     none
main           .block
               jsr  push
               jsr  screendis
               jsr  scrmaninit

               jsr  setscreenptr
;              jsr  copycharset
               jsr  staticscreen
               jsr  screenena

               #affichemesg edit_msg       
               lda  #$00
               sta  fkeyset
               jsr  showfkeys
               jsr  pop
               jsr  keyaction
               jsr  cls
               #affichemesg bye_msg       
               #locate 0,0
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
scrnnewram     =  $0400
setscreenptr   .block
               jsr  push

               ; BASIC -> print chr$(8)
               lda  #$08      ; basic commande to disable ...
               jsr  chrout    ; ... character set change.
               
               ; BASIC -> poke 56578,peek(56578) or 3
               lda  cia2ddra  ;$dd02, 56578 cia2 data direction A
               ora  #$00000011
               sta  cia2ddra  ;$dd02, 56578 cia2 data direction A
               
               ; BASIC -> poke 56576, (peek(56576)and252) or 0
               lda  cia2pra   ;$dd00, 56576 cia2 dataport A
               and  #%11111100
               ora  #%00000000
               sta  cia2pra   ;$dd00, 56576 cia2 dataport A
               
               ; BASIC -> poke 53272, (peek(53272) and 240) or 2
               lda  vicmemptr ;$d018, 53272               
               ; vicmemptr
               ;  +-------+-------+-------+-------+-------+-------+-------+-------+
               ;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
               ;  +-------+-------+-------+-------+-------+-------+-------+-------+
               ;  |  txt  |  txt  |  txt  |  txt  | chars | chars | chars |       | 
               ;  |  scr  |  scr  |  scr  |  scr  |  def  |  def  |  def  |   X   |
               ;  | bit 3 | bit 2 | bit 1 | bit 0 | bit 2 | bit 1 | bit 0 |       |
               ;  +-------+-------+-------+-------+-------+-------+-------+-------+
               and  #%11110000
               ora  #%00000010
               sta  vicmemptr; $d018, 53272

               ; BASIC -> poke 648, 196               
               lda  #%11000100     ;196
               sta  $0288 ;648 - top page of screen memory

               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
copycharset    .block
               jsr  push

               ; BASIC -> poke 56334, peek(56334) and 254
               lda  cia1cra        ;$dc0e, 56334 cia1 control register A
               and  #%11111110     ;254
               sta  cia1cra        ;$dc0e, 56334 cia1 control register A

               ; BASIC -> poke 1, peek(1) and 251
               lda  u6510map       ;$01
               and  #%11111011     ;251
               sta  u6510map       ;$01

               ; ici on copy le character-map
               jsr  memcopy

               ; BASIC -> poke 1, peek(1) or 4
               lda  u6510map       ;$01
               ora  #%00000100
               sta  u6510map       ;$01

               ; BASIC -> poke 56334, peek(56334) or 1
               lda  cia1cra        ;$dc0e, 56334 cia1 control register A
               ora  #%00000001     ;254
               sta  cia1cra        ;$dc0e, 56334 cia1 control register A

               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
memcopy        .block
               jsr  push
               
onemore        lda  startaddr
               sta  zpage1
               lda  startaddr+1
               sta  zpage1+1
               lda  destaddr
               sta  zpage2
               lda  destaddr+1
               sta  zpage2+1
               ldy  #$00
               lda  (zpage1),y
               sta  (zpage2),y
               jsr  inczp1
               jsr  inczp2

               lda  zpage1+1
               cmp  stopaddr+1
               bne  onemore

               lda  zpage1
               cmp  stopaddr
               bne  onemore

               jsr  pop
               rts
               .bend
startaddr      .word     53248
destaddr       .word     53248-2048
stopaddr       .word     55296
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
keyaction      .block
               jsr  push
loop           jsr  getkey
               #locate 0,20
               jsr  putch
               #locate 0,21
               pha
               pha
               lda  #'$'
               jsr  putch
               pla
               tax
               lda  asciitorom,x
               jsr  putahex
               #print txt1
               #locate 0,22
               lda  #'$'
               jsr  putch
               pla
               ;and  #$7f
               jsr  putahex
               #print txt2
               cmp  #key_f1
               beq  f1
               cmp  #key_f2
               beq  f2
               cmp  #key_f3
               beq  f3
               cmp  #key_f4
               beq  f4
               cmp  #key_f5
               beq  f5
               cmp  #key_f6
               beq  f6
               cmp  #key_f7
               beq  f7
               cmp  #key_f8
               beq  f8
               cmp  #ctrl_x
               beq  quit
               jmp  loop
f1             jsr  f1action
               jmp  loop
f2             jsr  f2action
               jmp  loop
f3             jsr  f3action
               jmp  loop
f4             jsr  f4action
               jmp  loop
f5             jsr  f5action
               jmp  loop
f6             jsr  f6action
               jmp  loop
f7             jsr  f7action
               jmp  loop
f8             jsr  f8action
               jmp  loop
quit           
               jsr  pop
               rts
txt1           .null     " rom pos."
txt2           .null     " key value"
               .bend
fkeyset        .byte     0
               
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f1action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f1abutton
               #affichemesg f1a_msg
               jmp  out
menub          #flashfkey f1bbutton               
               #affichemesg f1b_msg
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f2action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f2abutton
               #affichemesg f2a_msg
               jmp  out
menub          #flashfkey f2bbutton               
               #affichemesg f2b_msg
out            pla
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f3action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f3abutton
               #affichemesg f3a_msg
               jmp  out
menub          #flashfkey f3bbutton               
               #affichemesg f3b_msg
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f4action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f4abutton
               #affichemesg f4a_msg
               jmp  out
menub          #flashfkey f4bbutton               
               #affichemesg f4b_msg
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f5action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f5abutton
               #affichemesg f5a_msg
               jmp  out
menub          #flashfkey f5bbutton               
               #affichemesg f5b_msg
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f6action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f6abutton
               #affichemesg f6a_msg
               jmp  out
menub          #flashfkey f6bbutton               
               #affichemesg f6b_msg
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f7action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f7abutton
               #affichemesg f7a_msg
               jmp  out
menub          #flashfkey f7bbutton               
               #affichemesg f7b_msg
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f8action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f8abutton
               #affichemesg   menub_msg
               jmp  swapit
menub          #flashfkey f8bbutton               
               #affichemesg   menua_msg
swapit         eor  #$ff
               sta  fkeyset
               jsr  showfkeys
               pla
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
staticscreen   .block
               #changebord vgris1
               #changeback vgris
               #uppercase
               jsr  showlines
               jsr  showallchars
               jsr  showgrid
               jsr  showfkeys
               #affichemesg quit_msg
               #locate   0,7
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showfkeys      .block
               jsr  push
               lda  fkeyset
               cmp  #$0
               bne  secondks
               #printcxy f1abutton
               #printcxy f2abutton
               #printcxy f3abutton
               #printcxy f4abutton
               #printcxy f5abutton
               #printcxy f6abutton
               #printcxy f7abutton
               #printcxy f8abutton
               jmp end
secondks       #printcxy f1bbutton
               #printcxy f2bbutton
               #printcxy f3bbutton
               #printcxy f4bbutton
               #printcxy f5bbutton
               #printcxy f6bbutton
               #printcxy f7bbutton
               #printcxy f8bbutton
end            jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showallchars   .block
               jsr push
               #locate   0,0
               ldx  #$00
nextc          txa  
               sta  scrnnewram,x
               inx
               cpx  #$80
               bne  nextc
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showlines      .block
hline1=4
hline2=6
hline3=18
vlinepos=16
vzplit=scrnnewram+(6*40)+8
               jsr  push
               ldx  #40
               lda  #64
nextl          sta  scrnnewram+(40*hline1)-1,x  ;On imprime les deux grande
               sta  scrnnewram+(40*hline2)-1,x  ; lignes horizontales
               dex
hline          cpx  #vlinepos
               bpl  notyet
               sta  scrnnewram+(40*hline3),x    ;On imprime la demiligne horz.
notyet         cpx  #$00
               bne  nextl
               ; on imprime le caractere de jonction (t) au dessus de la 
               ; ligne vert
               lda  #<scrnnewram+(40*(hline2))+vlinepos
               sta  zpage1
               lda  #>scrnnewram+(40*(hline2))+vlinepos
               sta  zpage1+1
               ldy  #0
               lda  #114
               sta  (zpage1),y
               jsr  zp1add40
               ; on imprime ensuite les characteres de la ligne vert
               ldx  #24-hline2
               lda  #93
another93      sta  (zpage1),y
               jsr  zp1add40
               dex
               bne  another93
               ; on imprime le joint se la ligne vert et la demi 
               ; ligne horz
               lda  #<scrnnewram+(40*(hline3))+vlinepos
               sta  zpage1
               lda  #>scrnnewram+(40*(hline3))+vlinepos
               sta  zpage1+1
               ldy  #0
               lda  #115
               sta  (zpage1),y
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showgrid      .block
gligne=8
gcol=1
               jsr  push
               jsr  screendis
               lda  #<scrnnewram+(40*(gligne))+gcol
               sta  zpage1
               lda  #>scrnnewram+(40*(gligne))+gcol
               sta  zpage1+1
               ldx  #8
nextbox        lda  #101
               ldy  #9
               sta  (zpage1),y
               dey
               lda  #79
nextcol        sta  (zpage1),y
               dey  
               bne  nextcol
               jsr  zp1add40
               dex
               bne  nextbox
               ldy  #8
               lda  #119
nextlin        sta  (zpage1),y
               dey  
               bne  nextlin
               jsr screenena
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
zp1add40       .block
               php
               pha
               clc
               lda  zpage1
               adc  #40
               bcc  nocarry
               inc  zpage1+1
nocarry        sta  zpage1
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
delay          .block
               jsr  push
               lda  #$0
               tax
               tay
xagain         dex
yagain         dey
               cpy  #$00
               bne  yagain
               cpx  #$00
               bne  xagain
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
template       .block
               jsr  push
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "messages.asm"
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm"
               .include "map-c64-basic2.asm"
               .include "lib-c64-vicii.asm"
               .include "lib-c64-basic2.asm" 
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
;               .include "lib-cbm-disk.asm"
;               .include "lib-c64-text-sd.asm"
;               .include "lib-c64-text-mc.asm"
;               .include "lib-c64-showregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
