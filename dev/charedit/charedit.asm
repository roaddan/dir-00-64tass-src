;-------------------------------------------------------------------------------
version  = "20231113-164208" 
;-------------------------------------------------------------------------------
               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .include "localmacro.asm"
               .enc     none

scrnnewram     =    $0400 
charsdef       =    14
grid_top       =    9
grid_left      =    1
grid_bot       =    grid_top + 7
grid_right     =    grid_left + 7
mesgcol        =    vcyan
menu1col       =    vvert1
menu2col       =    vrose
flashcol       =    vblanc      
 
main           .block
               jsr  push
               jsr  scrmaninit
               #disable
               jsr  splashscreen
               #printcxy menu_msg
wait           jsr  getkey
               cmp  #ctrl_x
               bne  wait
               jsr  cls
               jsr  screendis
               jsr  copycharset
               jsr  setscreenptr
               jsr  setdefaultchar
               jsr  staticscreen
               jsr  drawbitmap
               lda  #$00
               sta  fkeyset
               jsr  showfkeys
               jsr  f8action       
               jsr  f8action
               lda  #$00
               jsr  screenena
               jsr  keyaction
               jsr  cls
               #lowercase
               jsr  splashscreen
               #printcxy bye_msg
               #printcxy any_msg
               jsr  getkey
               jsr  k_warmboot       
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
eorval         .byte     $80,$40,$20,$10,$08,$04,$02,$01
editmode       .byte     0
fkeyset        .byte     0
currentchar    .byte     0
currentkey     .byte     0
bitmapoffset   .byte     0
mapaddr        .word     0
byteaddr       .word     0
gridaddr       .word     0 
cursln         .byte     grid_top
curscl         .byte     grid_left
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "routines.asm"
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