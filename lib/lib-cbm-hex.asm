;-------------------------------------------------------------------------------
; Nomprog: hexutil.s
; Auteur.: daniel lafrance
; Version: 0.1
; Date 2021-01-23
;
; Descrition:
; Fonction utilitaires de conversion en hexadécimal.
; ** Note: Utilise: butils.asm
;-------------------------------------------------------------------------------
a2hexcol       .byte     1              ; pour aputscxy
a2hexbkcol     .byte     %00000000
a2hexpos  
a2hexpx        .byte     0              ; pour aputsxy
a2hexpy        .byte     0
a2hexprefix    .byte     "$"            ; pour aputs
a2hexstr       .word     $00
               .word     $00
               .byte     0              ; 0 end string
abin           .null     "00000000"
adec           .null     "   "
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
putahexfmt     .block
               jsr  push
               jsr  atohex
               ldx  #<a2hexprefix
               ldy  #>a2hexprefix
               jsr  puts
               jsr  pop
               rts
               .bend
               
putahex        .block
               jsr  push
               jsr  atohex
               ldx  #<a2hexstr
               ldy  #>a2hexstr
               jsr  puts
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
; Transforme le quartets le moins significatif du registre A en son équivalent 
; hexadécimal.
; La méthode décimal est employé puisque c'est la plus rapide.
;-------------------------------------------------------------------------------
nibtohex        .block          
               php             
               and  #$0f    
               sed
               clc
               adc  #$90
               adc  #$40
               cld
               plp
               rts
               .bend
;***************************************
; Décale le contenu du registre A de 4
; bits vers la droite.
;***************************************
lsra4bits      .block
               php
               lsr     
               lsr
               lsr
               lsr
               plp
               rts
               .bend
;***************************************
; Transforme le contenu du registre A
; dans son équivalent Petscii
; hehadécimal.
; Le résultat est une chaine-0.
; Entré : A
; Sortie : chaine-0 à a2hexstr.
; Il est possible de changer la couleur
; et la position de l'affichage en 
; modifiant les variables :
;         a2hexcol, a2hexpx et a2hexpy.
; Utilisez les pointeurs :
; a2hexcol - modifie couleur, position
; a2hexpos - modifie position
; a2hexstr - affiche la chaine
; a2hexstr+1 - sans afficher le ($)
;***************************************
atohex         .block
               php
               pha
               pha
               jsr  lsra4bits
               jsr  nibtohex
               sta  a2hexstr
               pla
               jsr  nibtohex
               sta  a2hexstr+1
               lda  #$00                ; set end of string
               sta  a2hexstr+2
               pla
               plp
               rts
               .bend
;***************************************
; Converti l'adresse contenu dans $XXYY
; en hexadécimal
;***************************************
xy2hex         .block
               jsr  push
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
               jsr  pop                     
               .bend
;***************************************
; Converti le contenu de A en chaine 
; binaire dans abin. 
;***************************************
atobin         .block
               jsr  push
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
               jsr  pull
               rts
               .bend          
;***************************************
; affiche le contenu de abin à la 
; position du curseur.
;***************************************
putabin        .block
               jsr     atobin
               jsr     push
               ldx     #<abin
               ldy     #>abin
               jsr     puts
               jsr     pop
               rts
               .bend
;***************************************
; affiche le contenu de abin à la 
; position du curseur.
;***************************************
printabin      .block
               jsr     push
               ldx     #<abin
               ldy     #>abin
               jsr     puts
               jsr     pop
               rts
               .bend
;***************************************
; Affiche le contenu de abin à la 
; position du curseur en le préfixan du
; symbole (%).
;***************************************
putabinfmt     .block
               php
               pha
               lda     #"%"
               jsr     putch
               pla
               jsr     putabin
               plp
               rts
               .bend        
;***************************************
; Affiche le contenu de abin à la 
; position x, y.
;***************************************
putabinxy      .block
               jsr     gotoxy
               jsr     putabin
               rts
               .bend                
;***************************************
; Affiche le contenu de abin à la 
; position x, y en le préfixan du
; symbole (%).
;***************************************
putabinfmtxy   .block
               jsr     gotoxy
               jsr     putabinfmt
               rts
               .bend
;***************************************
; Converti le contenu de A en chaine 
; decimale dans adec. 
;***************************************
atodec         .block
               jsr  push
               sed
               tax
               ldy  #$00
               lda  #$00
nextbit        clc
               adc  #$01
               bcc  decx
               iny
decx           dex
               bne  nextbit
               pha  
               tya
               jsr  nibtohex
               sta  adec
               pla
               pha
               jsr  nibtohex
               sta  adec+2
               pla
               ror
               ror
               ror
               ror
               jsr  nibtohex
               sta  adec+1
               cld
               jsr  pull
               rts
buffer         .byte     0,0,0
               .bend          

putadec        .block
               jsr  push
               jsr  atodec
               ldx  #<adec
               ldy  #>adec+1
               jsr  puts 
               jsr  pop
               rts
               .bend