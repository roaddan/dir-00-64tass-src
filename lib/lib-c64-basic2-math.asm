;--------------------------------------------------------------------------------
; Scripteur ........: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier ...: lib-c64-basic2-math.asm
; Cernière m.à j. ..: 20250521
; Inspiration ......: Vic-20 and Commodore 64 Tool Kit: Basic by Dan Heeb.
; ISBN .............: 0-942386-32-9 
; Section du livre .: Direct Use of Floarting Point (Pages 19 à 40)
;--------------------------------------------------------------------------------
b_math_template
               .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend
;--------------------------------------------------------------------------------
; N O T E : Dans les commentaire les acronymes suivant signifient :
;
; √ "P.F." = "Point Flottant".
; √ conv.   = conversion     
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Variables publiques communes.
;--------------------------------------------------------------------------------
b_bufflenght   .byte     $00
b_num1         .word     $0000,$0000,$0000
b_num2         .word     $0000,$0000,$0000
b_num0
b_numresult    .word     $0000,$0000,$0000
b_testnum      .null     "128"

;------------------------------------------------------------------------------
; Convertion de Accum et X-reg ($AAXX) en chaine décimal ascii.
; Entrée: A=MSB, X=LSB
; Pour charger les registres a and x utilisez les macros   
;            loadaxmem pour un contenu mémoire ou   
;            loadaximm pour le mode immédiat.    
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 1 de la page 25.
;------------------------------------------------------------------------------
b_praxstr          .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_axout
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; M a c r o s   p o u r   p e u p l e r   A A X X .
;------------------------------------------------------------------------------
loadaxmem      .macro axadd
               php
               ldx  \axadd         ; Charge lsb de l'adresse dans X.
               lda  \axadd+1       ; Charge msb de l'adresse dans A.
               plp
               .endm

loadaximm      .macro aximm
               php
               ldx  #<\aximm       ; Charge dans X le LSB de la valeur imm.
               lda  #>\aximm       ; Charge dans A le MSB de la valeur imm.
               plp
               .endm
;------------------------------------------------------------------------------
; Récupère un nombre à partir du périphérique d'entrée et le sauvegarde en 
; ASCII dans le tampon d'éditeur de ligne de BASIC et sauvegarde la longueur de
; la chaîne dans la variable b_bufflenght.
; Entrée  .: STDIN
; Sortie  .: Tampon de ligne Basic et la variable b_bufflenght.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 2, page 26.
;------------------------------------------------------------------------------
b_getascnum     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_intcgt       ; Initialise charget
               jsr  b_clearbuff    ; Efface le tampon d'entrée de BASIC.
               jsr  b_prompt       ; Affiche ? et peuple de tampon d'entrée de 
                                   ;   BASIC.
               stx  $7a            ; X and Y pointent vers $01ff au retour.
               sty  $7b
               jsr  b_chrget       ; Lit un jeton du périphérique d'entrée.
               jsr  b_ascflt       ; Conv. ASCII de l'adresse 0200 vers FAC1.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  b_getbufflen   ; Calcule la longueur de la chaîne dans var. 
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend               

;------------------------------------------------------------------------------
; Sous-routine commune pour effacer le tampon de commande BASIC.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 2, page 26.
;------------------------------------------------------------------------------
b_clearbuff     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               lda  #$00           ; Place des $00 à toutes adresses de 
               ldy  #$59           ;   $1a6 à $200 pour effacer le
clear          sta  $0200,y        ;   tampon d'entrée de BASIC.
               dey                 ; 
               bne  clear          ; 60 octets.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Affiche le nombre P.F. sauvegardé en ascii dans le tampon d'édition de ligne
; BASIC.
; Entrée  : Récupère la longueur de la chaîne de b_bufflenght.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 2, page 26.
;------------------------------------------------------------------------------
b_printbuff     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               lda  #$00           ; Positionne le vecteur $0022 et 
               sta  $22            ;   $0023 pour quLil pointe vers
               lda  #$01           ; l'adresse $0100.
               sta  $23
               lda  b_bufflenght   ; Charge la longueur de la chaîne.
               jsr  b_strout       ; Affiche la chaine
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Recoit un nombre de l'éditeur et le convertie en point flottant dans FAC1.
; Sortie  .: FAC1 contient le nombre en format PF 
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 3, page 27.
;------------------------------------------------------------------------------
b_insub          .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_intcgt       ; Initialise CHRGET.
               jsr  b_clearbuff    ; Efface le tampon d'entrée de BASIC.
               jsr  b_prompt       ; Affiche ? et peuple de tampon d'entrée de 
                                   ;   BASIC. 
               stx  $7a
               sty  $7b
               jsr  b_chrget       ; Lit un jeton du périphérique d'entrée.
               jsr  b_ascflt       ; Conv. la chaîne ascii en PF dans FAC1.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Lecture d'un point flottant à partir de la mémoire.
; Sortie  : La Variable b_bufflenght contient la longueur de la chaîne.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 4, page 27.
;------------------------------------------------------------------------------
b_readmemfloat     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_intcgt       ; Initialisation de CHRGET.
               lda  $7a            ; Sauvegarde des valeurs actuelles des cases
               sta  b_v7a          ;   mémoires $007a et $007b. 
               lda  $7b
               sta  b_v7b
               ldx  #<(b_testnum-1); Initialise le pointeur FVAR à l'adresse de
               stx  $7a            ; - 
               ldy  #>(b_testnum-1); - 
               sty  $7b            ; - la variable -1.
               jsr  b_chrget       ; Lit un jeton du périphérique d'entrée.
               jsr  pushreg        ; Sauvegarde tous les registres.
               ldx  #<(b_num1)     ; Copie de FAC1 dans la variable b_num1. 
               ldy  #>(b_num1)     ;   
               jsr  b_f1tmem       ; 
               jsr  b_f1x10        ; Multiplie FAC1 par 10.
               ldx  #<(b_num2)     ; Copie de FAC1 dans la variable b_num2.
               ldy  #>(b_num2)     ;   
               jsr  b_f1tmem       ; 
               ldx  #<(b_num0)     ; Copie de FAC1 dans la variable b_num0.
               ldy  #>(b_num0)     ; 
               jsr  b_f1tmem       ; 
               jsr  b_prhexbnum1   ; Affiche b_num1 en hexadécimal.
               jsr  popreg         ; Récupère tous les registres.
               jsr  b_ascflt       ; Conv. chaîne ASCII vers P.F. dans FAC1.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  b_getbufflen   ; Calcule la longueur de la chaîne dans var. 
               lda  b_v7a          ; Récupération des valeurs initiales des 
               sta  $7a            ;   cases mémoires $007a et $007b.
               lda  b_v7b          ;  
               sta  $7b            ;
               jsr  b_clearbuff    ; Efface le tampon d'entrée de BASIC.
               jsr  popreg         ; Récupère tous les registres.
               rts
; Variables locale privées
b_v7a          .byte     $00
b_v7b          .byte     $00
               .bend

;------------------------------------------------------------------------------
; Multiplication de FAC1 et FAV et place le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 5, page 28.
;------------------------------------------------------------------------------
b_mul2fptomem     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 dans $0057.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_f1xfv        ; Effectue la multiplication 
                                   ; FAC1 = FAC1 X FVAR.
               ldx  #<b_numresult  ; Initialise le pointeur ou le résultat doit
               ldy  #>b_numresult  ;   être copié.
               jsr  b_f1tmem       ; Copie FAC1 en mémoire.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Multiplication de deux nombres reçus du périphérique d'entrée.
; Sortie  : La variable b_bufflenght contiemnt la longueur de la chaîne.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 6, page 29.
;------------------------------------------------------------------------------
b_mul2fptoasc     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 dans $0057.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_f1xfv        ; Effectue la multiplication : 
                                   ; FAC1 = FAC1 X FVAR.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Sous-routine commune pour calculer la longueur du tampon d'entrée de commande 
; de BASIC.
; Sortie  : La variable b_bufflenght contient la longueur de la chaîne.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 6, page 29.
;------------------------------------------------------------------------------
b_getbufflen     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               ldy  #$ff           ; Détermine la longueur de la chaine en
nxtchar        iny                 ;   cherchant le caractère $00
               lda  $0100,y        ;   ($00 = EOS 'End Of String').
               bne  nxtchar        ; Pas celui là. on passe au prochain.
               iny                 ; On ajuste Y pour la longueur de la chaîne.
               sty  b_bufflenght   ; Sauvegarde dans le variable.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Sous-routine Commune qui affiche le tampon de commande BASIC sur le 
; périphérique de sortie.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 6, page 29.
;------------------------------------------------------------------------------
b_outsub          .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_getbufflen   ; Calcule la longueur de la chaîne dans var. 
               jsr  b_printbuff    ; Affiche le contenu du tampon sur le 
                                   ;   périphérique de sortie.
               jsr  b_clearbuff    ; Efface le tampon d'entrée de BASIC.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Multiplication de FAC1 par 10 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 7, page 30.
;------------------------------------------------------------------------------
b_fac1x10          .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1x10        ; Multiplie FAC1 par 10.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; L'exemple 8 de la page 31 n'existe que pour démontrer le 'bug' de signe du 
;   ROM BASIC 
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Division de FAC1 par 10 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 9, page 31.
;------------------------------------------------------------------------------
b_fac1d10          .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_sgnf1        ; Vérifie le signe de FAC1.
               pha                 ; Sauvegarde le signe.
               jsr  b_f1d10        ; Divise FAC1 par 10.
               pla                 ; Récupère le signe.
               tax                 ; Place le signe dans X.
               inx                 ; Incrémente et si n'est pas  
               bne  notneg         ;   egale à 0 i.e. non négatif.
               lda  #$80           ; On force le bit de signe  
               sta  $66            ;   de FAC1 a 1 (neg).
notneg          jsr  b_facasc      ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Calcul le carré de FAC1 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 10, page 32.
;------------------------------------------------------------------------------
b_fac1square     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1tf2        ; Copie FAC1 vers FAC2.
               lda  $61            ; Récupère l'exposant de FAC1.
               jsr  b_f1xf2        ; Multiplie FAC1 et FAC2. FAC1=FAC1xFAC2.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Division d'un P.F. en mémoire par FAC1 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 11, page 32.
;------------------------------------------------------------------------------
b_fvardfac1     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_fvdf1        ; Divise FVAR et FAC1. (FAC1=FVAR/FAC1).
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Division de FAC2 par FAC1 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 12, page 32.
;------------------------------------------------------------------------------
b_fac2dfac1     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.       
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_memtf2       ; Copie FVAR vers FAC2.
               lda  $61            ; Récupère l'exposant de FAC1.
               jsr  b_f2df1        ; Effectue la division: FAC1 = FAC2 / FAC1.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Addition de FVAR et FAC1 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 13, page 33.
;------------------------------------------------------------------------------
b_fac1pfvar     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.               
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_f1pfv        ; Effectue l'adition: FAC1 = FAC1 + FVAR.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Soustraction de FAC1 de FAC2 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 14, page 33.
;------------------------------------------------------------------------------
b_fac2sfac1     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.              
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_memtf2       ; Copie FVAR vers FAC2.
               jsr  b_f2sf1        ; Effec. la soustraction: FAC1 = FAC2 - FAC1.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Soustraction de FAC1 de FVAR et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 15, page 34.
;------------------------------------------------------------------------------
b_fvarsfac1     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.              
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_fvsf1        ; Effec. la soustraction: FAC1 = FVAR - FAC1.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Adition de l'Aacc à FAC1 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 16, page 34.
;------------------------------------------------------------------------------
b_accpfac1     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               pha                 ; Sauvegarde l'Acc.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               pla                 ; Récupère l'Acc.
               jsr  b_f1pacc       ; Effectue l'adition: FAC1 = FAC1 + ACC.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Adition de FAC2 à FAC1 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 17, page 34.
;------------------------------------------------------------------------------
b_fac2pfac1     .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.              
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_memtf2       ; Copie FVAR vers FAC2.
               lda  $61            ; Récupère l'exposant de FAC1.
               jsr  b_f1pf2        ; Effactue l'adition: FAC1 = FAC1 + FAC2.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Calcul FAC1 à la puissance FAC2 et sauvegarde le résultat en mémoire.
;------------------------------------------------------------------------------
; Code inspiré de l'exemple 17, page 34.
;------------------------------------------------------------------------------
b_fac1powfac2
               .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               jsr  b_f1t57        ; Copie FAC1 vers $0057.           
               jsr  b_insub        ; Capture un nombre de L'entrée STD.
               lda  #$57           ; Charge l'adresse mémoire du 
               ldy  #$00           ;   premier nombre.
               jsr  b_memtf2       ; Copie FVAR vers FAC2.
               lda  $61            ; Récupère l'exposant de FAC1.
               jsr  b_expon        ; Calcul FAC1 = FAC1 ^ FAC2.
               jsr  b_facasc       ; Conv. P.F. FAC1 vers chaîne ascii à $0100.
               jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;------------------------------------------------------------------------------
; Printing b_num1, b_num2 ans b_numresult in hex on screen.
;------------------------------------------------------------------------------
; test et debug des fonctions.
b_prhexbnum1   .block
               jsr  pushall        ; debug
               #locate   0,5
               lda  #<b_num1
               sta  zpage1
               lda  #>b_num1
               sta  zpage1+1
               ldy  #$00
               ldx  #18
more           lda  (zpage1),y
               jsr  putahex
               iny
               cpy  #6
               bne  is12
               #locate   0,7
is12           cpy  #12
               bne  doit               
               #locate   0,9
doit           dex
               bne  more
               jsr  popall
               rts     
               .bend
