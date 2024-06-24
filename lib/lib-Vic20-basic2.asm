;---------------------------------------------------------------------
; Librarie utilisant les Fonctions d'écran du Basic 2.0
;---------------------------------------------------------------------
;---------------------------------------------------------------------
; Initialisation des paramêtres de base pour la gestion de l'écran 
; virtuelle.
;---------------------------------------------------------------------
scrmaninit     .block  
               jsr  push  
               lda  #vnoir
               rol
               rol
               rol
               rol
               ora  #vvert
               ora  #%00001000
               sta  vicbackcol
               lda  #vblanc
               sta  bascol
               lda  #%00000010
               sta  vichorcnt
               jsr  cls
               jsr  pop
               rts
               .bend  
;---------------------------------------------------------------------
; Place le curseur à la position HOME et efface l'écran.
;---------------------------------------------------------------------
cls            .block
               php
               pha
               lda  #$93
               jsr  putch
               ;lda  #$0e
               ;jsr  putch
               lda  #$04
               sta  vichorcnt
               lda  #$1a
               sta  vicvercnt
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Place le caractère A à la position du
; curseur.
;---------------------------------------------------------------------
putch          .block
               php
               jsr  $ffd2
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Affiche la chaine0 pointée par $YYAA
;---------------------------------------------------------------------
puts           .block
               jsr  push
               stx  zpage1
               sty  zpage1+1
               ldy  #$00
next           lda  (zpage1),y
               beq  out
               jsr  putch
               iny
               bne  next 
out            jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
; Positionne le curseyr à la position
; Ligne X, Colonne Y 
;---------------------------------------------------------------------
gotoxy         .block
               jsr  push
               tya
               pha
               txa
               tay
               pla
               tax
               clc
               jsr  kplot
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
; Positionne C=1 ou Sauvegarde C=0 
; le curseur et la couleur par défaut.
;---------------------------------------------------------------------
cursor         .block
bascol    =    $0286
               php
               pha
               bcc  restore
               jsr  kplot
               sty  cx
               stx  cy
               lda  bascol
               sta  bcol
               jmp  out
restore        ldx  cy
               ldy  cx
               jsr  kplot
               lda  bcol
               sta  bascol
out            pla
               plp
               rts
cx   .byte     $00
cy   .byte     $00
bcol .byte     $00
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
cursave        .block
               php
               sec
               jsr  cursor
               plp
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
curput         .block
               php
               clc
               jsr  cursor
               plp
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
putsxy         .block
               php
     ;-------------------------------------------- 
     ; Save start addr
     ;-------------------------------------------- 
               stx  straddr
               sty  straddr+1
     ;-------------------------------------------- 
     ; Save a,y,x
     ;-------------------------------------------- 
               pha
               tya
               pha
               txa
               pha
     ;-------------------------------------------- 
     ;save zpage1
     ;-------------------------------------------- 
               lda  zpage1
               sta  zp1
               lda  zpage1+1
               sta  zp1+1
     ;-------------------------------------------- 
     ;set zpage1
     ;-------------------------------------------- 
               lda  straddr+1
               sta  zpage1+1
               lda  straddr
               sta  zpage1
     ;-------------------------------------------- 
     ; set z to zptr offset 0
     ;-------------------------------------------- 
               ldy  #$00
     ;-------------------------------------------- 
     ; load x param
     ;-------------------------------------------- 
               lda  (zpage1),y
     ;-------------------------------------------- 
     ; and save it
     ;-------------------------------------------- 
               sta  px
     ;-------------------------------------------- 
     ; next param
     ;-------------------------------------------- 
               iny
     ;-------------------------------------------- 
     ; looad y param
     ;-------------------------------------------- 
               lda  (zpage1),y
     ;-------------------------------------------- 
     ; and save it
     ;-------------------------------------------- 
               sta  py
     ;-------------------------------------------- 
     ; tfr a in x reg
     ;-------------------------------------------- 
               tax
     ;-------------------------------------------- 
     ; load x param in y
     ;-------------------------------------------- 
               ldy  px
     ;-------------------------------------------- 
     ; position cursor
     ;-------------------------------------------- 
               jsr  gotoxy
     ;-------------------------------------------- 
     ; adjusting start addr
     ;-------------------------------------------- 
               clc
               inc  straddr
               lda  straddr
               sta  straddr
               bcc  norep1
               inc  straddr+1
norep1         inc  straddr
               bcc  norep2
               inc  straddr+1
norep2         lda  straddr
               ldy  straddr+1
               jsr  puts
               lda  zp1+1
               sta  zpage1+1
               lda  zp1
               sta  zpage1
               pla
               tax
               pla
               tay
               pla
               plp
               rts
straddr   .word     $00
px        .byte     $00
py        .byte     $00
zp1       .word     $00
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
putscxy        .block
               php
     ;-------------------------------------------- 
     ;save start addr
     ;-------------------------------------------- 
               stx  straddr
               sty  straddr+1
     ;-------------------------------------------- 
     ;save a,y,x
     ;-------------------------------------------- 
               pha
               tya
               pha
               txa
               pha
     ;-------------------------------------------- 
     ;save zpage1
     ;-------------------------------------------- 
               lda  zpage1
               sta  zp1
               lda  zpage1+1
               sta  zp1+1
     ;-------------------------------------------- 
     ;set zpage1
     ;-------------------------------------------- 
               lda  straddr+1
               sta  zpage1+1
               lda  straddr
               sta  zpage1
     ;-------------------------------------------- 
     ; set z to zptr offset 0
     ; save  current basiccolor
     ;-------------------------------------------- 
               lda  bascol
               sta  bc
               ldy #$00
     ;-------------------------------------------- 
     ; load color param
     ;-------------------------------------------- 
               lda  (zpage1),y
     ;-------------------------------------------- 
     ; and set it
     ;-------------------------------------------- 
               sta  bascol
     ;-------------------------------------------- 
     ; adjusting start addr
     ;-------------------------------------------- 
               clc
               inc  straddr
               bcc  norep1
               inc  straddr+1
     ;-------------------------------------------- 
     ; get address of remainder
     ;-------------------------------------------- 
norep1         lda  straddr
               ldy  straddr+1
     ;-------------------------------------------- 
     ; print string at x,y pos.
     ;-------------------------------------------- 
               jsr  putsxy
     ;-------------------------------------------- 
     ; restoring basic color
     ;-------------------------------------------- 
               lda  bc
               sta  bascol
     ;-------------------------------------------- 
     ; replacing zpage1 for basic
     ;-------------------------------------------- 
               lda  zp1+1
               sta  zpage1+1
               lda  zp1
               sta  zpage1
               pla
               tax
               pla
               tay
               pla
               plp
               rts
straddr  .word      $00
bc       .byte      $00
zp1      .word      $00
         .bend
;---------------------------------------------------------------------
; Transforme le contenu du registre A en
; hexadécimal et retourne l'adresse de
; la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la 
;          position du curseur.
;---------------------------------------------------------------------
putrahex       .block
               php
               pha
               jsr  a2hex
               lda  #<a2hexstr
               ldy  #>a2hexstr
               jsr  puts
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Transforme le contenu du registre A en
; hexadécimal et retourne 
; l'adresse de la chaine dans X-(lsb) et
; Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la
;          position (a2hexpx,a2hexpy).
; **Note : a2hexpx et a2hexpy doivent
;          être modifiées avant l'appel.
;---------------------------------------------------------------------
kputrahexxy
bputrahexxy    
putrahexxy     .block
               php
               jsr  a2hex
               lda  #<a2hexpos
               ldy  #>a2hexpos
               jsr  putsxy
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Transforme le contenu du registre A en
; hexadécimal et retourne 
; l'adresse de la chaine dans X-(lsb) et
; Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la
;          position (a2hexpx,a2hexpy) et
;          dans la couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy
;          doivent être modifiées avant 
;          l'appel.
;---------------------------------------------------------------------
putrahexcxy    .block
               php
               jsr  a2hex
               lda  #<a2hexpos
               ldy  #>a2hexpos
               jsr  putscxy
               pla
               plp
               rts
               .bend
setinverse     .block
               pha
               lda  #$12
               jsr  $ffd2
               pla
               rts
               .bend
clrinverse     .block
               pha
               lda  #$92
               jsr  $ffd2
               pla
               rts
               .bend

