;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: lib-c64-joystick.asm
; Version ........: Quelque part en 2023
; Cernière m.à j. : 20250521
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Lecture de la des manettes de commande numériques.
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Déclaration des constantes.
;--------------------------------------------------------------------------------
js_2port       =    $dc00          ; CIA #1 Port data A 
js_1port       =    $dc01          ; CIA #1 Port data B
js_2dir        =    $dc02          ; CIA #1 Port de direction A
js_1dir        =    $dc03          ; CIA #1 port de direction B
js_xoffset     =    2
js_yoffset     =    2
js_location    =    0

;--------------------------------------------------------------------------------
; Initialisation des registres PIA pour la lecture des ports manette.
;--------------------------------------------------------------------------------
js_init        .block
               php
               pha
               lda  js_1dir        ; Place les bits de direction du port B
               and  #$e0           ; 4-0 en entrées (0).
               sta  js_1dir
               lda  js_2dir        ; Place les bits de direction du port A
               and  #$e0           ; 4-0 en entrées (0).
               sta  js_2dir
               plp
               pla
               rts
               .bend
                
;--------------------------------------------------------------------------------
; Effectue un scan de tous les ports pour mettre à jour les variables d'action.
;--------------------------------------------------------------------------------
js_scan        .block
               jsr  js_1scan
               jsr  js_2scan
               rts
               .bend
;--------------------------------------------------------------------------------
; Port 1 js_1= %000FRLDU
;--------------------------------------------------------------------------------
js_1scan       .block
               jsr  push
               lda  js_1port 
               and  #$1f
               pha
               eor  #$1f
               sta  js_1status
               pla
               cmp  #$00
               bne  p1scan
               jmp  port1_out
p1scan         eor  #$1f
               clc
               ;------------------------
               ; BOUTON EN-HAUT
               ;------------------------
               ;On decale js_2 bit 0 dans C
js_1b0         lsr                     
               ;Est-ce vers le haut (U)
               bcc  js_1b1          
               ;On stock la valeur
               pha
               inc  js_1flag
               ;Oui!
               lda  js_1pixy
               ;On place la carry a 1
               sec
               ;On reduit
               sbc  #js_yoffset
               cmp  #$f0
               bcc  sto1ym
               lda  #$00
               ; le y 
sto1ym         sta  js_1pixy
               ;On recupere la valeur
               pla                     
     ;------------------------
     ; BOUTON EN-BAS
     ;------------------------
     ;On decale js_2 bit 0 dans C
js_1b1         lsr
     ;Est-ce vers le bas (D)
               bcc  js_1b2
     ;On stack la valeur
               pha
               inc  js_1flag
     ;Oui!
               lda  js_1pixy
     ;On place la carry a 0
               clc
     ;On augmente
               adc  #js_yoffset
               cmp  #199
               bcc  sto1yp
               lda  #199
     ; le y 
sto1yp         sta  js_1pixy
     ;On recupere la valeur
               pla
     ;------------------------
     ; BOUTON A-GAUCHE
     ;------------------------
     ;On decale js_1 bit 0 dans C
js_1b2         lsr
     ;Est-ce vers la gauche (L)
               bcc  js_1b3
     ;On stack la valeur
               pha
               inc  js_1flag
     ;Oui!
               lda  js_1pixx
               ora  js_1pixx+1
               beq  js_1b2out
     ;On place la carry a 1
               sec
     ;Oui!
               lda  js_1pixx
     ;On diminue
               sbc  #js_xoffset
     ; le X 
               sta  js_1pixx
     ; de offset
               bcs  js_1b2out
               lda  js_1pixx+1
               beq  js_1b2out
     ; sur 16 bits
               dec  js_1pixx+1
     ;On recupere la valeur
js_1b2out      pla
;------------------------
; BOUTON A-BROITE
;------------------------
     ;On decale js_1 bit 0 dans C
js_1b3         lsr
     ;Est-ce vers la droite (R)
               bcc  js_1b4
     ;On stack la valeur
               pha
               inc  js_1flag
               lda  js_1pixx+1
               beq  incj1x
               lda  js_1pixx
               cmp  #$40-4
               bmi  incj1x
               jmp  js_1b3out
     ;On place la carry a 0
incj1x         clc
               lda  js_1pixx       
     ;On augmente
               adc  #js_xoffset
     ; le X 
               sta  js_1pixx
     ; de offset
               bcc  js_1b3out
     ; sur 16 bits
               inc  js_1pixx+1
     ;On recupere la valeur
js_1b3out      pla
;------------------------
; BOUTON FIRE
;------------------------
js_1b4          lsr                     ;Estce le bbouton fire (F)
                bcc     port1_out       ;Oui!
                inc     js_1flag
                inc     js_1fire        ; on augmente le nombre de tir
js_1wait        ldx     #$01
                ldy     #$ff
js_1rel         iny
                ;jsr     showregs
                lda     js_1port 
                eor     #$ff
                and     #$10
                ;cmp     #$1f            ;On attend le telachement 
                bne     js_1rel         ; des boutons
port1_out       lda     js_1flag
                beq     out
                jsr     js_1correct
                lda     #0
                sta     js_1flag
out             jsr     pop
                .bend
;-------------------------------------------------------------------------------
; Port 2 js_2= %100FRLDU
;-------------------------------------------------------------------------------
js_2scan         .block
                jsr     push
port2           lda     js_2port 
                and     #$1f
                pha 
                eor     #$1f
                sta js_2status
                pla 
                cmp #$1f
                bne     p2scan
                ;jsr     showregs
                jmp     port2_out
p2scan          eor     #$1f
                ;ldx     #$02
                ;jsr     showregs          
                clc
;------------------------
; BOUTON EN-HAUT
;------------------------
js_2b0          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b1          ;Est-ce vers le haut (U)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixy        ;Oui!
                sec                     ;On place la carry a 1
                sbc     #js_yoffset     ;On reduit
                cmp     #$f0
                bcc     sto2ym
                lda     #$00
sto2ym          sta     js_2pixy        ; le y 
                pla                     ;On recupere la valeur
;------------------------
; BOUTON EN-BAS
;------------------------
js_2b1          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b2          ;Est-ce vers le bas (D)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixy        ;Oui!
                clc                     ;On place la carry a 0
                adc     #js_yoffset     ;On augmente
                cmp     #199
                bcc     sto2yp
                lda     #199
sto2yp          sta     js_2pixy        ; le y 
                pla                     ;On recupere la valeur
;------------------------
; BOUTON A-GAUCHE
;------------------------
js_2b2          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b3          ;Est-ce vers la gauche (L)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixx        ;Oui!
                ora     js_2pixx+1
                beq     js_2b2out
                sec                     ;On place la carry a 1
                lda     js_2pixx        ;Oui!
                sbc     #js_xoffset     ;On diminue
                sta     js_2pixx        ; le X 
                bcs     js_2b2out       ; de offset
                lda     js_2pixx+1
                beq     js_2b2out
                dec     js_2pixx+1      ; sur 16 bits
js_2b2out       pla                     ;On recupere la valeur
;------------------------
; BOUTON A-DROITE
;------------------------
js_2b3          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b4          ;Est-ce vers la droite (R)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixx+1
                beq     incj2x
                lda     js_2pixx
                cmp     #$40-js_xoffset
                bmi     incj2x
                jmp     js_2b3out
incj2x          clc                     ;On place la carry a 0
                lda     js_2pixx        ;Oui!
                adc     #js_xoffset     ;On augmente
                sta     js_2pixx        ; le X 
                bcc     js_2b3out       ; de offset
                inc     js_2pixx+1      ; sur 16 bits
js_2b3out       pla                     ;On recupere la valeur
;------------------------
; BOUTON FIRE
;------------------------
js_2b4          lsr                     ;Estce le bbouton fire (F)
                bcc     port2_out       ;Oui!
                inc     js_2flag
                inc     js_2fire        ; on augmente le nombre de tir
                lda     #%00000001
                sta     js_2events
                lda     js_2pixx
                sta     js_2clickx
                lda     js_2pixx+1
                sta     js_2clickx+1
                lda     js_2pixy
                sta     js_2clicky
                lda     js_2val16a+1
                eor     #%01000000
                sta     js_2val16a+1
js_2wait        ldx     #$00
                ldy     #$ff
js_2rel         iny
                bne     sr1
                inx
sr1             ;jsr     showregs
                lda     js_2port 
                eor     #$ff
                and     #$10
                ;cmp     #$1f           ;On attend le telachement 
                bne     js_2rel         ; des boutons
port2_out       lda     js_2flag
                beq     out
                jsr     js_2correct
                lda     #0
                sta     js_2flag
out             jsr     pop
                .bend
;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_corrector    .block          
                php          
                pha
                lda     js_1flag
                beq     check2
                jsr     js_1correct          
                lda     #0
                sta     js_1flag
check2          lda     js_2flag  
                beq     no_update
                jsr     js_2correct  
                lda     #0
                sta     js_2flag
no_update       pla
                plp
                rts
                .bend          
;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_1correct     .block
                php
                pha 
                ; Port 1 X
                lda     js_1pixx
                sta     vallsb  
                lda     js_1pixx+1
                ror                     ; ex = %0000000100000001 = 257 pixel
                ror     vallsb          ; Cnnnnnnn      On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn      caracteres de 8 pixels     
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_1x
                ; Port 1 Y
                lda     js_1pixy
                sta     vallsb  
                lsr     vallsb          ; Cnnnnnnn     On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn     caracteres de 8 pixels     
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_1y
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
                lda     js_2pixx
                sta     vallsb  
                lda     js_2pixx+1
                ror                     ; ex = %0000000100000001 = 257 pixel
                ror     vallsb          ; Cnnnnnnn     On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn     caracteres de 8 pixels    
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_2x
                ; Port 2 Y
                lda     js_2pixy
                sta     vallsb
                lsr     vallsb          ; Cnnnnnnn     On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn     caracteres de 8 pixels     
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_2y
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
                ;jsr     js_1showvals
                jsr     js_2showvals
                rts
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_1showvals    .block
                jsr     push
                ; la valeur 8 bits de js_1 X
                lda     js_1x          
                jsr     a2hex
                lda     a2hexstr+1 
                sta     js_1val8+19
                lda     a2hexstr+2 
                sta     js_1val8+20
                ; la valeur 16 bits de js_1 X
                lda     js_1pixx
                jsr     a2hex
                lda     a2hexstr+1 
                sta     js_1val16+14
                lda     a2hexstr+2 
                sta     js_1val16+15
                lda     js_1pixx+1
                jsr     a2hex
                lda     a2hexstr+1 
                sta     js_1val16+12
                lda     a2hexstr+2 
                sta     js_1val16+13
                ; la valeyr 8 bits de js_1 Y
                lda     js_1y          
                jsr     a2hex
                ;lda  a2hexstr 
                ;sta  js_1val+21
                lda     a2hexstr+1 
                sta     js_1val8+23
                lda     a2hexstr+2 
                sta     js_1val8+24
                ; la valeur 16 bits de js_1 Y
                lda     js_1pixy
                jsr     a2hex
                lda     a2hexstr+1 
                sta     js_1val16+20
                lda     a2hexstr+2 
                sta     js_1val16+21
                lda     #0
                jsr     a2hex
                lda     a2hexstr+1 
                sta     js_1val16+18
                lda     a2hexstr+2 
                sta     js_1val16+19
                ; le bouton fire de js_1          
                lda     js_1fire          
                jsr     a2hex
                lda     a2hexstr+2 
                sta     js_1val8+33
                ldx     #<js_1val8 
                ldy     #>js_1val8
                jsr     putscxy
                ldx     #<js_1val16 
                ldy     #>js_1val16
                jsr     putscxy
                jsr     pop                
                rts
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_2showvals    .block
                jsr     push                    ; stack : y, x, a, flg
                ; la valeur 8 bits de js_2 X
                lda     js_2x          
                jsr     a2hex
                lda     a2hexstr 
                sta     js_2val8+19
                lda     a2hexstr+1 
                sta     js_2val8+20
                ; la valeur 16 bits de js_2 X
                ;lda     js_2pixx
                lda     js_2clickx
                jsr     a2hex
                lda     a2hexstr 
                sta     js_2val16+14
                lda     a2hexstr+1 
                sta     js_2val16+15
                ;lda     js_2pixx+1
                lda     js_2clickx+1
                jsr     a2hex
                lda     a2hexstr 
                sta     js_2val16+12
                lda     a2hexstr+1 
                sta     js_2val16+13
                ; la valeur 8 bits de js_2 Y
                lda     js_2y          
                jsr     a2hex
                lda     a2hexstr 
                sta     js_2val8+23
                lda     a2hexstr+1 
                sta     js_2val8+24
                ; la valeur 16 bits de js_2 Y
                ;lda     js_2pixy
                lda     js_2clicky
                jsr     a2hex
                lda     a2hexstr 
                sta     js_2val16+20
                lda     a2hexstr+1 
                sta     js_2val16+21
                lda     #0
                jsr     a2hex
                lda     a2hexstr 
                sta     js_2val16+18
                lda     a2hexstr+1 
                sta     js_2val16+19
                ; le bouton fire de js_2          
                lda     js_2fire          
                jsr     a2hex
                lda     a2hexstr+1 
                sta     js_2val8+33
; on affiche les données
                ldx     #<js_2val8
                ldy     #>js_2val8
                jsr     putscxy
                ldx     #<js_2val16a
                ldy     #>js_2val16a
                jsr     putscxy
                ldx     #<js_2val16
                ldy     #>js_2val16
                jsr     putscxy
                jsr     pop
                rts
                .bend
                
js_updatecurs   .block
                jsr     push                
                ;lda     js_oldx
                ;cmp     #$ff
                ;beq     running             
                ;ldx     js_2x
                ;ldy     js_2y
                ;stx     js_oldx
                ;sty     js_oldy
                ;jsr     js_eoraddrxy
                ;       on réécrit l'ancien caractèere àa sa place
running         lda     js_2x
                cmp     js_x
                beq     chky
                sta     js_x
                inc     flag
chky            lda     js_2y                
                cmp     js_y
                beq     chkflag
                sta     js_y
                inc     flag
chkflag         lda     flag
                beq     showit
                ldx     js_oldx
                ldy     js_oldy
                jsr     js_eoraddrxy
                ldx     js_x
                ldy     js_y
                jsr     js_eoraddrxy
                lda     js_x
                sta     js_oldx
                lda     js_y
                sta     js_oldy
showit          lda     #0
                sta     flag
                sta     addr1
                lda     #$04
                sta     addr1+1
                ldx     js_x
                ldy     js_y
                jsr     xy2addr
                ldy     addr2
                ldx     addr2+1
                ;jsr     showregs
                jsr pop
                rts
flag            .byte   0
                .bend

js_eoraddrxy    .block
                jsr     push
                ;jsr     showregs
                jsr     savezp2
                lda     #$04
                sta     addr1+1
                lda     #0
                sta     addr1
                jsr     xy2addr
                ldy     addr2
                sty     zpage2
                ldx     addr2+1
                stx     zpage2+1
                ldy     #0
                lda     (zpage2),y
                eor     #%01000000
                sta     (zpage2),y
                jsr     restzp2
                jsr     pop
                rts
                .bend
                
js_x            .byte   0
js_y            .byte   0
js_oldx         .byte   $ff   
js_oldy         .byte   $ff
js_oldcar       .byte   0
js_oldcol       .byte   0


js_1pixx        .word   0
js_1pixy        .byte   0
js_1x           .byte   0
js_1y           .byte   0
js_1fire        .byte   0
js_1flag        .byte   0
js_1clickx      .word   0        
js_1clicky      .byte   0
js_1events      .byte   0

js_2pixx        .word   0
js_2pixy        .byte   0     
js_2x           .byte   0
js_2y           .byte   0
js_2fire        .byte   0
js_2flag        .byte   0
js_2clickx      .word   0        
js_2clicky      .byte   0
js_2events      .byte   0

js_txtcol       =       vcyan         
js_txtbak       =       bkcol0        
js_1val8        .byte     js_txtcol,js_txtbak,4,5
                        ;      111111111122222222223333
                        ;456789012345678901234567890123
                .text   "Port 1 (x,y):($00,$00) Fire:(0)"
                .byte   0
                        ;      111111111122
                        ;456789012345678901
js_1val16       .byte   js_txtcol,js_txtbak,11,7
                .text   "(x,y):($0000,$0000)"
                .byte   0
                        ;      111111111122222222223333
                        ;456789012345678901234567890123
js_2val8        .byte   js_txtcol,js_txtbak,4,10
                .text   "CarPos (x,y):($00,$00) Fire:(0)"
                .byte   0
js_2val16a      .byte   vblanc,js_txtbak,4,12
                .text   "Click pos."
                .byte   0
js_2val16       .byte   js_txtcol,js_txtbak,16,12
                .text   "(x,y):($0000,$0000)"
                .byte   0

js_1status     .byte 0
js_2status     .byte 0

                