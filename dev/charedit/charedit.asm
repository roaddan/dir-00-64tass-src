;-------------------------------------------------------------------------------
; version : 20231104-22550021
;-------------------------------------------------------------------------------
                .include "header-c64.asm"
                .include "macros-64tass.asm"
                .include "localmacro.asm"
                .enc     none
main           .block
               jsr push
               jsr screendis
               jsr scrmaninit
               jsr staticscreen
               jsr screenena
               #affichemesg edit_msg       
               lda  #$00
               sta  fkeyset
               jsr  showfkeys
again          #locate 0,24
               jsr  pop
               jsr  keyaction
               rts
               .bend
fkeyset        .byte     0
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setscreenptr   .block
               jsr  push
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
keyaction      .block
               jsr  push
loop           jsr  getkey
               cmp  #key_f1
               beq  f1
               cmp  #key_f8
               beq  f8
               cmp  #ctrl_x
               beq  quit
               jmp  loop
f1             jsr  f1action
               jmp  loop
f8             jsr  f8action
               jmp  loop
quit           jsr  pop
               rts
               .bend
               
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f1action       .block
               pha
               lda  fkeyset
               bne  menub  
               #flashfkey f1abutton
               #affichemesg edit_msg
               jmp  out
menub          #flashfkey f1bbutton               
               #affichemesg rvrs_msg
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
               sta  scrnram,x
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
vzplit=scrnram+(6*40)+8
               jsr  push
               ldx  #40
               lda  #64
nextl          sta  scrnram+(40*hline1)-1,x  ;On imprime les deux grande
               sta  scrnram+(40*hline2)-1,x  ; lignes horizontales
               dex
hline          cpx  #vlinepos
               bpl  notyet
               sta  scrnram+(40*hline3),x    ;On imprime la demiligne horz.
notyet         cpx  #$00
               bne  nextl
               ; on imprime le caractere de jonction (t) au dessus de la 
               ; ligne vert
               lda  #<scrnram+(40*(hline2))+vlinepos
               sta  zpage1
               lda  #>scrnram+(40*(hline2))+vlinepos
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
               lda  #<scrnram+(40*(hline3))+vlinepos
               sta  zpage1
               lda  #>scrnram+(40*(hline3))+vlinepos
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
               lda  #<scrnram+(40*(gligne))+gcol
               sta  zpage1
               lda  #>scrnram+(40*(gligne))+gcol
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
