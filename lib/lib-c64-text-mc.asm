;---------------------------------------------------------------------------
; Program ...: VICII Multi Color mode screen managing utilities
; Fichier ...: c64_lib_text_mc.asm
; Auteur ....: Daniel Lafrance     
; Création ..: 2020-01-01     
; Version ...: 22.03.04     
; Dépendance : c64_map_kernal.asm, c64_map_vicii.asm
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
; Variables globales Utilisees par ces fonctions
;---------------------------------------------------------------------------
                                        ; Pour le prochain catactère ...
scrptr         .word     $00            ; ... pointe position ecran, ...
colptr         .word     $00            ; ... pointe position couleur, ...
curcol         .byte     $01            ; ... la couleur du caractère, ...
brdcol         .byte     vbleu          ; ... la couleur de la bordure et
                                        ; ... les couleurs d'arrièere plan:
vicbkcol0      .byte     vnoir  ;$0b    ; 0,
vicbkcol1      .byte     vrouge ;$0b    ; 1,
vicbkcol2      .byte     vvert  ;$0b    ; 2,
vicbkcol3      .byte     vbleu  ;$0b    ; et 3.
inverse        .byte     $00
scraddr        .byte     0,0,0,0,0
coladdr        .byte     0,0,0,0,0
bkcol          .byte     %00000000      ; Pointeur de la couleur actuelle
virtaddr       .word     $0400          ; L'adresse de l'ecran virtuel 
;---------------------------------------------------------------------------
; Macros pour la sélection des couleurs d'arrière plan des caractèeres.
;---------------------------------------------------------------------------
bkcol0         =         %00000000      ; 
bkcol1         =         %01000000
bkcol2         =         %10000000
bkcol3         =         %11000000
;---------------------------------------------------------------------------
; Initialise le pointeur et efface l'ecran.
;---------------------------------------------------------------------------
screeninit
scrmaninit  .block
               php            ; On sauvegarde les registres
               pha
               lda  #%00010101; Selectionne la plage memoire video
               sta  $d018     ; et le jeu de caracteeres.          
     ;---------------------------------------
     ; Registre $18/24 du VIC-II
     ; Role de l'octet place dans $d018
     ;---------------------------------------
     ; bits: 
     ; 76543210         
     ; |||||||0->   Non utilise 
     ; ||||||1--\
     ; |||||2---->  Adresse du jeu de carac. 
     ; ||||3----/     (*2048) (*$800)
     ; ||||
     ; |||4-----\   Video RAM address 
     ; ||5-------\    (*1024) (*$400)
     ; |6--------/    1024, 2018, 3072,
     ; 7--------/     4096, ... 
     ;---------------------------------------
               lda  $d016     ; 53270 Lecture valeur actuelle pour ne 
               ora  #%00010000; modifier que le bit 4.
               and  #%11101111
               sta  $d016 ; 53270
     ;---------------------------------------
     ; Registre $16/22 du VIC-II
     ; Role de l'octet place dans $d016
     ;---------------------------------------
     ; bits: 
     ; 76543210         
     ; |||||||0\   
     ; ||||||1--> Defilement horizontal
     ; |||||2--/ 
     ; |||||
     ; ||||3----> Format 38/40 carac.  
     ; |||4-----> Mode multi-couleur On/Off 
     ; ||5------> Reinitialisation Tjrs 0
     ; |6-------> 
     ; 7--------> Non utilise 
     ;---------------------------------------
               lda  $d011     ; On ne change que le bit 6 pour
               ora  #%01000000; selectionner le md. couleur de
               sta  $d011     ; 53270   ; fond etendu.
     ;---------------------------------------
     ; Registre $11/17 du VIC-II
     ; Role de l'octet place dans $d011
     ;---------------------------------------
     ; bits: 
     ; 76543210         
     ; |||||||0-\
     ; ||||||1---> Defilement verticale
     ; |||||2---/
     ; ||||3----> Md. 24/25 ligne
     ; |||4-----> Inhibe l'affichage 
     ; ||5------> Md. bitmap
     ; |6-------> Md. coul. ext. fond ecran
     ; 7--------> Bit 8 reg. $d012 (Raster)
     ;---------------------------------------
     ; La couleur de l'arriere plan est 
     ; choisi par les bits 6 et 7 du 
     ; caractere affiche.
     ; Dans mode le jeux de caracteeres est
     ; restreind à 64;
     ;---------------------------------------
     ; @ABCDEFGHIJKLMNOPQRSTUVWXYZ[£]^<  
     ;  !"#$%&'()*+,-./0123456789:;<=>?
     ; ou 
     ; @abcdefghijklmnopqrstuvwxyz[£]^<  
     ;  !"#$%&'()*+,-./0123456789:;<=>?
     ;---------------------------------------
     ; Pre selection des quatre couleurs de
     ; fond d'ecran par defaut.
     ;---------------------------------------
               lda  vicbkcol0
               sta  $d021     ; 53281
               lda  vicbkcol1
               sta  $d022     ; 53282
               lda  vicbkcol2
               sta  $d023     ; 53283
               lda  vicbkcol3
               sta  $d024     ; 54284
               lda  bkcol0    ; On charge et utilise la couleur de ...
               sta  bkcol     ; ... fond par defaut des caracteres.
               jsr  cls       ; Finalement on efface l'ecran          
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Replace le curseur virtuel au coin supperieur gauche.
;---------------------------------------------------------------------------
curshome    .block          
               php                      ; Sauvegarde flags ...
               pha                      ; ... et accumulateur
               lda  virtaddr            ; In replace le pointeur ... 
               sta  scrptr              ; ... d'écran virtuel à sa ... 
               lda  virtaddr+1          ; ... position initiale.
               sta  scrptr+1
               jsr  synccolptr          ; On synchronise le ptr couleur.
               lda  vicbkcol0 
               sta  $d021               ; On recharge les couleurs ...
               lda  vicbkcol1           ; ... de fond par defaut tel ...
               sta  $d022               ; ... que specifie dans les ...
               lda  vicbkcol2           ; ... les variables globales.
               sta  $d023 
               lda  vicbkcol3 
               sta  $d024
               pla                      ; Récupère l'accumulateur ...
               plp                      ; ... et les flags
               rts
               .bend
;---------------------------------------------------------------------------
; Incremente le pointeur d'ecran de une position.
;---------------------------------------------------------------------------
incscrptr   .block
               php                      ; Sauvegarde flags ...
               pha                      ; ... et accumulateur
               inc  scrptr              ; Incremente le pointeur
               lda  scrptr              ; Regarde si on doit faire un ... 
               bne  pasdereport         ; ... report dans le MSB
               inc  scrptr+1            ; Si oui on fait le repport
pasdereport    jsr  synccolptr          ; On synchronise le ptr couleur.
               pla                      ; Récupère l'accumulateur ...
               plp                      ; ... et les flags
               rts
               .bend
;---------------------------------------------------------------------------
; Synchronise les pointeurs d'ecran et 
; de couleur.
;---------------------------------------------------------------------------
synccolptr  .block
               php                      ; Sauvegarde flags ...
               pha                      ; ... et accumulateur
     ;---------------------------------------
     ; On conserve le LSB comme offset.
     ;---------------------------------------
               lda  scrptr              ; Récupère le LSB du scrptr ...
               sta  colptr              ; ... pour le placer dans le colptr.
     ;---------------------------------------
     ; Peu importe ou se trouve la 
     ; memoire video, la memoire de 
     ; couleurs se trouve  toujours à 
     ; $d800.           
     ;---------------------------------------
     ; Exemple: 
     ;  Si le curseur est à $0455 - 2009
     ;  On transforme le MSB en masquant 
     ;  les 6 bits les plus significatif
     ;  et en y ajoutant $d8. 
     ;  Ainsi $0455 devient $d855
     ;---------------------------------------
               lda  scrptr+1            ; Récupère le mSB du scrptr, ...
               and  #%00000011          ; ... le converti pour pointer ...
               ora  #%11011000          ; ... la RAM couleur ...
               sta  colptr+1            ; ... et le sauvegarde.
               pla                      ; Récupère l'accumulateur ...
               plp                      ; ... et les flags
               rts
               .bend
;---------------------------------------------------------------------------
; Efface l'ecran avec la couleur voulue 
; et place le curseur à 0,0.
;---------------------------------------------------------------------------
cls            .block
               jsr  push                ; On sauvegarde les registres
               lda  virtaddr            ; On replace le curseur d'ecran à
               sta  scrptr
               lda  virtaddr+1          ; sa position initiale, ($0400).
               sta  scrptr+1
               jsr  synccolptr          ; On synchronise la couleur.
               jsr  scrptr2zp1          ; L'adresse actuelle dans le ZP1.
               lda  brdcol              ; On place la couleur ...
               sta  vicbordcol          ; ... de la bordure.
               lda  bkcol               ; Associer couleur pour ...
               sta  vicbackcol          ; ... remplir l'ecran ...
               lda  #$20                ; ... de caracteres espace. 
               ldx  #4                  ; Quatre blocs de ...
nextline       ldy  #0                  ; ... 256 caracteres.
     ;---------------------------------------
     ; on ecrit l'espace ...
     ;---------------------------------------
nextcar        
               sta  (zpage1),y          ;
     ;---------------------------------------
     ; On sauvegarde le MSB du pointeur 
     ; de caracteere actuel
     ;---------------------------------------
               lda  zpage1+1
               pha
     ;---------------------------------------
     ; On le transforme en pointeur de 
     ; couleur.
     ;---------------------------------------
               and  #%00000011
               ora  #%11011000
     ;---------------------------------------;     
     ; ... et sa couleur, mais dans la
     ; version multi couleur la ram
     ; inutilisee, alors on y met des 0            
     ;---------------------------------------
               sta  zpage1+1
               lda  #0
               sta  (zpage1),y
     ;---------------------------------------
     ; on recupeere le pointeur de 
     ; caractere de la pile.
     ;---------------------------------------
               pla
               sta  zpage1+1
     ;---------------------------------------
     ; On remet un espace dans A
     ;---------------------------------------
               lda  #$20
     ;---------------------------------------
     ; Les 256 ont-ils ete fait ?
     ;---------------------------------------
;               jsr  putch
               dey
               bne  nextcar
     ;---------------------------------------
     ; On passe aux 256 suivants
     ;---------------------------------------
               inc  zpage1+1
     ;---------------------------------------
     ; Les 4 pages de 256 ont elles ete
     ; faites?
     ;---------------------------------------
               dex
               bne  nextcar
     ;---------------------------------------
     ; On replace le curseur à 0
     ;---------------------------------------
               lda  #$00
               sta  scrptr
               lda  #$04
               sta  scrptr+1
     ;---------------------------------------
     ; On synchronise les couleurs
     ;---------------------------------------
               jsr  synccolptr
     ;---------------------------------------
     ; On replace le ZP1 du programme 
     ; appelant.
     ;---------------------------------------
               ;jsr  restzp1
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------------
; Change la couleur du pourtour et sa 
; valeur de reference.
;---------------------------------------------------------------------------
setborder      .block
               php
               sta  brdcol
               sta  vicbordcol
               plp
               rts
               .bend

;---------------------------------------------------------------------------
; Place le flag de l'inverse video pour 
; le prochain caracteere à afficher.
;---------------------------------------------------------------------------
setinverse  .block
               php
               pha
     ;---------------------------------------
     ; En multi couleur on choisi les 
     ; couleurs de fond #2 ou #3 comme 
     ; inverse video.
     ;---------------------------------------
               lda  #%10000000
               sta  inverse
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Retire le flag de l'inverse video pour 
; le prochain caracteere à afficher.
;---------------------------------------------------------------------------
clrinverse     .block
               php
               pha
     ;---------------------------------------
     ; En multi couleur on choisi les 
     ; couleurs de fond #2 ou #3 comme 
     ; inverse video.
     ;---------------------------------------
               lda  #%00000000
               sta  inverse
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche le caracteere dans A à la 
; position/couleur de l'ecran virtuel.
;---------------------------------------------------------------------------
putch          .block              ; Voir Ordinogramme B
               jsr  push           ; On sauvegarde les registres
               jsr  scrptr2zp1     ; Place le ptr d'ecran sur zp1
               and  #%00111111     ; Masque des bits 6 et 7 pour la ouleur.
               ora  bkcol          ; On y ajoute la couleur du fond.
               ldy  #0             ; Met Y à 0
               sta  (zpage1),y     ; Affiche le caractere
               ldx  colptr+1       ; Place le MSB du ptr de couleur
               stx  zpage1+1       ; ... dans le MSB du zp1.
               lda  curcol         ; Charge la couleur voulu dans.
               sta  (zpage1),y     ; ... la ram de couleur.
               jsr  incscrptr      ; Incremente le pointeur d'ecran. 
               jsr  pop            ; Replace tous les registres
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche un caracteres dont l'adresse 
; est dans zp2 à la position et la
; couleur du curseur virtuel.        
;---------------------------------------------------------------------------
z2putch        .block              ; Voir Ordinogramme A
               jsr  push           ; On sauvegarde les registres
               ldy  #$0            ; Met Y à 0
               lda  (zpage2),y     ; Charge le caractere
               jsr  putch          ; Appel pour affichage
               jsr  pop            ; Replace tous les registres
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres 
; dont l'adresse est dans zp2 à la 
; position du curseur virtuel.        
;---------------------------------------------------------------------------
z2puts         .block              ; Voir Ordinogramme C
               jsr  push           ; On sauvegarde les registres
               ldy  #$0            ; Met Y à 0
nextcar        lda  (zpage2),y     ; Charge le caractere 
               beq  endstr         ; Est-ce le 0 de fin de chaine ?
               jsr  z2putch        ; Appel pour affichage
               jsr  inczp2         ; On pointe zp2 sur le prochain caractere.
               jmp  nextcar        ; On passe au prochain  
endstr         jsr  pop            ; Replace tous les registres
               rts
               .bend               
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres à 
; la position du curseur virtuel.        
; ldx <addr        
; ldy >addr       
;---------------------------------------------------------------------------
puts           .block              ; Voir Ordinogramme D
               jsr  push           ; On sauvegarde les registres
               stx  zpage2         ; On positionne xp2 en fonction de
               sty  zpage2+1       ; l'adresse reçcu dans X et Y
               jsr  z2puts         ; Appel pour affichage
               jsr  pop            ; Replace tous les registres
               rts
               .bend    
;---------------------------------------------------------------------------
; Positionne le pointeur de position du
; prochain caractere de l'ecran virtuel. 
;---------------------------------------------------------------------------
gotoxy         .block              ; Voir Ordinogramme E
               jsr  push           ; On sauvegarde les registres
               jsr  curshome       ;  retourne le curseur virtuel a 0,0.
yagain         cpy  #0             ; Devons nous changer de ligne ?
               beq  setx           ; Si non, on verifi les colonnes.
               lda  #40            ; Si oui on ajoute 40
               jsr  saddscrptr     ;  à l'adresse du pointeur virtuel autant 
               dey                 ;  de fois qu'il est spécifié dans y.
               jmp  yagain         ; On passe au prochain y.
setx           txa                 ; On ajoute la valeur de X
               jsr  saddscrptr     ;  à l'adresse di pointeur virtuel.
               jsr  synccolptr     ; Synchro du pointeur des couleurs
               jsr  pop            ; Replace tous les registres
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres 
; dans la couleus C, à la position X, Y 
; qui sont les trois premier octets de 
; ladresse X = MSB, Y = LSB
;---------------------------------------------------------------------------
putsxy         .block              ; Voir Ordinogramme F
               jsr  push           ; On sauvegarde les registres et le zp2
               stx  zpage2         ; Place l'adr de chaine dans zp2
               sty  zpage2+1       ; X = MSB, Y = LSB
               ldy  #0             ; On place le compteur
               lda  (zpage2),y     ; Lecture de la position X
               tax                 ; de A à X
               jsr  inczp2         ; On deplace le pointeur
               lda  (zpage2),y     ; Lecture de la position Y
               tay                 ; de A à Y
               jsr  gotoxy         ; gotoxy : X=col, Y=ligne 
               jsr  inczp2         ; On deplace le pointeur
               jsr  z2puts         ; On imprime la chaine
               jsr  pop            ; Replace tous les registres
               rts
               .bend    
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres 
; dans la couleus C, à la position X, Y 
; qui sont les trois premier octets de 
; ladresse X = MSB, Y = LSB
; Utilisation : Carcol, backno, x, y, texte, 0
;---------------------------------------------------------------------------
putscxy        .block
               jsr  push           ; On Sauvegarde registres et zp2         
               stx  zpage2         ; On place l'adresse de chaine dans zp2
               sty  zpage2+1       ; X = MSB, Y = LSB
               ldy  #0             ; Place le compteur
               lda  (zpage2),y     ; Charge la couleur
               sta  curcol         ; ... et on la definie
               jsr  inczp2         ; Pointe le prochain byte
               lda  (zpage2),y     ; Récupere et sauvegarde ...
               sta  bkcol          ; ... l'index de couleur de fond 
               jsr  inczp2         ; Deplace le pointeur
               lda  (zpage2),y     ; Lecture de la position X
               tax                 ; ... de A à X
               jsr  inczp2         ; Deplace le pointeur
               lda  (zpage2),y     ; Lecture de la position Y
               tay                 ; de A à Y
               jsr  gotoxy         ; gotoxy : X=col, y=ligne 
               jsr  inczp2         ; Place le ptr en début de chaine
               jsr  z2puts         ; On imprime la chaine
               jsr  pop
               rts
               .bend    
;---------------------------------------------------------------------------
; Place A dans le registre de couleur du
; prochain caractere de l'ecran virtuel. 
;---------------------------------------------------------------------------
setcurcol      .block
               php
               sta  curcol
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Place A dans le xieme registre de 
; couleur de l'arriere plan du VIC. 
;---------------------------------------------------------------------------
setvicbkcol    .block
               php
               pha  
               txa
               and  #$03
               tax
               pla
               sta  vicbkcol0,x
               sta  $d021,x
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Place A dans le registre de couleur de
; l'arriere plan du VIC. 
;---------------------------------------------------------------------------
setbkcol    .block
               php
               pha
               asl
               asl
               asl
               asl
               asl
               asl
               and  #$c0
               sta  bkcol
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Deplace le pointeur du caractere
; virtuel de A position. 
;---------------------------------------------------------------------------
saddscrptr  .block
               php
               pha
               clc
               adc  scrptr
               sta  scrptr
               bcc  norep
               inc  scrptr+1
norep          pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Conversion de l'adresse SCRPTR en 
; hexadecimal.
;---------------------------------------------------------------------------
scrptr2str  .block
     ;----------------------------------
     ; on sauvegarde tout
     ;----------------------------------
               jsr  push
     ;----------------------------------
     ; chaine du msb de l'ecran
     ;----------------------------------
               lda  scrptr+1
               pha
               jsr  lsra4bits
               jsr  nib2hex
               sta  scraddr
               pla
               jsr  lsra4bits
               jsr  nib2hex
               sta  scraddr+1
     ;----------------------------------
     ; chaine du msb de la couleur
     ;----------------------------------
               lda  scrptr+1
               pha
               jsr  lsra4bits
               jsr  nib2hex
               sta  scraddr
               pla
               jsr  lsra4bits
               jsr  nib2hex
               sta  scraddr+1
     ;----------------------------------
     ; Chaine du lsb d'ecran et couleur
     ;----------------------------------
               lda  scrptr
               pha
               jsr  lsra4bits
               jsr  nib2hex
               sta  scraddr+2
               sta  coladdr+2
               pla
               jsr  lsra4bits
               jsr  nib2hex
               sta  scraddr+3
               sta  coladdr+3
     ;----------------------------------
     ; on recupere tout
     ;----------------------------------
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------------
; Copie scrptr dans zp1
;---------------------------------------------------------------------------
scrptr2zp1  .block
               php
               pha
               lda  scrptr
               sta  zpage1
               lda  scrptr+1
               sta  zpage1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Copie colptr dans zp1
;---------------------------------------------------------------------------
colptr2zp1   .block
               php
               pha
               lda  colptr
               sta  zpage1
               lda  colptr+1
               sta  zpage1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Copie scrptr dans zp2
;---------------------------------------------------------------------------
scrptr2zp2   .block
               php
               pha
               lda  scrptr
               sta  zpage2
               lda  scrptr+1
               sta  zpage2+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Copie colptr dans zp2
;---------------------------------------------------------------------------
colptr2zp2   .block
               php
               pha
               lda  colptr
               sta  zpage2
               lda  colptr+1
               sta  zpage2+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Transforme le contenu du registre A en
; hexadecimal et retourne l'adresse de
; la chaine dans X-(lsb) et Y-(msb).
; Entree : A
; Sortie : Valeur hexadecimale à la 
;          position du curseur.
;---------------------------------------------------------------------------
putrahex    .block
               php
               pha
               jsr     a2hex
               ldx     #<a2hexcol
               ldy     #>a2hexcol
               jsr     puts
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Transforme le contenu du registre A en
; hexadecimal et retourne l'adresse de
; la chaine dans X-(lsb) et Y-(msb).
; Entree : A
; Sortie : Valeur hexadecimale à la
;          position (a2hexpx,a2hexpy).
; **Note : a2hexpx et a2hexpy doivent 
;          etre modifiees avant l'appel.
;---------------------------------------------------------------------------
putrahexxy  .block
               php
               pha
               jsr  a2hex
               lda  #<a2hexpos
               ldy  #>a2hexpos
               jsr  putsxy
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Transforme le contenu du registre A en
; hexadecimal et retourne l'adresse de
; la chaine dans X-(lsb) et Y-(msb).
; Entree : A
; Sortie : Valeur hexadecimale à la 
;          position (a2hexpx,a2hexpy) et
;          dans la couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy
;          doivent etre modifiees avant 
;          l'appel.
;---------------------------------------------------------------------------
putrahexcxy .block
               php
               pla
               jsr  a2hex
               lda  #<a2hexpos
               ldy  #>a2hexpos
               jsr  putscxy
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; c64_lib_mc Fin
;---------------------------------------------------------------------------
