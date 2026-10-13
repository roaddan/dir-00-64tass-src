;---------------------------------------------------------------------
;screen managing utilities
;---------------------------------------------------------------------
zp1       .word     $00
zp2       .word     $00
scrptr    .word     $00
colptr    .word     $00
curcol    .byte     $00
brdcol    .byte     $0c
bakcol    .byte     $00 ;$0b
sinverse  .byte     $00
scraddr   .byte     0,0,0,0,0
coladdr   .byte     0,0,0,0,0
;---------------------------------------------------------------------
; Initialise le pointeur d'écran et efface l'écran
;---------------------------------------------------------------------
scurshome
scrmaninit
          .block
          php
          pha
          lda  #$00
          sta  scrptr
          lda  #$04
          sta  scrptr+1
          jsr  synccolptr
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Incrémente le pointeur d'écran de une position
;---------------------------------------------------------------------
incscrptr
          .block
          php
          pha
          inc  scrptr
          lda  scrptr
          bne  norep
          inc  scrptr+1
norep     jsr  synccolptr
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Synchronise les pointeurs d'écran et de couleur.
;---------------------------------------------------------------------
synccolptr
          .block
          php
          pha
          lda  scrptr
          sta  colptr
          lda  scrptr+1
          and  #%00000011
          ora  #%11011000
          sta  colptr+1
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Efface l'écran avec la couleur voulue et place le curseur à 0,0.
;---------------------------------------------------------------------
scls
          .block
          php
          pha
          txa
          pha
          tya
          pha
          jsr  scrmaninit
          jsr  savezp1
          jsr  scrptr2zp1
          lda  brdcol
          sta  vborder
          lda  bakcol
          sta  vbkgrnd
          lda  #$20
          ldx  #4
nextline  ldy  #0
nextcar   sta  (zpage1),y
          lda  zpage1+1
          pha
          and  #%00000011
          ora  #%11011000
          sta  zpage1+1
          lda  #0
          sta  (zpage1),y
          pla
          sta  zpage1+1
          lda  #$20
          dey
          bne  nextcar
          inc  zpage1+1
          dex
          bne  nextcar
          jsr  scrmaninit
          jsr  restzp1
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend
ssetinverse   
          .block
          php
          pha
          lda  #%10000000
          sta  sinverse
          pla
          plp
          rts
          .bend
sclrinverse   
          .block
          php
          pha
          lda  #%00000000
          sta  sinverse
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Affiche une le caractères dont l'adresse est dans zp2 à la position et couleur
; du curseur virtuel.        
;---------------------------------------------------------------------        
z2putch   
          .block                
          php                
          pha         
          tya
          pha
          ldy  #$0
          lda  (zpage2),y                
          ora  sinverse
          jsr  sputch
          pla
          tay
          pla
          plp
          rts
          .bend                
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dont l'adresse est dans zp2 à la position 
; du curseur virtuel.        
;---------------------------------------------------------------------
z2puts     
          .block               
          php                    
          pha
          tya
          pha
          ldy  #$0
nextcar   lda  (zpage2),y 
          beq  endstr
          jsr  z2putch
          jsr  inczp2
          jmp  nextcar          
endstr    pla
          tay
          pla
          plp               
          rts
          .bend               
;---------------------------------------------------------------------
; Affiche le caractèere dans A à la position et la couleur de l'écran virtuel.
;---------------------------------------------------------------------
sputch
          .block
          php                 ; On sauvegarde les registres
          pha
          sta  car            ; On memorise le caractèere à imprimer
          txa
          pha
          tya
          pha
          jsr  savezp1        ; On sauve le zp1 du progamme appelant
          jsr  scrptr2zp1     ; On place le pointeur d'écran sur ZP1
          ldy  #0             ; On met Y à 0
          lda  car            ; On recharge le caractère
          ;and  #%00111111    ; pour le mettre en majuscule
          sta  (zpage1),y     ; On affiche le caractèere
          ldx  colptr+1       ; On place le MSB du pointeur de couleur
          stx  zpage1+1       ; dans le MSB du ZP1
          lda  curcol         ; on charge la couleur voulu dans
          sta  (zpage1),y     ; la ram de couleur
          jsr  incscrptr      ; On incrémente le pointeur d'écran 
          jsr  restzp1        ; On récupèere le zpe du programme appelant
          pla                 ; on replace tous les registres
          tay
          pla
          tax
          pla
          plp
          rts
          car      .byte $00
          .bend
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères se terminant par 0 à la position du curseur        
; virtuel.        
;---------------------------------------------------------------------
sputs     
          .block
          php
          pha
          txa
          pha
          tya
          pha
          jsr  savezp2
          stx  zpage2
          sty  zpage2+1
          jsr  z2puts
;          ldy  #0
;nextcar   lda  (zpage2),y
;          cmp  #0
;          beq  getout
;          jsr  sputch
;          jsr  inczp2
;          jmp  nextcar
getout    jsr  restzp2
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend    
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dans la couleus C, à la position X,Y 
; qui sont les trois premier octets de ladresse X = MSB, Y = LSB
;---------------------------------------------------------------------
sputsxy   
          .block
          php                 ; On sauvegarde les registres et le zp2         
          pha
          txa
          pha
          tya
          pha
          jsr  savezp2
          stx  zpage2         ; On place l'adresse de la chaine dans le zp2
          sty  zpage2+1       ; X = MSB, Y = LSB
          ldy  #0             ; On place le compteur
          lda  (zpage2),y     ; Lecture de la position X
          tax                 ; de A à X
          jsr  inczp2         ; On déplace le pointeur
          lda  (zpage2),y     ;
          tay                 ; de A à Y
          jsr  sgotoxy        ; sgotoxy prend X = colonne, y = ligne 
          jsr  inczp2
          jsr  z2puts
          jsr  restzp2
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend    
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dans la couleus C, à la position X,Y 
; qui sont les trois premier octets de ladresse X = MSB, Y = LSB
;---------------------------------------------------------------------
sputscxy .block
          php                 ; On sauvegarde les registres et le zp2         
          pha
          txa
          pha
          tya
          pha
          jsr  savezp2
          stx  zpage2         ; On place l'adresse de la chaine dans le zp2
          sty  zpage2+1       ; X = MSB, Y = LSB
          ldy  #0             ; On place le compteur
          lda  (zpage2),y     ; on charge la couleur
          jsr  setcurcol      ; et on la définie
          jsr  inczp2         ; On pointe le prochain byte
          lda  (zpage2),y     ; Lecture de la position X
          tax                 ; de A à X
          jsr  inczp2         ; On déplace le pointeur
          lda  (zpage2),y     ;
          tay                 ; de A à Y
          jsr  sgotoxy        ; sgotoxy prend X = colonne, y = ligne 
          jsr  inczp2
          jsr  z2puts
          jsr  restzp2
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend    
;---------------------------------------------------------------------
; Place A dans le registre de couleur du prochain caractère de l'écran virtuel. 
;---------------------------------------------------------------------
setcurcol
          .block
          php
          sta  curcol
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Positionne le pointeur de position du prochain caractère de l'écran virtuel. 
;---------------------------------------------------------------------
sgotoxy
          .block
          php
          sta  ra
          stx  rx
          sty  ry
          jsr  scurshome
yagain    cpy  #0
          beq  setx
          lda  #40
          jsr  saddscrptr
          dey
          jmp  yagain
setx      txa      
          jsr  saddscrptr  
          jsr  synccolptr 
          ldy  ry
          ldx  rx
          lda  ra
          plp
          rts
ra        .byte $00
rx        .byte $00
ry        .byte $00
          .bend
;---------------------------------------------------------------------
; Déplace le pointeur du caractèere virtuel de A position. 
;---------------------------------------------------------------------
saddscrptr
          .block
          php
          pha
          clc
          adc scrptr
          sta scrptr
          bcc norep
          inc scrptr+1
norep     pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
scrptr2str
         .block
;--on sauvegarde tout-------------------
         php
         txa
         pha
         tya
         pha
;--chaine du msb de l'ecran-------------
         lda scrptr+1
         pha
         jsr lsra4bits
         jsr nib2hex
         sta scraddr
         pla
         jsr lsra4bits
         jsr nib2hex
         sta scraddr+1
;--chaine du msb de la couleur----------
         lda scrptr+1
         pha
         jsr lsra4bits
         jsr nib2hex
         sta scraddr
         pla
         jsr lsra4bits
         jsr nib2hex
         sta scraddr+1
;--chaine du lsb de l'ecran et couleur--
         lda scrptr
         pha
         jsr lsra4bits
         jsr nib2hex
         sta scraddr+2
         sta coladdr+2
         pla
         jsr lsra4bits
         jsr nib2hex
         sta scraddr+3
         sta coladdr+3
;--on recupere tout---------------------
         pla
         tay
         pla
         tax
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
savezp1
         .block
         php
         pha
         lda zpage1
         sta zp1
         lda zpage1+1
         sta zp1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
restzp1
         .block
         php
         pha
         lda zp1
         sta zpage1
         lda zp1+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
savezp2
         .block
         php
         pha
         lda zpage2
         sta zp2
         lda zpage2+1
         sta zp2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
restzp2
         .block
         php
         pha
         lda zp2
         sta zpage2
         lda zp2+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
scrptr2zp1
         .block
         php
         pha
         lda scrptr
         sta zpage1
         lda scrptr+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
colptr2zp1
         .block
         php
         pha
         lda colptr
         sta zpage1
         lda colptr+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
scrptr2zp2
         .block
         php
         pha
         lda scrptr
         sta zpage2
         lda scrptr+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
colptr2zp2
         .block
         php
         pha
         lda colptr
         sta zpage2
         lda colptr+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
inczp1  
          .block
          php
          pha
          inc  zpage1
          lda  zpage1
          bne  nopage
          inc  zpage1+1
nopage    pla       
          plp         
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
inczp2  
          .block
          php
          pha
          inc  zpage2
          lda  zpage2
          bne  nopage
          inc  zpage2+1
nopage    pla        
          plp         
          rts
          .bend