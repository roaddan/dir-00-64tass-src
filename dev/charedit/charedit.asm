;-------------------------------------------------------------------------------
; version : 20231107-222128 
;-------------------------------------------------------------------------------
               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .include "localmacro.asm"
               .enc     none 

scrnnewram     = $0400 
charsdef       = 14
mesgrid_left   = vvert1
grid_top       =         9
grid_left      =         1
grid_bot       =         grid_top + 7
grid_right     =         grid_left + 7
mesgcol        =         vvert1    

main           .block
               jsr  push
               jsr  screendis
               jsr  scrmaninit
               jsr  copycharset
               jsr  setscreenptr
               jsr  staticscreen
               jsr  screenena
               lda  #$00
               sta  fkeyset
               jsr  showfkeys
               jsr  pop
               jsr  f8action       
               jsr  f8action
               lda  #$00
;               lda  #'A'
;               sta  scrnnewram,x      
               jsr  keyaction
               #locate 0,0
               jsr  cls
               #affichemesg bye_msg
               #affichemesg any_msg
               #locate 0,0
               jsr  getkey
               jsr  k_warmboot       
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
showkeyval     .block
               jsr  push


               #locate 1,19
               ;#print txt0
               ;lda  currentkey
               jsr  putabin
               ;jsr  putch

               #locate 1,20
               #print txt1
               lda  #'$'
               jsr  putch
               lda  currentkey
               jsr  putahex


               #locate 1,21
               #print txt2
               lda  #'$'
               jsr  putch
               lda  bitmapaddr+1
               jsr  putahex
               lda  bitmapaddr
               jsr  putahex

               #locate 1,22
               #print txt3
               lda  #'$'
               jsr  putch               
               lda  bitmapoffset
               jsr  putahex


               #locate 1,23
               #print txt4
               lda  #'$'
               jsr  putch
               lda  mapaddr+1
               jsr  putahex
               lda  mapaddr
               jsr  putahex

               #locate 1,24
               #print txt5
               lda  curscl
               jsr  putahex
               lda  #$da
               jsr  putch
               lda  cursln
               jsr  putahex

               ;jsr  delay
               jsr  pop
               rts
txt0           .null     "petscii :   "
txt1           .null     "key code: "
txt2           .null     "bitmap..: "
txt3           .null     "offset..:   "
txt4           .null     "mapaddr.: "
txt5           .null     "cursval.: "
txt6           .null     "stack......:"
               .bend
               
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
keyaction      .block
               jsr  push
loop
               ;#affichemesg keyaction_msg
               jsr  getkey
               sta  currentkey
               ;jsr  showkeyval
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
quit           jsr  pop
               rts

keyaction_msg  .byte vrose,1,5
               .null     "[keyaction]"
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
editor         .block
               jsr  push
               #affichemesg exit_msg
               #affichemesg edit_msg
               lda  #'@'
               sta  currentkey
               #locate   13,12
               jsr  putch
               tax
               ldy  asciitorom,x
               sty  bitmapoffset
               ;jsr  showkeyval
               jsr  drawbitmap
               jsr  setcurs
ed_loop        ;#affichemesg editor_msg
               jsr  getkey
               sta  currentkey
               tax
               ldy  asciitorom,x
               sty  bitmapoffset
; --- gestion des touches ---
cu             cmp  #cursu
               bne  cd
               jmp  do_up
cd             cmp  #cursd
               bne  cl
               jmp  do_down
cl             cmp  #cursl
               bne  cr
               jmp  do_left
cr             cmp  #cursr
               bne  sp
               jmp  do_right
sp             cmp  #$20
               bne  cx
               jmp  do_swap
cx             cmp  #ctrl_x
               bne  rest
               jmp  do_ctrlx
rest           ;cmp  #$20
               ;bmi  ed_loop
               

               #locate   13,12
               jsr  putch
               #locate   17,5
               jsr  atodec
               #print    adec
               jsr  drawbitmap
               jmp  totop
;-------------------------------------------------------------------------------
; specific actions for certain keys
;-------------------------------------------------------------------------------
do_up          lda  cursln
               cmp  #grid_top
               beq  totop

               jsr  clrcurs
               dec  cursln
               jsr  setcurs
               jmp  totop

do_down        lda  cursln
               cmp  #grid_bot
               beq  totop

               jsr  clrcurs
               inc  cursln
               jsr  setcurs
               jmp  totop

do_left        lda  curscl
               cmp  #grid_left
               beq  totop

               jsr  clrcurs
               dec  curscl
               jsr  setcurs
               jmp  totop

do_right       lda  curscl
               cmp  #grid_right
               beq  totop

               jsr  clrcurs
               inc  curscl
               jsr  setcurs
               jmp  totop
do_swap        jsr  do_eor
               jmp  totop
totop          ;jsr  showkeyval
               jmp  ed_loop
do_ctrlx       jsr  clrcurs
               #affichemesg quit_msg
               jsr  pop
               rts
editor_msg     .byte vrose,1,5
               .null     "[editor]"
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
; use     byteaddr,cursln,curscl
do_eor         .block
               jsr  push
               lda  #<mapaddr
               sta  zpage2
               lda  #>mapaddr+1
               sta  zpage2+1

               ldx  cursln     ; calcul de 
               dex            ; l'offset de 
               txa            ; la 
               and  #$f7      ; ligne
               tay
               ldx  curscl
               dex
               lda  eorval,x
               eor  (zpage2),y
               jsr  showkeyval
               sta  (zpage2),y
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setcurs        .block
               jsr  push
               ldx  #grid_left
               ldy  cursln
               jsr  gotoxy
               lda  #$da
               jsr  putch
               ldx  curscl
               inx
               ldy  #grid_top-1
               jsr  gotoxy
               lda  #$da
               jsr  putch
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
clrcurs        .block
               jsr  push
               ldx  #grid_left
               ldy  cursln
               jsr  gotoxy
               lda  #$20
               jsr  putch
               ldx  curscl
               inx
               ldy  #grid_top-1
               jsr  gotoxy
               lda  #$20
               jsr  putch
               jsr  pop
               rts

               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------

drawbitmap     .block
               jsr  push
               ; prépare le text 
               lda  #<letext       ; le pointeur
               sta  zpage2
               lda  #<letext+1
               sta  zpage2+1

               lda  #grid_left          ; la position
               sta  textline+1
               lda  #grid_top
               sta  textline+2
               
               jsr  calcmapaddr              

               lda  mapaddr     ; on pointe sur la table des bitmaps
               sta  zpage1
               lda  mapaddr+1
               sta  zpage1+1
;               ; on ajuste l'offset du pointeur de bitmap
;               ldx  bitmapoffset
;               cpx  #$00
;               beq  thesame       ; sommes nous déja à 0
;addagain       lda  #8
;               jsr  zp1addnum      ; on augmente de 8 byte ...
;               dex                 ; pour chaque caracteres
;               bne  addagain
;thesame        pha
;               lda  zpage1
;               sta  mapaddr
;               lda  zpage1+1
;               sta  mapaddr+1
;               pla
               ; On affiche les 8 lignes du caractere
drawchar       ldy  #$00      
               ldx  #grid_top      ;on replace la ...
               stx  isy+1          ;ligne de départ
nextline       jsr  push
               ldx  #grid_left+1        ; la colonne
isy            ldy  #$00      ; la ligne (autoinc)
               jsr  gotoxy
               jsr  pop
               lda  (zpage1),y     ; on li une ligne
               jsr  atobin
               jsr  abintograph
               #print abin
               inc  isy+1
               iny
               cpy  #$08
               bmi  nextline
               jsr  pop
               rts
textline       .byte vblanc,grid_left,grid_top
letext         .null "        "
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
calcmapaddr    .block
               jsr  push
               lda  bitmapaddr     ; on pointe sur la table des bitmaps
               sta  zpage1
               lda  bitmapaddr+1
               sta  zpage1+1
               ; on ajuste l'offset du pointeur de bitmap
               ldx  bitmapoffset
               cpx  #$00
               beq  thesame         ; sommes nous déja à 0
addagain       lda  #8
               jsr  zp1addnum      ; on augmente de 8 byte ...
               dex                 ; pour chaque caracteres
               bne  addagain
thesame        pha
               lda  zpage1
               sta  mapaddr
               lda  zpage1+1
               sta  mapaddr+1
               pla
               jsr  showkeyval
out            jsr  pop
               rts
               .bend


;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
abintograph    .block
               jsr  push
               lda  #<abin
               sta  zpage1
               lda  #>abin+1
               sta  zpage1+1
               ldy  #$00
nextbit        lda  (zpage1),y
               cmp  #$30
               beq  itszero
itsone         lda  #$d1
               sta  (zpage1),y
               jmp  next
itszero        lda  #$20
               sta  (zpage1),y
next           iny
               cpy  #$08       
               bmi  nextbit
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setscreenptr   .block
               jsr  push
;               ; BASIC -> print chr$(8)
               lda  #$08      ; basic commande to disable ...
               jsr  chrout    ; ... character set change.
               
;               ; BASIC -> poke 56578,peek(56578) or 3
;               lda  cia2ddra  ;$dd02, 56578 cia2 data direction A
;               ora  #$00000011
;               sta  cia2ddra  ;$dd02, 56578 cia2 data direction A
;               
;               ; BASIC -> poke 56576, (peek(56576) and 252) or 0
;               lda  cia2pra   ;$dd00, 56576 cia2 dataport A
;               and  #%11111100
;               ora  #%00000000
;               sta  cia2pra   ;$dd00, 56576 cia2 dataport A
               
               ; BASIC -> poke 53272, (peek(53272) and 240) or 12
               lda  vicmemptr      ;$d018, 53272               
               ; vicmemptr
               ;  +-------+-------+-------+-------+-------+-------+-------+-------+
               ;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
               ;  +-------+-------+-------+-------+-------+-------+-------+-------+
               ;  |  txt  |  txt  |  txt  |  txt  | chars | chars | chars |       | 
               ;  |  scr  |  scr  |  scr  |  scr  |  def  |  def  |  def  |   X   |
               ;  | bit 3 | bit 2 | bit 1 | bit 0 | bit 2 | bit 1 | bit 0 |       |
               ;  +-------+-------+-------+-------+-------+-------+-------+-------+
               and  #%11110000     ; On conserve les bits 7654 de ce registre ...
                                   ; ... afin de conserver la mémoire vidéo à $0400.
               ora  #charsdef      ; on place les bits 3210 à %xxxx001x ce qui ...
                                   ; ... sélectionne la mémoire du bitmap des ...
                                   ; ... charactères à $0800. 
               sta  vicmemptr      ; $d018, 53272

;               ; BASIC -> poke 648, 196               
;               lda  #%00000100     ;%11000100 ; 196
;               sta  $0288          ; On indique au kernal que la mémoire video ...
;                                   ; ... commence à 4 * 256 = 1024
;                                   ; 648 - top page of screen memory
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
copycharset    .block
               jsr  push

               ; On desactive les interruptions du clavier.
               ; BASIC -> poke 56334, peek(56334) and 254 
               lda  cia1cra        ;$dc0e, 56334 cia1 control register A
               and  #%11111110     ;254
               sta  cia1cra        ;$dc0e, 56334 cia1 control register A

               ; On active la rom des bitmaps charactères.     
               ; BASIC -> poke 1, peek(1) and 251
               lda  u6510map       ;$01
               and  #%11111011     ;251
               sta  u6510map       ;$01

               ; ici on copy le character-map
               jsr  memcopy

               ; On réactive les i/o en replaçant la rom des 
               ; BASIC -> poke 1, peek(1) or 4
               lda  u6510map       ;$01
               ora  #%00000100
               sta  u6510map       ;$01

               ; On réactive les interruptions du clavier.
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

               lda  startaddr
               sta  zpage1
               lda  startaddr+1
               sta  zpage1+1
               lda  bitmapaddr
               sta  zpage2
               lda  bitmapaddr+1
               sta  zpage2+1
               ldy  #$00

onemore        lda  (zpage1),y
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

bitmapmem =    charsdef * 1024     ;Calcul de la position ram des caracteres.
mstopaddr =    $d000+(4*$800)
startaddr      .word     $d000               ; 53248
stopaddr       .word     mstopaddr           ; 55296 
bitmapaddr     .word     bitmapmem           ; $3000, 12288     
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
staticscreen   .block
               #changebord vgris1
               #changeback vgris
               ;#uppercase
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

               jsr  push
               jsr  screendis
               lda  #<scrnnewram+(40*(grid_top))+grid_left
               sta  zpage1
               lda  #>scrnnewram+(40*(grid_top))+grid_left
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
               lda  #$3e
               sta  scrnnewram+(40*(12))+11
               lda  #$70                     ;+
               sta  scrnnewram+(40*(11))+12
               lda  #$43                    ;-
               sta  scrnnewram+(40*(11))+13  
               lda  #$6e                     ;+
               sta  scrnnewram+(40*(11))+14
               lda  #$5d                     ;|
               sta  scrnnewram+(40*(12))+12
               lda  #$5d                     ;|
               sta  scrnnewram+(40*(12))+14
               lda  #$6d                     ;+
               sta  scrnnewram+(40*(13))+12
               lda  #$43                     ;-
               sta  scrnnewram+(40*(13))+13  
               lda  #$7d                     ;+
               sta  scrnnewram+(40*(13))+14

               jsr screenena
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
zp1addnum       .block
               php
               pha
               clc
               adc  zpage1
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
               dex
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
f1action       .block
               pha
               lda  #$ff
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f1a_msg
               #flashfkey f1abutton
               jsr  editor
               #affichemesg f1a_msg
               jmp  out
menub          lda  #$0
               sta  editmode
               #affichemesg f1b_msg
               #flashfkey f1bbutton    
out            pla
               rts
test_msg       .byte     vblanc,1,5
               .null     "[f1-action]"
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f2action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f2a_msg
               #flashfkey f2abutton
               jmp  out
menub          #affichemesg f2b_msg
               #flashfkey f2bbutton               
out            pla
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f3action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f3a_msg
               #flashfkey f3abutton
               jmp  out
menub          #affichemesg f3b_msg
               #flashfkey f3bbutton               
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f4action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f4a_msg
               #flashfkey f4abutton
               jmp  out
menub          #affichemesg f4b_msg
               #flashfkey f4bbutton               
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f5action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f5a_msg
               #flashfkey f5abutton
               jmp  out
menub          #affichemesg f5b_msg
               #flashfkey f5bbutton               
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f6action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f6a_msg
               #flashfkey f6abutton
               jmp  out
menub          #affichemesg f6b_msg
               #flashfkey f6bbutton               
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f7action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg f7a_msg
               #flashfkey f7abutton
               jmp  out
menub          #affichemesg f7b_msg
               #flashfkey f7bbutton               
out            pla
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f8action       .block
               pha
               lda  #$0
               sta  editmode
               lda  fkeyset
               bne  menub  
               #affichemesg menub_msg
               #flashfkey f8abutton
               jmp  swapit
menub          #affichemesg menua_msg
               #flashfkey f8bbutton               
swapit         eor  #$ff
               sta  fkeyset
               jsr  showfkeys
               pla
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