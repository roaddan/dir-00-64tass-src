;-----------------------------------------------------------
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
Version = "20260123-101151a"
;--------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     .include  "m-v20-utils.asm"
;--------------------------------------
main      .block
          #scrcolors vocean,vblanc,vbleu
          #outcar locase
          jsr fillscreen
;--------------------------------------
          lda  #7
          sta  $fe
          lda  #6
          sta  $fd
          lda  #5
          sta  $fc
          lda  #4
          sta  $fb
          lda  #1
          ldx  #2
          ldy  #3
          jsr pushall
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
          jsr popall
;--------------------------------------
          jsr kmenu
          #outcar sbleu
          ;#outcar 19
          rts
          .bend
;-----------------------------------------------------------
kmenu     .block
          jsr  pushregs  ; Sauvegarde les registres.
uneclef   jsr  getkey    ; Attend une clef.
          jsr  putahexdec; Affiche .a en ascii, hexa, bin et dec.
          cmp  #$51 ;'Q' ; Est-ce la lettre 'Q'?
          bne  keyr      ; Non on en verifie une autre.
          jmp  out       ; Oui, on quitte la fonction
keyr      cmp  #$52 ;'R' ; Est-ce la lettre 'R'?
          bne  nextkey   ; Non on en verifie une autre.
          jsr  showregs  ; Oui, On affiche les registres.
nextkey   jmp  uneclef   ; On retourne chercher une autre clef.
out       jsr  popregs   ; Récupère les rehgistres.
          rts
          .bend
;-----------------------------------------------------------
showregs  .block
          jsr pushregs
          tsx
          stx  mysp
          #outcar locase
          sec
          jsr plot
          stx x
          sty y
          jsr scrnsave
          lda #$00
          tax
          tay
          clc
          jsr plot
          #outcar snoir
          #prnligne 176,174,rtitle
          #prnligne 221,221,rlable
          #prnligne 221,221,rvalues
          #prnligne 173,189,rbline
;--------------------------------------
          pla
          #locate 12,2
          jsr putahex    ; ry
;--------------------------------------
          pla
          #locate 9,2
          jsr putahex    ; rx
;--------------------------------------
          pla
          #locate 6,2
          jsr putahex    ; ra
;--------------------------------------
          pla
          #locate 15,2
          jsr putahex    ; sr
;--------------------------------------
          pla  
          tax
          pla
          tay
          inx
          bcc go
          iny
go             #locate 1,2
          jsr putyxhex   ; pc
;--------------------------------------
          ldx mysp
          txa
          #locate 18,2
          jsr putahex    ; sp
;--------------------------------------
          lda #$5f  ; [ESC]
          jsr waitkey
          jsr clrkbbuf
          jsr scrnrest
          clc
          ldx  x
          ldy  y
          jsr  plot
          ldx  mysp
          txs
          jsr  popregs
          rts
mysp           .byte     0
x              .byte     0
y              .byte     0
          .bend

;-----------------------------------------------------------
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
;-----------------------------------------------------------
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
     .include  "string-fr.asm"
     ;.include  "string-en.asm"


     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "e-v20-vars.asm"

