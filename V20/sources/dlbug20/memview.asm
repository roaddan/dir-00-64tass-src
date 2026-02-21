;--------------------------------------
; Affiche les prochains 64 octets a 
; partir de l'adresse specifiée dans 
; la variable adrptr. 
; Dépendance: 
;    pushregs, popregs, put4mem
;--------------------------------------
mvmenu    .block
          jsr  pushregs
          jsr  mvaide
another   jsr  memdump   
          jsr  getkey
          cmp  #$5f
          bne  keyr
          jmp  out
;--------------------------------------
keyr      cmp  #$52      ; [R] refresh
          bne  upar      ; -64
          lda  #64
          #ldyxmem adrptr               
          jsr  subatoyx
          #styxmem adrptr
          jmp  another
;--------------------------------------
upar      cmp  #$91      ; crsr-up
          bne  dnar      ; -128
          lda  #128
          #ldyxmem adrptr               
          jsr  subatoyx
          #styxmem adrptr
          jmp  another
;--------------------------------------
dnar      cmp  #$11      ; crsr-down
          bne  lfar      ; asis
          jmp  another
;--------------------------------------
lfar      cmp  #$9d      ; crsr-left
          bne  rtar      ; -192
          lda  #192
          #ldyxmem adrptr               
          jsr  subatoyx
          #styxmem adrptr
          jmp  another
;--------------------------------------
rtar      cmp  #$1d      ; crsr-right
          bne  kf1        ; +64
          lda  #64
          #ldyxmem adrptr               
          jsr  addatoyx
          #styxmem adrptr
          jmp  another
kf1       cmp  #$85       ; f1
          bne  kf3        ; +1024
          lda  #64
          #ldyxmem adrptr               
          jsr  subatoyx
          #styxmem adrptr
          lda  adrptr+1
          sec
          sbc  #$10
          sta  adrptr+1
          jmp  another
kf3       cmp  #$86      ; crsr-right
          bne  chkkey    ; +64
          lda  #64
          #ldyxmem adrptr               
          jsr  subatoyx
          #styxmem adrptr
          lda  adrptr+1
          clc
          adc  #$10
          sta  adrptr+1
          jmp  another
;--------------------------------------
chkkey    jmp  another
out       ; effacer l'aide
          #outcar 147
          jsr  popregs
          rts
          .bend


mvaide    .block
          jsr  pushregs
          ldx  #16
          ldy  #00
          clc
          jsr  plot
          #print mvaide1
          #print mvaide2
          #print mvaide3
          #print mvaide4
          #print mvaide5
          #print mvaide6
          jsr  popregs
          rts
          .bend



;--------------------------------------
; Affiche les prochains 64 octets a 
; partir de l'adresse specifiée dans 
; la variable adrptr. 
; Dépendance: 
;    pushregs, popregs, put4mem
;--------------------------------------
memdump   .block
          #outcar 19
          jsr  pushregs
          ldy  #16
another   jsr  put4mem 
          dey
          bne  another
          jsr  popregs
          rts    
          .bend
;--------------------------------------
; Affiche le contenu de 4 adresses 
; memoire consécutives à partir de 
; l'adresse donnée par adrptr.
;--------------------------------------
put4mem   .block
          jsr  pushall
          lda  kcol
          pha
          #outcar snoir
          #ldyxmem adrptr               ; On sauve et affiche l'adresse memoire
          #outcar '$'
          jsr  putyxhex
          #styxzp1 adrptr               ; On place l'adresse dans ZP1          
          #ldyxmem scrnlin             ; On recupère l'adresse de l'ecran
          lda  #$12                     ; On y aditionne 18 pour la position
          jsr  addatoyx
          #styxmem scraddr              ; On sauvegarde l'adresse ecran
          #styxmem coladdr              ; On sauvegarde l'adresse couleur
          lda  coladdr+1                ; On ajuste l'adresse couleur en 
;          and  #%11101111               ; de l'adresse ecran en travaillant 
          ora  #%10010100               ; sur le MSB seulement. 
          sta  coladdr+1  
          #ldyxmem adrptr               ; On affiche le code ascii          
          #styxzp1
          ldy  #$00
nxtbyte   #outcar srouge
          #outcar 29
          lda  (zp1),y
          jsr  putahex
          #stvalzp2 scraddr             ; On affiche le caractere          
          sta  (zp2),y
          #stvalzp2 coladdr             ; et sa couleur.
          tya
          clc
          rol
          ;lda  #vbleu
          sta  (zp2),y 
          iny
          cpy  #$04
          bne  nxtbyte
          #ldyxmem adrptr               ; Ajuste adrptr 
          lda  #$4                      ;   pour afficher  
          jsr  addatoyx                 ;   les quatres 
          #styxmem adrptr               ;   prochains octets.
          #outcar 13  
          pla
          sta  kcol    
          jsr  popall
          rts  
          .bend          
