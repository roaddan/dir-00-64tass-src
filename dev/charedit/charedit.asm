;-------------------------------------------------------------------------------
version  = "20231116-100400"  
;-------------------------------------------------------------------------------
               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .include "localmacro.asm"
               .enc     none

fkeyleft       =    18
f1top          =    9 
scrnnewram     =    $0400 
charsdef       =    12
grid_top       =    9
grid_left      =    1
grid_bot       =    grid_top + 7
grid_right     =    grid_left + 7
bordure        =    vgris
fond           =    vnoir
mesgcol        =    vcyan
menu1col1      =    vcyan
menu1col2      =    vbleu1
menu2col1      =    vvert1
menu2col2      =    vvert
flashcol       =    vblanc
whoamicol      =    vjaune
charcolor      =    vblanc   
charscolor     =    vgris2
main           .block
               jsr  push
               jsr  scrmaninit
               #disable
               jsr  drawcredits
               ;#printcxy menu_msg
wait           ;jsr  getkey
               ;cmp  #ctrl_x
               ;bne  wait
               jsr  screendis
               jsr  copycharset
               jsr  cls
               jsr  setscreenptr
               jsr  setdefaultchar
               jsr  staticscreen
               jsr  drawbitmap
               lda  #$00
               sta  fkeyset
               jsr  drawfkeys
               lda  #$00
               jsr  screenena 
               jsr  keyaction
               jsr  cls
               jsr  drawcredits
               #printcxy bye_msg
               #printcxy any_msg
               jsr  getkey
               ;jsr  k_warmboot
               jsr  cls       
               jsr  pop
               rts
               .bend

savefile       .block
               #pushall

               #popall
               rts
               .bend

pfname         .byte     vvert,27,3,18     
fname          .text     "@0:"
name           .text     "??????"
ext            .null     ".chr"
device         .byte     146,0

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
eorval         .byte     $80,$40,$20,$10,$08,$04,$02,$01
editmode       .byte     0
fkeyset        .byte     0
currentchar    .byte     0
currentkey     .byte     0
previouskey    .byte     0
bitmapoffset   .byte     0
mapaddr        .word     0
byteaddr       .word     0
gridaddr       .word     0 
cursln         .byte     grid_top
curscl         .byte     grid_left
;-------------------------------------------------------------------------------
; Including my self written libraries.
;-------------------------------------------------------------------------------
               .include "routines.asm"
               .include "messages_en.asm"
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
;               .include "lib-c64-drawregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
