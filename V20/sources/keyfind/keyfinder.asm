;-----------------------------------------------------------
; Fichier : keyfinder.asm
; Auteur..: Daniel Lafrance
Version = "20260123-101151g"
;-----------------------------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
     .include  "m-v20-utils.asm"
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
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
               jsr fillscreen
               jsr scrnsave
               #outcar locase
               #outcar snoir
               #prnligne 176,174,texte0
               #prnligne 221,221,texte1
               #prnligne 221,221,texte2
               #prnligne 173,189,ligne
               jsr anykey
               jsr scrnrest
               jsr anykey
               #outcar 147
               jsr anykey
               jsr scrnrest
               jsr anykey
               #outcar 147
               #outcar sbleu
                              rts
               .bend
regdemo        .block

               .bend

texte0         .byte 32,snoir,revson        ;0-2
               .text " CPU REGISTERS HEX " ;3-23
               .byte snoir,revsoff,32,$0d
               .byte 0  
texte1         .byte 32,sbleu,revsoff
               .text " PC  RA RX RY SR SP"
               .byte snoir,revsoff,32,$0d
               .byte 0  
texte2         .byte 32,srouge,revsoff        ;0-2 - 0
               .text "0000 00 00 00 00 00" ;3-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0  
ligne          .byte 32,snoir,revsoff        ;0-2
               .byte 192,192,192,192,192     ;3-8   ;1
               .byte 192,192,192,192,192     ;9-13
               .byte 192,192,192,192,192     ;14-18
               .byte 192,192,192,192         ;19-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0      

;-----------------------------------------------------------
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "e-v20-vars.asm"

