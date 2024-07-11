;---------------------------------------------------------------------
; Librarie utilisant les Routines d'écran du Basic 2.0.
;---------------------------------------------------------------------
;---------------------------------------------------------------------
; Routine qui Initialisation des paramêtres de base pour la gestion 
; de l'écran virtuelle.
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
; Routine qui place le curseur à la position HOME et efface l'écran.
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
; Routine qui place le caractère A à la position du curseur.
;---------------------------------------------------------------------
putch          .block
               php
               jsr  $ffd2
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Routine qui affiche la chaine0 pointée par $YYAA
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
; Routine qui positionne le curseur à la position rX=Ligne, rY=Colonne. 
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
; Routine qui positionne C=1 ou Sauvegarde C=0 le curseur et la 
; couleur par défaut.
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
; Routine qui sauvegarde la position actuelle du curseur.
;---------------------------------------------------------------------
cursave        .block
               php
               sec
               jsr  cursor
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Routine qui positionne le curseur à la dernière position 
; sauvegardée. (cursave)
;---------------------------------------------------------------------
curput         .block
               php
               clc
               jsr  cursor
               plp
               rts
               .bend
;---------------------------------------------------------------------
; Routine qui affiche et positionne une chaine de caractères se 
; terminant par 0 et précédée par sa position comme suit:
; x,y,"chaine",0
;
; Exemple chaine    .null     2,10,"bonjour!"
;         chaine2   .text     2,11,"au revoir!",0
;                   ldx #<chaine
;                   ldy #>chaine
;                   jsr putsxy    
;---------------------------------------------------------------------
putsxy         .block
               php
               stx  straddr        ; Save start addr
               sty  straddr+1
               pha                 ; Sauvegarde rA 
               tya                 ; Prepare la ...
               pha                 ; ... sauvegarde de rY.
               txa                 ; Prepare la ...
               pha                 ; ... sauvegarde de rX.
               lda  zpage1         ; Save zpage1
               sta  zp1
               lda  zpage1+1
               sta  zp1+1
               lda  straddr+1      ; Set zpage1
               sta  zpage1+1
               lda  straddr
               sta  zpage1
               ldy  #$00           ; Set z to zptr offset 0 ...
               lda  (zpage1),y     ; Load x param
               sta  px             ; and save it
               iny                 ; next param
               lda  (zpage1),y     ; load y param
               sta  py             ; and save it
               tax                 ; tfr a in x reg
               ldy  px             ; load x param in y
               jsr  gotoxy         ; position cursor
               clc                 ; adjusting start addr
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
; Routine qui affiche et positionne une chaine de caractères se 
; terminant par 0 et précédée par sa couleur et sa position comme 
; suit:
;              c, x, y,"chaine",0
;
; Exemple chaine    .null     1,2,10,"bonjour!"
;         chaine2   .text     4,2,11,"au revoir!",0
;                   ldx #<chaine2
;                   ldy #>chaine2
;                   jsr putsxy    
;---------------------------------------------------------------------
putscxy        .block
               php
               stx  straddr        ;save start addr
               sty  straddr+1
               pha                 ;save a,y,x
               tya
               pha
               txa
               pha
               lda  zpage1         ;save zpage1
               sta  zp1
               lda  zpage1+1
               sta  zp1+1
               lda  straddr+1      ;set zpage1
               sta  zpage1+1
               lda  straddr
               sta  zpage1
               lda  bascol         ; save  current basiccolor
               sta  bc
               ldy  #$00           ; set y to zptr offset 0
               lda  (zpage1),y     ; load color param
               sta  bascol         ; and set it
               clc                 ; adjusting start addr
               inc  straddr
               bcc  norep1
               inc  straddr+1
norep1         lda  straddr        ; get address of remainder
               ldy  straddr+1
               jsr  putsxy         ; print string at x,y pos.
               lda  bc             ; restoring basic color 
               sta  bascol
               lda  zp1+1          ; replacing zpage1 for basic
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
straddr        .word      $00
bc             .byte      $00
zp1            .word      $00
               .bend
;---------------------------------------------------------------------
; Routine qui transforme le contenu du registre A en hexadécimal et
; retourne l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position du curseur.
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
; Routine qui transforme le contenu du registre A en hexadécimal et 
; retourne l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position (a2hexpx,a2hexpy).
; **Note : a2hexpx et a2hexpy doivent être modifiées avant l'appel.
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
; Routine qui transforme le contenu du registre A en hexadécimal et
; retourne l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position (a2hexpx,a2hexpy) et
;          dans la couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy doivent être modifiées avant 
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

;---------------------------------------------------------------------
; Routine qui place le drapeau d'inversion de caractère.
;---------------------------------------------------------------------
setinverse     .block
               pha
               lda  #$12
               jsr  $ffd2
               pla
               rts
               .bend

;---------------------------------------------------------------------
; Routine qui annule le drapeau d'inversion de caractère.
;---------------------------------------------------------------------
clrinverse     .block
               pha
               lda  #$92
               jsr  $ffd2
               pla
               rts
               .bend

