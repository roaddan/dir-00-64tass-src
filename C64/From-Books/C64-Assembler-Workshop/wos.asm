;-------------------------------------------------------------------------------
; Auteur : 
; Inspiration : 
; Programmeur  = "Daniel Lafrance" 
  version      = "20241122-130155"
;-------------------------------------------------------------------------------
     .include "header-c64.asm"     ; Saut à la fonction main (jmp main)
     .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
; Equates
;-------------------------------------------------------------------------------
     ready     =    $a474
               .enc none
               *=$8000
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
initwos        lda  #$08
               sta  dsk_dev
               lda  bascol
               sta  fcol
               lda  vicbordcol
               sta  bcol
               lda  vicbackcol
               sta  scol
               lda  #$4c           ; On remplace l’instruction cmp
               sta  $7c            ; ... avec « : » par jmp à 
               lda  #<wos          ; ... l’adresse de notre
               sta  $7d            ; ... fonction à la place de 
               lda  #>wos          ; ... celle du basic du c64
               sta  $7e            ; ... pour s’insérer.
; ============================================================  Fin de la page 9
               jmp  ready          ; Affiche "Ready" et lance basic warm-start.
; --------------------------
; Début de WOS
; --------------------------
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
; Program Mode
;-------------------------------------------------------------------------------
lmodepgm       jsr  lfindxcmd      ; On trouve et exécute notre commande
               ldy  #$00           ; On initialise l'indexe.
lnxtbuffb      lda  ($7a),y        ; On lit un octet de la ligne du programme.
               cmp  #$00           ; Si #$00, Il s'agit de la fin de la ligne.
               beq  lnormcmd       ; Alors on branche pour traiter une autre commande.
               cmp  #$3a           ; Est-ce un délimiteur ":"?
               beq  lnormcmd       ; Oui, on branche ranche à $09 ( +9) bytes 
               inc  $7a            ; Incrémente LSB du pointeur.
               bne  lnxtbuffb      ; Pas de report, on lit le prochaon octet.
               inc  $7b            ; On fait le report
               sec                 ; On force le branchement par BCS.
               bcs  lnxtbuffb      ; On lit le prochaon octet.  
; ============================================================  Fin de la page 10
lnormcmd       cmp  #$3a           ; Est-ce un délimiteur ":"?
               bcs  ltbasic        ; Si >= $0a 
               cmp  #$20           ; Est-ce un " "?
               beq  ltochrget      ; On passe au prochain caractère.
               sec                 ; Set Carry pour se préparer à la soustraction.
               sbc  #$30           ; Soustrait la base de l'ascii su chiffre "0"
               sec                 ; set Carry pour se préparer à la soustraction.
               sbc  #$d0           ; Soustrait ascii et set bit
ltbasic        rts                 ; tbasic - 1 Retourne à Basic
               jmp  ready
;-------------------
; FIND-EXECUTE
;-------------------
ltochrget      jmp  $0073          ; tochrget - 3 lance CHARGET
; ============================================================ Fin de la page 11
lfindxcmd      lda  #<cmdtbl       ; On place le (LSB) de l'adresse de la ... 
               sta  $7f            ; ... table des commandes a l'adresse $7f ...
               lda  #>cmdtbl       ; ... et le (MSB) ...
               sta  $80            ; ... a l'adresse $80.
               inc  $7a            ; On passe au caractere suivant le @.
               bne  lsetxy         ; Pas de report à faire. 
               inc  $7b            ; On fait le report. 
lsetxy         ldy  #$00           ; On initialise les deux index X et Y... 
               ldx  #$00           ; ... à $00.               
lgettabcar     lda  ($7f),y        ; Somme nous à la fin de la commande ($00)?
               beq  lgcmdvct       ; Si oui On récupère le vecteur de la commande. 
               cmp  ($7a),y        ; Regarde si car = cmd.  
               bne  lnocmdfnd      ; Non, on regarde la commande suivante.
               iny                 ; Oui, on compate le prochain caractère.
               sec                 ; On force un branchement à gettabcar pour ...
l820           bcs  lgettabcar     ; ... comparer le prochain car. de la table.
lnocmdfnd      lda  ($7f),y        ; La fin commande n'est pas trouvé.
               beq  lcmdend        ; Avons nous trouver la fin de la commande.
               iny                 ; Incrémente l'index
               sec                 ; Met le Carry à 1 pour forcer BCS.
               bcs  lnocmdfnd      ; Branche puisqu'aucune commande n'a été trouvée.
lcmdend        iny                 ; Incremente index
               tya                 ; Sauvegarde l'index dans l'acc.
               clc                 ; Met le Carry à 0 pour préparer l'addition.
               adc  $7f            ; Aditionne l'Acc. au vecteur de commande.
               sta  $7f            ; On le replace en mémoire.
               lda  #$00           ; On ajoute le Carry (C+$00) de la dernière ...
               adc  $80            ; ... addition dans le MSB du vecteur ...
               sta  $80            ; ... et le sauvegarder.
               ldy  #$00           ; nitialise l'index
               inx                 ; Ajoute 2 à x pour se déplacer vers la prochaine
               inx                 ; ... adresse dans la table des commandes.
               sec                 ; Force le branchement de BCS.
               bcs  lgettabcar     ; Va lire le prochain caractere de la table.
lgcmdvct       lda  cmdvect,x      ; Récupère le LSB de l'adresse d'exécution.
               sta  $80            ; Le place à 80.
               inx                 ; Avance X pour aller chercher le MSB ...
               lda  cmdvect,x      ; ... de l'adresse d'exécution et ...
               sta  $81            ; ... le sauvegarde.
               jmp  ($0080)        ; Saute vers le vecteur d'exécution.
; ============================================================ Fin de la page 12
illegal        ldx  #$0b           ; Charge le code d'erreur dans X 
               jmp  ($300)         ; Affiche l'erreur.
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
               lda  #$0d
               jsr  putch
               #print msg1
               lda  #$0d
               jsr  putch
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
help           .block
;-------------------------------------------------------------------------------
               jsr  push
               #print    msg0
               #print    msg1
               #print    hlp0
               #print    msg6
               #print    msg1
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
ascii2bintxt     .block
;-------------------------------------------------------------------------------
               jsr  push           ;p21
               cmp  #$30           ;120
               bcc  Lnonum         ;130
               cmp  #$3a           ;140
               bcc  L210           ;150
               sbc  #$07           ;160
               bcc  Lnonum         ;170
               cmp  #$40           ;180
               bcs  L220           ;190
                                   ;200 Zero-nine
L210           and  #$0f           ;210 
L220           jsr  pop            ;220 return
               rts                 ;230
                                   ;240 Illegale
Lnonum         sec                 ;nonum
               jsr  pop
               rts
               .bend
;-------------------------------------------------------------------------------
p2tester       .block
;-------------------------------------------------------------------------------
               jsr  push
lnoxcmd        jsr  getin          ;noxcmd
               beq  lnoxcmd        ;390
               jsr  atobin          ;aschex2bin;400
               bcc  out            ;410
               lda  #$FF           ;flushpfx
                                   ;430 over
out            sta  $fb            ;430
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
               .text     "S+",0,"S-",0,"B+",0,"B-",0,"F+",0,"F-",0,"FILL",0
               .text     "DIR",0,"8DIR",0,"9DIR",0,"10DIR",0,"11DIR",0,"12DIR",0
               ;Lowrecase
               .text     "cls",0,"low",0,"up",0
               .text     "test",0
               .text     "about",0,"?",0
               .text     "s+",0,"s-",0,"b+",0,"b-",0,"f+",0,"f-",0,"fill",0
               .text     "dir",0,"8dir",0,"9dir",0,"10dir",0,"11dir",0,"12dir",0
;-------------------------------------------------------------------------------
cmdvect        ;Uppercase
;-------------------------------------------------------------------------------
               .word     woscls, woslow, wosup
               .word     wostest
               .word     wosabout, woshelp
               .word     wosincback, wosdecback,wosincbrd, wosdecbrd 
               .word     wosincfont, wosdecfont, wosfillcol
               .word     dir, dir8, dir9, dir10, dir11, dir12
               ;Lowercase
               .word     woscls, woslow, wosup
               .word     wostest
               .word     wosabout, woshelp
               .word     wosincback, wosdecback, wosincbrd, wosdecbrd 
               .word     wosincfont, wosdecfont, wosfillcol
               .word     dir, dir8, dir9, dir10, dir11, dir12
;-------------------------------------------------------------------------------
cmdcode
;-------------------------------------------------------------------------------
woscls         lda  #$93       ; code 147 clear+home
               jmp  chrout     ;
woslow         lda  #$0e
               jmp  chrout
wosup          lda  #$8e
               jmp  chrout
wostest        #print tester
               ;jsr  ascii2bintxt
               rts
wosabout       jsr  greetings
               rts
tester         .null "tester"
wosfillcol     jsr  fillcarcol
               rts
               jmp  woscleancol
woshelp        jsr  help
               rts
wosincbrd      inc  bcol
               jmp  woscleancol
wosdecbrd      dec  bcol
               jmp  woscleancol
wosincback     inc  scol
               jmp  woscleancol
wosdecback     dec  scol
               jmp  woscleancol
wosincfont     inc  fcol
               jmp  woscleancol
wosdecfont     dec  fcol
               jmp  woscleancol
woscleancol    lda  scol
               and  #$0f
               sta  scol
               sta  vicbackcol
               lda  bcol
               and  #$0f
               sta  bcol
               sta  vicbordcol
               lda  fcol
               and  #$0f
               sta  fcol
               sta  bascol
               rts

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
dir            jsr  diskerror            
               jsr  diskdir
               jsr  diskerror
               ;jsr  showregs
               ;jsr  cls
               rts

bcol           .byte     $00
scol           .byte     $00
fcol           .byte     $00

fillcarcol     .block
               jsr  push
               ldx  #$04
               ldy  #$00
               lda  bascol
nxtcolram      sta  colram0,y
               sta  colram1,y
               sta  colram2,y
               sta  colram3,y
               iny  
               bne  nxtcolram
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
; D A T A   A R E A 
;-------------------------------------------------------------------------------
msg0 .byte 147,14,0         
msg1 .null " **************************************"  
msg2 .byte 13
     .text " *     c64 WOS Commandes Etendues     *"
msg3 .byte 13
     .text " * Inspiration C64 Assembler Workshop *"
msg4 .byte 13
     .text " * by Bruce Smith ISBN: 1 85014 004 9 *"
msg5 .byte 13
     .text " * Code Daniel Lafrance (@? for help) *"     
msg6 .byte 13
     .null format(   " *    Version.....: %s   *",version)
hlp0           .byte $0d
               .text "  @cls  = clear scr ; @test =          "
hlp1           .byte $0d
               .text "  @low  = lcase     ; @up   = ucase    "
hlp2           .byte $0d
               .text "  @about= tell me   ; @?    = this help"
hlp3           .byte $0d
               .text "  @s+/- = scrn-col  ; @b+/- = bord-col "
hlp4           .byte $0d
               .text "  @f+/- = font-col  ; @fill = fill-font"
hlp5           .byte $0d
               .text "  @dir  = list disk ; @8dir = disk #8  "
hlp6           .byte $0d
               .text "  @9dir = disk #9   ; @10dir= disk #10 "
hlp7           .byte $0d
               .text "  @11dir= disk #11  ; @12dir= disk #12 "
               .byte $00
;-------------------------------------------------------------------------------
; Inclusion des librairies
;-------------------------------------------------------------------------------
          *=$c000
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
