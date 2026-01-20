          .enc      "screen"   
;---------------------------------------------------------------------
;screen managing utilities
;---------------------------------------------------------------------
sd_bkcol    =    %00000000
sd_bkcol0   =    %00000000
sd_bkcol1   =    %01000000
sd_bkcol2   =    %10000000
sd_bkcol3   =    %11000000
sd_zp1       .word     $00
sd_zp2       .word     $00
sd_scrptr    .word     $00
sd_colptr    .word     $00
sd_curcol    .byte     $00
sd_brdcol    .byte     $0c
sd_bakcol    .byte     $00
sd_bakcol0   .byte     vnoir   ;$0b
sd_bakcol1   .byte     vrouge   ;$0b
sd_bakcol2   .byte     vvert  ;$0b
sd_bakcol3   .byte     vbleu  ;$0b
sd_inverse   .byte     $00
sd_scraddr   .byte     0,0,0,0,0
sd_coladdr   .byte     0,0,0,0,0
;---------------------------------------------------------------------
; Initialise le pointeur d'écran et efface l'écran
;---------------------------------------------------------------------

sd_scrmaninit
          .block
          php
          pha
          lda  #%00010111
          ;      |||||||+-> Not Used 
          ;      ||||||+--\
          ;      |||||+----> Character-set addr (*2048) (*$800)
          ;      ||||+----/
          ;      |||+-----\
          ;      ||+-------\ Video RAM address (*1024) (*$400)
          ;      |+--------/ (1024, 2018, 3072, 4096, ... 
          ;      +--------/
          sta  $d018
          ;lda  $d016
          ;ora  #%00010000
          ;sta  $d016
          lda  $d011
          and  #%10111111
          pla
          plp
          .bend
sd_curshome          
          .block          
          php
          pha
          lda  #$00
          sta  sd_scrptr
          lda  #$04
          sta  sd_scrptr+1
          jsr  sd_synccolptr
          lda  sd_bakcol0 
          sta  $d021
          lda  sd_bakcol1 
          sta  $d022
          lda  sd_bakcol2 
          sta  $d023
          lda  sd_bakcol3 
          sta  $d024
          ;jsr  sd_cls
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Incrémente le pointeur d'écran de une position
;---------------------------------------------------------------------
sd_incscrptr
          .block
          php
          pha
          inc  sd_scrptr
          lda  sd_scrptr
          bne  norep
          inc  sd_scrptr+1
norep     jsr  sd_synccolptr
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Synchronise les pointeurs d'écran et de couleur.
;---------------------------------------------------------------------
sd_synccolptr
          .block
          php
          pha
          lda  sd_scrptr
          sta  sd_colptr
          lda  sd_scrptr+1
          and  #%00000011
          ora  #%11011000
          sta  sd_colptr+1
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Efface l'écran avec la couleur voulue et place le curseur à 0,0.
;---------------------------------------------------------------------
sd_cls
          .block
          php
          pha
          txa
          pha
          tya
          pha
          lda  #$00
          sta  sd_scrptr
          lda  #$04
          sta  sd_scrptr+1
          jsr  sd_synccolptr
          jsr  sd_savezp1
          jsr  sd_scrptr2zp1
          lda  sd_brdcol
          sta  vborder
          lda  sd_bakcol
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
          lda  #$00
          sta  sd_scrptr
          lda  #$04
          sta  sd_scrptr+1
          jsr  sd_synccolptr
          jsr  sd_restzp1
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend
sd_setinverse   
          .block
          php
          pha
          lda  #%10000000
          sta  sd_inverse
          pla
          plp
          rts
          .bend
sd_clrinverse   
          .block
          php
          pha
          lda  #%00000000
          sta  sd_inverse
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Affiche une le caractères dont l'adresse est dans sd_zp2 à la position et couleur
; du curseur virtuel.        
;---------------------------------------------------------------------        
sd_z2putch   
          .block                
          php                
          pha         
          tya
          pha
          ldy  #$0
          lda  (zpage2),y                
          jsr  sd_putch
          pla
          tay
          pla
          plp
          rts
          .bend                
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dont l'adresse est dans sd_zp2 à la position 
; du curseur virtuel.        
;---------------------------------------------------------------------
sd_z2puts     
          .block               
          php                    
          pha
          tya
          pha
          ldy  #$0
nextcar   lda  (zpage2),y 
          beq  endstr
          jsr  sd_z2putch
          jsr  sd_inczp2
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
sd_putch
          .block
          php                 ; On sauvegarde les registres
          pha
          sta  car            ; On memorise le caractèere à imprimer
          txa
          pha
          tya
          pha
          jsr  sd_savezp1     ; On sauve le sd_zp1 du progamme appelant
          jsr  sd_scrptr2zp1  ; On place le pointeur d'écran sur sd_zp1
          ldy  #0             ; On met Y à 0
          lda  car            ; On recharge le caractère
          ora  sd_inverse
          sta  (zpage1),y     ; On affiche le caractèere
          ldx  sd_colptr+1    ; On place le MSB du pointeur de couleur
          stx  zpage1+1       ; dans le MSB du sd_zp1
          lda  sd_curcol      ; on charge la couleur voulu dans
          sta  (zpage1),y     ; la ram de couleur
          jsr  sd_incscrptr   ; On incrémente le pointeur d'écran 
          jsr  sd_restzp1     ; On récupèere le zpe du programme appelant
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
sd_puts     
          .block
          php
          pha
          txa
          pha
          tya
          pha
          jsr  sd_savezp2
          stx  zpage2
          sty  zpage2+1
          jsr  sd_z2puts
;          ldy  #0
;nextcar   lda  (zpage2),y
;          cmp  #0
;          beq  getout
;          jsr  sd_putch
;          jsr  sd_inczp2
;          jmp  nextcar
getout    jsr  sd_restzp2
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
sd_putsxy   
          .block
          php                 ; On sauvegarde les registres et le sd_zp2         
          pha
          txa
          pha
          tya
          pha
          jsr  sd_savezp2
          stx  zpage2         ; On place l'adresse de la chaine dans le sd_zp2
          sty  zpage2+1       ; X = MSB, Y = LSB
          ldy  #0             ; On place le compteur
          lda  (zpage2),y     ; Lecture de la position X
          tax                 ; de A à X
          jsr  sd_inczp2         ; On déplace le pointeur
          lda  (zpage2),y     ;
          tay                 ; de A à Y
          jsr  sd_gotoxy        ; sd_gotoxy prend X = colonne, y = ligne 
          jsr  sd_inczp2
          jsr  sd_z2puts
          jsr  sd_restzp2
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
sd_putscxy .block
          php                 ; On sauvegarde les registres et le sd_zp2         
          pha
          txa
          pha
          tya
          pha
          jsr  sd_savezp2
          stx  zpage2         ; On place l'adresse de la chaine dans le sd_zp2
          sty  zpage2+1       ; X = MSB, Y = LSB
          ldy  #0             ; On place le compteur
          lda  (zpage2),y     ; on charge la couleur
          jsr  sd_setcurcol   ; et on la définie
          jsr  sd_inczp2      ; On pointe le prochain byte
          lda  (zpage2),y     ; Lecture de la position X
          and  #$c0
          sta  sd_bkcol          
          jsr  sd_inczp2      ; On déplace le pointeur
          lda  (zpage2),y     ; Lecture de la position X
          tax                 ; de A à X
          jsr  sd_inczp2         ; On déplace le pointeur
          lda  (zpage2),y     ;
          tay                 ; de A à Y
          jsr  sd_gotoxy        ; sd_gotoxy prend X = colonne, y = ligne 
          jsr  sd_inczp2
          jsr  sd_z2puts
          jsr  sd_restzp2
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
sd_setcurcol
          .block
          php
          sta  sd_curcol
          plp
          rts
          .bend
sd_setbakcols
          .block
          php
          pha  
          txa
          and  #$3
          tax
          pla
          pha
          sta  sd_bakcol1,x
          sta  $d021,x
          pla  
          plp
          rts
          .bend
sd_setbkcol
          .block
          php
          pha
          and  #$c0
          sta  sd_bkcol
          lsr
          lsr
          lsr
          lsr
          lsr
          lsr
          and  #%00000011
          txa
          lda  sd_bakcol1,x
          sta  sd_bakcol
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Positionne le pointeur de position du prochain caractère de l'écran virtuel. 
;---------------------------------------------------------------------
sd_gotoxy
          .block
          php
          sta  ra
          stx  rx
          sty  ry
          jsr  sd_curshome
yagain    cpy  #0
          beq  setx
          lda  #40
          jsr  sd_saddscrptr
          dey
          jmp  yagain
setx      txa      
          jsr  sd_saddscrptr  
          jsr  sd_synccolptr 
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
sd_saddscrptr
          .block
          php
          pha
          clc
          adc sd_scrptr
          sta sd_scrptr
          bcc norep
          inc sd_scrptr+1
norep     pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_scrptr2str
         .block
;--on sauvegarde tout-------------------
         php
         txa
         pha
         tya
         pha
;--chaine du msb de l'ecran-------------
         lda sd_scrptr+1
         pha
         jsr lsra4bits
         jsr nib2hex
         sta sd_scraddr
         pla
         jsr lsra4bits
         jsr nib2hex
         sta sd_scraddr+1
;--chaine du msb de la couleur----------
         lda sd_scrptr+1
         pha
         jsr lsra4bits
         jsr nib2hex
         sta sd_scraddr
         pla
         jsr lsra4bits
         jsr nib2hex
         sta sd_scraddr+1
;--chaine du lsb de l'ecran et couleur--
         lda sd_scrptr
         pha
         jsr lsra4bits
         jsr nib2hex
         sta sd_scraddr+2
         sta sd_coladdr+2
         pla
         jsr lsra4bits
         jsr nib2hex
         sta sd_scraddr+3
         sta sd_coladdr+3
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
sd_savezp1
         .block
         php
         pha
         lda zpage1
         sta sd_zp1
         lda zpage1+1
         sta sd_zp1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_restzp1
         .block
         php
         pha
         lda sd_zp1
         sta zpage1
         lda sd_zp1+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_savezp2
         .block
         php
         pha
         lda zpage2
         sta sd_zp2
         lda zpage2+1
         sta sd_zp2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_restzp2
         .block
         php
         pha
         lda sd_zp2
         sta zpage2
         lda sd_zp2+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_scrptr2zp1
         .block
         php
         pha
         lda sd_scrptr
         sta zpage1
         lda sd_scrptr+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_colptr2zp1
         .block
         php
         pha
         lda sd_colptr
         sta zpage1
         lda sd_colptr+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_scrptr2zp2
         .block
         php
         pha
         lda sd_scrptr
         sta zpage2
         lda sd_scrptr+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_colptr2zp2
         .block
         php
         pha
         lda sd_colptr
         sta zpage2
         lda sd_colptr+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
sd_inczp1  
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
sd_inczp2  
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