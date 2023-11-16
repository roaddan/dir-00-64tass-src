;-------------------------------------------------------------------------------
version  = "20231115-164208"
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
menu1col1      =    vblanc   ;vvert1
menu1col2      =    vgris2     ;vvert
menu2col1      =    vblanc
menu2col2      =    vgris2
flashcol       =    vblanc
whoamicol      =    vjaune
charcolor      =    vvert1      
charscolor     =    vgris1

 
main           .block
               jsr  push
               jsr  scrmaninit
               #disable
               jsr  splashscreen
               ;#printcxy menu_msg
wait           
               ;jsr  getkey
               ;cmp  #ctrl_x
               ;bne  wait
               jsr  copycharset
               jsr  screendis
               jsr  cls
               jsr  setscreenptr
               jsr  setdefaultchar
               jsr  staticscreen
               jsr  drawbitmap
               lda  #$00
               sta  fkeyset
               jsr  drawfkeys
               jsr  f8action       
               jsr  f8action
               lda  #$00
               jsr  screenena 
               jsr  keyaction
               jsr  cls
               jsr  splashscreen
               ;#printcxy bye_msg
               ;#printcxy any_msg
               ;jsr  getkey
               ;jsr  k_warmboot
               jsr  cls       
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
copychar       .block
               jsr  push
               jsr  getvalidkey
               lda  bitmapaddr     ; on pointe sur la table des bitmaps
               sta  zpage1
               lda  bitmapaddr+1
               sta  zpage1+1
               ; on ajuste l'offset du pointeur de bitmap
               ldx  copykey
               lda  asciitorom,x
               tax
               cpx  #$00
               beq  no_offset      ; sommes nous déja à 0
addagain       lda  #$08
               jsr  zp1addnum      ; on augmente de 8 byte ...
               dex                 ; pour chaque caracteres
               bne  addagain
               ; on place les pointeurs pour faire la copie
no_offset      lda  mapaddr        ; le caractere actuel
               sta  zpage2         ;
               lda  mapaddr+1      ;
               sta  zpage2+1       ;
               ; on effectue la copie des 8 octets
               ldy  #$00
nextbyte       lda  (zpage1),y
               sta  (zpage2),y
               iny
               cpy  #$08
               bne  nextbyte               
out            jsr  pop
               rts
thismapaddr
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
getvalidkey    .block
               jsr  push
               #affichemesg copychar_msg
getgoodkey     jsr  getkey
               sta  copykey
               tax
               ldy  asciitorom,x
               cpy  $00
               bne  goodone
               ldx  copykey
               cpx  #$40
               beq  goodone
               jmp  getgoodkey
goodone        jsr  putch
               jsr  pop
               rts
               .bend
copykey        .byte 0   

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
getfname       .block 
               jsr  push
               #affichemesg fname_msg
               ldx  #$00
               stx  count
getanother     jsr  getkey
               cmp  #$30      ; 0
               bmi  getanother
               cmp  #$3a      ; 9+1
               bmi  goodone          
isitletter     cmp  #$41      ; A
               bmi  getanother
               cmp  #$5b      ; Z+1
               bmi  goodone
               jmp  getanother              
goodone        jsr  putch
               ldx  count
               sta  name,x
               inc  count
               ldx  count
               cpx  #$06
               beq  finish
               jmp  getanother
finish         #affichemesg pfname
               jsr  pop
               rts
count          .byte     0
               .bend
pfname         .byte     1,1,5     
fname          .text     "@0:"
name           .text     "??????"
ext            .null     ".chr"
device         .byte     0
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
;               .include "lib-c64-drawregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
