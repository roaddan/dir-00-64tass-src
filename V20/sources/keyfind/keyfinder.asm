;-----------------------------------------------------------
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
version  = "20260127-161114"
;-----------------------------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     .include  "string-fr.asm"
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

main           .block
               #scrcolors vocean, vblanc, vbleu
               jsr scrnsave
               #outcar upcase
               #outcar snoir
               #prnligne 176,174,texte0
               #prnligne 221,221,texte1
               #prnligne 173,189,ligne
               #print revision
morekey        #outcar sbleu
               jsr getkey
               #outcar 13
               #print spaces
               #outcar 91
               jsr chrout
               #outcar 93
               #outcar 32
               #outcar 36
               jsr putahex
               #outcar 32
               pha
               tax
               lda #$00
               jsr fiaxtf1
               pla
               cmp #95
               beq out
               jmp morekey
out            #outcar sbleu
               #print bonjour
               rts
               .bend
revision       .byte $0d
               .null format(" ver:%15s",version)
;-----------------------------------------------------------
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "e-v20-vars.asm"
     .include  "m-v20-utils.asm"
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"

