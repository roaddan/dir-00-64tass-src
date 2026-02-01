;**************************************
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
Version = "20260123-101151a"
;**************************************
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     .include  "m-v20-utils.asm"
;**************************************
main      .block
          #scrcolors vocean,vblanc,vbleu
          #outcar locase
          jsr fillscreen
;**************************************
;          lda  #7
;          sta  $fe
;          lda  #6
;          sta  $fd
;          lda  #5
;          sta  $fc
;          lda  #4
;          sta  $fb
;          lda  #1
;          ldx  #2
;          ldy  #3
;          jsr pushall
;          jsr showstack
;          jsr popall
;**************************************
          jsr kmenu
          #outcar sbleu
          ;#outcar 19
          rts
          .bend
;**************************************
kmenu     .block
          jsr  pushregs  
          ; Sauvegarde les registres.
uneclef   jsr  getkey    
          ; Attend une clef.
          jsr  putahexdec
          ; Affiche .a en 
          ; ascii, hexa, bin et dec.
          cmp  #$51 ;'Q' 
          ; Est-ce la lettre 'Q'?
          bne  keyr      
          ; Non on verifie une autre.
          jmp  out       
          ; Oui, on quitte la fonction
keyr      cmp  #$52 ;'R' 
          ; Est-ce la lettre 'R'?
          bne  nextkey   
          ; Non on verifie une autre.
          jsr  showregs  
          ; Oui, affiche les registres.
nextkey   jmp  uneclef   
          ; On cherche une autre clef.
out       jsr  popregs   
          ; Récupère les rehgistres.
          rts
          .bend
sra       .byte     00
srx       .byte     00
sry       .byte     00
ssr       .byte     00
ssp       .byte     00
spcl      .byte     00
spch      .byte     00


;**************************************
;
;**************************************
showregs  .block
          jsr scrnsave
          php
    ;----------------------------------- 
    ; stack-> p, pcl, pch
    ;----------------------------------- 
          sta  ar
          pla
    ;----------------------------------- 
    ; stack-> pcl, pch
    ;----------------------------------- 
          sta  sr
          stx  xr
          sty  yr
          tsx   
          stx  sp
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
          pla
          sta  thispcl         
          pla                 
          sta  thispch
          pha
          lda  thispcl
          pha         
          lda #$00
          ldx #regline
          tay
          clc
          jsr plot
          #outcar snoir
          #prnligne 176,174,rtitle
          #prnligne 221,221,rlable
          #prnligne 221,221,rvalues
          #prnligne 173,189,rbline
    ;----------------------------------- 
          ldy  thispch
          ldx  thispcl            
          inx  
          bcc  go
          iny
go        #locate 1,regline+2
          jsr putyxhex   ; pc
    ;----------------------------------- 
          lda  ar
          #locate 6,regline+2
          jsr putahex    ; reg x
    ;----------------------------------- 
          lda  xr
          #locate 9,regline+2
          jsr  putahex    ; reg x
    ;----------------------------------- 
          lda  yr
          #locate 12,regline+2
          jsr  putahex    ; reg y
    ;----------------------------------- 
          lda  sr
          #locate 15,regline+2
          jsr putahex    ; status reg
    ;----------------------------------- 
          lda  sp
          txa
          #locate 18,regline+2
          jsr putahex    ; sp
    ;----------------------------------- 
          lda #$5f  ; [ESC]
          jsr waitkey
          jsr scrnrest
          lda  ar
          ldx  xr
          ldy  yr
          lda  sr
          pha
          plp
          rts
;-------------------------------------- 
regline   =18
ar        .byte     0
xr        .byte     0
yr        .byte     0
sr        .byte     0
sp        .byte     0
thispcl       .byte     0
thispch       .byte     0
          .bend

;**************************************
;
;**************************************
showstack .block
          sta ra
          php
          pla
          sta sr
          stx rx
          sty ry
          sec
          ldy  #$10
          tsx
          inx
          txa
          jsr showra
          #outcar 13
          #outcar 13          
morey     lda $0100,x
          jsr showra
          #outcar 13
          inx
          dey
          bne morey
          lda sr
          pha
          lda ra
          ldx rx
          ldy ry
          plp
          rts
sr        .byte 0
ra        .byte 0
rx        .byte 0
ry        .byte 0
          .bend
;**************************************
prnligne  .macro lcar, rcar, pointeur
          jsr  pushregs
          lda #\lcar
          sta \pointeur+0
          lda #\rcar
          sta \pointeur+24
          ldx  #<\pointeur
          ldy  #>\pointeur
          jsr  putsyx
          jsr  popregs
          .endm
;**************************************
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
;**************************************
     .include  "string-fr.asm"
     ;.include  "string-en.asm"
;**************************************
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "e-v20-vars.asm"

