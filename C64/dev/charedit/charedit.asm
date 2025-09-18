;-------------------------------------------------------------------------------
version  = "20250917-231330"  
;-------------------------------------------------------------------------------
               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .include "localmacro.asm"
               .enc     "none"
fkeyleft       =    18
f1top          =    9 
scrnnewram     =    $0400 
charsdef       =    10
grid_top       =    9
grid_left      =    1
grid_bot       =    grid_top + 7
grid_right     =    grid_left + 7
bordure        =    vgris
fond           =    vnoir
mesgcol        =    vcyan
menu1col1      =    vcyan
menu1col2      =    vbleu1
menu2col1      =    vgris2
menu2col2      =    vgris1
flashcol       =    vblanc
whoamicol      =    vjaune
charcolor      =    vblanc   
charscolor     =    vgris2
main           .block
               jsr  push
               jsr  scrmaninit
               #disable
               jsr  drawcredits
               #printcxy menu_msg
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
               #affichemesg prompt_msg
               jsr  kbflushbuff
               jsr  screenena 
               jsr  keyaction
               jsr  cls
               jsr  drawcredits
               #printcxy bye_msg
               #printcxy any_msg
               jsr  getkey
               jsr  cls       
endmain        jsr  pop
               ;jsr  k_coldboot
               brk
               .bend

savetofile     .block
               jsr  pushall
               lda  #<fname
               sta  dsk_fnptr
               lda  #>fname
               sta  dsk_fnptr+1
               lda  #(device-fname-1)               
               sta  dsk_fnlen
               lda  device
               and  #$0f
               sta  dsk_lfsno
               sta  dsk_dev
               lda  #<bitmapmem
               sta  dsk_data_s
               lda  #>bitmapmem
               sta  dsk_data_s+1
               lda  #<endofaddr
               sta  dsk_data_e
               lda  #>endofaddr
               sta  dsk_data_e+1
               #printcxy blankmsg
               #printcxy wait_msg
               #locate 1,4
               jsr  memtofile
               jsr  popall
               rts
               .bend
loadfromfile   .block
               jsr  pushall
               lda  #<fname
               sta  dsk_fnptr
               lda  #>fname
               sta  dsk_fnptr+1
               lda  #(device-fname-1)
               sta  dsk_fnlen
               lda  device
               and  #$0f
               sta  dsk_dev
               sta  dsk_lfsno
               lda  #<bitmapmem
               sta  dsk_data_s
               lda  #>bitmapmem
               sta  dsk_data_s+1
               lda  #<endofaddr
               sta  dsk_data_e
               lda  #>endofaddr
               sta  dsk_data_e+1
               #printcxy blankmsg
               #printcxy wait_msg
               #locate 1,4
               jsr  filetomem
               jsr  popall
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
bitmapmem      =         charsdef * 1024     ;Calcul position ram des caracteres.
endofaddr      =         (charsdef * 1024) + (4*$800)
mstopaddr      =         $d000+(4*$800)
startaddr      .word     $d000               ; 53248
stopaddr       .word     mstopaddr           ; 55296 
bitmapaddr     .word     bitmapmem           ; $3000, 12288     
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
pfname         .byte     vvert,27,3,18     
fname          .text     "@0:"
name           .text     "origin"
ext            .null     ".chr"
device         .byte     8
;-------------------------------------------------------------------------------
; Including my self written libraries.
;-------------------------------------------------------------------------------
               .include "routines.asm"
               .include "strings_fr.asm"
;               .include "strings_en.asm"

*=$c000
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm"
               .include "map-c64-basic2.asm"
               .include "lib-c64-vicii.asm"
               .include "lib-c64-basic2.asm" 
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
               .include "lib-cbm-disk.asm"
               .include "lib-c64-showregs-sd.asm"
;               .include "lib-c64-text-sd.asm"
;               .include "lib-c64-text-mc.asm"
;               .include "lib-c64-drawregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
