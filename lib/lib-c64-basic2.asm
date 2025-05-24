;--------------------------------------------------------------------------------
; Scripteur   : Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: lib-c64-basic2.asm
; Version    : 20230610-223618
; Dernière m.à j. : 20250521
; Inspiration  .: 
;--------------------------------------------------------------------------------
; lib-c64-basic2.asm - Fonctions d'affichage par l'utilisation des routines du 
; rom BASIC du Commodores 64 et 64c. 
;
; Note: Compatibilité avec le Vic-20 à vérifier.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass utilisez
; la syntaxes  
;
;         .include "lib-c64-basic2.asm"
;
;   en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Initialisation des paramêtres de base pour la gestion de l'écran.
;-------------------------------------------------------------------------------
scrmaninit     .block  
               jsr  pushreg        ; Sauvegarde tous les registres
               jsr  screendis      ; Disable screen
               lda  #vbleu         ; Place bleue pour la couleur  
               sta  vicbackcol     ;   d'arrière plan,  
               lda  #vvert         ; vert pour la couleur  
               sta  vicbordcol     ;   de la bordure d'écran,  
               lda  #vblanc        ;   et blanc pour la couleur du  
               sta  bascol         ; texte.
               jsr  cls            ; Efface l'écran.
               jsr  screenena      ; enable screen
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend  

;---------------------------------------------------------------------
; Place le curseur à la position HOME et efface l'écran.
; Entrée  : Aucune.
; Sortie  : Aucune.
;---------------------------------------------------------------------
characterset   .byte b_uppercase
cls            .block
               php                 ; Sauvegarde les registres  
               pha                 ;   modifiés.
               lda  #$93           ; Affiche le code basic de  
               jsr  putch          ;   d'effacement d'écran.
               pla                 ; Récupère les registres  
               plp                 ;   modifiés.
               rts
               .bend

;---------------------------------------------------------------------
; Place le caractère A à la position du curseur X fois.
; Entrée  : Acc le caractère, X le nombre de fois. $00 = 256.
; Sortie  : Aucune.
;---------------------------------------------------------------------
putnch         .block
               jsr  pushreg        ; Sauvegarde tous les registres.
again          jsr  $ffd2          ; On affiche A.
               dex                 ; Un de moins à faire.
               bne  again          ; Si pas à 0 on en affiche encore.
out            jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;---------------------------------------------------------------------
; Place le caractère A à la position du
; curseur.
; Entrée  : Aucune.
; Sortie  : Aucune.
;---------------------------------------------------------------------
putch          .block
               php                 ; Sauvegarde le registre de status.
               jsr  $ffd2          ; Affiche le caractère de Acc.
               plp                 ; Récupère le registre de status.
               rts
               .bend

;---------------------------------------------------------------------
; Affiche la chaine0 pointée par $YYXX
; Entrée  : $YYXX adresse de la chaîne se terminant par 0.
; Sortie  : Aucune.
;---------------------------------------------------------------------
puts           .block
               jsr  pushall        ; Sauvegarde registres, ZP1 et ZP2. 
               stx  zpage1         ; Place l'adresse de la chaine   
               sty  zpage1+1       ;   dans ZP1.
               ldy  #0             ; Initialise l'index du mode (ZP),Y 
next           lda  (zpage1),y     ; Lit un charactère.
               beq  exit           ; Si $00 on sort.
               jsr  putch          ; Affiche le caractères.
               jsr  inczp1         ; Inc. le pointeur ZP1 en 16 bits.
               jmp  next           ; Saute chercher le prochain carac.
exit           jsr  popall         ; Récupère registre, ZP1 et ZP2.
               rts
               .bend

;---------------------------------------------------------------------
; Positionne le curseyr à la position X et Y. 
; Entrée  : X = colonne, Y = ligne.
; Sortie  : Aucune.
;---------------------------------------------------------------------
gotoxy         .block
               php                 ; Sauvegarde le registre de  
               pha                 ;   status et le registre a.
               clc                 ; Carry = 1 pour que kplot  
               txa                 ;   positionne le curseur.
               pha                 ; On inverse X et Y pcq kplot  
               tya                 ;  
               tax                 ;   prend X comme la ligne                    
               pla                 ;  
               tay                 ;   et Y comme la colonne.
               jsr  kplot          ; Positionne le curseur
               pla                 ; Récupère le registre a et  
               plp                 ;   le registre de status.
               rts
               .bend

;---------------------------------------------------------------------
; Positionne C=1 ou Sauvegarde C=0 le curseur et la couleur par défaut.
; Entrée  : Carry = 0 pour sauvegarder, carry = 1 pour récupérer.
; Sortie  : Aucune.
;---------------------------------------------------------------------
cursor         .block
bascol    =    $0286               ; debugme
               jsr  pushreg        ; Sauvegarde tous les registres.
               bcc  restore        ; Si C=0 c'est une récupération.
               jsr  kplot          ; On récupère la position du  
               sty  cx             ;   curseur et on la sauvegarde  
               stx  cy             ;   dans les vars locales.
               lda  bascol         ; On sauvegarde la couleur  
               sta  bcol           ; BASIC du texte.
               jmp  out            ; c'est fini on sort.
restore        ldx  cy             ; Comme C=1, On charge x avec   
               ldy  cx             ;   la ligne, y ace  la col.
               jsr  kplot          ; On positionne le curseur.
               lda  bcol           ; On replace la couleur par basic  
               sta  bascol         ;   sauvegardé.
out            jsr  popreg         ; Récupère tous les registres.
               rts
cx   .byte     $00
cy   .byte     $00
bcol .byte     $00
               .bend

;---------------------------------------------------------------------
; Sauvegarde de la position du curseur.
; Entrée  : Aucune.
; Sortie  : Aucune.
;---------------------------------------------------------------------
cursave        .block
               php
               sec
               jsr  cursor         ; Voir cette fonction plus haut.
               plp
               rts
               .bend

;---------------------------------------------------------------------
; Récupération de la position du curseur.
; Entrée  : Aucune.
; Sortie  : Aucune.
;---------------------------------------------------------------------
curput         .block
               php
               clc
               jsr  cursor         ; Voir cette fonction plus haut.
               plp
               rts
               .bend

;---------------------------------------------------------------------
; Affiche une chaîne de caractères se terminani par 0 à une position
; x,y du curseur. 
; Entrée  : Adresse $YYXX de la chaine de caractères se terminant 
;             par 0.
;             Les deux premiers octets de la chaine forment les 
;             positions X et Y (colonne, ligne) de la position du
;             texte. 
; Sortie  : Aucune.
;---------------------------------------------------------------------
putsxy         .block
               jsr  pushall        ; Sauvegarde registres, ZP1 et ZP2. 
               stx  zpage1         ; On place la position de la  
               sty  zpage1+1       ;   chaine dans le pointeur ZP1.
               ldy  #$00           ; On charge l'index à 0.
               lda  (zpage1),y     ; Charge la coordonné X   
               tax                 ;   dans X.
               jsr  inczp1         ; Inc. le pointeur ZP1 en 16 bits.
               lda  (zpage1),y     ; Charge la coordonnée Y   
               tay                 ; dans Y.
               jsr  gotoxy         ; on positionne le curseur.
               jsr  inczp1         ; Inc. le pointeur ZP1 en 16 bits.
               ldx  zpage1         ; On charge la nouvelle adresse  
               ldy  zpage1+1       ;   de la chaine et on  
               jsr  puts           ;   l'affiche.
               jsr  popall         ; Récupère registre, ZP1 et ZP2.
               rts
straddr   .word     $00
px        .byte     $00
py        .byte     $00
zp1       .word     $00
               .bend

;---------------------------------------------------------------------
; Affiche une chaîne de caractères se terminani par 0 à une position
; x,y du curseur et dans une couleur donnée  
; Entrée  :  Adresse $YYXX de la chaine de caractères se terminant 
;              par 0.
;              Les trois premier octets de la chaine forment la 
;              couleur du texte et les positions X et Y 
;              (colonne, ligne) de la position du texte. 
; Sortie  : Aucune.
;---------------------------------------------------------------------
putscxy        .block
               jsr  pushall        ; Sauvegarde registres, ZP1 et ZP2. 
               stx  zpage1         ; On place la position de la  
               sty  zpage1+1       ;   chaine dans le pointeur ZP1.
               ldy  #$00           ; On charge l'index à 0.
               lda  bascol         ; On sauvegarde la couleur   
               pha                 ;   actuelle de basic.
               lda  (zpage1),y     ; On charge le paramètre de  
               sta  bascol         ;   couleur et le force a Basic.
               jsr  inczp1         ; Inc. le pointeur ZP1 en 16 bits.
               ldx  zpage1         ; On charge la nouvelle adresse  
               ldy  zpage1+1       ;   de la chaine et on  
               jsr  putsxy         ;   l'affiche.
               pla                 ; On replace la couleur basic  
               sta  bascol         ;   que nous avions sauvegardée.
     ;-------------------------------------------- 
     ; replacing zpage1 for basic
     ;-------------------------------------------- 
               jsr  popall         ; Récupère registre, ZP1 et ZP2.
               rts
               .bend

;---------------------------------------------------------------------
; Affiche le contenu du registre A en hexadécimal à la position du
; curseur.
; Entrée  : A
; Sortie  : Valeur hexadécimale à la position du curseur.
;---------------------------------------------------------------------
putrahex       .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  atohex         ; Conversion de a chaîne hexa.
               ldx  #<a2hexstr     ; Charge l'adresse de la chaîne 
               ldy  #>a2hexstr     ;   hexa dans $YYXX. 
               jsr  puts           ; Affiche la chaîne.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;---------------------------------------------------------------------
; Affiche le contenu du registre A en hexadécimal à la position
; déterminé par les deux variables (a2hexpx,a2hexpy).
; Y-(msb).
; **Note : a2hexpx et a2hexpy doivent être modifiées avant l'appel.
; Entrée : A
; Sortie : X=a2hexpx, Y=a2hexpy.
;---------------------------------------------------------------------
kputrahexxy
bputrahexxy    
putrahexxy     .block
               php                 ; Sauvegarde le registre de  
               pha                 ;   status et le registre a.
               jsr  atohex         ; Convertion de a en hexadécimal.
               ldx  #<a2hexpos     ; Charge l'adresse de la chaîne 
               ldy  #>a2hexpos     ;   hexa dans $YYXX. 
               jsr  putsxy         ; Positionne et affiche la chaîne.
               pla                 ; Récupère le registre a et  
               plp                 ;   le registre de status.
               rts
               .bend

;---------------------------------------------------------------------
; Transforme le contenu du registre A en exadécimal dans la couleur et 
; la position déterminé par les trois premier octets de la variable 
; a2hexcol.
; Entrée : A
; Sortie : Valeur hexadécimale à la
;          position (a2hexpx,a2hexpy) et
;          dans la couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy
;          doivent être modifiées avant 
;          l'appel.
;---------------------------------------------------------------------
putrahexcxy    .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  atohex         ; Convertion de a en hexadécimal.
               ldx  #<a2hexpos     ; Charge l'adresse de la chaîne 
               ldy  #>a2hexpos     ;   hexa dans $YYXX. 
               jsr  putsxy         ; Colore, positionne et affiche la
                                   ;   chaîne.
               jsr  popreg         ; Récupère tous les registres.
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


