;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Nomprog: hexutil.s
; Auteur.: daniel lafrance
; Version: 0.1
; Date 2021-01-23
;
; Descrition:
; Fonction utilitaires de conversion en hexadécimal.
; ** Note: Utilise: butils.asm
;-------------------------------------------------------------------------------
a2hexprefix    .byte     "$"            ; pour aputs
a2hexstr       .word     $00
               .word     $00
               .byte     0              ; 0 end string
abincol        .byte     1
abinbkcol      .byte     %00000000           
abin           .null     "00000000"
adec           .null     "   "
               
;-----------------------------------------------------------------------------
;
;-----------------------------------------------------------------------------
putahexfmtxy   .block
               jsr  push
               jsr  atohex
               ldx  a2hexpx
               ldy  a2hexpy
               jsr  gotoxy
               ldx  #<a2hexprefix
               ldy  #>a2hexprefix
               jsr  puts
               jsr  pop
               rts
               .bend
               
;-----------------------------------------------------------------------------
;
;-----------------------------------------------------------------------------
putahexfmt     .block
               jsr  push
               jsr  atohex
               ldx  #<a2hexprefix
               ldy  #>a2hexprefix
               jsr  puts
               jsr  pop
               rts
               .bend
;-----------------------------------------------------------------------------
; Décale le contenu du registre A de 4 bits vers la droite.
;-----------------------------------------------------------------------------
lsra4bits      .block
               php
               lsr     
               lsr
               lsr
               lsr
               plp
               rts
               .bend
;-----------------------------------------------------------------------------
; Converti l'adresse contenu dans $XXYY en hexadécimal.
;-----------------------------------------------------------------------------

xy2hex         .block
               jsr  pushregs
               jsr  atohex
               txa
               pha
               jsr  lsra4bits
               jsr  nibtohex
               sta  a2hexstr
               pla
               jsr  nibtohex
               sta  a2hexstr+1
               tya
               pha
               jsr  lsra4bits
               jsr  nibtohex
               sta  a2hexstr+2
               pla
               jsr  nibtohex
               sta  a2hexstr+3
               lda  #$00                ; 0 ended string
               sta  a2hexstr+4
               jsr  popregs                     
               .bend

;-----------------------------------------------------------------------------
; Converti le contenu de A en chaine  binaire dans abin. 
;-----------------------------------------------------------------------------
atobin         .block
               jsr  pushregs
               ldx  #8
               ldy  #0
               clc
nextbit        rol
               pha
               adc  #$00
               and  #$01
               jsr  nibtohex
               sta  abin,y
               pla
               iny
               dex
               bne  nextbit
               lda  #0
               sta  abin,y
               jsr  popregs
               rts
               .bend          

abinsetmccol   .block
               jsr  pushregs
               jsr  popregs
               rts
               .bend


;-----------------------------------------------------------------------------
; Affiche le contenu de abin à la position du curseur.
;-----------------------------------------------------------------------------
putabin        .block
               jsr     atobin
               jsr     pushregs
               ldx     #<abin
               ldy     #>abin
               jsr     puts
               jsr     popregs
               rts
               .bend

;-----------------------------------------------------------------------------
; affiche le contenu de abin à la position du curseur.
;-----------------------------------------------------------------------------
printabin      .block
               jsr     pushregs
               ldx     #<abin
               ldy     #>abin
               jsr     puts
               jsr     popregs
               rts
               .bend

;-----------------------------------------------------------------------------
; Affiche le contenu de abin à la position du curseur en le préfixan du
; symbole (%).
;-----------------------------------------------------------------------------
putabinfmt     .block
               php
               pha
               lda     #"%"
               jsr     chrout
               pla
               jsr     putabin
               plp
               rts
               .bend        

;-----------------------------------------------------------------------------
; Affiche le contenu de abin à la position x, y.
;-----------------------------------------------------------------------------
putabinxy      .block
               jsr     gotoxy
               jsr     putabin
               rts
               .bend                

;-----------------------------------------------------------------------------
; Affiche le contenu de abin à la position x, y en le préfixan du symbole (%).
;-----------------------------------------------------------------------------
putabinfmtxy   .block
               jsr     gotoxy
               jsr     putabinfmt
               rts
               .bend

;-----------------------------------------------------------------------------
; Converti le contenu de A en chaine decimale dans adec.
; On décrémente X jusqu'a 0 en aditionnant 1 a Y,A.  
;-----------------------------------------------------------------------------
atodec         .block
               jsr  pushregs
               sed            ; On se place en mode décimal.
               tax            ; On déplace a dans x.
               ldy  #$00      ; On pointe Y au début de la str.
               lda  #$00      ; 0 dans A.
nextbit        clc            ; Bit carry a 0.
               adc  #$01      ; Ajoute 1 a A.
               bcc  decx      ; Pas de carry, pas de report.
               iny            ; On incrémente Y
decx           dex            ; X=X-1
               bne  nextbit   ; Pas encore a 0, on boucle.
               ; Maintenant que X = 0.
               pha            ; A sur le stack.
               tya            ; Y dans A (MSB)
               jsr  nibtohex  ; a hex petsci ... 
               sta  adec      ; ... dans tampon.
               pla            ; Récupere A
               pha            ; 
               jsr  nibtohex
               sta  adec+2
               pla
               ror
               ror
               ror
               ror
               jsr  nibtohex
               sta  adec+1
               cld            ; On revient en mode binaire.
               jsr  popregs
               rts
               .bend          

;-----------------------------------------------------------------------------
;
;-----------------------------------------------------------------------------
putadec        .block
               jsr  pushregs
               jsr  atodec
               ldx  #<adec
               ldy  #>adec+1
               jsr  puts 
               jsr  popregs
               rts
               .bend