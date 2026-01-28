;-----------------------------------------------------------
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
Version = "20260123-101151g"
;-----------------------------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     .include  "m-v20-utils.asm"
;-----------------------------------------------------------
main           .block
               #scrcolors vocean, vblanc, vbleu
               jsr fillscreen
               jsr kmenu
               #outcar sbleu
               #outcar 147
               rts
               .bend
;-----------------------------------------------------------
kmenu          .block
               jsr  pushall

keymore        jsr  getkey
               jsr  showkey
               cmp  #'q'
               bne  keyr
               jmp  out
keyr           cmp  #'r'
               bne  key
               jsr  showregs
               jmp keymore
 key           
               jmp keymore

 out           jsr  popall
               rts
               .bend
;-----------------------------------------------------------
showregs       .block
               jsr pushall
               jsr scrnsave
               #outcar locase
               #outcar snoir
               #prnligne 176,174,rtitle
               #prnligne 221,221,rlable
               #prnligne 221,221,rvalues
               #prnligne 173,189,rbline
               jsr anykey
               jsr scrnrest
               jsr popall
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

