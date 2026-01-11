;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Librarie utilisant les Routines d'écran du Basic 2.0.
;---------------------------------------------------------------------
;---------------------------------------------------------------------
; Routine qui initialisation des paramêtres de base pour la gestion 
; de l'écran virtuelle.
;
; Cette routine place la bordure de l'écran en vert, le fond d'écran 
; en bleu et les caractères en blanc. 
;---------------------------------------------------------------------
scrmaninit     .block  
               jsr  push  
               lda  #vbleu
               rol
               rol
               rol
               rol
               ora  #vvert         ; Du vert pour ... 
               ora  #%00001000     ; ???
               sta  vicbackcol     ; ... le fond d'écran.
               lda  #vblanc        ; Du blanc pour ...
               sta  bascol         ; les caractères.
               lda  #%00000010     ; ???
               sta  vichorcnt      ; ???
               jsr  cls            ; On efface l'écran
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
; Routine qui transforme le contenu du registre A en hexadécimal et
; retourne l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position du curseur.
;---------------------------------------------------------------------
putrahex       .block
               php
               pha
               jsr atohex
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
               jsr atohex
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
               jsr atohex
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

