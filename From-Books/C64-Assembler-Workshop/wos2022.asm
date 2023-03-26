*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;-------------------------------------------------------------------------------
; Inclusion des librairies
;-------------------------------------------------------------------------------
     .include  "c64_map_kernal.asm" ; Saut à la fonction main (jmp main)
     .include  "c64_map_basic2.asm"
     .include  "c64_lib_basic2.asm"
     .include  "c64_lib_pushpop.asm"
     .include  "c64_lib_mem.asm"
     .include  "c64_lib_hex.asm"
     .include  "c64_lib_disk.asm"
     ;.include  "c64_lib_sd_new.asm"
     .include  "c64_lib_showregs.asm"                
     ;.include  "c64_lib_joystick.asm"
     ;.include  "c64_lib_spriteman.asm"
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
;-------------------------------------------------------------------------------
main           .block
;-------------------------------------------------------------------------------
               jsr  scrmaninit
               jsr  wedgeos
over           rts  
               .bend
;-------------------------------------------------------------------------------
wedgeos        .block
;-------------------------------------------------------------------------------
initwos        jsr  greetings
               lda  #$4c      ; 140 - 2 on remplace l’instruction cmp
               sta  $7c       ; 150 - 2 ... avec « : » par jmp à 
               lda  #<wos     ; 160 - 2 ... l’adresse de notre
               sta  $7d       ; 170 - 2 ... fonction à la place de 
               lda  #>wos     ; 180 - 2 ... celle du basic du c64
               sta  $7e       ; 190 - 2 ... pour s’insérer.
               jmp  ($0302)   ; 200 - 3 fonction basic warm-start
;début de notre fonction
wos            cmp  #$40      ; 210 - 2 est-ce un "@"
               bne  l570      ; 220 - 2 branche a $44 (+68) bytes
               lda  $9d       ; 230 - 2 sommes nous en mode pgm
               beq  l450      ; 240 - 2 oui - branche a $28 (+40) bytes
               lda  $0200     ; 250 - 3 non - lire kb buffer
               cmp  #$40      ; 260 - 2 est-ce un "@"
               bne  l420      ; 270 - 2 non, stdcmd, branche a $1c (+28) bytes
               jsr  l670      ; 280 - 3 oui, xtdcmd, une de nos commandes
l290           ldy  #$00      ; 290 - 2 Initialise l'index
l300           lda  ($7a),y   ; 300 - 2 Prend un byte du buffer
               cmp  #$20      ; 310 - 2 est-ce un espace
               beq  l380      ; 320 - 2 oui on va à 380
               inc  $7a       ; 330 - 2 on incremente le lsB du pointeur
               bne  l300      ; 340 - 2 Pas de report branche a $f6 (-10) bytes
               inc  $7b       ; 350 - 2 on fait le repport
               sec            ; 360 - 1 on force un branchement a 290 
               bcs  l300      ; 370 - 2 branche a $f1 (-15) bytes  
l380           jsr  b_warmstart ; 380 - 3 appel à basic  
               lda  #$00      ; 390 - 2  On efface a
               sec            ; 400 - 1 On force le C pour brch à 570  
l410           bcs  l570      ; 410 - 2 branche a $1d (+29) bytes
l420           lda  #$40      ; 420 - 2 récupère @
               sec            ; 430 - 1 On force le C pour brch à 570
               bcs  l570      ; 440 - 2 branche a $18  (+24) bytes
;-------------------------------------------------------------------------------
; --- Program Mode ---------------
;-------------------------------------------------------------------------------
l450           jsr  l670      ; 450 - 3 On trouve et exécute notre commande
               ldy  #$00      ; 460 - 2 On initialise l'indexe
l470           lda  ($7a),y   ; 470 - 2 On lit un octet du programme
               cmp  #$00      ; 480 - 2 Si 0, fin de ligne
               beq  l570      ; 490 - 2 branche à $0d (+13) bytes
               cmp  #$3a      ; 500 - 2 Est-ce un :
               beq  l570      ; 510 - 2 branche à $09 ( +9) bytes 
               inc  $7a       ; 520 - 2 Incrémente lsB du PTR
               bne  l470      ; 530 - 2 branche à $f2 (-14) bytes
               inc  $7b       ; 540 - 2 On fait le repport
               sec            ; 550 - 1 On force le branchement
               bcs  l470      ; 560 - 2 branche à $ed  (-20) bytes  
l570           cmp  #$3a      ; 570 - 2 est-ce un délimiteur :
               bcs  l650      ; 580 - 2 branche si >= à $0a (+10) bytes
               cmp  #$20      ; 590 - 2 est-ce un " "
               beq  l660      ; 600 - 2 branche à $07 ( +7) bytes
               sec            ; 610 - 1 set Carry
               sbc  #$30      ; 620 - 2 Soustrait la base de l'ascii
               sec            ; 630 - 1 set Carry
               sbc  #$d0      ; 640 - 2 soustrait ascii et set bit
l650           rts            ; 650 - 1 Retourne à Basic
l660           jmp  $0073     ; 660 - 3 lance CHARGET

l670           ; On charge la table de commande en mémoire
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
               sta  backgrnd
               lda  #vcyan
               sta  vborder
               jsr  cls
               lda  #vblanc
               sta  bascol
               lda  #<msg0    ; 110 - 2 charge lsb du message initial
               ldy  #>msg0    ; 120 - 2 charge msb du message initial 
               jsr  puts      ; 130 - 3 affiche le message initial (basic)
               lda  #<msg1    ; 110 - 2 charge lsb du message initial
               ldy  #>msg1    ; 120 - 2 charge msb du message initial 
               jsr  puts      ; 130 - 3 affiche le message initial (basic)
               lda  #<msg2    ; 110 - 2 charge lsb du message initial
               ldy  #>msg2    ; 120 - 2 charge msb du message initial 
               jsr  puts      ; 130 - 3 affiche le message initial (basic)
               lda  #<msg3    ; 110 - 2 charge lsb du message initial
               ldy  #>msg3    ; 120 - 2 charge msb du message initial 
               jsr  puts      ; 130 - 3 affiche le message initial (basic)
               lda  #<msg4    ; 110 - 2 charge lsb du message initial
               ldy  #>msg4    ; 120 - 2 charge msb du message initial 
               jsr  puts      ; 130 - 3 affiche le message initial (basic)
               lda  #<msg1    ; 110 - 2 charge lsb du message initial
               ldy  #>msg1    ; 120 - 2 charge msb du message initial 
               jsr  puts      ; 130 - 3 affiche le message initial (basic)
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
L380           jsr  getin     ;380
               beq  L380      ;390
               jsr  aschex2bin;400
               bcc  out       ;410
               lda  #$FF      ;420
                              ;430 over
out            sta  $fb       ;430
               jsr  pop       
               rts            ;450
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
dirn           sta  driveno
dir            jsr  diskdir
               jsr  diskerror
               ;jsr  showregs
               ;jsr  cls
               rts
woshelp        jmp  greetings
wosincbrd      inc  vborder
               jmp  woscleancol
wosdecbrd      dec  vborder
               jmp  woscleancol
wosincback     inc  vbkgrnd
               jmp  woscleancol
wosdecback     dec  vbkgrnd
               jmp  woscleancol
wosincfont     inc  bascol
               jmp  woscleancol
wosdecfont     dec  bascol
               jmp  woscleancol
woscleancol    lda  vbkgrnd
               and  #$0f
               sta  vbkgrnd
               lda  vborder
               and  #$0f
               sta  vborder
               lda  bascol
               and  #$0f
               sta  bascol
               rts
;-------------------------------------------------------------------------------
; D A T A   A R E A 
;-------------------------------------------------------------------------------
msg0 .byte 147,0         
msg1 .text " **************************************"
     .byte 13, 0     
msg2 .byte 1
     .text " **** C64 Super Basic Etendue v2.1 ****"
     .byte 13,0      ; cr, eot  
msg3 .text " ******** par Daniel Lafrance. ********"
     .byte 13, 0     
msg4 .text " ******* Assemble le 2022-01-05 *******"
     .byte 13,0
