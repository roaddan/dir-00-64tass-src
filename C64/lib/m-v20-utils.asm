;-----------------------------------------------------------------------------
; Nom du fichier .: m-v20-utils.asm
;-----------------------------------------------------------------------------
; fichier......: m-utils.asm (seq)
; type fichier.: macros
; auteur.......: daniel lafrance
; version......: 0.0.1
; revision.....: 20151126
;-----------------------------------------------------------------------------
; Notes de développement.
; Récupérer en immediat l'octet en paramètre......:  #\param
; Récupérer le LSB du pointeur en paramètre.......:  #<\param
; Récupérer le MSB du pointeur en paramètre.......:  #>\param
; Manipuler la donnée du pointeur en paramètre..:  \param 


;    

;-----------------------------------------------------------------------------
; Affichage d'un caractere par kernal.
;-----------------------------------------------------------------------------
outcar      .macro car
            php
            pha
            lda   #\car       ; Récupérer en immediat l'octet en paramètre.
            jsr chrout
            pla
            plp
            .endm        
;-----------------------------------------------------------------------------
; Affiche une chaine par le kernal
;-----------------------------------------------------------------------------
outstr      .macro      sptr
            jsr   pushall
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            sty   zp1+1
            stx   zp1
            jsr   puts
            jsr   popall
            .endm
;-----------------------------------------------------------------------------
; Affiche une chaine par le kernal
;-----------------------------------------------------------------------------
outstrxy    .macro      sptr
            jsr   pushregs
            ldy   \sptr+1     ; Manipuler la donnée du pointeur en paramètre.
            ldx   \sptr       ; Manipuler la donnée du pointeur en paramètre.
            jsr   gotoxy
            ldy   #>\sptr+2   ; Récupérer le MSB du pointeur en paramètre.
            ldx   #<\sptr+2   ; Récupérer le LSB du pointeur en paramètre.
            jsr   putsyx
            jsr   popregs
            .endm

;-----------------------------------------------------------------------------
; Deplace le curseur a la position (x,y).
;-----------------------------------------------------------------------------
locate      .macro      x, y
            jsr   pushregs
            ldy   #\x         ; Récupérer en immediat l'octet en paramètre.
            ldx   #\y         ; Récupérer en immediat l'octet en paramètre.
            clc
            jsr   plot
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Place tous les regiatres sur la pile.
;-----------------------------------------------------------------------------
mpushr      .macro
            php
            pha
            txa
            pha
            tya
            pha
            .endm
;-----------------------------------------------------------------------------
; Récupère toous les registres de la pile.
;-----------------------------------------------------------------------------
mpopr       .macro   
            pla
            tay
            pla
            tax
            pla
            plp
            .endm        
;-----------------------------------------------------------------------------
; Lcount est une valeur 16 bits passée en immediat.
;-----------------------------------------------------------------------------
setloop     .macro      lcount
            php
            pha
            lda   #<\lcount   ; Récupérer le LSB du pointeur en paramètre.
            sta   loopcount
            lda   #>\lcount   ; Récupérer le MSB du pointeur en paramètre.
            sta   loopcount+1
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Inhibe le changement de jeu de caractères par les touches [C=]+[SHIFT].
;-----------------------------------------------------------------------------
disable     .macro   
            php
            pha
            lda  #$08
            jsr  $ffd2
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Permet le changement de jeu de caractères par les touches [C=]+[SHIFT].
;-----------------------------------------------------------------------------
enable      .macro   
            php
            pha
            lda  #$09
            jsr  $ffd2
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Charge dans $YYXX le contenu 16 bits de l'adresse par ptr.
;-----------------------------------------------------------------------------
loadxymem   .macro    ptr
            php
            ldx   \ptr        ; Manipuler la donnée du pointeur en paramètre.
            ldy   \ptr+1      ; Manipuler la donnée du pointeur en paramètre.
            plp
            .endm
;-----------------------------------------------------------------------------
; Charge dans $YYXX l'adresse ptr.
;-----------------------------------------------------------------------------
loadxyimm   .macro    ptr
            php
            ldx   #>\xyimm    ; Récupérer le MSB du pointeur en paramètre.
            ldy   #<\xyimm    ; Récupérer le LSB du pointeur en paramètre.
            plp
            .endm

;-----------------------------------------------------------------------------
; Sélectionne et mémorise le jeu de caractères Minuscule/Majuscule.
;-----------------------------------------------------------------------------
lowercase .macro   
            php
            pha
            lda   #14
            jsr   $ffd2
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Sélectionne le jeu de caractères Majuscule/Graphique.
;-----------------------------------------------------------------------------
uppercase .macro   
            php
            pha
            lda   #upcase
            jsr   $ffd2
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Change la couleur de la bordure de l'écran du Vic20.
;-----------------------------------------------------------------------------
changebord  .macro    c
            php
            pha
            lda   #\c         ; Récupérer en immediat l'octet en paramètre.
            and   #%00000111
            sta   freevar
            lda   vic15
            and   #%11111000
            ora   freevar
            sta   vic15
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Change la couleur du fond d'écran du Vic20.
;-----------------------------------------------------------------------------
changeback  .macro    c
            php
            pha
            lda   #\c         ; Récupérer en immediat l'octet en paramètre.
            asl
            asl
            asl
            asl
            sta   freevar
            lda   vic15
            and   #%00001111
            ora   freevar
            sta   vic15
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur immitant le commodore 64.
;-----------------------------------------------------------------------------
couleursc64 .macro   
            #changebord vbleu
            #changeback vbleup
            #color vbleu
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur jaune/blanc/noir
;-----------------------------------------------------------------------------
mescouleurs .macro   
            #changebord vjaune
            #changeback vblanc
            #color vnoir
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeux de couleur à l'écran du Vic20.
;-----------------------------------------------------------------------------
scrcolors   .macro    fg, bg, tx  
            php       
            pha
            lda #(\bg*16+(\fg|8))
            sta vic15
            lda #\tx    ; Récupérer en immediat l'octet en paramètre.
            sta kcol
            lda #147
            jsr $ffd2
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur immitant le commodore 64 au texte blanc.
;-----------------------------------------------------------------------------
c64blanc    .macro   
            jsr  pushregs
            #changebord vbleu
            #changeback vbleup
            #color vblanc
            jsr  popregs
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur au démarrage du vic 20.
;-----------------------------------------------------------------------------
couleursv20 .macro   
            jsr  pushregs
            #changebord vocean
            #changeback vblanc
            #color vbleu
            jsr  popregs
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur Texte blanc sur écran noir.
;-----------------------------------------------------------------------------
grisaille   .macro   
            jsr  pushregs
            #changebord vnoir
            #changeback vnoir
            #color vblanc
            jsr  popregs
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur Aux teinte de rose..
;-----------------------------------------------------------------------------
colrose     .macro   
            jsr  pushregs
            #changebord vrouge
            #changeback vrose
            #color vmauve
            jsr  popregs
            .endm
;-----------------------------------------------------------------------------
; Met en place un jeu de couleur sans bordure.
;-----------------------------------------------------------------------------
monoscreen  .macro      col, back
            jsr   pushregs
            #changebord \back ; Manipuler la donnée du pointeur en paramètre.
            #changeback \back ; Manipuler la donnée du pointeur en paramètre.
            #color      \col  ; Manipuler la donnée du pointeur en paramètre.
            jsr  popregs
            .endm
;-----------------------------------------------------------------------------
; Change la couleur du texte pour les prochains affichages.
;-----------------------------------------------------------------------------
color       .macro       col
            php
            pha
            lda   #\col       ; Récupérer en immediat l'octet en paramètre.
            sta   kcol
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Affiche une chaine de caractères sptr à la position du curseur.
;-----------------------------------------------------------------------------
print       .macro    sptr
            jsr   pushall
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            stx   $fb
            sty   $fc
            jsr   puts
            jsr   popall
            .endm
;-----------------------------------------------------------------------------
; Affiche une chaine de caractères sptr à la position du curseur suivi d'un 
; retour de chariot.
;-----------------------------------------------------------------------------
println     .macro    sptr
            jsr   pushregs
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            stx   $fb
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            sty   $fc
            jsr   puts
            lda   #$0d
            jsr   chrout
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Affiche une chaine de caractères sptr à la position (x,y) .
;-----------------------------------------------------------------------------
print_xy    .macro      x,y,sptr
            jsr   pushregs
            ldy   #\x         ; Récupérer en immediat l'octet en paramètre.
            ldx   #\y         ; Récupérer en immediat l'octet en paramètre.
            clc
            jsr   plot
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            jsr   putsyx
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Change la couleur et affiche une chaine de caractères sptr à la position 
; (x,y).
;-----------------------------------------------------------------------------
print_cxy   .macro      c,x,y,sptr
            jsr   pushregs
            lda   bascol
            pha 
            lda   #\c         ; Récupérer en immediat l'octet en paramètre.
            sta   bascol
            ldy   #\x         ; Récupérer en immediat l'octet en paramètre.
            ldx   #\y         ; Récupérer en immediat l'octet en paramètre.
            clc
            jsr   plot
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            jsr   putsyx
            pla
            sta   bascol
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Affiche une chaine de caractères à une position donnée par les deux premiers 
; octets de la chaine.
;-----------------------------------------------------------------------------
printxy     .macro    sptr
            jsr   pushregs
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            jsr   putsxy
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Affiche une chaine de caractères dans une couleurs donnée par le premier 
; octet de la chaine et à une position donnée par les octets 1 et 2  
; de la chaine.
;-----------------------------------------------------------------------------
printcxy    .macro    sptr
            jsr   pushregs
            ldx   #<\sptr     ; Récupérer le LSB du pointeur en paramètre.
            ldy   #>\sptr     ; Récupérer le MSB du pointeur en paramètre.
            jsr   putscxy
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Affiche la chaine sptr précédé du prefixte prfx.
;-----------------------------------------------------------------------------
printfmt    .macro    prfx, sptr
            jsr   pushregs
            lda   #\prfx      ; Récupérer en immediat l'octet en paramètre.
            jsr   chrout
            #print \sptr      ; Manipuler la donnée du pointeur en paramètre.
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Affiche la chaine sptr à la position  donnée par les paramètres (x,y).
;-----------------------------------------------------------------------------
printpos    .macro    x,y,sptr
            jsr   pushregs
            #locate \x,\y     ; Manipuler la donnée du pointeur en paramètre.
            #print \sptr      ; Manipuler la donnée du pointeur en paramètre.
            jsr   popregs
            .endm

;-----------------------------------------------------------------------------
; Affiche à la position (x,y) la chaine sptr précédé du prefixte prfx.
;-----------------------------------------------------------------------------
printfmtxy  .macro    x,y,prfx,sptr
            jsr   pushregs
            #locate \x,\y     ; Manipuler la donnée du pointeur en paramètre.
            #printfmt \prfx,\sptr 
            jsr   popregs
            .endm
;-----------------------------------------------------------------------------
; Affiche le contenue 16 bits d'une adresse en binaire.
;-----------------------------------------------------------------------------
printwrdbin .macro    adresse
            jsr   pushall
            lda   \adresse    ; Manipuler la donnée du pointeur en paramètre.
            sta   zpage1
            lda   \adresse+1  ; Manipuler la donnée du pointeur en paramètre.
            sta   zpage1+1
            ldy   #$01 
            lda   (zpage1),y
            jsr   atobin
            #printfmt "%", binstr
            dey
            lda   (zpage1),y
            jsr   atobin
            #print binstr
            jsr   popall
            .endm
;-----------------------------------------------------------------------------
; Sauve le contenu de $YYXXà l'adresse ptr.
;-----------------------------------------------------------------------------
styxmem     .macro      ptr
            php
            sty   \ptr+1      ; Manipuler la donnée du pointeur en paramètre.
            stx   \ptr        ; Manipuler la donnée du pointeur en paramètre.
            plp
            .endm
;-----------------------------------------------------------------------------
; Charge le contenu de l'adresse ptr dans $YYXX
;-----------------------------------------------------------------------------
ldyxmem     .macro      ptr
            php
            ldy   \ptr+1      ; Manipuler la donnée du pointeur en paramètre.
            ldx   \ptr        ; Manipuler la donnée du pointeur en paramètre.
            plp
            .endm
;-----------------------------------------------------------------------------
; Charge l'adresse ptr dans $yyxx.
;-----------------------------------------------------------------------------
ldyxptr     .macro      ptr
            php
            ldy #>\ptr        ; Récupérer le MSB du pointeur en paramètre.
            ldx #<\ptr        ; Récupérer le LSB du pointeur en paramètre.
            plp
            .endm
;-----------------------------------------------------------------------------
; Charge le contenu de l'adresse ptr dans les registre ($AAXX).
;-----------------------------------------------------------------------------
ldaxval     .macro      ptr
            php
            ldx   \ptr        ; Manipuler la donnée du pointeur en paramètre.
            lda   \ptr+1      ; Manipuler la donnée du pointeur en paramètre.
            plp
            .endm
;-----------------------------------------------------------------------------
; Charge l'adresse ptr dans les registre ($AAXX).
;-----------------------------------------------------------------------------
ldaxptr     .macro      ptr
            php
            ldx   #<\ptr      ; Récupérer le LSB du pointeur en paramètre.
            lda   #>\ptr      ; Récupérer le MSB du pointeur en paramètre.
            plp
            .endm
;-----------------------------------------------------------------------------
; Place dans zpage1 le contenue 16 bits situé à l'adresse ptr.
;-----------------------------------------------------------------------------
ldzpage1    .macro      ptr
            php
            pha
            lda   \ptr        ; Manipuler la donnée du pointeur en paramètre.
            sta   zpage1
            lda   \ptr+1      ; Manipuler la donnée du pointeur en paramètre.
            sta   zpage1+1
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Place le pointeur ptr dans zpage1.
;-----------------------------------------------------------------------------
setzpage1   .macro    ptr
            php
            pha
            lda  #<\ptr    ; Récupérer le LSB du pointeur en paramètre.
            sta  $fb
            lda  #>\ptr    ; Récupérer le MSB du pointeur en paramètre.
            sta  $fc
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Place dans zpage2 le contenue 16 bits situé à l'adresse ptr.
;-----------------------------------------------------------------------------
ldzpage2    .macro      ptr
            php
            pha
            lda   \ptr        ; Manipuler la donnée du pointeur en paramètre.
            sta   zpage2
            lda   \ptr+1      ; Manipuler la donnée du pointeur en paramètre.
            sta   zpage2+1
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; Place le pointeur ptr dans zpage2.
;-----------------------------------------------------------------------------
setzpage2   .macro    ptr
            php
            pha
            lda  \ptr ; Manipuler la donnée du pointeur en paramètre.
            sta  $fd
            lda  \ptr+1 ; Manipuler la donnée du pointeur en paramètre.
            sta  $fe
            pla
            plp
            .endm
;-----------------------------------------------------------------------------
; charge un ptr dans zpage2
;-----------------------------------------------------------------------------
styxzp1     .macro
            sty zp1+1
            stx zp1
            .endm
;-----------------------------------------------------------------------------
; charge un ptr dans zpage2
;-----------------------------------------------------------------------------
styxzp2     .macro
            sty zp2+1
            stx zp2
            .endm

