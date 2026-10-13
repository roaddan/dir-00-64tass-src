;---------------------------------------------------------------------
; Nomprog: hexutil.s
; Auteur.: daniel lafrance
; Version: 0.1
; Date 2021-01-23
;
; Descrition:
; Fonction utilitaires de conversion en hexadécimal.
; **Note: Utilise: butils.asm
;---------------------------------------------------------------------
; Transforme le quartets le moins significatif du registre A en son
; équivalent hexadécimal. La méthode décimal la plus rapide.
;---------------------------------------------------------------------
nib2hex
          .block         ; $03 %00000011 $03  0
          php            ;+$90 %10010011 $93  0
          and  #$0f      ;+$40 %00110011 $33  0
          sed            ;
          clc            ; $0a %00001010 $0a  0
          adc  #$90      ;+$90 %00000000 $90  1
          adc  #$40      ;+$40 %01000001 $41  0
          cld
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Décale le contenu du registre A de 4 bits vers la droite.
;---------------------------------------------------------------------
lsra4bits
          .block
          php
          lsr  a
          lsr  a
          lsr  a
          lsr  a
          plp
          rts
         .bend
;---------------------------------------------------------------------
; Transforme le contenu du registre A dans son équivalent Petscii
; hehadécimal. Le résultat est une chaine-0.
; Entré : A
; Sortie : chaine-0 à a2hexstr.
; Il est possible de changer la couleur et la position de l'affichage 
; en modifiant les variables a2hexcol, a2hexpx et a2hexpy.
; Utilisez les pointeurs :    a2hexcol (modifie couleur et position)
;                             a2hexpos (modifie la position seulement)
;                             a2hexstr (affiche la chaine seulement)
;                             a2hexstr+1 (pour ne pas afficher le $)
;---------------------------------------------------------------------
a2hex
          .block
          php
          pha
          pha
          jsr  lsra4bits
          jsr  nib2hex
          sta  a2hexstr+1
          pla
          jsr  nib2hex
          sta  a2hexstr+2
          pla
          plp
          rts
          .bend
a2hexcol  .byte     1         ; pour aputscxy
a2hexpos  
a2hexpx   .byte     0         ; pour aputsxy
a2hexpy   .byte     0
a2hexstr  .byte     "$"       ; pour aputs
          .word     $00
          .byte     0         ; 0 ended string
;---------------------------------------------------------------------
; Transforme le contenu du registre A en hexadécimal et retourne 
; l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position du curseur.
;---------------------------------------------------------------------
bputrahex
          .block
          php
          pha
          jsr a2hex
          ldx #<a2hexcol
          ldy #>a2hexcol
          jsr bputs
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Transforme le contenu du registre A en hexadécimal et retourne 
; l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position (a2hexpx,a2hexpy).
; **Note : a2hexpx et a2hexpy doivent être modifiées avant l'appel.
;---------------------------------------------------------------------
bputrahexxy
          .block
          php
          jsr  a2hex
          lda  #<a2hexpos
          ldy  #>a2hexpos
          jsr  bputsxy
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Transforme le contenu du registre A en hexadécimal et retourne 
; l'adresse de la chaine dans X-(lsb) et Y-(msb).
; Entrée : A
; Sortie : Valeur hexadécimale à la position (a2hexpx,a2hexpy) et dans
;          la couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy doivent être modifiées avant 
;          l'appel.
;---------------------------------------------------------------------
bputrahexcxy
          .block
          php
          jsr  a2hex
          lda  #<a2hexpos
          ldy  #>a2hexpos
          jsr  bputscxy
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
