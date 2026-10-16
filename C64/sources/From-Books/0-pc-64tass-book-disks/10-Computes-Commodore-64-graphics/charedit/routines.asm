;-------------------------------------------------------------------------------
; Redessine l'écran de travail
;-------------------------------------------------------------------------------
scrredraw   .block
            jsr   pushreg           ; Sauvegarde les registres
            jsr   screendis         ; Inhibe l'affichage
            jsr   cls               ; Efface l'écran
            jsr   scrstatic         ; Affiche les éléments statiques de l'écran.
            jsr   drawbitmap        ; Affiche la représentation bitmap du car.
            jsr   drawfkeys         ; Affiche le menu de clefs fonctions.
            #locate   13,12         ; Positionne le curseur.
            lda   currentkey        ; Affiche le caractère actuellement
            jsr   putch             ; ... représenté.
            #affichemesg prompt_msg ; Affiche un invite.
            jsr   screenena         ; Permet l'affichage d'écran.
            jsr   popreg            ; Récupère les registres.
            rts                     ; Bye.
            .bend

;-------------------------------------------------------------------------------
; Capture un nom de fichier de 6 lettres entré par l'usager.
;-------------------------------------------------------------------------------
getfname    .block
            jsr   pushreg           ; Sauvegarde les registres
            #affichemesg fname_msg  ; Affiche l'invite 
            ldx  #$00               ; X à 0
            stx  count              ; pour compter les caractères
getanother  jsr  getalnum           ; Lit un car alphanum
            jsr  putch              ; l'affiche
            ldx  count              ; Sauvegarde le caractere àa la pos. X
            sta  name,x             ; du nom de fichier en memoire.
            inc  count              ; Incrémente le compteur.
            ldx  count              ; Le compare avec ...
            cpx  #$06               ; 6 et s'il y a 6 lettre
            beq  finish             ; Le nom est terminé.
            jmp  getanother         ; Sinon on en demande un autre.
finish      #affichemesg pfname     ; Affiche le nom du fichier
            jsr   popreg            ; Récupère les registres.
            rts
count       .byte     0
            .bend

;-------------------------------------------------------------------------------
; Récupère un caractère de a-z et 0-9 dans Acc.
;-------------------------------------------------------------------------------
getalnum    .block
            jsr   pushreg           ; Sauvegarde les registres
getanother  jsr   getkey            ; Li une clef.
            cmp   #$30              ; Plus petit que 0?
            bmi   getanother        ; On le refuse et en demande une autre.
            cmp   #$3a      ; 9+1   ; Plus petit 9+1?
            bmi   goodone           ; C'est un bon caractère. 
isitletter  cmp   #$41      ; A     ; Plus petit que A?
            bmi   getanother        ; On le refuse et en demande une autre.
            cmp   #$5b      ; Z+1   ; Plus petit que Z+1?
            bmi   goodone           ; C'est un bon caractère. 
            jmp   getanother        ; On le refuse et en demande une autre.
goodone     sta   tempbyte          ; On le sauvegarde pour ...
            jsr   popreg            ; ... récupèrer les registres.
            lda   tempbyte          ; On le replace dans A.
            rts                     ; On quitte
tempbyte    .byte 0
            .bend

;-------------------------------------------------------------------------------
; Copie le bitmap d'un caractère sur le caractère actuel.
;-------------------------------------------------------------------------------
copychar    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            jsr   getvalidkey       ; On cherche une clef valide.
            lda   bitmapaddr        ; On pointe sur la table des bitmaps
            sta   zpage1            ; ... pour copier les octets
            lda   bitmapaddr+1      ; ... de la définition des 
            sta   zpage1+1          ; ... caractères.
            ldx   copykey           ; On ajuste l'offset du pointeur de bitmap.
            lda   asciitorom,x      ; 
            tax
            cpx   #$00
            beq   no_offset         ; sommes nous déja à 0
addagain    lda   #$08
            jsr   zp1addnum         ; on augmente de 8 byte ...
            dex                     ; pour chaque caracteres
            bne   addagain
            ; on place les pointeurs pour faire la copie
no_offset   lda   mapaddr           ; le caractere actuel
            sta   zpage2            ;
            lda   mapaddr+1         ;
            sta   zpage2+1          ;
            ; on effectue la copie des 8 octets
            ldy   #$00
nextbyte    lda   (zpage1),y
            sta   (zpage2),y
            iny
            cpy   #$08
            bne   nextbyte            
out         jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend 

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
getvalidkey .block
            jsr   pushreg           ; Sauvegarde les registres
            #affichemesg copychar_msg
getgoodkey  jsr   getkey
            sta   copykey
            tax
            ldy   asciitorom,x
            cpy   $00
            bne   goodone
            ldx   copykey
            cpx   #$40
            beq   goodone
            jmp   getgoodkey
goodone     jsr   putch
            jsr   popreg            ; Récupère les registres.
            rts
            .bend 

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawcredits   .block
            jsr   pushreg           ; Sauvegarde les registres
            jsr  cls
            #printcxy whoami0
            #printcxy whoami1
            #printcxy whoami2
            #printcxy whoami3
            #printcxy whoami4
            #printcxy whoami5
            #printcxy whoami6
            #printcxy whoami7
            #printcxy whoami8
            #printcxy whoami9
            jsr  delay
            jsr  delay
            jsr  delay
            jsr  delay
            jsr  delay
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setdfltchar .block
            jsr   pushreg           ; Sauvegarde les registres
            lda  #$40
            sta  currentkey
            tax
            ldy  asciitorom,x
            sty  bmoffset
            jsr  drawkeyval
            jsr  drawbitmap
            #locate   13,12
            jsr  putch
            #locate   17,5
            jsr  atodec
            #print    adec
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
rstmenucol  .block
            jsr   pushreg           ; Sauvegarde les registres
            lda  #menu1col1
            sta  f1abutton
            sta  f3abutton
            sta  f5abutton
            sta  f7abutton
            lda  #menu1col2
            sta  f2abutton
            sta  f4abutton
            sta  f6abutton
            sta  f8abutton
            ;jsr  drawfkeys
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
resetmenubcolor  .block
            jsr   pushreg           ; Sauvegarde les registres
            lda  #menu2col1
            sta  f1bbutton
            sta  f3bbutton
            sta  f5bbutton
            sta  f7bbutton
            lda  #menu2col1
            sta  f2bbutton
            sta  f4bbutton
            sta  f6bbutton
            sta  f8bbutton
            ;jsr  drawfkeys
            jsr   popreg            ; Récupère les registres.
            rts
            .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setmenuacolor  .block
            jsr   pushreg           ; Sauvegarde les registres
            sta  f1abutton
            sta  f2abutton
            sta  f3abutton
            sta  f4abutton
            sta  f5abutton
            sta  f6abutton
            sta  f7abutton
            sta  f8abutton
            ;jsr  drawfkeys
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setmenubcolor  .block
            jsr   pushreg           ; Sauvegarde les registres
            sta  f1bbutton
            sta  f2bbutton
            sta  f3bbutton
            sta  f4bbutton
            sta  f5bbutton
            sta  f6bbutton
            sta  f7bbutton
            sta  f8bbutton
            ;jsr  drawfkeys
            jsr   popreg            ; Récupère les registres.
            rts
            .bend
            
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawkeyval     .block
            jsr   pushreg           ; Sauvegarde les registres
            #locate 1,19
            ;#print txt0
            lda  currentkey
            jsr  putch
            pha
            lda  #'='
            jsr  putch
            lda  #'%'
            jsr  putch
            pla
            jsr  putabin

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
            lda  bmoffset
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
            jsr   popreg            ; Récupère les registres.
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
keyaction   .block
            jsr   pushreg           ; Sauvegarde les registres
myloop      jsr   getkey      ; Boucle de récupération de clef.  
f1          cmp   #key_f1     ; est-ce F1  
            bne   f2          ; non, on va voir la prochaine.
            jmp   dof1        ; Oui, On l'exécute.
f2          cmp   #key_f2     ; est-ce F2  
            bne   f3          ; non, on va voir la prochaine.
            jmp   dof2        ; Oui, On l'exécute.
f3          cmp   #key_f3     ; est-ce F3  
            bne   f4          ; non, on va voir la prochaine.
            jmp   dof3        ; Oui, On l'exécute.
f4          cmp   #key_f4     ; est-ce F4  
            bne   f5          ; non, on va voir la prochaine.
            jmp   dof4        ; Oui, On l'exécute.
f5          cmp   #key_f5     ; est-ce F5  
            bne   f6          ; non, on va voir la prochaine.
            jmp   dof5        ; Oui, On l'exécute.
f6          cmp   #key_f6     ; est-ce F6  
            bne   f7          ; non, on va voir la prochaine.
            jmp   dof6        ; Oui, On l'exécute.
f7          cmp   #key_f7     ; est-ce F7  
            bne   f8          ; non, on va voir la prochaine.
            jmp   dof7        ; Oui, On l'exécute.
f8          cmp   #key_f8     ; est-ce F8  
            bne   ctrlx       ; non, on va voir la prochaine.
            jmp   dof8        ; Oui, On l'exécute.
ctrlx       cmp   #ctrl_x     ; est-ce CTRL+X  
            bne   ctrlr       ; non, on va voir la prochaine.
            jmp   doquit      ; Oui, On l'exécute.
ctrlr       cmp   #ctrl_r     ; est-ce CTRL+R
            bne   ishex14     ; non, on va voir la prochaine.
            jmp   doredraw    ; Oui, On l'exécute.
ishex14     cmp   #$14        ; est-ce $14 ???  
            bne   ishex12     ; non, on va voir la prochaine.    
                        ; XXXX - Ici faire quelque chose
            jmp   myloop      ; On boucle             
ishex12     cmp   #$12        ; est-ce F1  
            bne   reste       ; non, on fait le reste des clefs
                        ; XXXX - Ici faire quelque chose
            jmp   myloop            
reste       #locate   13,12
            jsr   putch
            pha            ; remembers 
            lda   currentkey  ; the 
            sta   previouskey ; previous key
            pla            ;
            sta   currentkey  ; an store current
            tax
            ldy   asciitorom,x            
            sty   bmoffset
            jsr   drawkeyval

            pha
            lda #$41
            jsr waitkey
            pla

;            jsr  drawbitmap
            #locate   17,5
            jsr  atodec
            #print    adec
            jmp  myloop
;----------------------------------------------------------
dof1        jsr  f1action  ;edit/reverse
            jmp  myloop
;----------------------------------------------------------
dof2        jsr  f2action  ;save/flip vert
            jmp  myloop
;----------------------------------------------------------
dof3        jsr  f3action  ;load/flip horz
            jmp  myloop
;----------------------------------------------------------
dof4        jsr  f4action  ;copy/scroll r
            jmp  myloop
;----------------------------------------------------------
dof5        jsr  f5action  ;clear/scroll l
            jmp  myloop
;----------------------------------------------------------
dof6        jsr  f6action  ;fill;/scroll up
            jmp  myloop
;----------------------------------------------------------
dof7        jsr  f7action  ;clear;/scroll down
            jmp  myloop
;----------------------------------------------------------
dof8        jsr  f8action  ; function
            jmp  myloop
;----------------------------------------------------------
doredraw    jsr  scrredraw
            jmp  myloop
;----------------------------------------------------------
doquit      jsr  popreg
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
editor      .block 
            jsr   pushreg           ; Sauvegarde les registres
            #affichemesg exit_msg
            #affichemesg edit_msg
            jsr  setcurs
            lda  currentkey
            #locate   17,5
            jsr  atodec
            #print    adec
            jsr  drawbitmap
ed_loop     jsr  getkey
; --- gestion des touches ---
f1          cmp  #f1key
            bne  cu
            jmp  do_ctrlx
cu          cmp  #cursu
            bne  cd
            jmp  do_up
cd          cmp  #cursd
            bne  cl
            jmp  do_down
cl          cmp  #cursl
            bne  cr
            jmp  do_left
cr          cmp  #cursr
            bne  cx
            jmp  do_right
cx          cmp  #ctrl_x
            bne  sp
            jmp  do_ctrlx
sp          cmp  #$20
            bne  ishex14
            jmp  do_swap
ishex14     cmp  #$14
            bne  ishex12
            jmp  do_swap
ishex12     cmp  #$12
            bne  rest
            jmp  do_swap
rest        #locate   13,12
            jsr  putch
            pha
            lda  currentkey
            sta  previouskey
            pla
            sta  currentkey
            tax
            ldy  asciitorom,x
            sty  bmoffset
            jsr  drawkeyval
            jsr  drawbitmap
            #locate   13,12
            jsr  putch
            #locate   17,5
            jsr  atodec
            #print    adec
            jmp  totop
;-------------------------------------------------------------------------------
; specific actions for certain keys
;-------------------------------------------------------------------------------
do_up       lda  cursln
            cmp  #grid_top
            beq  totop

            jsr  clrcurs
            dec  cursln
            jsr  setcurs
            jmp  totop

do_down     lda  cursln
            cmp  #grid_bot
            beq  totop

            jsr  clrcurs
            inc  cursln
            jsr  setcurs
            jmp  totop

do_left     lda  curscl
            cmp  #grid_left
            beq  totop

            jsr  clrcurs
            dec  curscl
            jsr  setcurs
            jmp  totop

do_right    lda  curscl
            cmp  #grid_right
            beq  totop

            jsr  clrcurs
            inc  curscl
            jsr  setcurs
            jmp  totop
do_swap     jsr  do_eor
            jsr  drawbitmap
            ;jmp  totop
totop       jmp  ed_loop
do_ctrlx    jsr  clrcurs
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
; use     byteaddr,cursln,curscl
do_eor         .block
            jsr   pushreg           ; Sauvegarde les registres
            lda  mapaddr
            sta  zpage2
            lda  mapaddr+1
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
            jsr  drawkeyval
            sta  (zpage2),y
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setcurs        .block
            jsr   pushreg           ; Sauvegarde les registres
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
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
clrcurs        .block
            jsr   pushreg           ; Sauvegarde les registres
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
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawbitmap     .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            ; prépare le text
            jsr  calcmapaddr              
            lda  mapaddr        ; on pointe sur la table des bitmaps
            sta  zpage1
            lda  mapaddr+1
            sta  zpage1+1
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
            jsr  highlight
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

highlight      .block
            jsr   pushreg           ; Sauvegarde les registres
            ldx  previouskey
            lda  asciitorom,x
            tax
            lda  #charscolor
            sta  colorram,x
            ldx  currentkey
            lda  asciitorom,x
            tax
            lda  #charcolor
            sta  colorram,x 
            jsr   popreg            ; Récupère les registres.
            rts
            .bend


;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
calcmapaddr    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            lda  bitmapaddr     ; on pointe sur la table des bitmaps
            sta  zpage1
            lda  bitmapaddr+1
            sta  zpage1+1
            ; on ajuste l'offset du pointeur de bitmap
            ldx  bmoffset
            cpx  #$00
            beq  thesame         ; sommes nous déja à 0
addagain       lda  #$08
            jsr  zp1addnum      ; on augmente de 8 byte ...
            dex              ; pour chaque caracteres
            bne  addagain
thesame        pha
            lda  zpage1
            sta  mapaddr
            lda  zpage1+1
            sta  mapaddr+1
            pla
            jsr  drawkeyval
out         jsr  popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
abintograph    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
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
itszero        lda  #$2e
            sta  (zpage1),y
next           iny
            cpy  #$08       
            bmi  nextbit
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
setscreenptr   .block
            jsr   pushreg           ; Sauvegarde les registres
;            ; BASIC -> print chr$(8)
            lda  #$08      ; basic commande to disable ...
            jsr  chrout    ; ... character set change.
            
;            ; BASIC -> poke 56578,peek(56578) or 3
;            lda  cia2ddra  ;$dd02, 56578 cia2 data direction A
;            ora  #$00000011
;            sta  cia2ddra  ;$dd02, 56578 cia2 data direction A
;            
;            ; BASIC -> poke 56576, (peek(56576) and 252) or 0
;            lda  cia2pra   ;$dd00, 56576 cia2 dataport A
;            and  #%11111100
;            ora  #%00000000
;            sta  cia2pra   ;$dd00, 56576 cia2 dataport A
            
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

;            ; BASIC -> poke 648, 196            
;            lda  #%00000100     ;%11000100 ; 196
;            sta  $0288          ; On indique au kernal que la mémoire video ...
;                             ; ... commence à 4 * 256 = 1024
;                             ; 648 - top page of screen memory
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-----------------------------------------------------------------------------
copycharset       .block
               jsr   pushreg           ; Sauvegarde les registres
               ;-----------------------------------------------------------
               ; On desactive les interruptions du clavier.
               ; BASIC -> poke 56334, peek(56334) and 254 
               lda  cia1cra        ;$dc0e, 56334 cia1 control register A
               and  #%11111110     ;254
               sta  cia1cra        ;$dc0e, 56334 cia1 control register A
               ;-----------------------------------------------------------
               ; On active la rom des bitmaps charactères.     
               ; BASIC -> poke 1, peek(1) and 251
               lda  u6510map       ;$01
               and  #%11111011     ;251
               sta  u6510map       ;$01
               ;-----------------------------------------------------------
               ; ici on copy le character-map
               jsr  memcopy
               ;-----------------------------------------------------------
               ; On réactive les i/o en replaçant la rom des 
               ; BASIC -> poke 1, peek(1) or 4
               lda  u6510map       ;$01
               ora  #%00000100
               sta  u6510map       ;$01
               ;-----------------------------------------------------------
               ; On réactive les interruptions du clavier.
               ; BASIC -> poke 56334, peek(56334) or 1
               lda  cia1cra        ;$dc0e, 56334 cia1 control register A
               ora  #%00000001     ;254
               sta  cia1cra        ;$dc0e, 56334 cia1 control register A
               ;-----------------------------------------------------------
               jsr   popreg            ; Récupère les registres.
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
memcopy        .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP

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
 
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend


;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
scrstatic   .block
            #changebord bordure
            #changeback fond
            ;#uppercase
            jsr  drawlines
            jsr  drawallchars
            jsr  drawgrid
            jsr  drawfkeys
            lda  #vrose
            sta  redraw_msg  
            #affichemesg redraw_msg
            #affichemesg quit_msg
            #locate   0,7
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawfkeys      .block
            jsr   pushreg           ; Sauvegarde les registres
            lda  fkeyset
            cmp  #$0
            bne  secondks
            #printcxy titremenu1
            #printcxy f1abutton
            #printcxy f2abutton
            #printcxy f3abutton
            #printcxy f4abutton
            #printcxy f5abutton
            #printcxy f6abutton
            #printcxy f7abutton
            #printcxy f8abutton
            jmp end 
secondks       #printcxy titremenu2
            #printcxy f1bbutton
            #printcxy f2bbutton
            #printcxy f3bbutton
            #printcxy f4bbutton
            #printcxy f5bbutton
            #printcxy f6bbutton
            #printcxy f7bbutton
            #printcxy f8bbutton
end            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawallchars   .block
            jsr pushreg
            #locate   0,0
            ldx  #$00
nextc          txa  
            sta  scrnnewram,x
            lda  #charscolor
            sta  colorram,x
            inx
            cpx  #$80
            bne  nextc
            jsr   popreg            ; Récupère les registres.
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawlines      .block
hline1=4
hline2=6
hline3=18
vlinepos=16
vzplit=scrnnewram+(6*40)+8
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
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
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
drawgrid      .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
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
            lda  #$2e
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
            lda  #$70                  ;+
            sta  scrnnewram+(40*(11))+12
            lda  #$43                  ;-
            sta  scrnnewram+(40*(11))+13  
            lda  #$6e                  ;+
            sta  scrnnewram+(40*(11))+14
            lda  #$5d                  ;|
            sta  scrnnewram+(40*(12))+12
            lda  #$5d                  ;|
            sta  scrnnewram+(40*(12))+14
            lda  #$6d                  ;+
            sta  scrnnewram+(40*(13))+12
            lda  #$43                  ;-
            sta  scrnnewram+(40*(13))+13  
            lda  #$7d                  ;+
            sta  scrnnewram+(40*(13))+14
            jsr screenena
            jsr   popall            ; Récupère registres et pointeur ZP
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
            jsr   pushreg           ; Sauvegarde les registres
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
            jsr   popreg            ; Récupère les registres.
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
            beq  menua
            jmp  menub  
menua          #affichemesg f1a_msg
            #flashfkey f1abutton
            lda  #vgris
            jsr  setmenuacolor
            lda  #menu1col1
            sta  f1abutton
            jsr  drawfkeys
            lda  #vgris
            sta  redraw_msg  
            #affichemesg redraw_msg
            jsr  editor
            lda  #vrose
            sta  redraw_msg  
            #affichemesg redraw_msg
            #affichemesg quit_msg
            #affichemesg menua_msg
            jsr  rstmenucol
            jsr  drawfkeys
            jmp  out
menub          #affichemesg f1b_msg
            #flashfkey f1bbutton
            jsr  flipvert
            jsr  drawbitmap 
out            #affichemesg prompt_msg
            pla
            rts
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
            jsr  copychar
            jsr  drawbitmap
            jmp  out
menub          #affichemesg f2b_msg
            #flashfkey f2bbutton
            jsr  fliphorz
            jsr  drawbitmap           
out            #affichemesg prompt_msg
            pla
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
            #flashfkey f3abutton
            #affichemesg f3a_msg
getagain       jsr  getkey
            cmp  #$31
            beq  devok
            cmp  #$38
            beq  devok
            cmp  #$39
            beq  devok
            jmp  getagain
devok          sta  device
            jsr  getfname
            #affichemesg wait_msg
            jsr  savetofile
            jmp  out
menub          #affichemesg f3b_msg
            #flashfkey f3bbutton
            jsr  scrollright
            jsr  drawbitmap             
out            #affichemesg prompt_msg
            pla
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
            #flashfkey f4abutton
            #affichemesg f4a_msg
getagain       jsr  getkey
            cmp  #$31
            beq  devok
            cmp  #$38
            beq  devok
            cmp  #$39
            beq  devok
            jmp  getagain
devok          sta  device
            jsr  getfname
            #affichemesg wait_msg
            jsr  loadfromfile
            jsr  scrredraw 
            jmp  out
menub          #affichemesg f4b_msg
            #flashfkey f4bbutton
            jsr  scrollleft
            jsr  drawbitmap            
out            #affichemesg prompt_msg
            pla
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
            jsr  clearchar
            jsr  drawbitmap  
            jmp  out
menub          #affichemesg f5b_msg
            #flashfkey f5bbutton
            jsr  scrollup            
            jsr  drawbitmap 
out            #affichemesg prompt_msg
            pla
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
            jsr  fillchar
            jsr  drawbitmap 
            jmp  out
menub          #affichemesg f6b_msg
            #flashfkey f6bbutton
            jsr  scrolldown 
            jsr  drawbitmap            
out            #affichemesg prompt_msg
            pla
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
            jsr  copycharset
            jsr  drawbitmap
            jmp  out
menub          lda  #$0
            sta  editmode
            #affichemesg f7b_msg
            #flashfkey f7bbutton
            jsr  reverse
            jsr  drawbitmap            
out            #affichemesg prompt_msg
            pla
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
f8action       .block
            php
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
            jsr  drawfkeys
            #affichemesg prompt_msg
            pla
            plp
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
reverse        .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage2     mapaddr
            ldy  #$00
again          lda  (zpage2),y
            eor  #$ff
            sta  (zpage2),y
            iny
            cpy  #$08
            bne  again
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
scrollup       .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage1     mapaddr
            #setzpage2     mapaddr
            jsr  inczp2
            ldy  #$00
            lda  (zpage1),y
            sta  tmpbyte
again          lda  (zpage2),y
            sta  (zpage1),y
            iny
            cpy  #$07
            bne  again
            lda  tmpbyte
            sta  (zpage1),y  
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
scrolldown     .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage1     mapaddr
            #setzpage2     mapaddr
            jsr  inczp2
            ldy  #$07             ;xxxxxxxx zpage1
            lda  (zpage1),y          ;xxxxxxxx zpage2
            sta  tmpbyte             ;xxxxxxxx
again          dey                   ;xxxxxxxx
            lda  (zpage1),y          ;xxxxxxxx
            sta  (zpage2),y          ;xxxxxxxx
            cpy  #$00             ;xxxxxxxx
            bne  again            ;xxxxxxxx
            ldy  #$00                   
            lda  tmpbyte
            sta  (zpage1),y  
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
scrollright     .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage1     mapaddr
            ldy  #$00
again          lda  (zpage1),y
            clc
            ror
            bcc  zero
            clc
one            adc  #$80
zero           sta  (zpage1),y
            iny
            cpy  #$08
            bne  again 
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
scrollleft     .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage1     mapaddr
            ldy  #$00
again          lda  (zpage1),y
            clc
            rol
            adc  #$00
            sta  (zpage1),y
            iny
            cpy  #$08
            bne  again 
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
fillchar      .block
            php
            pha
            lda  #$ff
            jsr  allsame
            pla
            plp
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
clearchar      .block
            php
            pha
            lda  #$00
            jsr  allsame
            pla
            plp
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
allsame        .block
            #setzpage2     mapaddr
            ldy  #$00
again          sta  (zpage2),y
            iny
            cpy  #$08
            bne  again
            rts
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
fliphorz       .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage2     mapaddr
            ldy  #$00
nextbyte       lda  (zpage2),y
            ldx  #$00
rolagain       rol
            ror  tmpbyte
            inx
            cpx  #$08
            bmi  rolagain
            lda  tmpbyte
            sta  (zpage2),y     
            iny
            cpy  #$08
            bmi  nextbyte
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
tmpbyte        .byte     $00
            .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
flipvert       .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP
            #setzpage2     mapaddr
            ldy  #$00
tostack        lda  (zpage2),y
            pha
            iny
            cpy  #$08
            bne  tostack
            ldy  #$00
fromstack      pla
            sta  (zpage2),y
            iny
            cpy  #$08
            bne  fromstack
            jsr   popall            ; Récupère registres et pointeur ZP
            rts
            .bend

