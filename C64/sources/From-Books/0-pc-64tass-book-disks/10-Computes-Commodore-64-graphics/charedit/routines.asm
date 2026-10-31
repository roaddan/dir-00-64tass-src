;=============================================================================
; Projet...: charedit
; Fichier..: routines.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.1
; Révision.: 2026-10-16
;=============================================================================
; Historique des révisions:
; --------------------------
; 2026-10-16 - Ajout et francisation des commentaires.
;=============================================================================

;=============================================================================
; Routine qui redessine l'écran de travail.
;=============================================================================
scrredraw      .block
               jsr   push           ; Sauvegarde les registres.
               jsr   screendis      ; Inhibe l'affichage
               jsr   cls            ; Efface l'écran
               jsr   drawstatic     ; Affiche les éléments statiques d'écran.
               jsr   drawfkeys      ; Affiche le menu de clefs fonctions.
               lda   currentkey     ; Affiche le caractère actuellement
               ;jsr   drawkeyval    ; ... représenté.
               jsr   drawbitmap     ; Affiche la représentation bitmap du car.
               #putmesg prompt_msg  ; Affiche un invite.
               jsr   screenena      ; Permet l'affichage d'écran.
               jsr   pop            ; Récupère les registres.
               rts                     
               .bend

;=============================================================================
; Routine qui capture un nom de fichier de 6 lettres entré par l'usager.
;=============================================================================
getfname    .block
            jsr   push           ; Sauvegarde les registres.
            #putmesg fname_msg  ; Affiche l'invite.
            ldx  #$00               ; X à 0.
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
finish      #putmesg pfname     ; Affiche le nom du fichier
            jsr   pop            ; Récupère les registres.
            rts
count       .byte     0
            .bend

;=============================================================================
; Routine qui récupère un caractère de a-z et 0-9 dans Acc.
;=============================================================================
getalnum    .block
            jsr   push           ; Sauvegarde les registres.
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
            jsr   pop            ; ... récupèrer les registres.
            lda   tempbyte          ; On le replace dans A.
            rts                     ; On quitte
            .bend

;=============================================================================
; Routine qui copie le bitmap d'un caractère sur le caractère actuel.
;=============================================================================
copychar    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            jsr   getvalidkey       ; On cherche une clef valide.
            ;jsr   getkey
            lda   bitmapaddr        ; On pointe sur la table des bitmaps
            sta   zpage1            ; ... pour copier les octets
            lda   bitmapaddr+1      ; ... de la définition des 
            sta   zpage1+1          ; ... caractères.
            ldx   copykey           ; On ajuste l'offset du pointeur bitmap.
            lda   asciitorom,x      ; Convertie le code ascii en offset dans
            tax                     ; ... la memoire de bitmap.
            cpx   #$00              ; S'il n'y a pas d'offset
            beq   no_offset         ; ... nous sommes nous déja à 0
addagain    lda   #$08              ; On aditionne 8, X fois.
            jsr   zp1addnum         ; On augmente de 8 byte ...
            dex                     ; ... pour chaque caracteres
            bne   addagain          ; si pas fini.
no_offset   lda   mapaddr           ; On place les pointeurs pour faire la
            sta   zpage2            ; ... copie le caractere actuel
            lda   mapaddr+1         ;
            sta   zpage2+1          ;
            ldy   #$08              ; On effectue la copie des 8 octets
nextbyte    lda   (zpage1),y        ; ... constituant l'image bitmap
            sta   (zpage2),y        ; ... du caractère visé.
            dey
            bpl   nextbyte            
out         jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend 

;=============================================================================
; Routine qui récupère une clef entrée par l'utilisateur dont le code ascii 
; correspond à une entrée valide dans la table asciitopetscii présente dans 
; le fichier: l-cbm-keyb.asm 
;=============================================================================
getvalidkey .block
            jsr   push           ; Sauvegarde les registres.
            #putmesg cp_char_msg
getgoodkey  jsr   getkey            ; Obtient une clef.
            sta   copykey           ; Garde une copie de la clef.
            tax                     ; La transfere dans X.
            ldy   asciitorom,x      ; Charge dans Y le 
            cpy   $00
            bne   goodone
            ldx   copykey
            cpx   #$40
            beq   goodone
            jmp   getgoodkey
goodone     jsr   putch
            jsr   pop            ; Récupère les registres.
            rts
            .bend 

;=============================================================================
; Routine qui affiche l'écran de présentation du programme.
;=============================================================================
drawcredits   .block
            jsr   push           ; Sauvegarde les registres.
            jsr   cls               ; Efface l'écran.
            #printcxy whoami0       ; Affiche les 10 lignes du message 
            #printcxy whoami1       ; ... de bienvenue.
            #printcxy whoami2
            #printcxy whoami3
            #printcxy whoami4
            #printcxy whoami5
            #printcxy whoami6
            #printcxy whoami7
            #printcxy whoami8
            #printcxy whoami9
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui affiche le premier caractères au début du programme
;=============================================================================
setdfltchar .block
            jsr   push           ; Sauvegarde les registres.
            lda  #$41
            sta  currentkey         ; In initialise la clef courrante.
            tax                     ; On en cherche le  
            ldy  asciitorom,x       ; ... code petscii.
            sty  bmoffset           ; En memorise l'offset.
;            jsr  drawkeyval         ; Affiche les infos du caractère.
            jsr  drawbitmap         ; Affiche le bitmap.
;            #locate   13,12
;            jsr  putch
;            #locate   11,15
;            jsr  atodec
;            #print    adec
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui rétabli les couleurs normales du menu de clefs fonction.
; Le premier octet de chacune des chaines de menu contien sa couleur.
;=============================================================================
rstmenucol  .block
            jsr   push           ; Sauvegarde les registres.
            lda   #menu1col1        ; Charge la couleur normale des clefs
            sta   f1abutton         ; ... impaires et l'atrribut a tous les
            sta   f3abutton         ; ... menus impairs.
            sta   f5abutton
            sta   f7abutton
            lda   #menu1col2        ; Charge la couleur normale des clefs
            sta   f2abutton         ; ... paires et l'atrribut a tous les
            sta   f4abutton         ; ... menus pairs.
            sta   f6abutton
            sta   f8abutton
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui établie les couleurs du menu A avec la couleurs reçue de l'ACC.
; Le premier octet de chacune des chaines de menu contien sa couleur.
;=============================================================================
setmenuacolor  .block
            jsr   push           ; Sauvegarde les registres.
            sta   f1abutton         ; Attribut la couleur à chacun des menus.
            sta   f2abutton
            sta   f3abutton
            sta   f4abutton
            sta   f5abutton
            sta   f6abutton
            sta   f7abutton
            sta   f8abutton
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui établie les couleurs du menu Bavec la couleurs reçue de l'ACC.
; Le premier octet de chacune des chaines de menu contien sa couleur.
;=============================================================================
setmenubcolor  .block
            jsr   push           ; Sauvegarde les registres.
            sta   f1bbutton         ; Attribut la couleur à chacun des menus.
            sta   f1abutton
            sta   f2bbutton
            sta   f3bbutton
            sta   f4bbutton
            sta   f5bbutton
            sta   f6bbutton
            sta   f7bbutton
            sta   f8bbutton
            ;jsr   drawfkeys
            jsr   pop            ; Récupère les registres.
            rts
            .bend
            
;=============================================================================
; Routine qui affiche le tableau de conversion des valeurs du caractère.
;=============================================================================
drawkeyval     .block
            jsr   push           ; Sauvegarde les registres.
            lda  currentkey         ; Récupère la dernière clef pesée.
            #locate   13,12
            jsr  putch              ; L'affiche dans le carré.
            #locate   12,20
            pha
            lda   #'#'
            jsr   $ffd2
            pla
            jsr  atodec             ; L'affiche en décimal.
            #print   a2decstr
            #locate 1,20            ; Affiche la valeur de la clef en binaire
            pha                     ; Sauvegarde la clef.
            lda  #'%'               ; Le préfixe de Binaire (%).
            jsr  putch              ;
            pla                     ; Récupère la clef.
            pha                     ; Sauvegarde la clef.
            jsr  putabin            ; L'affiche en binaire
            lda  #','               ; ... suivi d'une virgule.
            jsr  putch              ;
            #locate 1,19            ; Positionne le curseur. 
            #print txt1             ; Affiche le texte.
            lda  #'$'               ; Affiche le préfixe de l'hexadécimal.
            jsr  putch
            pla                     ; Récupère la clef.
            jsr  putahex            ; l'affiche en hexadécimal.
            #locate 1,21            ; Affiche l'adresse de la table  
            #print txt2             ; ... des bitmaps 
            lda  #'$'               ; ... préfixée d'un 
            jsr  putch              ; ... $
            lda  bitmapaddr+1       ; ... en hexadecimal
            jsr  putahex            ; ... sur
            lda  bitmapaddr         ; ... 16
            jsr  putahex            ; ... bits.
            #locate 1,22            ; Affiche l'offset dans la table
            #print txt3             ; ... des bitmaps
            lda  #'$'               ; ... préfixée d'un 
            jsr  putch              ; ... $
            lda  bmoffset           ; ... sur 8 bits.
            jsr  putahex            ; ... en hexadecimal.
            #locate 1,23            ; Affiche l'adresse du debut du bitmap 
            #print txt4             ; ... du caractère 
            lda  #'$'               ; ... préfixée d'un 
            jsr  putch              ; ... $
            lda  mapaddr+1          ; ... en hexadecimal.
            jsr  putahex            ; ... sur
            lda  mapaddr            ; ... 16
            jsr  putahex            ; ... bits.
            #locate 1,24            ; Affiche la ligne et la colonne
            #print txt5             ; ... du curseur
            lda  curscl             ; ... (la colonne)
            jsr  putahex            ; ... en hexadécimal
            lda  #$da               ; ... suivi d'un
            jsr  putch              ; ... diamand et de
            lda  cursln             ; ... (la ligne)
            jsr  putahex            ; ... en hexadécimal.
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les action des clef des menus.
;=============================================================================
keyaction   .block
            jsr   push           ; Sauvegarde les registres.
actionloop  jsr   getkey            ; Boucle de récupération de clef.
isitf1      cmp   #key_f1           ; est-ce F1  
            bne   isitf2            ; non, on va voir la prochaine.
            jmp   dof1              ; Oui, On l'exécute.
isitf2      cmp   #key_f2           ; est-ce F2  
            bne   isitf3            ; non, on va voir la prochaine.
            jmp   dof2              ; Oui, On l'exécute.
isitf3      cmp   #key_f3           ; est-ce F3  
            bne   isitf4            ; non, on va voir la prochaine.
            jmp   dof3              ; Oui, On l'exécute.
isitf4      cmp   #key_f4           ; est-ce F4  
            bne   isitf5            ; non, on va voir la prochaine.
            jmp   dof4              ; Oui, On l'exécute.
isitf5      cmp   #key_f5           ; est-ce F5  
            bne   isitf6            ; non, on va voir la prochaine.
            jmp   dof5              ; Oui, On l'exécute.
isitf6      cmp   #key_f6           ; est-ce F6  
            bne   isitf7            ; non, on va voir la prochaine.
            jmp   dof6              ; Oui, On l'exécute.
isitf7      cmp   #key_f7           ; est-ce F7  
            bne   isitf8            ; non, on va voir la prochaine.
            jmp   dof7              ; Oui, On l'exécute.
isitf8      cmp   #key_f8           ; est-ce F8  
            bne   ctrlx             ; non, on va voir la prochaine.
            jmp   dof8              ; Oui, On l'exécute.
ctrlx       cmp   #ctrl_x           ; est-ce CTRL+X  
            bne   ctrlr             ; non, on va voir la prochaine.
            jmp   doquit            ; Oui, On l'exécute.
ctrlr       cmp   #ctrl_r           ; est-ce CTRL+R
            bne   reste              ; non, on va voir la prochaine.
            jmp   doredraw          ; Oui, On l'exécute.
            ;-----------------------------------------------------------------
            ; Il s'agit maintenant d'une autre touche
            ;-----------------------------------------------------------------
reste       ;jsr   drawkeyval
            pha                     ; Mémorise la nouovelle clef
            lda   currentkey        ; ... mémorise   
            sta   previouskey       ; ... l'ancienne
            pla                     ; ... et place la nouvelle clef dans
            sta   currentkey        ; ... la variable à cet effet.
            tax                     ; La clef dans X
            ldy   asciitorom,x      ; Trouve l'offset bitmap de la clef       
            sty   bmoffset          ; ... et le mémorise.
            jsr   drawbitmap
            jmp   actionloop
            ;-----------------------------------------------------------------
dof1        jsr   f1action          ;edit/reverse
            jmp   actionloop
            ;-----------------------------------------------------------------
dof2        jsr   f2action          ;save/flip vert
            jmp   actionloop
            ;-----------------------------------------------------------------
dof3        jsr   f3action          ;load/flip horz
            jmp   actionloop
            ;-----------------------------------------------------------------
dof4        jsr   f4action          ;copy/scroll r
            jmp   actionloop
            ;-----------------------------------------------------------------
dof5        jsr   f5action          ;clear/scroll l
            jmp   actionloop
            ;-----------------------------------------------------------------
dof6        jsr   f6action          ;fill/scroll up
            jmp   actionloop
            ;-----------------------------------------------------------------
dof7        jsr   f7action          ;clear/scroll down
            jmp   actionloop
            ;-----------------------------------------------------------------
dof8        jsr   f8action          ;menub/menua
            jmp   actionloop
            ;-----------------------------------------------------------------
doredraw    jsr   scrredraw         ;Redessine l'écran
            jmp   actionloop
            ;-----------------------------------------------------------------
doquit      
            jsr   pop            ;Retourne à main
            rts
            .bend

;=============================================================================
; Routine qui permet de modifier le bitmap d'un caractère.
;=============================================================================
editor      .block 
            jsr   push           ; Sauvegarde les registres.
            #putmesg exit_msg   ;
            #putmesg edit_msg   ;
            jsr   setcurs           ; Positionne les curseurs.
            lda   currentkey        ; Li la clef actuelle.
            #locate   17,5          ; 
            jsr   atodec            ; Converti a en décimal.
            #print  a2decstr         ; Affiche la valeur décimale.
            jsr   drawbitmap        ; Affiche la matrice de point.
ed_loop     jsr   getkey            ; Récupère une clef.
; --- gestion des touches ---
f1          cmp   #f1key            ; Est-ce F1?
            bne   cu                ; Sinon verifie la prochaine clef.
            jmp   do_ctrlx
cu          cmp   #cursu            ; ESt-ce flèche vers le haut?
            bne   cd                ; Sinon verifie la prochaine clef.
            jmp   do_up
cd          cmp   #cursd            ; ESt-ce flèche vers le bas?
            bne   cl                ; Sinon verifie la prochaine clef.
            jmp   do_down
cl          cmp   #cursl            ; ESt-ce flèche vers la gauche?
            bne   cr                ; Sinon verifie la prochaine clef.
            jmp   do_left
cr          cmp   #cursr            ; ESt-ce flèche vers la droite?
            bne   cx                ; Sinon verifie la prochaine clef.
            jmp   do_right
cx          cmp   #ctrl_x           ; Est-ce CTRL+X?
            bne   sp                ; Sinon verifie la prochaine clef.
            jmp   do_ctrlx
sp          cmp   #$20              ; Est-ce la barre d'espacement?
            bne   ishex14           ; Sinon verifie la prochaine clef.
            jmp   do_swap
ishex14     cmp   #$14              ; Est-ce $14 
            bne   ishex12           ; Sinon verifie la prochaine clef.
            jmp   do_swap           
ishex12     cmp   #$12
            bne   rest              ; Sinon on gère le reste des touches..
            jmp   do_swap
rest        #locate   13,12         ; Positionne le curseur et 
            jsr   putch             ; ... affiche le caractère.
            pha                     ; Réserve la nouvelle clef
            lda   currentkey        ; Sauvegarge l'ancienne 
            sta   previouskey       ; ... clef.
            pla                     ; Récupère la nouvelle clef
            sta   currentkey        ; ... et la mémorise.
            tay                     ; La clef devient l'offset dans la table
            ldx   asciitorom,y      ; ... de convertion ascii à 
            stx   bmoffset          ; petscii et l'offset de la matrice.
            jsr   drawbitmap        ; Affiche la matrice de point
            jmp   ed_loop
;=============================================================================
; Code des actions spécifiques pour certaines touches.
;=============================================================================
do_up       lda   cursln            ; Vérifie si le curseur est déjà 
            cmp   #grid_top         ; ... en haut de la matrice.
            beq   no_up             ; Oui, on le monte pas.

            jsr   clrcurs           ; On efface les curseurs.
            dec   cursln            ; On décrémente la ligne.
            jsr   setcurs           ; On affiche les curseurs.
no_up       jmp   ed_loop           ; On retourne au menu edit.

do_down     lda   cursln            ; Vérifie si le curseur est déjà 
            cmp   #grid_bot         ; ... en bas de la matrice.
            beq   no_down           ; Oui, on le descend pas.

            jsr   clrcurs           ; On efface les curseurs.
            inc   cursln            ; On incrémente la ligne.
            jsr   setcurs           ; On affiche les curseurs.
no_down     jmp   ed_loop           ; On retourne au menu edit.

do_left     lda   curscl            ; Vérifie si le curseur est déjà 
            cmp   #grid_left        ; ... à gauche de la matrice.
            beq   no_left           ; Oui, on le tasse pas à gauche. 

            jsr   clrcurs           ; On efface les curseurs.
            dec   curscl            ; On décrémente la colonne.
            jsr   setcurs           ; On affiche les curseurs.
no_left     jmp   ed_loop           ; On retourne au menu edit.

do_right    lda   curscl            ; Vérifie si le curseur est déjà 
            cmp   #grid_right       ; ... à droite de la matrice.
            beq   no_right          ; Oui, on le tasse pas à droite. 

            jsr   clrcurs           ; On efface les curseurs.
            inc   curscl            ; On incrémente la colonne.
            jsr   setcurs           ; On affiche les curseurs.
no_right    jmp   ed_loop           ; On retourne au menu edit.

do_swap     jsr   do_eor            ; On inverse la matrice.
            jsr   drawbitmap        ; On affiche la matrice.
            jmp   ed_loop           ; On retourne au menu edit.

do_ctrlx    jsr   clrcurs           ; On efface les curseurs.
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue l'inversion bit par bit de la matrice en fonction de la
; position des curseurs.
;=============================================================================
; use     byteaddr,cursln,curscl
do_eor         .block
            jsr   push           ; Sauvegarde les registres.
            lda   mapaddr           ; Place l'adresse 
            sta   zpage2            ; 16 bits de la
            lda   mapaddr+1         ; matrice dans 
            sta   zpage2+1          ; zpage2 ($fe-$fd).
            ldx   cursln            ; Calcul de 
            dex                     ; l'offset de 
            txa                     ; la 
            and   #$f7              ; ligne
            tay                     
            ldx   curscl
            dex
            lda   eorval,x
            eor   (zpage2),y
            sta   (zpage2),y
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui affiche les pointeurs X et Y du curseur d'éditeur de caractère à 
; l'endroit donnée par cursln et curscl.
;=============================================================================
setcurs     .block
            jsr   push           ; Sauvegarde les registres.
            ldx  #grid_left         ; Récupère la position de la colonne
            ldy  cursln             ; ... de la grille.
            jsr  gotoxy             ; ... positionne le curseur
            lda  #$da               ; ... y affiche un 
            jsr  putch              ; ... diamamd.
            ldx  curscl             ; Récupère la colonne
            inx                     ; ... et l'incrémente.
            ldy  #grid_top-1        ; Trouve le haut de la grille
            jsr  gotoxy             ; ... y positionne le curseur
            lda  #$da               ; ... et affiche un autre 
            jsr  putch              ; ... diamand.
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui positionne le curseur au coin sup gauche de la matrice de point.
;=============================================================================
clrcurs     .block
            jsr   push           ; Sauvegarde les registres.
            ldx   #grid_left        ; Récupère la position de la colonne
            ldy   cursln            ; ... de la grille.
            jsr   gotoxy            ; ... positionne le curseur
            lda   #$20              ; ... y affiche un 
            jsr   putch             ; ... espace.
            ldx   curscl            ; Récupère la colonne
            inx                     ; ... et l'incrémente.
            ldy   #grid_top-1       ; Trouve le haut de la grille
            jsr   gotoxy            ; ... y positionne le curseur
            lda   #$20              ; ... et affiche un autre 
            jsr   putch             ; ... espace.
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui affiche la représentation bitmap du caractère choisi.
;=============================================================================
drawbitmap  .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            jsr   calcmapaddr       ; On calcule l'adresse de la matrice.
            jsr   drawkeyval       
drawchar    ldy   #$00              ; On affiche les 8 lignes du caractere  
            ldx   #grid_top         ; On replace la ligne de départ.
            stx   isy+1             ; (Code auto-modifié) 
nextline    jsr   push
            ldx   #grid_left+1      ; la colonne
isy         ldy   #$00              ; la ligne (autoinc)
            jsr   gotoxy
            jsr   pop
            lda   mapaddr           ; On pointe zpage 1 sur 
            sta   zpage1            ; ... l'adresse 
            lda   mapaddr+1         ; ... 16 bits de
            sta   zpage1+1          ; ... la table des bitmaps.
            lda   (zpage1),y        ; On li un octet.
            jsr   atobin            ; Transforme l'octet en binaire ascii ...
            jsr   abintograph       ; ... puis en une série de points.
            #print a2binstr          ; On affiche la ligne.
            inc   isy+1             ; (Code auto-modifié) 
            iny                     ; On passe à la ligne suivante.
            cpy   #$08              ; Avons-nous afficher les 8 octets?
            bmi   nextline          ; Non, on passe à la prochaine.
            jsr   highlight         ; 
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui met le caractere actuel en surbrillance dans la liste..
;=============================================================================
highlight   .block
            jsr   push           ; Sauvegarde les registres.
            ldx  previouskey        ; Replace le caractère précédente
            lda  asciitorom,x       ; ... dans sa 
            tax                     ; ... couleur
            lda  #charscolor        ; ... normale 
            sta  colorram,x         ; ... sur l'écran.
            ldx  currentkey         ; Place le caractère actuel
            lda  asciitorom,x       ; ... dans sa 
            tax                     ; ... couleur
            lda  #charcolor         ; ... surbrillante 
            sta  colorram,x         ; ... sur l'écran.
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui calcule l'adresse de la matrice de points pour le charactère 
; dont l'offset est dans bmoffset et place le résultat dans mapaddr. 
;=============================================================================
calcmapaddr .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            lda   bitmapaddr        ; On pointe zpage1 ($fc$fb) 
            sta   zpage1            ; ... sur l'adresse 16 bits
            lda   bitmapaddr+1      ; ... de la 
            sta   zpage1+1          ; ... table des bitmaps.
            ldx   bmoffset          ; On charge l'offset du caractère
            cpx   #$00              ; Sommes nous déja à 0
            beq   idem              ; Oui, pas d'offset a ajuster.      
plusencore  lda   #$08              ; On ajoute un offset de 8
            jsr   zp1addnum         ; ... au pointeur pour 
            dex                     ; ... chaquun des caracteres
            bne   plusencore        ; ... de la table.
idem        pha                     ; On mémorise Acc.
            lda   zpage1            ; On place l'adresse 16 bits
            sta   mapaddr           ; ... du bitmap du
            lda   zpage1+1          ; ... caractère dana      
            sta   mapaddr+1         ; ... la variable mapaddr.
            pla                     ; On recupère l'Acc.
;            jsr   drawkeyval        ; On affiche le tableau de conversion.
out         jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui convertie une chaine binaire en chaine de points petits et gros.
;=============================================================================
abintograph    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            lda   #<a2binstr         ; Récupère le pointeur
            sta   zpage1            ; ... 16 bits de la 
            lda   #>a2binstr+1       ; ... chaine de caractères 
            sta   zpage1+1          ; ... binaire.
            ldy   #$00              ; Index à 0.
nextbit     lda   (zpage1),y        ; Charge le premier caractère.
            cmp   #$30              ; Est-ce un 0?
            beq   itszero           ; Oui, on le traite.
itsone      lda   #$d1              ; Nous plaçons un gros point
            sta   (zpage1),y        ; ... à la place du 1.
            jmp   next              ; Prochain caractère.
itszero     lda   #$2e              ; Nous plaçons un point 
            sta   (zpage1),y        ; ... à la place du 0.
next        iny                     ; Incrémente l'index.
            cpy   #$08              ; En avons-nous traité 8?
            bmi   nextbit           ; Non! on passe au prochain.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui initialise les pointeurs du VIC-II pour le programme.
;=============================================================================
setscrptr   .block
            jsr   push           ; Sauvegarde les registres.
            ;-----------------------------------------------------------------
            ; Conversion en assembleur de la commande Basic;
            ; BASIC -> print chr$(8)
            ;-----------------------------------------------------------------
            lda  #$08               ; La commande Basic pour inhiber le
            jsr  chrout             ; ... changement de jeu caractères.
            ;-----------------------------------------------------------------
            ; Conversion en assembleur de la commande Basic;
            ; BASIC -> poke 56578,peek(56578) or 3
            ;-----------------------------------------------------------------
;            lda   cia2ddra  ;$dd02, 56578 cia2 data direction A
;            ora   #$00000011
;            sta   cia2ddra  ;$dd02, 56578 cia2 data direction A
;            
            ;-----------------------------------------------------------------
            ; Conversion en assembleur de la commande Basic;
            ; BASIC -> poke 56576, (peek(56576) and 252) or 0
            ;-----------------------------------------------------------------
;            lda   cia2pra   ;$dd00, 56576 cia2 dataport A
;            and   #%11111100
;            ora   #%00000000
;            sta   cia2pra   ;$dd00, 56576 cia2 dataport A
            
            ;-----------------------------------------------------------------
            ; Conversion en assembleur de la commande Basic;
            ; BASIC -> poke 53272, (peek(53272) and 240) or 12
            ;-----------------------------------------------------------------
            lda  vicmemptr      ;$d018, 53272            
            ; vicmemptr
            ;+-------+-------+-------+-------+-------+-------+-------+-------+
            ;|   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
            ;+-------+-------+-------+-------+-------+-------+-------+-------+
            ;|  txt  |  txt  |  txt  |  txt  | chars | chars | chars |       | 
            ;|  scr  |  scr  |  scr  |  scr  |  def  |  def  |  def  |   X   |
            ;| bit 3 | bit 2 | bit 1 | bit 0 | bit 2 | bit 1 | bit 0 |       |
            ;+-------+-------+-------+-------+-------+-------+-------+-------+
            and   #%11110000  ; On conserve les bits 7654 de ce registre ...
                              ;    afin de conserver la mémoire vidéo à $0400.
            ora   #charsdef   ; on place les bits 3210 à %xxxx001x ce qui ...
                              ; ... sélectionne la mémoire du bitmap des ...
                              ; ... charactères à $0800. 
            sta   vicmemptr   ; $d018, 53272

            ;-----------------------------------------------------------------
            ; Conversion en assembleur de la commande Basic;
            ; BASIC -> poke 648, 196            
            ;-----------------------------------------------------------------
;            lda   #%00000100  ;%11000100 ; 196
;            sta   $0288       ; On indique au kernal que la mémoire video ...
;                              ; ... commence à 4 * 256 = 1024
;                              ; 648 - top page of screen memory
            jsr   pop      ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui copie la matrice complète du jeu de caractères de la ROM à la 
; RAM.
;=============================================================================
copycharset .block
            jsr   push           ; Sauvegarde les registres.
            ;-----------------------------------------------------------------
            ; On desactive les interruptions du clavier.
            ; BASIC -> poke 56334, peek(56334) and 254 
            ;-----------------------------------------------------------------
            lda   cia1cra           ;$dc0e, 56334 cia1 control register A
            and   #%11111110        ;254
            sta   cia1cra           ;$dc0e, 56334 cia1 control register A
            ;-----------------------------------------------------------------
            ; On active la rom des bitmaps charactères.     
            ; BASIC -> poke 1, peek(1) and 251
            ;-----------------------------------------------------------------
            lda   u6510map          ;$01
            and   #%11111011        ;251
            sta   u6510map          ;$01
            ;-----------------------------------------------------------------
            ; ici on copy le character-map
            ;-----------------------------------------------------------------
            jsr   memcopy
            ;-----------------------------------------------------------------
            ; On réactive les i/o en replaçant la rom des 
            ; BASIC -> poke 1, peek(1) or 4
            ;-----------------------------------------------------------------
            lda   u6510map          ;$01
            ora   #%00000100
            sta   u6510map          ;$01
            ;-----------------------------------------------------------------
            ; On réactive les interruptions du clavier.
            ; BASIC -> poke 56334, peek(56334) or 1
            ;-----------------------------------------------------------------
            lda   cia1cra           ;$dc0e, 56334 cia1 control register A
            ora   #%00000001        ;254
            sta   cia1cra           ;$dc0e, 56334 cia1 control register A
            ;-----------------------------------------------------------------
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui copie une région mémoire vers une autre.
;=============================================================================
memcopy        .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            lda   startaddr         ; Charge le LSB de l'adresse de départ 
            sta   zpage1            ; ... dans zpage1 ($fb).
            lda   startaddr+1       ; Charge le MSB de l'adresse de départ 
            sta   zpage1+1          ; ... dans zpage1+1 ($fc).
            lda   bitmapaddr        ; Charge le LSB de l'adresse des bitmaps 
            sta   zpage2            ; ... en ram dans zpage2 ($fd).
            lda   bitmapaddr+1      ; Charge le LSB de l'adresse des bitmaps 
            sta   zpage2+1          ; ... en ram dans zpage2+1 ($fe).
            ldy   #$00              ; Index Y à 0.
onemore     lda   (zpage1),y        ; Prend un octet de la rom et 
            sta   (zpage2),y        ; ... la copie en mémoire.
            jsr   inczp1            ; Incrémente les 
            jsr   inczp2            ; ... pointeurs
            lda   zpage1+1          ; Compare le MSB du pointeur avec
            cmp   stopaddr+1        ; ... l'adresse de fin.
            bne   onemore           ; Pas encore à cette page, on continue.
            lda   zpage1            ; Compare le LSB du pointeur avec
            cmp   stopaddr          ; ... l'adresse de fin.
            bne   onemore           ; Pas encore à la fin, on continue.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui affiche les éléments statiques de l'écran.
;=============================================================================
drawstatic  .block
            #changebord bordure
            #changeback fond
            ;#uppercase              ; Bloque le système en majuscule/graph. 
            jsr  drawlines          ; Affiche tout ce qui est ligne à l'écran.
            jsr  drawchars          ; Affiche les 128 caractères à l'écran
            jsr  drawgrid           ; Affiche la grille de bitmap. 
            jsr  drawfkeys          ; Affiche le menu de clefs fonction.
            #putmesg redraw_msg ; Affiche le message pour CTRL-R.
            #putmesg quit_msg   ; Affiche le message pour CTRL-X.
            rts
            .bend

;=============================================================================
; Routine qui affiche le menu de clefs fonction du menu 1 ou 2 selon la variable
; fkeyset.
;=============================================================================
drawfkeys      .block
            jsr   push           ; Sauvegarde les registres.
            lda  fkeyset            ; On vérifie dans quel menu nous 
            cmp  #$0                ; somme présentement
            bne  secondks           ; Pas 0, alors on affiche le second menu.
            #printcxy titremenu1    ; Affiche ... le titre
            #printcxy f1abutton     ; ... le F1,
            #printcxy f2abutton     ; ... le F2,
            #printcxy f3abutton     ; ... le F3,
            #printcxy f4abutton     ; ... le F4,
            #printcxy f5abutton     ; ... le F5,
            #printcxy f6abutton     ; ... le F6,
            #printcxy f7abutton     ; ... le F7
            #printcxy f8abutton     ; ... ainsi que le F8.
            jmp end 
secondks    #printcxy titremenu2    ; Affiche ... le titre
            #printcxy f1bbutton     ; ... le F1,
            #printcxy f2bbutton     ; ... le F2,
            #printcxy f3bbutton     ; ... le F3,
            #printcxy f4bbutton     ; ... le F4,
            #printcxy f5bbutton     ; ... le F5,
            #printcxy f6bbutton     ; ... le F6,
            #printcxy f7bbutton     ; ... le F7
            #printcxy f8bbutton     ; ... ainsi que le F8.
end         jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui affiche tous les 128 caractères principaux directement dans la 
; mémoire vidéo et la mémoire des couleurs.  
;=============================================================================
drawchars   .block
            jsr   push           ; Sauvegarde les registres.
;            #locate   0,0
            ldx   #$00              ; Index à 0.
nextc       txa                     ; On fait un caractère de l'index.
            sta   scrnnewram,x      ; On affiche directement en ram vidéo.
            lda   #charscolor       ; On charge la couleur.
            sta   colorram,x        ; On la place en ram couleur. 
            inx                     ; Incrémente l'index.
            cpx   #$80              ; Sommes nous à la fin?
            bne   nextc             ; Non!, on saute au prochain.
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui affiche toute les lignes de l'écran statique.
;=============================================================================
drawlines   .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            ldx   #40               ; Un index à 40 (décimal).
            lda   #64               ; On charge le caractère dans l'Acc.
nextl       sta   scrnnewram+(40*hline1)-1,x  ; On imprime les deux grande
            sta   scrnnewram+(40*hline2)-1,x  ; lignes horizontales
            dex                     ; Décrémente l'index.
hline       cpx   #vlinepos         ; Sommes-nous à l'intersection?
            bpl   notyet            ; Non, pas encore.
            sta   scrnnewram+(40*hline3),x    ; On imprime la demiligne horz.
notyet      cpx   #$00              ; Avons-noous terminé?
            bne   nextl             ; Non!, on saute au prochain.
            ; On imprime le caractere de jonction (t) au dessus de la 
            ; ... ligne vert.
            lda   #<scrnnewram+(40*(hline2))+vlinepos
            sta   zpage1            ; Charge l'adresse 16 bit de l'écran
            lda   #>scrnnewram+(40*(hline2))+vlinepos
            sta   zpage1+1          ; ... pour tracer la ligne verticale.
            ldy   #0                ; Index à 0.
            lda   #114              ; Charge l'Acc. avec le caractère. 
            sta   (zpage1),y        ; Affiche dans la mémoire vidéo.
            jsr   zp1add40          ; Ajoute 40 au pointeur.
            ; On imprime ensuite les characteres de la ligne vert
            ldx   #24-hline2        ; Charge l'index de départ.
            lda   #93               ; Une ligne verticale.
another93   sta   (zpage1),y        ; Place dans la mémoire vidéo.
            jsr   zp1add40          ; Ajoute 40 au pointeur.
            dex                     ; Une ligne de moins à faire.
            bne   another93         ; Si pas fini on en fait une autre.
            ; On imprime le joint se la ligne vert et la demi 
            ; ... ligne horz.
            lda   #<scrnnewram+(40*(hline3))+vlinepos
            sta   zpage1            ; Charge l'adresse 16 bit de l'int- 
            lda   #>scrnnewram+(40*(hline3))+vlinepos
            sta   zpage1+1          ; ... -ersection des ligne ver et hor.
            ldy   #0                ; Index à 0.
            lda   #115              ; Une intersection hor-ver droite. 
            sta   (zpage1),y        ; On l'écrit dans la mémoire vidéo.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui affiche la grille de la matrice de point.
;=============================================================================
drawgrid    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            jsr   screendis         ; Inhibe la mise à jour de l'écran.
            lda   #<scrnnewram+(40*(grid_top))+grid_left
            sta   zpage1            ; Charge l'adresse 16 bits de la position
            lda   #>scrnnewram+(40*(grid_top))+grid_left
            sta   zpage1+1          ; ... de la grille bitmap à l'écran.
            ldx   #8                ; Il y a 8 ligne de point.
nextbox     lda   #101              ; Ligne horizontale
            ldy   #9                ; Index à 9.
            sta   (zpage1),y        ; On en place une
            dey                     ; Décrémente l'index.
            lda   #$2e              ; Un point.
nextcol     sta   (zpage1),y        ; On en place .
            dey                     ; Décrémente l'index.
            bne   nextcol           ; Si pas fini on en met un autre.
            jsr   zp1add40          ; On ajoute 40 au pointeur.
            dex                     ; Une ligne en moins à faire.
            bne   nextbox           ; On branche si pas fini.
            ldy   #8                ; Index à 8
            lda   #119              ; Une ligne horizontale haute..
nextlin     sta   (zpage1),y        ; On la place en mémoire vidéo.
            dey                     ; Décrémente l'index.
            bne   nextlin           ; Pas fini? on en fait une autre.
            lda   #$3e              ; 62 = le signe ">"
            sta   scrnnewram+(40*(12))+11
            lda   #$70              ; Un coin sup gauche.
            sta   scrnnewram+(40*(11))+12
            lda   #$43              ; Le signe "+".
            sta   scrnnewram+(40*(11))+13  
            lda   #$6e              ; Un coin suppérieur droit.
            sta   scrnnewram+(40*(11))+14
            lda   #$5d              ;| Une ligne verticale.
            sta   scrnnewram+(40*(12))+12
;            lda   #$5d              ;| Une ligne verticale.
            sta   scrnnewram+(40*(12))+14
            lda   #$6d              ; Un coin inférieur gauche.
            sta   scrnnewram+(40*(13))+12
            lda   #$43              ; Le sighe "+".
            sta   scrnnewram+(40*(13))+13  
            lda   #$7d              ; Le joint hor-ver droit
            sta   scrnnewram+(40*(13))+14
            jsr   screenena         ; Permet l'affichage de l'écran.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui ajoute l'accumulateur au pointeur 16 bits zpage1
;=============================================================================
zp1addnum   .block
            php                     ; Sauvegarde minimaliste des 
            pha                     ; ... registres.
            clc                     ; Carry à 0.
            adc  zpage1             ; Calcule Zpage1 + Acc. + Carry.
            bcc  nocarry            ; Si Carry encore à 0, pas de report.
            inc  zpage1+1           ; Si report à faire.
nocarry     sta  zpage1             ; Sauvegarde le LSB.
            pla                     ; Récupération minimaliste des
            plp                     ; ... registres.
            rts
            .bend
;=============================================================================
; Routine qui ajoute le nombre 40 au pointeur 16 bits zpage1.
;=============================================================================
zp1add40    .block
            php                     ; Sauvegarde minimaliste des 
            pha                     ; ... registres.
            lda   #40               ; Ajouter 40 avec l'aide 
            jsr   zp1addnum         ; ... de zp1addnum.    
            pla                     ; Récupération minimaliste des
            plp                     ; ... registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue un delais d'environ une seconde sur un C64 NTSC.
;=============================================================================
delay       .block
            jsr   push           ; Sauvegarde les registres.
            ldx   #$00              ; 2 cycles.
            ldy   #$00              ; 2 cycles.
xagain      dex                     ; 2 cycles. ;-------------\
yagain      dey                     ; 2 cycles. ;-\            \
            nop                     ; 2 cycles. ;  \            \ 3843 cycles
            nop                     ; 2 cycles. ;   \            \ *256
            nop                     ; 2 cycles. ;   / 15 cycles   \ =983808
            nop                     ; 2 cycles. ;  /  * 256       / *1,023 MHz
            cpy   #$00              ; 2 cycles. ; / =3840 cycles / =1006435us
            bne   yagain            ; 3 cycles. ;/              / ou 1,006s
            cpx   #$00              ; 2 cycles. ;              / 
            bne   xagain            ; 3 cycles. ;-------------/ 
            jsr   pop            ; Récupère les registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F1.
; A) Edition de matrice.
; B) Permutation verticale.
;=============================================================================
f1action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            beq   menua             ; On saute au menu a.
            jmp   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F1A. Edition de matrice.
            ;-----------------------------------------------------------------
menua       lda   #$ff              ; On se met en mode édition.
            sta   editmode          ; Drapeau pour indiquer le mode edition.
            #putmesg f1a_msg    ; Affiche l'invite de f1a.
            #flashfkey f1abutton    ; Clignotte le menu sélectionné.
            lda   #vgris            ; Du gris
            jsr   setmenuacolor     ; ... pour les autres options.
            lda   #menu1col1        ; Surbrillance pour
            sta   f1abutton         ; ... l'option choisie.
            jsr   drawfkeys         ; Redessine le menu.
            lda   #vgris            ; Le gris pour
            sta   redraw_msg        ; ... le messages redessiner
            #putmesg redraw_msg ; ... que nous affichons.
            jsr   editor            ; On invoque la fonction d'étition.
            lda   #vrose            ; Le gris pour
            sta   redraw_msg        ; ... le messages redessiner 
            #putmesg redraw_msg ; ... que nous affichons.
            #putmesg menua_msg  ; Réaffiche le menu a
            jsr   rstmenucol        ; Restaure les couleurs du menu.
            jsr   drawfkeys         ; Redessine les clefs fonction.
            lda   #$00              ; On sort du mode édition.
            sta   editmode          ; Drapeau pour indiquer le mode edition.
            jmp   out               ; On sort du menu f1A
            ;-----------------------------------------------------------------
            ; Action du menu F1B. Permutation verticale.
            ;-----------------------------------------------------------------
menub       #putmesg f1b_msg    ; Affiche le message menu f1b.
            #flashfkey f1bbutton    ; Clognotte l'option choisi.
            jsr   flipvert          ; On permute verticalement le bitmap.
            jsr   drawbitmap        ; On redessine les affichages bitmap.
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F2.
; A) Copier d'un autre caractère.
; B) Permutation horizontale.
;=============================================================================
f2action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F2A. Copier d'un autre caractère.
            ;-----------------------------------------------------------------
menua       #putmesg f2a_msg    ; Affiche l'invite de f2a.
            #flashfkey f2abutton    ; Clignotte le menu sélectionné.
            jsr   copychar          ; Effectue la copie du caractèreé
            jsr   drawbitmap        ; Redessine les information.
            jmp   out               ; On sort.
            ;-----------------------------------------------------------------
            ; Action du menu F2b. Permutation horizontale.
            ;-----------------------------------------------------------------
menub       #putmesg f2b_msg    ; Affiche l'invite de f2b.
            #flashfkey f2bbutton    ; Clignotte le menu sélectionné.
            jsr   fliphorz          ; Effectue la permutation horiz. des bits. 
            jsr   drawbitmap        ; Redessine les information.          
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F3.
; A) Sauvegarde de la matrice sur medium.
; B) Décallage d'un bit vers la droite.
;=============================================================================
f3action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F3A. Sauvegarde de la matrice sur medium.
            ;-----------------------------------------------------------------
menua       #putmesg f3a_msg    ; Affiche l'invite de f3a.
            #flashfkey f3abutton    ; Clignotte le menu sélectionné.
getagain    jsr   getkey            ; Récupère une clef
            cmp   #$31              ; Le lecteur cassette ?
            beq   devok             ; ... Oui.
            cmp   #$38              ; Le lecteur de disque #8? 
            beq   devok             ; ... Oui.
            cmp   #$39              ; Le lecteur de disque #9? 
            beq   devok             ; ... Oui.
            jmp   getagain          ; On redemande le # de périphérique.
devok       and   #$0f              ; On masque le MSN.
            sta   device            ; On sauvegarde le # de périphérique.
            jsr   getfname          ; On requière un nom de fichier.
            #putmesg prompt_msg ; Affiche l'invite.
            jsr   savefile          ; Enregistre le fichier.
            jmp   out               ; On sort.
            ;-----------------------------------------------------------------
            ; Action du menu F3B. Décallage d'un bit vers la droite.
            ;-----------------------------------------------------------------
menub       #putmesg f3b_msg    ; Affiche l'invite de f3b.
            #flashfkey f3bbutton    ; Clignotte le menu sélectionné.
            jsr   scrollright       ; Décallage d'un bit vers la droite.
            jsr   drawbitmap        ; Redessine les information.             
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F4.
; A) Récupère de la matrice sur medium.
; B) Décallage d'un bit vers la gauche.
;=============================================================================
f4action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F4A. Récupère de la matrice sur medium.
            ;-----------------------------------------------------------------
menua       #putmesg f4a_msg    ; Affiche l'invite de f4a.    
            #flashfkey f4abutton    ; Clignotte le menu sélectionné.
getagain    jsr   getkey            ; Récupère une clef
            cmp   #$31              ; Le lecteur cassette ?
            beq   devok             ; ... Oui.
            cmp   #$38              ; Le lecteur de disque #8? 
            beq   devok             ; ... Oui.
            cmp   #$39              ; Le lecteur de disque #9? 
            beq   devok             ; ... Oui.
            jmp   getagain          ; On redemande le # de périphérique.
devok       and   #$0f              ; On masque le MSN.
            sta   device            ; On sauvegarde le # du périphérique.
            jsr   getfname          ; On récupère le nom du fichier.
            #putmesg wait_msg   ; On demande d'attendre.
            jsr   loadfile          ; Récupère de la matrice d'un medium.
            jsr   scrredraw         ; On redessine l'écran complet.
            jmp   out               ; On sort.
            ;-----------------------------------------------------------------
            ; Action du menu F4B. Décallage d'un bit vers la gauche.
            ;-----------------------------------------------------------------
menub       #putmesg f4b_msg    ; Affiche l'invite de f4b.
            #flashfkey f4bbutton    ; Clignotte le menu sélectionné.
            jsr   scrollleft        ; Décallage d'un bit vers la gauche.
            jsr   drawbitmap        ; Redessine les information.            
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F5.
;=============================================================================
f5action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F5A.
            ;-----------------------------------------------------------------
menua       #putmesg f5a_msg    ; Affiche l'invite de f5a.
            #flashfkey f5abutton    ; Clignotte le menu sélectionné.
            jsr   clearchar         ; PLace tous les bits à 0.
            jmp   out               ; On sort.
            ;-----------------------------------------------------------------
            ; Action du menu F5B.
            ;-----------------------------------------------------------------
menub       #putmesg f5b_msg    ; Affiche l'invite de f5b.
            #flashfkey f5bbutton    ; Clignotte le menu sélectionné.
            jsr   scrollup          ; Décale la matrice vers le haut.
out         jsr   drawbitmap        ; Redessine les information. 
            #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F6.
;=============================================================================
f6action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F6A.
            ;-----------------------------------------------------------------
menua       #putmesg f6a_msg    ; Affiche l'invite de f6a.
            #flashfkey f6abutton    ; Clignotte le menu sélectionné.
            jsr   fillchar          ; PLace tous les bits à 1.
            jsr   drawbitmap        ; Redessine les information. 
            jmp   out               ; On sort.
            ;-----------------------------------------------------------------
            ; Action du menu F6B.
            ;-----------------------------------------------------------------
menub       #putmesg f6b_msg    ; Affiche l'invite de f6b.
            #flashfkey f6bbutton    ; Clignotte le menu sélectionné.
            jsr   scrolldown        ; Décale la matrice vers le bas.
            jsr   drawbitmap        ; Redessine les information.            
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F7.
;=============================================================================
f7action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F7A.
            ;-----------------------------------------------------------------
menua       #putmesg f7a_msg    ; Affiche l'invite de f7a.
            #flashfkey f7abutton    ; Clignotte le menu sélectionné.
            jsr   copycharset       ; Recopie le jeu de caractères de la ROM.
            jsr   drawbitmap        ; Redessine les information.
            jmp   out               ; On sort.
            ;-----------------------------------------------------------------
            ; Action du menu F7B.
            ;-----------------------------------------------------------------
menub       #putmesg f7b_msg    ; Affiche l'invite de f7b.
            #flashfkey f7bbutton    ; Clignotte le menu sélectionné.
            jsr   reverse           ; Inverse les bits du bitmap.
            jsr   drawbitmap        ; Redessine les information.            
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue les actions de la touche F8.
;=============================================================================
f8action    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   fkeyset           ; Identifie le jeu de clef actuel.
            bne   menub             ; si 1 menu B, JMP pour long saut. 
            ;-----------------------------------------------------------------
            ; Action du menu F8A.
            ;-----------------------------------------------------------------
menua       #putmesg menub_msg  ; Affiche l'invite de f8a.
            #flashfkey f8abutton    ; Clignotte le menu sélectionné.
            jmp   swapit            ; Permute les menus d'action.
            ;-----------------------------------------------------------------
            ; Action du menu F8B.
            ;-----------------------------------------------------------------
menub       #putmesg menua_msg  ; Affiche l'invite de f8b.
            #flashfkey f8bbutton    ; Clignotte le menu sélectionné.            
swapit      eor   #$ff              ; Permute les
            sta   fkeyset           ; ... menus d'action.
            jsr   drawfkeys         ; Redessine le menu.
out         #putmesg prompt_msg ; Affiche l'invite.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui effectue l'actions d'inverser la matrice de points.
;=============================================================================
reverse     .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage2  mapaddr     ; Positionne zpage2 ($fe,$fd) sur mapaddr.
            ldy   #$00              ; Un index à 0.
again       lda   (zpage2),y        ; On charge la matrice du caractère 
            eor   #$ff              ; ... pour l'inverser et 
            sta   (zpage2),y        ; ... le remettre.
            iny                     ; On fait toute la matrice 
            cpy   #$08              ; ... un octet à la fois
            bne   again             ; ... pour les 8 octets.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui décale la matrice de points d'un bit vers le haut.
;=============================================================================
scrollup    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fc,$fb) sur mapaddr.
            #setzpage2  mapaddr     ; Positionne zpage2 ($fe,$fd) sur mapaddr.
            jsr   inczp2            ; On incremente zpage2.
            ldy   #$00              ; Index à 0
            lda   (zpage1),y        ; On prend le premier ictet de la matrice
            sta   tmpbyte           ; ... et on le mémorise.
again       lda   (zpage2),y        ; On decale les octets suivant 
            sta   (zpage1),y        ; ... vers le haut du caractère.
            iny                     ; On avance l'index.
            cpy   #$07              ; En sommes-nous au septième?
            bne   again             ; Non, on continue.
            lda   tmpbyte           ; On récupère le premier octet et 
            sta   (zpage1),y        ; ... on le place en dernier.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui décale la matrice de points d'un bit vers le bas.
;=============================================================================
scrolldown  .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fc,$fb) sur mapaddr.
            #setzpage2  mapaddr     ; Positionne zpage2 ($fe,$fd) sur mapaddr.
            jsr   inczp2            ; On incrémente zpage2.
            ldy   #$07              ; Index à 7
            lda   (zpage1),y        ; On mémorise le dernier octet 
            sta   tmpbyte           ; ... de la matrice.
again       dey                     ; On recule l'index.
            lda   (zpage2),y        ; On decale les octets suivant 
            sta   (zpage1),y        ; ... vers le bas du caractère.
            cpy   #$00              ; En sommes-nous à l'avant dernier?
            bne   again             ; Non, on continue.
            ldy   #$00              ; Index à 0.  
            lda   tmpbyte           ; On récupère le dernier octet et 
            sta   (zpage1),y        ; ... on le place en premier.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui décale la matrice de points d'un bit vers la droite.
;=============================================================================
scrollright .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fc,$fb) sur mapaddr.
            ldy   #$00              ; Index à 0.
again       lda   (zpage1),y        ; On prend une ligne de la matrice.
            clc                     ; Carry à 0.
            ror                     ; Rotation des bit vers la droite.
            bcc   zero              ; Carry est-il à 0?
one         ora   #$80              ; Non, on place le bit 7 à 1.
zero        sta   (zpage1),y        ; Oui, on sauvegarde.
            iny                     ; Incremente l'index.
            cpy   #$08              ; Avons-nous fait les 8 octets?
            bne   again             ; Non, on continue.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui décale la matrice de points d'un bit vers la gauche.
;=============================================================================
scrollleft  .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fc,$fb) sur mapaddr.
            ldy   #$00              ; Index à 0.
again       lda   (zpage1),y        ; On prend une ligne de la matrice.
            clc                     ; Carry à 0.
            rol                     ; Rotation des bit vers la gauche.
            adc   #$00              ; On ajoute le carry au bit 0.
            sta   (zpage1),y        ; On sauvegarde.
            iny                     ; Incremente l'index.
            cpy   #$08              ; Avons-nous fait les 8 octets?
            bne   again             ; Non, on continue.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui place des 1 partout dans la matrice de points.
;=============================================================================
fillchar    .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   #$ff              ; Pour avoir tous les bits à 1.
            jsr   allsame           ; On en remplie la matrice.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui place des 0 partout dans la matrice de points.
;=============================================================================
clearchar   .block
            php                     ; Sauvegarde minimaliste 
            pha                     ; ... des registres.
            lda   #$00              ; Pour avoir tous les bits à 0.
            jsr   allsame           ; On en remplie la matrice.
            pla                     ; Récupération minimaliste
            plp                     ; ... des registres.
            rts
            .bend

;=============================================================================
; Routine qui place la valeur de l'Acc dans toutes les ligne de la matrice.
;=============================================================================
allsame     .block
            jsr   push           ; Sauvegarde tous les registres.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fc,$fb) sur mapaddr.
            ldy   #$00              ; Index à 0.
again       sta   (zpage1),y        ; On remplace un octet de la matrice.
            iny                     ; Incremente l'index.
            cpy   #$08              ; Sommes-nous au huitième.
            bne   again             ; Non. on en fait un autre.
            jsr   pop            ; Récupère toous les registres.      
            rts
            .bend

;=============================================================================
; Routine qui bascule la matrice de points horizontalement.
;=============================================================================
fliphorz    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fe,$fd) sur mapaddr.
            ldy   #$00              ; Place 0 
            sty   tmpbyte           ; ... dans l'octet temporaire.
            ldy   #$07              ; Index à 7.
nextbyte    lda   (zpage1),y        ; Charge un octet de la matrice.
            ldx   #$07              ; On le fait sur 8 bits.
rolagain    rol                     ; On place le bit 7 dans carry
            ror   tmpbyte           ; ... et carry dans le bit 0.
            dex                     ; Décremente l'index X.
            bpl   rolagain          ; 0 et plus on continue.
            lda   tmpbyte           ; Charge l'octet temporaire dans Acc
            sta   (zpage1),y        ; ... et remplace l'octet de la matrice.
            dey                     ; Décremente l'index X.
            bpl   nextbyte          ; 0 et plus on continue.
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui bascule la matrice de points verticalement.
;=============================================================================
flipvert    .block
            jsr   pushall           ; Sauvegarde registres et pointeur ZP.
            #setzpage1  mapaddr     ; Positionne zpage1 ($fe,$fd) sur mapaddr.
            ldy   #$07              ; Index à 7.
tostack     lda   (zpage1),y        ; Charge un octet de la matrice
            pha                     ; ... et le place sur la pile.
            dey                     ; Décrémente l'index.
            bpl   tostack           ; 0 et plus on continue. 
            ldy   #$07              ; Index à 7.
fromstack   pla                     ; Récupère l'octet de la pile
            sta   (zpage1),y        ; ... et le sauvegarde dans la matrice.
            dey                     ; Décrémente l'index.
            bpl   fromstack         ; 0 et plus on continue. 
            jsr   popall            ; Récupère registres et pointeur ZP.
            rts
            .bend

;=============================================================================
; Routine qui sauvegarde les bitmaps dans un fichier.
;=============================================================================
savefile    .block
            jsr   pushall           ; Sauvegarde les registres
            lda   #<fname           ; Charge l'adresse 16 bits
            sta   dsk_fnptr         ; ... du pointeur de nom
            lda   #>fname           ; ... de fichier dans
            sta   dsk_fnptr+1       ; ... le pointeur standard du Kernal.
            lda   #(device-fname-1) ; Charge la longueur du nom de fichier       
            sta   dsk_fnlen         ; ... la place dans la variable du Kernal.
            lda   device            ; Charge le no de périphérique 
            and   #$0f              ; ... le masque pour limiter la valeur.
            sta   dsk_lfsno         ; ... le place dans la variable du Kernal
            sta   dsk_dev           ; ... pour les no. primaire et secondaire.
            lda   #<bitmapmem       ; Copie l'adresse 16 bits du debut de la 
            sta   dsk_data_s        ; ... matrice de point dans l'espace 
            lda   #>bitmapmem       ; ... réservée à cet 
            sta   dsk_data_s+1      ; ... effet.
            lda   #<endofaddr       ; Copie l'adresse 16 bits de la fin de la
            sta   dsk_data_e        ; ... matrice de point dans l'espace 
            lda   #>endofaddr       ; ... réservée à cet 
            sta   dsk_data_e+1      ; ... effet.
            #printcxy blankmsg      ; Efface la zone de message.
            #printcxy wait_msg      ; Affiche un message d'attente.
            #locate 1,4             ; Place le curseur colonne 2, ligne 5.
            jsr   memtofile         ; Appelle la fonction de sauvegarde ram.
            jsr   popall            ; Récupère tous les registres.
            rts
            .bend

;=============================================================================
; Routine qui récupère les bitmaps d'un fichier.
;=============================================================================
loadfile    .block
            jsr   pushall
            lda   #<fname
            sta   dsk_fnptr
            lda   #>fname
            sta   dsk_fnptr+1
            lda   #(device-fname-1)
            sta   dsk_fnlen
            lda   device
            and   #$0f
            sta   dsk_dev
            sta   dsk_lfsno
            lda   #<bitmapmem
            sta   dsk_data_s
            lda   #>bitmapmem
            sta   dsk_data_s+1
            lda   #<endofaddr
            sta   dsk_data_e
            lda   #>endofaddr
            sta   dsk_data_e+1
            #printcxy blankmsg
            #printcxy wait_msg
            #locate 1,4
            jsr   filetomem
            jsr   popall
            rts
            .bend
;=============================================================================
; Routine qui attend la touche A.
;=============================================================================
attend_a    .block
            php
            pha
            lda   #$41
            pha
            jsr   $ffd2
            pla
            jsr   waitkey
            pla
            plp
            rts
            .bend  


