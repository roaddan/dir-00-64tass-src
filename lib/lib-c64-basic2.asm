;--------------------------------------------------------------------------------
; lib-c64-basic2.asm - Carthographie memoire et declaration de constantes pour
; le Basic 2.0 du commodores 64 et 64c
;--------------------------------------------------------------------------------
; Scripteur...: daniel lafrance, G9B0S5, canada.
; Version.....: 20230610-223618
;--------------------------------------------------------------------------------
; Segmentation principales de la mémoire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass utilisez
; la syntaxes ...
;
;         .include "lib-c64-basic2.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;--------------------------------------------------------------------------------
; Initialisation des paramêtres de base pour la gestion de l'écran 
; virtuelle.
;--------------------------------------------------------------------------------
bkcol=0
bkcol0=0
bkcol1=0
bkcol2=0
bkcol3=0
scrmaninit     .block  
               jsr  push  
               lda  #vbleu
               sta  vicbackcol
               lda  #vvert
               sta  vicbordcol
               lda  #vblanc
               sta  bascol
               lda  scrnram
               ; and  #%11111101   ; entre en conflit avec les ... 
                                   ; ... autres manipulations.
               sta  scrnram
               jsr  cls
               jsr  pop
               rts
               .bend  
;---------------------------------------------------------------------
; Place le curseur à la position HOME et efface l'écran.
;---------------------------------------------------------------------
characterset   .byte b_uppercase
cls            .block
               php
               pha
               lda  #$93
               jsr  putch
               pla
               plp
               rts
               .bend

;---------------------------------------------------------------------
; Place le caractère A à la position du curseur X fois.
;---------------------------------------------------------------------
putnch         .block
               php
               cpx  #$00
               beq  out
again          jsr  $ffd2
               dex
               bne  again
out            plp
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
; Affiche la chaine0 pointée par $YYXX
;---------------------------------------------------------------------
puts           .block
               jsr  push
               stx  zpage1
               sty  zpage1+1
               ldy  #0
next           lda  (zpage1),y
               beq  exit
               jsr  putch
               jsr  inczp1
               jmp  next
               ;jsr  b_outstr_ay
exit           jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
; Positionne le curseyr à la position
; Colonne X, Ligne Y 
;---------------------------------------------------------------------
gotoxy         .block
               php
               clc
               txa
               pha
               tya
               tax
               pla
               tay
               jsr  kplot
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Positionne C=1 ou Sauvegarde C=0 
; le curseur et la couleur par défaut.
;---------------------------------------------------------------------
cursor         .block
bascol    =    $0286
               php            ;tourlou
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
               jsr  push
     ;-------------------------------------------- 
     ; Save start addr
     ;-------------------------------------------- 
               stx  zpage1
               sty  zpage1+1
     ;-------------------------------------------- 
     ; set y to zptr offset 0
     ;-------------------------------------------- 
               ldy  #$00
     ;-------------------------------------------- 
     ; load x param
     ;-------------------------------------------- 
               lda  (zpage1),y
               tax
     ;-------------------------------------------- 
     ; next param
     ;-------------------------------------------- 
               jsr  inczp1
     ;-------------------------------------------- 
     ; looad y param
     ;-------------------------------------------- 
               lda  (zpage1),y
     ;-------------------------------------------- 
     ; and save it
     ;-------------------------------------------- 
               tay
     ;-------------------------------------------- 
     ; position cursor
     ;-------------------------------------------- 
               jsr  gotoxy
     ;-------------------------------------------- 
     ; adjusting start addr
     ;-------------------------------------------- 
               jsr  inczp1
               ldx  zpage1
               ldy  zpage1+1
               jsr  puts
               jsr  pop
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
               jsr  push
     ;-------------------------------------------- 
     ;set zpage1
     ;-------------------------------------------- 
               sty  zpage1+1
               stx  zpage1
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
               jsr  inczp1
     ;-------------------------------------------- 
     ; get address of remainder
     ;-------------------------------------------- 
               ldx  zpage1
               ldy  zpage1+1
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
               jsr  pop
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
               jsr  atohex
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
               jsr  atohex
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
               jsr  atohex
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


