     .include "header-c64.asm"; Saut à la fonction main (jmp main)
     .include "macros-64tass.asm"
     version = "20241118-223038"
     ready     =    $a474
;-------------------------------------------------------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;||  |||||||  |||||  |||||    ||  |||||  ||||||        |||        ||||       |||
;||    ||||   ||||    |||||  |||   ||||  ||||||  |||||  ||  |||||  ||  |||||  ||
;||  |  |  |  |||  ||  ||||  |||    |||  ||||||  |||||  ||  |||||  ||  |||||||||
;||  ||   ||  ||  ||||  |||  |||  |  ||  ||||||  |||||  ||  |||||  ||  |||||||||
;||  ||| |||  ||  ||||  |||  |||  ||  |  ||||||        |||        |||  ||     ||
;||  |||||||  ||        |||  |||  |||    ||||||  |||||||||  |||  ||||  |||||  ||
;||  |||||||  ||  ||||  |||  |||  ||||   ||||||  |||||||||  ||||  |||  |||||  ||
;||  |||||||  ||  ||||  ||    ||  |||||  ||||||  |||||||||  |||||  |||       |||
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-------------------------------------------------------------------------------
               .enc none
               *=$c000
;-------------------------------------------------------------------------------
main           .block
;-------------------------------------------------------------------------------
               jsr  scrmaninit     ; Initialisation de l'é
               jsr  greetings
               jsr  wedgeos
over           rts  
               .bend
;-------------------------------------------------------------------------------
wedgeos        .block
;-------------------------------------------------------------------------------
initwos        lda  #$4c           ; On remplace l’instruction cmp
               sta  $7c            ; ... avec « : » par jmp à 
               lda  #<wos          ; ... l’adresse de notre
               sta  $7d            ; ... fonction à la place de 
               lda  #>wos          ; ... celle du basic du c64
               sta  $7e            ; ... pour s’insérer.
               jmp  ready          ; Affiche "Ready" et lance basic warm-start.
 
;début de notre fonction
wos            cmp  #$40           ; Est-ce un "@" (ASCII).
               bne  lnormcmd       ; Laisse Basic interpreter sa commande.
               lda  $9d            ; Le Z de MSGFLG indique si en mode pgm.
               beq  lmodepgm       ; Oui - branche a lmodepgm.
               lda  $0200          ; Non - lecture du tampon clavier.
               cmp  #$40           ; Est-ce un "@" (ASCII).
               bne  lflushpfx      ; Non, stdcmd, branche a $1c (+28) bytes
               jsr  lfindxcmd      ; Oui, cherchons parmis nos commandes.
l290           ldy  #$00           ; Initialise l'index à $00.
lgetbuffb      lda  ($7a),y        ; Prend un octet du tampon clavier.
               cmp  #$20           ; Est-ce un espace?
               beq  lnoxcmd        ; Oui, On ignore le "@".
               inc  $7a            ; On incremente le LSB du pointeur.
               bne  lgetbuffb      ; Pas de report, On lit le prochain octet.
               inc  $7b            ; On fait un repport au MSB du pointeur.
               sec                 ; On force un branchement par BCS. 
               bcs  lgetbuffb      ; On lit le prochain octet. 
lnoxcmd        jsr  b_warmstart    ; On retourne à l'interpréteur Basic.  
               lda  #$00           ; On place $00 dans Acc.
               sec                 ; On force le C pour BCS et ... 
l410           bcs  lnormcmd       ; ... brancher à lnormcmd.
lflushpfx      lda  #$40           ; Charge "@" dans Acc. 
               sec                 ; On force le C pour BCS et ... 
               bcs  lnormcmd       ; ... brancher à lnormcmd.
;-------------------------------------------------------------------------------
; --- Program Mode ---------------
;-------------------------------------------------------------------------------
lmodepgm           jsr  lfindxcmd      ; modepgm - 3 On trouve et exécute notre commande
               ldy  #$00      ; 460 - 2 On initialise l'indexe
l470           lda  ($7a),y   ; 470 - 2 On lit un octet du programme
               cmp  #$00      ; 480 - 2 Si 0, fin de ligne
               beq  lnormcmd      ; 490 - 2 branche à $0d (+13) bytes
               cmp  #$3a      ; 500 - 2 Est-ce un :
               beq  lnormcmd      ; 510 - 2 branche à $09 ( +9) bytes 
               inc  $7a       ; 520 - 2 Incrémente lsB du PTR
               bne  l470      ; 530 - 2 branche à $f2 (-14) bytes
               inc  $7b       ; 540 - 2 On fait le repport
               sec            ; 550 - 1 On force le branchement
               bcs  l470      ; 560 - 2 branche à $ed  (-20) bytes  
lnormcmd           cmp  #$3a      ; normcmd - 2 est-ce un délimiteur :
               bcs  l650      ; 580 - 2 branche si >= à $0a (+10) bytes
               cmp  #$20      ; 590 - 2 est-ce un " "
               beq  l660      ; 600 - 2 branche à $07 ( +7) bytes
               sec            ; 610 - 1 set Carry
               sbc  #$30      ; 620 - 2 Soustrait la base de l'ascii
               sec            ; 630 - 1 set Carry
               sbc  #$d0      ; 640 - 2 soustrait ascii et set bit
l650           rts            ; 650 - 1 Retourne à Basic
               jmp  ready
l660           jmp  $0073     ; 660 - 3 lance CHARGET

lfindxcmd           ; On charge la table de commande en mémoire
               lda  #<cmdtbl  ;$00      ; 670 - 2
               sta  $7f       ;           680 - 2
               lda  #>cmdtbl  ;$c1      ; 690 - 2
               sta  $80       ;           700 - 2
               ;on passe au caractere suivant le @
               inc  $7a       ; 710 - 2 Incrémente ptr ...
               bne  l740      ; 720 - 2 branche à $02 (+02) bytes
               inc  $7b       ; 730 - 2 ... avec report 
               
l740           ldy  #$00      ; 740 - 2 initialise x et y
               ldx  #$00      ; 750 - 2
               
l760           lda  ($7f),y   ; 760 - 2 Lit un car de la table
               ;regarde si le caractère de commande 0
               beq  l1010     ; 770 - 2 brabche à $24 (+36) bytes
               ; estce le même caractère que la commande
               cmp  ($7a),y   ; 780 - 2
               ; non, on regarde la commande suivante
               bne  l830      ; 790 - 2 branche à $02 (+02) bytes
               ; oui on compate le prochain caractère
               iny            ; 800 - 1
               ; on force un branchement à 760
               sec            ; 810 - 1
l820           bcs  l760      ; 820 - 2 branche à $f4 (-12) bytes
               ; La commande n'est pas trouvé
l830           lda  ($7f),y   ; 830 - 2
               ; avons nous trouver la fin de la commande
               beq  l880      ; 840 - 2 branche à $04 (+04) bytes
               ; incrémente l'index
               iny            ; 850 - 1
               ; force le branchement à 820
               sec            ; 860 - 1
               bcs  l830      ; 870 - 2 branche à $f8 (-06) bytes
               ; incremente index
l880           iny            ; 880 - 1
               tya            ; 890 - 1
               clc            ; 900 - 1
               ; aditionne le lsB au vecteur 
               adc  $7f       ; 910 - 2
               ; et le sauvegarde
               sta  $7f       ; 920 - 2
               lda  #$00      ; 930 - 2
               ; fait le repport dans le msB du vecteur
               adc  $80       ; 940 - 2
               ; et le sauvegarde
               sta  $80       ; 950 - 2
               ldy  #$00      ; 960 - 2 Initialise l'index
               inx            ; 970 - 1 ajoute 2 à x
               inx            ; 980 - 1
               sec            ; 990 - 1 force le branchement
               bcs  l760      ;1000 - 2 branche à $d8 (-40) bytes
l1010          lda  cmdvect,x ;1010 - 3 $c050,x   ;1010 - 3
               sta  $80       ;1020 - 2
               inx            ;1030 - 1
               lda  cmdvect,x ;$c050,x   ;1040 - 3
               sta  $81       ;1050 - 2
               jmp  ($0080)   ;1060 - 3 Exécute le code de notre commande
illegal        ldx  #$0b      ;1070 - 2
               jmp  ($300)    ;1080 - 3 vct -> $e38b Table $a193
               .bend
;-------------------------------------------------------------------------------
greetings      .block
;-------------------------------------------------------------------------------
               jsr  push
               lda  #vbleu
               sta  vicbackcol
               lda  #vcyan
               sta  vicbordcol
               jsr  cls
               lda  #vblanc
               sta  bascol
               #print msg0
               #print msg1 
               #print msg2
               #print msg3
               #print msg4
               lda  #$0d
               jsr  putch
               #print msg1
               lda  #$0d
               jsr  putch
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
ascii2bintxt     .block
;-------------------------------------------------------------------------------
               jsr  push      ;p21
               cmp  #$30      ;120
               bcc  L250      ;130
               cmp  #$3a      ;140
               bcc  L210      ;150
               sbc  #$07      ;160
               bcc  L250      ;170
               cmp  #$40      ;180
               bcs  L220      ;190
                              ;200 Zero-nine
L210           and  #$0f      ;210 
L220           jsr  pop       ;220 return
               rts            ;230
                              ;240 Illegale
L250           sec            ;250
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
p2tester       .block
;-------------------------------------------------------------------------------
               jsr  push
Lnoxcmd           jsr  getin     ;noxcmd
               beq  Lnoxcmd      ;390
               jsr  atobin    ;aschex2bin;400
               bcc  out       ;410
               lda  #$FF      ;flushpfx
                              ;430 over
out            sta  $fb       ;430
               jsr  pop       
               rts            ;modepgm
               .bend               

;-------------------------------------------------------------------------------
;setup command table
;-------------------------------------------------------------------------------
cmdtbl         ;Uppercase
;-------------------------------------------------------------------------------
               .text     "CLS",0,"LOW",0,"UP",0
               .text     "TEST",0
               .text     "ABOUT",0,"?",0
               .text     "S+",0,"S-",0,"B+",0,"B-",0,"F+",0,"F-",0
               .text     "DIR",0,"8DIR",0,"9DIR",0,"10DIR",0,"11DIR",0,"12DIR",0
               ;Lowrecase
               .text     "cls",0,"low",0,"up",0
               .text     "test",0
               .text     "about",0,"?",0
               .text     "s+",0,"s-",0,"b+",0,"b-",0,"f+",0,"f-",0
               .text     "dir",0,"8dir",0,"9dir",0,"10dir",0,"11dir",0,"12dir",0
;-------------------------------------------------------------------------------
cmdvect        ;Uppercase
;-------------------------------------------------------------------------------
               .word     woscls, woslow, wosup
               .word     wostest
               .word     wosabout, woshelp
               .word     wosincbrd, wosdecbrd, wosincback, wosdecback
               .word     wosincfont, wosdecfont
               .word     dir, dir8, dir9, dir10, dir11, dir12
               ;Lowercase
               .word     woscls, woslow, wosup
               .word     wostest
               .word     wosabout, woshelp
               .word     wosincbrd, wosdecbrd, wosincback, wosdecback 
               .word     wosincfont, wosdecfont
               .word     dir, dir8, dir9, dir10, dir11, dir12
;-------------------------------------------------------------------------------
cmdcode
;-------------------------------------------------------------------------------
woscls         lda  #$93        ; code 147 clear+home
               jmp  chrout     ; 
woslow         lda  #$0e
               jmp  chrout
wosup          lda  #$8e
               jmp  chrout
wostest        jmp  ascii2bintxt
wosabout       jmp  greetings
dir8           lda  #$08
               jmp  dirn
dir9           lda  #$09
               jmp  dirn
dir10          lda  #$0a
               jmp  dirn
dir11          lda  #$0b
               jmp  dirn
dir12          lda  #$0c
               jmp  dirn
dirn           sta  dsk_dev
dir            jsr  diskdir
               jsr  diskerror
               ;jsr  showregs
               ;jsr  cls
               rts
woshelp        jmp  greetings
wosincbrd      inc  vicbordcol
               jmp  woscleancol
wosdecbrd      dec  vicbordcol
               jmp  woscleancol
wosincback     inc  vicbackcol
               jmp  woscleancol
wosdecback     dec  vicbackcol
               jmp  woscleancol
wosincfont     inc  bascol
               jmp  woscleancol
wosdecfont     dec  bascol
               jmp  woscleancol
woscleancol    lda  vicbackcol
               and  #$0f
               sta  vicbackcol
               lda  vicbordcol
               and  #$0f
               sta  vicbordcol
               lda  bascol
               and  #$0f
               sta  bascol
               rts
;-------------------------------------------------------------------------------
; D A T A   A R E A 
;-------------------------------------------------------------------------------
msg0 .byte 147,14,0         
msg1 .null " **************************************"  
msg2 .byte 13
     .null " *      c64 WOS commande etendue      *"
msg3 .byte 13
     .null " *         par Daniel Lafrance        *"
msg4 .byte 13
     .null format(   " *    Version.....: %s   *",version)

;-------------------------------------------------------------------------------
; Inclusion des librairies
;-------------------------------------------------------------------------------
     .include  "map-c64-kernal.asm" 
     .include  "map-c64-basic2.asm"
     .include  "map-c64-vicii.asm"
     .include  "lib-c64-basic2.asm"
     .include  "lib-cbm-pushpop.asm"
     .include  "lib-cbm-mem.asm"
     .include  "lib-cbm-hex.asm"
     .include  "lib-cbm-disk.asm"
     ;.include  "lib-c64-sd-new.asm"
     ;.include  "lib-c64-showregs.asm"                
     ;.include  "lib-c64-joystick.asm"
     ;.include  "lib-c64-spriteman.asm"
