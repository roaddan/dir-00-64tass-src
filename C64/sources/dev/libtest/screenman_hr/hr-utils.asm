;---------------------------------------------------------------------
;screen managing utilities
;---------------------------------------------------------------------
hr_bkcol    =    %00000000
hr_bkcol0   =    %00000000
hr_bkcol1   =    %01000000
hr_bkcol2   =    %10000000
hr_bkcol3   =    %11000000
hr_zp1       .word     $00
hr_zp2       .word     $00
hr_scrptr    .word     $00
hr_colptr    .word     $00
hr_curcol    .byte     $00
hr_brdcol    .byte     $0c
hr_bakcol    .byte     $00
hr_bakcol0   .byte     vnoir   ;$0b
hr_bakcol1   .byte     vrouge   ;$0b
hr_bakcol2   .byte     vvert  ;$0b
hr_bakcol3   .byte     vbleu  ;$0b
hr_inverse   .byte     $00
hr_scraddr   .byte     0,0,0,0,0
hr_coladdr   .byte     0,0,0,0,0
;---------------------------------------------------------------------
; Initialise le pointeur d'écran et efface l'écran
;---------------------------------------------------------------------

hr_scrmaninit
          .block
          php
          pha
          lda  #%00010101
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
          ora  #%01000000
          sta  $d011
          lda  hr_bakcol0
          sta  $d021
          lda  hr_bakcol1
          sta  $d022
          lda  hr_bakcol2
          sta  $d023
          lda  hr_bakcol3
          sta  $d024
          pla
          plp
          .bend
hr_curshome          
          .block          
          php
          pha
          lda  #$00
          sta  hr_scrptr
          lda  #$04
          sta  hr_scrptr+1
          jsr  hr_synccolptr
          lda  hr_bakcol0 
          sta  $d021
          lda  hr_bakcol1 
          sta  $d022
          lda  hr_bakcol2 
          sta  $d023
          lda  hr_bakcol3 
          sta  $d024
          ;jsr  hr_cls
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Incrémente le pointeur d'écran de une position
;---------------------------------------------------------------------
hr_incscrptr
          .block
          php
          pha
          inc  hr_scrptr
          lda  hr_scrptr
          bne  norep
          inc  hr_scrptr+1
norep     jsr  hr_synccolptr
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Synchronise les pointeurs d'écran et de couleur.
;---------------------------------------------------------------------
hr_synccolptr
          .block
          php
          pha
          lda  hr_scrptr
          sta  hr_colptr
          lda  hr_scrptr+1
          and  #%00000011
          ora  #%11011000
          sta  hr_colptr+1
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Efface l'écran avec la couleur voulue et place le curseur à 0,0.
;---------------------------------------------------------------------
hr_cls
          .block
          php
          pha
          txa
          pha
          tya
          pha
          lda  #$00
          sta  hr_scrptr
          lda  #$04
          sta  hr_scrptr+1
          jsr  hr_synccolptr
          jsr  hr_savezp1
          jsr  hr_scrptr2zp1
          lda  hr_brdcol
          sta  vborder
          lda  hr_bakcol
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
          sta  hr_scrptr
          lda  #$04
          sta  hr_scrptr+1
          jsr  hr_synccolptr
          jsr  hr_restzp1
          pla
          tay
          pla
          tax
          pla
          plp
          rts
          .bend
hr_setinverse   
          .block
          php
          pha
          lda  #%10000000
          sta  hr_inverse
          pla
          plp
          rts
          .bend
hr_clrinverse   
          .block
          php
          pha
          lda  #%00000000
          sta  hr_inverse
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Affiche une le caractères dont l'adresse est dans hr_zp2 à la position et couleur
; du curseur virtuel.        
;---------------------------------------------------------------------        
hr_z2putch   
          .block                
          php                
          pha         
          tya
          pha
          ldy  #$0
          lda  (zpage2),y                
          jsr  hr_putch
          pla
          tay
          pla
          plp
          rts
          .bend                
;---------------------------------------------------------------------
; Affiche une chaine-0 de caractères dont l'adresse est dans hr_zp2 à la position 
; du curseur virtuel.        
;---------------------------------------------------------------------
hr_z2puts     
          .block               
          php                    
          pha
          tya
          pha
          ldy  #$0
nextcar   lda  (zpage2),y 
          beq  endstr
          jsr  hr_z2putch
          jsr  hr_inczp2
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
hr_putch
          .block
          php                 ; On sauvegarde les registres
          pha
          sta  car            ; On memorise le caractèere à imprimer
          txa
          pha
          tya
          pha
          jsr  hr_savezp1     ; On sauve le hr_zp1 du progamme appelant
          jsr  hr_scrptr2zp1  ; On place le pointeur d'écran sur hr_zp1
          ldy  #0             ; On met Y à 0
          lda  car            ; On recharge le caractère
          and  #%00111111
          ora  hr_bkcol
          sta  (zpage1),y     ; On affiche le caractèere
          ldx  hr_colptr+1    ; On place le MSB du pointeur de couleur
          stx  zpage1+1       ; dans le MSB du hr_zp1
          lda  hr_curcol      ; on charge la couleur voulu dans
          sta  (zpage1),y     ; la ram de couleur
          jsr  hr_incscrptr   ; On incrémente le pointeur d'écran 
          jsr  hr_restzp1     ; On récupèere le zpe du programme appelant
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
hr_puts     
          .block
          php
          pha
          txa
          pha
          tya
          pha
          jsr  hr_savezp2
          stx  zpage2
          sty  zpage2+1
          jsr  hr_z2puts
;          ldy  #0
;nextcar   lda  (zpage2),y
;          cmp  #0
;          beq  getout
;          jsr  hr_putch
;          jsr  hr_inczp2
;          jmp  nextcar
getout    jsr  hr_restzp2
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
hr_putsxy   
          .block
          php                 ; On sauvegarde les registres et le hr_zp2         
          pha
          txa
          pha
          tya
          pha
          jsr  hr_savezp2
          stx  zpage2         ; On place l'adresse de la chaine dans le hr_zp2
          sty  zpage2+1       ; X = MSB, Y = LSB
          ldy  #0             ; On place le compteur
          lda  (zpage2),y     ; Lecture de la position X
          tax                 ; de A à X
          jsr  hr_inczp2         ; On déplace le pointeur
          lda  (zpage2),y     ;
          tay                 ; de A à Y
          jsr  hr_gotoxy        ; hr_gotoxy prend X = colonne, y = ligne 
          jsr  hr_inczp2
          jsr  hr_z2puts
          jsr  hr_restzp2
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
hr_putscxy .block
          php                 ; On sauvegarde les registres et le hr_zp2         
          pha
          txa
          pha
          tya
          pha
          jsr  hr_savezp2
          stx  zpage2         ; On place l'adresse de la chaine dans le hr_zp2
          sty  zpage2+1       ; X = MSB, Y = LSB
          ldy  #0             ; On place le compteur
          lda  (zpage2),y     ; on charge la couleur
          jsr  hr_setcurcol   ; et on la définie
          jsr  hr_inczp2      ; On pointe le prochain byte
          lda  (zpage2),y     ; Lecture de la position X
          and  #$c0
          sta  hr_bkcol          
          jsr  hr_inczp2      ; On déplace le pointeur
          lda  (zpage2),y     ; Lecture de la position X
          tax                 ; de A à X
          jsr  hr_inczp2         ; On déplace le pointeur
          lda  (zpage2),y     ;
          tay                 ; de A à Y
          jsr  hr_gotoxy        ; hr_gotoxy prend X = colonne, y = ligne 
          jsr  hr_inczp2
          jsr  hr_z2puts
          jsr  hr_restzp2
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
hr_setcurcol
          .block
          php
          sta  hr_curcol
          plp
          rts
          .bend
hr_setbakcols
          .block
          php
          pha  
          txa
          and  #$3
          tax
          pla
          pha
          sta  hr_bakcol1,x
          sta  $d021,x
          pla  
          plp
          rts
          .bend
hr_setbkcol
          .block
          php
          pha
          and  #$c0
          sta  hr_bkcol
          lsr
          lsr
          lsr
          lsr
          lsr
          lsr
          and  #%00000011
          txa
          lda  hr_bakcol1,x
          sta  hr_bakcol
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
; Positionne le pointeur de position du prochain caractère de l'écran virtuel. 
;---------------------------------------------------------------------
hr_gotoxy
          .block
          php
          sta  ra
          stx  rx
          sty  ry
          jsr  hr_curshome
yagain    cpy  #0
          beq  setx
          lda  #40
          jsr  hr_saddscrptr
          dey
          jmp  yagain
setx      txa      
          jsr  hr_saddscrptr  
          jsr  hr_synccolptr 
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
hr_saddscrptr
          .block
          php
          pha
          clc
          adc hr_scrptr
          sta hr_scrptr
          bcc norep
          inc hr_scrptr+1
norep     pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_scrptr2str
         .block
;--on sauvegarde tout-------------------
         php
         txa
         pha
         tya
         pha
;--chaine du msb de l'ecran-------------
         lda hr_scrptr+1
         pha
         jsr lsra4bits
         jsr nib2hex
         sta hr_scraddr
         pla
         jsr lsra4bits
         jsr nib2hex
         sta hr_scraddr+1
;--chaine du msb de la couleur----------
         lda hr_scrptr+1
         pha
         jsr lsra4bits
         jsr nib2hex
         sta hr_scraddr
         pla
         jsr lsra4bits
         jsr nib2hex
         sta hr_scraddr+1
;--chaine du lsb de l'ecran et couleur--
         lda hr_scrptr
         pha
         jsr lsra4bits
         jsr nib2hex
         sta hr_scraddr+2
         sta hr_coladdr+2
         pla
         jsr lsra4bits
         jsr nib2hex
         sta hr_scraddr+3
         sta hr_coladdr+3
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
hr_savezp1
         .block
         php
         pha
         lda zpage1
         sta hr_zp1
         lda zpage1+1
         sta hr_zp1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_restzp1
         .block
         php
         pha
         lda hr_zp1
         sta zpage1
         lda hr_zp1+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_savezp2
         .block
         php
         pha
         lda zpage2
         sta hr_zp2
         lda zpage2+1
         sta hr_zp2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_restzp2
         .block
         php
         pha
         lda hr_zp2
         sta zpage2
         lda hr_zp2+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_scrptr2zp1
         .block
         php
         pha
         lda hr_scrptr
         sta zpage1
         lda hr_scrptr+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_colptr2zp1
         .block
         php
         pha
         lda hr_colptr
         sta zpage1
         lda hr_colptr+1
         sta zpage1+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_scrptr2zp2
         .block
         php
         pha
         lda hr_scrptr
         sta zpage2
         lda hr_scrptr+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_colptr2zp2
         .block
         php
         pha
         lda hr_colptr
         sta zpage2
         lda hr_colptr+1
         sta zpage2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
hr_inczp1  
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
hr_inczp2  
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