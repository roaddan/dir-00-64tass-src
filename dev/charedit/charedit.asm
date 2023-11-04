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
               jsr  anykey
               #affichemesg save_msg
               jsr  anykey
;               #affichemesg load_msg
;               jsr  anykey
;               #affichemesg copy_msg
;               jsr  anykey
;               #affichemesg clear_msg 
;               jsr  anykey
;               #affichemesg fill_msg
;               jsr  anykey
;               #affichemesg work_msg
;               jsr  anykey
               #affichemesg rvrs_msg
               jsr  anykey
;               #affichemesg invr_msg
;               jsr  anykey
;               #affichemesg flip_msg
;               jsr  anykey
;               #affichemesg scrollr_msg
;               jsr  anykey
;               #affichemesg scrolll_msg
;               jsr  anykey
;               #affichemesg scrollu_msg
;               jsr  anykey
;               #affichemesg scrolld_msg
;               jsr  anykey
;               #affichemesg save_fname_msg
;               jsr  anykey
;               #affichemesg load_fname_msg
               lda  #$ff
               sta  fkeyset
               jsr  showfkeys
               jsr  anykey
               #flashfkey     f8bbutton
               jsr  anykey
               lda  fkeyset
               eor  #$ff
               sta  fkeyset
               jsr  showfkeys
               jsr  anykey
               #flashfkey     f4abutton
               #locate 0,20
               jsr  getkey
               jsr  putch
               jsr pop
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
