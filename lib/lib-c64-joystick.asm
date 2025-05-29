;-------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: lib-c64-joystick.asm
; Version ........: Quelque part en 2023
; Cernière m.à j. : 20250521
; Inspiration ....: 
;-------------------------------------------------------------------------------
; Lecture de la des manettes de commande numériques.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Déclaration des constantes.
;-------------------------------------------------------------------------------
js_2port       =    $dc00          ; CIA #1 Port data A 
js_1port       =    $dc01          ; CIA #1 Port data B
js_2dir        =    $dc02          ; CIA #1 Port de direction A
js_1dir        =    $dc03          ; CIA #1 port de direction B
js_xoffset     =    2
js_yoffset     =    2
js_location    =    0

;-------------------------------------------------------------------------------
; Initialisation des registres PIA pour la lecture des ports manette.
;-------------------------------------------------------------------------------
js_init        .block
               php                 ; Sauvegarde le registre de  
               pha                 ;   status et le registre a.
               lda  js_1dir        ; Place les bits de direction du port B
               and  #$e0           ; 4-0 en entrées (0).
               sta  js_1dir
               lda  js_2dir        ; Place les bits de direction du port A
               and  #$e0           ; 4-0 en entrées (0).
               sta  js_2dir
               pla                 ; Récupère le registre a et  
               plp                 ;   le registre de status.
               rts
               .bend
               
;-------------------------------------------------------------------------------
; Effectue un scan de tous les ports pour mettre à jour les variables d'action.
;-------------------------------------------------------------------------------
js_scan        .block
               jsr  js_1scan       ; Scan la manette du port B.
               jsr  js_2scan       ; Scan la manette du port A.
               rts
               .bend

;-------------------------------------------------------------------------------
; Port 1 js_1= %000FRLDU
;-------------------------------------------------------------------------------
js_1scan       .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               lda  js_1port       ; Lecture du port d'entrées
               and  #$1f           ; Masque les bits 7, 6 et 5.
               pha                 ; Copie sur la pile.
               eor  #$1f           ; Inverse tous les bits.
               sta  js_1status     ; Sauvegarde le status.
               pla                 ; Récupère une copie originale.
               cmp  #$00           ; Si les bits sont tous 0
               bne  p1scan         ; On scan le port
               jmp  port1_out
p1scan         eor  #$1f
               clc
; ***** BOUTON EN-HAUT
js_1b0         lsr                 ; On decale js_2 bit 0 dans C            
               bcc  js_1b1         ; Est-ce vers le haut (U)  
               pha                 ; On stock la valeur
               inc  js_1flag
               lda  js_1pixy       ; Oui!
               sec                 ; On place la Carry a 1
               sbc  #js_yoffset    ; On reduit
               cmp  #$f0
               bcc  sto1ym
               lda  #$00
sto1ym         sta  js_1pixy       ; le y 
               pla                 ; On recupere la valeur               
; ***** BOUTON EN-BAS
js_1b1         lsr                 ; On decale js_2 bit 0 dans C
               bcc  js_1b2         ; Est-ce vers le bas (D)
               pha                 ; On stack la valeur
               inc  js_1flag
               lda  js_1pixy       ; Oui!
               clc                 ; On place la Carry a 0
               adc  #js_yoffset    ; On augmente
               cmp  #199
               bcc  sto1yp
               lda  #199
sto1yp         sta  js_1pixy       ; le y
               pla                 ; On recupere la valeur
; ***** BOUTON A-GAUCHE
js_1b2         lsr                 ; On decale js_1 bit 0 dans C
               bcc  js_1b3         ; Est-ce vers la gauche (L)
               pha                 ; On stack la valeur
               inc  js_1flag
               lda  js_1pixx       ; Oui!
               ora  js_1pixx+1
               beq  js_1b2out
               sec                 ; On place la Carry a 1
               lda  js_1pixx       ; Oui!
               sbc  #js_xoffset    ; On diminue
               sta  js_1pixx       ; le X 
               bcs  js_1b2out      ; de offset
               lda  js_1pixx+1
               beq  js_1b2out
               dec  js_1pixx+1     ; sur 16 bits
js_1b2out      pla                 ; On recupere la valeur
; ***** BOUTON A-BROITE
js_1b3         lsr                 ; On decale js_1 bit 0 dans C
               bcc  js_1b4         ; Est-ce vers la droite (R)
               pha                 ; On stack la valeur
               inc  js_1flag
               lda  js_1pixx+1
               beq  incj1x
               lda  js_1pixx
               cmp  #$40-4
               bmi  incj1x
               jmp  js_1b3out
incj1x         clc                 ; On place la Carry a 0
               lda  js_1pixx       
               adc  #js_xoffset    ; On augmente
               sta  js_1pixx       ; le X 
               bcc  js_1b3out      ; de offset
               inc  js_1pixx+1     ; sur 16 bits
js_1b3out      pla                 ; On recupere la valeur
; ***** BOUTON FIRE
js_1b4         lsr                 ; Est-ce le bbouton fire (F)
               bcc  port1_out      ; Oui!
               inc  js_1flag
               inc  js_1fire       ; On augmente le nombre de tir
js_1wait       ldx  #$01
               ldy  #$ff
js_1rel        iny
               ;jsr  showregs
               lda  js_1port 
               eor  #$ff
               and  #$10
               ;cmp  #$1f          ; On attend le relachement 
               bne  js_1rel        ;  des boutons
port1_out      lda  js_1flag
               beq  out
               jsr  js_1correct
               lda  #0
               sta  js_1flag
out            jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;-------------------------------------------------------------------------------
; Port 2 js_2= %100FRLDU
;-------------------------------------------------------------------------------
js_2scan         .block
               jsr  pushreg        ; Sauvegarde tous les registres.
port2          lda  js_2port       ; Lecture du port d'entrées.
               and  #$1f           ; Masque les bits 7, 6 et 5.
               eor  #$1f           ; Inverse les bits 4 à 0.
               sta  js_2status     ; Sauvegarde le status en mémoire.
               cmp  #$00           ; Si des interrupteurs sont appuyé ... 
               bne  p2scan         ; ... on cherche lesquels.
               jmp  port2_out      ; Si non on sort.
p2scan         inc  js_2flag       ; On incrémente le témoin de changement.
               clc                 ; On met le Carry à 0.
; ***** BOUTON EN-HAUT
js_2b0         lsr                 ; On decale js_2 bit 0 dans Carry.
               pha                 ; On stack la valeur décalée.
               bcc  js_2b1         ; Si pas BTNUP, on vérifi le prochain.
               lda  js_2pixy       ; Oui!
               sec                 ; On place la Carry a 1.
               sbc  #js_yoffset    ; Déplace le crs vrs le haut de offset.
               cmp  #$f0           ; Si posy plus basse que Viewport NTSC ...
               bcc  sto2ym         ; Si le crs dépasse le bas du viewport ...
               lda  #$00           ; On le replace en haut.
sto2ym         sta  js_2pixy       ; Sauvegarde La pos. pixel de Y. 
; ***** BOUTON EN-BAS
               pla                 ; On recupere la valeur du scan décalé.
js_2b1         lsr                 ; On decale js_2 bit 0 dans Carry.
               pha                 ; On stack la valeur décalée.
               bcc  js_2b2         ; Si pas BTN-BAS, on vérifi le prochain.
               lda  js_2pixy       ; Oui!
               clc                 ; On place la Carry a 0.
               adc  #js_yoffset    ; Déplace le crs vrs le bas de offset.
               cmp  #199           ; Sommes nous dépassé le bas de l'écran?
               bcc  sto2yp         ; Non, on sauvegarde la position.
               lda  #199           ; Oui,
sto2yp         sta  js_2pixy       ; On bloque le Y à 199.
; ***** BOUTON A-GAUCHE
               pla                 ; On recupere la valeur du scan décalé.
js_2b2         lsr                 ; On decale js_2 bit 0 dans C
               pha                 ; On stack la valeur décalée.
               bcc  js_2b3         ; Est-ce le bouton gauche (L)
               lda  js_2pixx       ; Oui!
               ora  js_2pixx+1     
               beq  js_2b2out
               sec                 ; On place la Carry a 1
               lda  js_2pixx       ; Oui!
               sbc  #js_xoffset    ; On diminue
               sta  js_2pixx       ;  le X 
               bcs  js_2b2out      ; de offset
               lda  js_2pixx+1
               beq  js_2b2out
               dec  js_2pixx+1     ; sur 16 bits
js_2b2out      
; ***** BOUTON A-DROITE
js_2b3         lsr                 ; On decale js_2 bit 0 dans C
               pha                 ; On stack la valeur décalée.
               bcc  js_2b4         ; Est-ce vers la droite (R)
               lda  js_2pixx+1
               beq  incj2x
               lda  js_2pixx
               cmp  #$40-js_xoffset
               bmi  incj2x
               jmp  js_2b3out
incj2x         clc                 ; On place la Carry a 0
               lda  js_2pixx       ; Oui!
               adc  #js_xoffset    ; On augmente
               sta  js_2pixx       ;   le X 
               bcc  js_2b3out      ; de offset
               inc  js_2pixx+1     ; sur 16 bits
js_2b3out
; ***** BOUTON FIRE
               pla                 ; On recupere la valeur du scan décalé.
js_2b4         lsr                 ;Estce le bbouton fire (F)
               bcc  port2_out      ;Oui!
               inc  js_2fire       ; On augmente le nombre de tir
               lda  #%00000001
               sta  js_2events
               lda  js_2pixx
               sta  js_2clickx
               lda  js_2pixx+1
               sta  js_2clickx+1
               lda  js_2pixy
               sta  js_2clicky
               lda  js_2val16a+1
               eor  #%01000000
               sta  js_2val16a+1
js_2wait       ldx  #$00
               ldy  #$ff
js_2rel        iny
               bne  sr1
               inx
sr1            lda  js_2port
               eor  #$ff
               and  #$10 
               bne  js_2rel        ; On attend le relachement du bouton FEU.
port2_out      lda  js_2flag
               beq  out
               jsr  js_2correct
               lda  #0
               sta  js_2flag
out            jsr  popreg         ; Récupère tous les registres.
               .bend

;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_corrector   .block          
               php          
               pha
               lda  js_1flag
               beq  check2
               jsr  js_1correct          
               lda  #0
               sta  js_1flag
check2         lda  js_2flag  
               beq  no_update
               jsr  js_2correct  
               lda  #0
               sta  js_2flag
no_update      pla
               plp
               rts
               .bend          

;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_1correct    .block
               php
               pha 
               ; Port 1 X
               lda  js_1pixx
               sta  vallsb  
               lda  js_1pixx+1
               ror                 ; ex = %0000000100000001 = 257 pixel
               ror  vallsb         ; Cnnnnnnn      On divise par 8 pc les 
               lsr  vallsb         ; 0Cnnnnnn      caracteres de 8 pixels     
               lsr  vallsb         ; 00Cnnnnn
               lda  vallsb         ; devient = %00100000 = 32           
               sta  js_1x
               ; Port 1 Y
               lda  js_1pixy
               sta  vallsb  
               lsr  vallsb         ; Cnnnnnnn     On divise par 8 pc les 
               lsr  vallsb         ; 0Cnnnnnn     caracteres de 8 pixels     
               lsr  vallsb         ; 00Cnnnnn
               lda  vallsb         ; devient = %00100000 = 32           
               sta  js_1y
               pla
               plp
               rts
vallsb          .byte     0
regx            .byte     0
               .bend

;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_2correct     .block
               php
               pha 
               ; Port 2 X
               lda  js_2pixx
               sta  vallsb  
               lda  js_2pixx+1
               ror                 ; ex = %0000000100000001 = 257 pixel
               ror  vallsb         ; Cnnnnnnn     On divise par 8 pc les 
               lsr  vallsb         ; 0Cnnnnnn     caracteres de 8 pixels    
               lsr  vallsb         ; 00Cnnnnn
               lda  vallsb         ; devient = %00100000 = 32           
               sta  js_2x
               ; Port 2 Y
               lda  js_2pixy
               sta  vallsb
               lsr  vallsb         ; Cnnnnnnn     On divise par 8 pc les 
               lsr  vallsb         ; 0Cnnnnnn     caracteres de 8 pixels     
               lsr  vallsb         ; 00Cnnnnn
               lda  vallsb         ; devient = %00100000 = 32           
               sta  js_2y
               pla
               plp
               rts
vallsb          .byte     0
regx            .byte     0
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_showvals      .block
               ;jsr  js_1showvals
               jsr  js_2showvals
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_1showvals    .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               ; la valeur 8 bits de js_1 X
               lda  js_1x          
               jsr  atohex
               lda  a2hexstr+1 
               sta  js_1val8+19
               lda  a2hexstr+2 
               sta  js_1val8+20
               ; la valeur 16 bits de js_1 X
               lda  js_1pixx
               jsr  atohex
               lda  a2hexstr+1 
               sta  js_1val16+14
               lda  a2hexstr+2 
               sta  js_1val16+15
               lda  js_1pixx+1
               jsr  atohex
               lda  a2hexstr+1 
               sta  js_1val16+12
               lda  a2hexstr+2 
               sta  js_1val16+13
               ; la valeyr 8 bits de js_1 Y
               lda  js_1y          
               jsr  atohex
               ;lda  a2hexstr 
               ;sta  js_1val+21
               lda  a2hexstr+1 
               sta  js_1val8+23
               lda  a2hexstr+2 
               sta  js_1val8+24
               ; la valeur 16 bits de js_1 Y
               lda  js_1pixy
               jsr  atohex
               lda  a2hexstr+1 
               sta  js_1val16+20
               lda  a2hexstr+2 
               sta  js_1val16+21
               lda  #0
               jsr  atohex
               lda  a2hexstr+1 
               sta  js_1val16+18
               lda  a2hexstr+2 
               sta  js_1val16+19
               ; le bouton fire de js_1          
               lda  js_1fire          
               jsr  atohex
               lda  a2hexstr+2 
               sta  js_1val8+33
               ldx  #<js_1val8 
               ldy  #>js_1val8
               jsr  putscxy
               ldx  #<js_1val16 
               ldy  #>js_1val16
               jsr  putscxy
out            jsr  popreg         ; Récupère tous les registres.
               rts
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_2showvals    .block
               jsr  pushreg        ; Sauvegarde tous les registres.
               ; la valeur 8 bits de js_2 X
               lda  js_2x          
               jsr  atohex
               lda  a2hexstr 
               sta  js_2val8+19
               lda  a2hexstr+1 
               sta  js_2val8+20
               ; la valeur 16 bits de js_2 X
               ;lda  js_2pixx
               lda  js_2clickx
               jsr  atohex
               lda  a2hexstr 
               sta  js_2val16+14
               lda  a2hexstr+1 
               sta  js_2val16+15
               ;lda  js_2pixx+1
               lda  js_2clickx+1
               jsr  atohex
               lda  a2hexstr 
               sta  js_2val16+12
               lda  a2hexstr+1 
               sta  js_2val16+13
               ; la valeur 8 bits de js_2 Y
               lda  js_2y          
               jsr  atohex
               lda  a2hexstr 
               sta  js_2val8+23
               lda  a2hexstr+1 
               sta  js_2val8+24
               ; la valeur 16 bits de js_2 Y
               ;lda  js_2pixy
               lda  js_2clicky
               jsr  atohex
               lda  a2hexstr 
               sta  js_2val16+20
               lda  a2hexstr+1 
               sta  js_2val16+21
               lda  #0
               jsr  atohex
               lda  a2hexstr 
               sta  js_2val16+18
               lda  a2hexstr+1 
               sta  js_2val16+19
               ; le bouton fire de js_2          
               lda  js_2fire          
               jsr  atohex
               lda  a2hexstr+1 
               sta  js_2val8+33
; on affiche les données
               ldx  #<js_2val8
               ldy  #>js_2val8
               jsr  putscxy
               ldx  #<js_2val16a
               ldy  #>js_2val16a
               jsr  putscxy
               ldx  #<js_2val16
               ldy  #>js_2val16
               jsr  putscxy
out            jsr  popreg         ; Récupère tous les registres.
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_updatecurs   .block
               jsr  pushreg        ; Sauvegarde tous les registres.         
               ;lda  js_oldx
               ;cmp  #$ff
               ;beq     running             
               ;ldx  js_2x
               ;ldy  js_2y
               ;stx  js_oldx
               ;sty  js_oldy
               ;jsr  js_eoraddrxy
               ;       on réécrit l'ancien caractèere à sa place
running        lda  js_2x
               cmp  js_x
               beq     chky
               sta  js_x
               inc     flag
chky           lda  js_2y               
               cmp  js_y
               beq     chkflag
               sta  js_y
               inc     flag
chkflag        lda  flag
               beq     showit
               ldx  js_oldx
               ldy  js_oldy
               jsr  js_eoraddrxy
               ldx  js_x
               ldy  js_y
               jsr  js_eoraddrxy
               lda  js_x
               sta  js_oldx
               lda  js_y
               sta  js_oldy
showit         lda  #0
               sta  flag
               sta  addr1
               lda  #$04
               sta  addr1+1
               ldx  js_x
               ldy  js_y
               jsr  xy2addr
               ldy  addr2
               ldx  addr2+1
               ;jsr  showregs
out            jsr  popreg         ; Récupère tous les registres.
               rts
flag            .byte   0
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_eoraddrxy    .block
               jsr  pushall
               ;jsr  showregs
               jsr  savezp2
               lda  #$04
               sta  addr1+1
               lda  #0
               sta  addr1
               jsr  xy2addr
               ldy  addr2
               sty  zpage2
               ldx  addr2+1
               stx  zpage2+1
               ldy  #0
               lda  (zpage2),y
               eor     #%01000000
               sta  (zpage2),y
               jsr  restzp2
               jsr  popall
               rts
               .bend

;-------------------------------------------------------------------------------
; Variables publiques
;-------------------------------------------------------------------------------             
js_x           .byte   0
js_y           .byte   0
js_oldx        .byte   $ff   
js_oldy        .byte   $ff
js_oldcar      .byte   0
js_oldcol      .byte   0

; Port de jeux #1
js_1pixx       .word   0
js_1pixy       .byte   0
js_1x          .byte   0
js_1y          .byte   0
js_1fire       .byte   0
js_1flag       .byte   0
js_1clickx     .word   0        
js_1clicky     .byte   0
js_1events     .byte   0

; Port de jeu #2
js_2pixx       .word   0
js_2pixy       .byte   0     
js_2x          .byte   0
js_2y          .byte   0
js_2fire       .byte   0
js_2flag       .byte   0
js_2clickx     .word   0        
js_2clicky     .byte   0
js_2events     .byte   0

js_txtcol      =       vcyan         
js_txtbak      =       bkcol0        
js_1val8       .byte     js_txtcol,js_txtbak,4,5
                        ;      111111111122222222223333
                        ;456789012345678901234567890123
               .null     "Port 1 (x,y):($00,$00) Fire:(0)"
                        ;      111111111122
                        ;456789012345678901
js_1val16      .byte     js_txtcol,js_txtbak,11,7
               .null     "(x,y):($0000,$0000)"
                        ;      111111111122222222223333
                        ;456789012345678901234567890123
js_2val8       .byte     js_txtcol,js_txtbak,4,10
               .null     "CarPos (x,y):($00,$00) Fire:(0)"
js_2val16a     .byte     vblanc,js_txtbak,4,12
               .null     "Click pos."
js_2val16      .byte     js_txtcol,js_txtbak,16,12
               .null     "(x,y):($0000,$0000)"
js_1status     .byte 0
js_2status     .byte 0

               