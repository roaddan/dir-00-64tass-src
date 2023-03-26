          .enc      "screen"   
;---------------------------------------------------------------------
; lecture de la des manettes de commande numériques
;---------------------------------------------------------------------
j2port    =    $dc00
j1port    =    $dc01
j2dir     =    $dc02
j1dir     =    $dc03
xoffset   =    4
yoffset   =    4
initjoy
          .block
          php
          pha
          lda j1dir
          and  #$e0
          sta j1dir
          lda j2dir
          and  #$e0
          sta j2dir
          pla
          plp
          rts
          .bend
scanjoy
          .block
          php
          pha
          txa
          pha
          tya
          pha
; on determine de quel port ils s'agit         
;---------------------------------------------------------------------
; Port 1  j1= %000FRLDY  j2= %100FRLDU
;---------------------------------------------------------------------
          lda  j1port 
          and  #$1f
          cmp	#$00
          beq  port2
          eor  #$1f
          ;ldx  #$01
          ;jsr  showregs
          clc

j1b0      lsr            ;On decale j2 bit 0 dans C
          bcc  j1b1      ;Est-ce vers le haut (U)
          pha            ;On stack la valeur
          lda  j1pixy    ;Oui!
          sec            ;On place la carry a 1
          sbc  #yoffset  ;On reduit
          cmp  #$f0
          bcc  sto1ym
          lda  #$00
sto1ym    sta  j1pixy    ; le y 
          pla            ;On recupere la valeur

j1b1      lsr            ;On decale j2 bit 0 dans C
          bcc  j1b2      ;Est-ce vers le bas (D)
          pha            ;On stack la valeur
          lda  j1pixy    ;Oui!
          clc            ;On place la carry a 0
          adc  #yoffset  ;On augmente
          cmp  #200
          bcc  sto1yp
          lda  #200
sto1yp    sta  j1pixy    ; le y 
          pla            ;On recupere la valeur

j1b2      lsr            ;On decale j2 bit 0 dans C
          bcc  j1b3      ;Est-ce vers la gauche (L)
          pha            ;On stack la valeur
          sec            ;On place la carry a 1
          lda  j1pixx    ;Oui!
          sbc  #xoffset  ;On diminue
          sta  j1pixx    ; le X 
          bcs  j1b2out   ; de offset
          dec  j1pixx+1  ; sur 16 bits
j1b2out   pla            ;On recupere la valeur

j1b3      lsr            ;On decale j2 bit 0 dans C
          bcc  j1b4      ;Est-ce vers la droite (R)
          pha            ;On stack la valeur
          lda  j1pixx    ;Oui!
          clc            ;On place la carry a 0
          adc  #xoffset  ;On augmente
          sta  j1pixx    ; le X 
          bcc  j1b3out      ; de offset
          inc  j1pixx+1  ; sur 16 bits
j1b3out   pla            ;On recupere la valeur

j1b4      lsr            ;Estce le bbouton fire (F)
          bcc  j1wait     ;Oui!
          inc  j1fire    ; on augmente le nombre de tir

j1wait    ldx  #$01
          ldy  #$ff
j1rel     iny
          jsr  showregs
          lda  j1port 
          and  #$1f
          cmp  #$1f      ;On attend le telachement 
          bne  j1rel     ; des boutons

;---------------------------------------------------------------------
; Port 2
;---------------------------------------------------------------------
port2     lda  j2port 
          and  #$1f 
          cmp	#$1f
          beq  out
          eor  #$1f
          ldx  #$02
          ;jsr  showregs          
          clc
          
j2b0      lsr            ;On decale j2 bit 0 dans C
          bcc  j2b1      ;Est-ce vers le haut (U)
          pha            ;On stack la valeur
          lda  j2pixy    ;Oui!
          sec            ;On place la carry a 1
          sbc  #yoffset  ;On reduit
          cmp  #$f0
          bcc  sto2ym
          lda  #$00
sto2ym    sta  j2pixy    ; le y 
          pla            ;On recupere la valeur

j2b1      lsr            ;On decale j2 bit 0 dans C
          bcc  j2b2      ;Est-ce vers le bas (D)
          pha            ;On stack la valeur
          lda  j2pixy    ;Oui!
          clc            ;On place la carry a 0
          adc  #yoffset  ;On augmente
          cmp  #200
          bcc  sto2yp
          lda  #200
sto2yp    sta  j2pixy    ; le y 
          pla            ;On recupere la valeur

j2b2      lsr            ;On decale j2 bit 0 dans C
          bcc  j2b3      ;Est-ce vers la gauche (L)
          pha            ;On stack la valeur
          sec            ;On place la carry a 1
          lda  j2pixx    ;Oui!
          sbc  #xoffset  ;On diminue
          sta  j2pixx    ; le X 
          bcs  j2b2out   ; de offset
          dec  j2pixx+1  ; sur 16 bits
j2b2out   pla            ;On recupere la valeur

j2b3      lsr            ;On decale j2 bit 0 dans C
          bcc  j2b4      ;Est-ce vers la droite (R)
          pha            ;On stack la valeur
          lda  j2pixx    ;Oui!
          clc            ;On place la carry a 0
          adc  #xoffset  ;On augmente
          sta  j2pixx    ; le X 
          bcc  j2b3out      ; de offset
          inc  j2pixx+1  ; sur 16 bits
j2b3out   pla            ;On recupere la valeur

j2b4      lsr            ;Estce le bbouton fire (F)
          bcc  j2wait    ;Oui!
          inc  j2fire    ; on augmente le nombre de tir

j2wait    ldx  #$02
          ldy  #$ff
j2rel     iny
          jsr  showregs
          lda  j2port 
          and  #$1f
          cmp  #$1f      ;On attend le telachement 
          bne  j2rel     ; des boutons

out       pla
          tay
          pla
          tax
          pla
          plp
          jsr  jscorrection
          rts
          .bend
          
jscorrection
          .block
          php
          pha 
          ; Port 1 X
          lda  j1pixx
          sta  vallsb  
          lda  j1pixx+1  ; xxxxxxxn
          ror            ; xxxxxxx(x)->C ex = %0000000100000001 = 257 pixel
          ror  vallsb    ; Cnnnnnnn      In divise par 8 pc les 
          lsr  vallsb    ; 0Cnnnnnn      caracteres ont 8 pixel de large     
          lsr  vallsb    ; 00Cnnnnn
          lda  vallsb    ;               devient = %00100000 = 32           
          sta  j1x
          ; Port 1 Y
          lda  j1pixy
          sta  vallsb  
          lda  j1pixy+1
          ror            ;              ex = %0000000100000001 = 257 pixel
          ror  vallsb    ; Cnnnnnnn     In divise par 8 pc les 
          lsr  vallsb    ; 0Cnnnnnn     caracteres ont 8 pixel de large     
          lsr  vallsb    ; 00Cnnnnn
          lda  vallsb    ;              devient = %00100000 = 32           
          sta  j1y
          ; Port 2 X
          lda  j2pixx
          sta  vallsb  
          lda  j2pixx+1
          ror            ;              ex = %0000000100000001 = 257 pixel
          ror  vallsb    ; Cnnnnnnn     In divise par 8 pc les 
          lsr  vallsb    ; 0Cnnnnnn     caracteres ont 8 pixel de large     
          lsr  vallsb    ; 00Cnnnnn
          lda  vallsb    ;              devient = %00100000 = 32           
          sta  j2x
          ; Port 2 Y
          lda  j2pixy
          sta  vallsb  
          lda  j2pixy+1
          ror            ;              ex = %0000000100000001 = 257 pixel
          ror  vallsb    ; Cnnnnnnn     In divise par 8 pc les 
          lsr  vallsb    ; 0Cnnnnnn     caracteres ont 8 pixel de large     
          lsr  vallsb    ; 00Cnnnnn
          lda  vallsb    ;              devient = %00100000 = 32           
          sta  j2y
          pla
          plp
          rts
vallsb    .byte     0
regx      .byte     0
          .bend
showjsvals
          .block
          php
          pha
          ; la valeur 8 bits de j1 X
          lda  j1x          
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j1val8+19
          lda  a2hexstr+2 
          sta  j1val8+20
          ; la valeur 16 bits de j1 X
          lda  j1pixx
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j1val16+14
          lda  a2hexstr+2 
          sta  j1val16+15
          lda  j1pixx+1
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j1val16+12
          lda  a2hexstr+2 
          sta  j1val16+13
          ; la valeyr 8 bits de j1 Y
          lda  j1y          
          jsr  a2hex
          ;lda  a2hexstr 
          ;sta  j1val+21
          lda  a2hexstr+1 
          sta  j1val8+23
          lda  a2hexstr+2 
          sta  j1val8+24
          ; la valeur 16 bits de j1 Y
          lda  j1pixy
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j1val16+20
          lda  a2hexstr+2 
          sta  j1val16+21
          lda  #0
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j1val16+18
          lda  a2hexstr+2 
          sta  j1val16+19
          ; le bouton fire de j1          
          lda  j1fire          
          jsr  a2hex
          lda  a2hexstr+2 
          sta  j1val8+33
          ; la valeur 8 bits de j2 X
          lda  j2x          
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j2val8+19
          lda  a2hexstr+2 
          sta  j2val8+20
          ; la valeur 16 bits de j2 X
          lda  j2pixx
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j2val16+14
          lda  a2hexstr+2 
          sta  j2val16+15
          lda  j2pixx+1
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j2val16+12
          lda  a2hexstr+2 
          sta  j2val16+13
          ; la valeur 8 bits de j2 Y
          lda  j2y          
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j2val8+23
          lda  a2hexstr+2 
          sta  j2val8+24
          ; la valeur 16 bits de j2 Y
          lda  j2pixy
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j2val16+20
          lda  a2hexstr+2 
          sta  j2val16+21
          lda  #0
          jsr  a2hex
          lda  a2hexstr+1 
          sta  j2val16+18
          lda  a2hexstr+2 
          sta  j2val16+19
          ; le bouton fire de j2          
          lda  j2fire          
          jsr  a2hex
          lda  a2hexstr+2 
          sta  j2val8+33
          txa
          pha
          tya
          pha
          ldx  #<j1val8 
          ldy  #>j1val8
          jsr  sd_putscxy
          ldx  #<j1val16 
          ldy  #>j1val16
          jsr  sd_putscxy
          ldx  #<j2val8
          ldy  #>j2val8
          jsr  sd_putscxy
          ldx  #<j2val16
          ldy  #>j2val16
          jsr  sd_putscxy
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend
j1pixx    .word     160
j1pixy    .byte     100
j1x       .byte     20
j1y       .byte     12
j1fire    .byte     $0
j2pixx    .word     160
j2pixy    .byte     100     
j2x       .byte     20
j2y       .byte     12
j2fire    .byte     $0
txtcol = vcyan         
txtbak = sd_bkcol0        
   
j1val8    .byte     txtcol,txtbak,4,5
                    ;      111111111122222222223333
                    ;456789012345678901234567890123
          .text     "Port 1 (x,y):($00,$00) Fire:(0)"
          .byte     0
                    ;      111111111122
                    ;456789012345678901
j1val16   .byte     txtcol,txtbak,11,7
          .text     "(x,y):($0000,$0000)"
          .byte     0
                    ;      111111111122222222223333
                    ;456789012345678901234567890123
j2val8    .byte     txtcol,txtbak,4,10
          .text     "Port 2 (x,y):($00,$00) Fire:(0)"
          .byte     0
                    ;      111111111122
                    ;456789012345678901
j2val16   .byte     txtcol,txtbak,11,12
          .text     "(x,y):($0000,$0000)"
          .byte     0
          
move          