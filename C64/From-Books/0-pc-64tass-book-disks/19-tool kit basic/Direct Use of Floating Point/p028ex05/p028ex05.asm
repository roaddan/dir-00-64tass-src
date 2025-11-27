;-------------------------------------------------------------------------------
           Version = "20241028-220934"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
          .enc      "none"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
p028ex05  .block
          jsr  pushregs
          #v20col
          jsr  cls
          jsr  insub
          jsr  b_f1t57
          jsr  insub
          lda  #$57
          ldy  #$00
          jsr  b_f1xfv
          ldx  #<floatnum
          ldy  #>floatnum
          jsr  b_f1tmem
          jsr  popregs
          rts
floatnum  .byte 0,0,0,0,0,0
          .bend
akey      .block
          lda  #<kmsg
          sta  $22
          lda  #>kmsg
          sta  $23
          lda  #kmsgend-kmsg
          jsr  b_strout
          jsr  anykey
          rts
          .bend

insub  .block
          pha
          txa
          pha
          jsr  kbflushbuff
          jsr  b_intcgt       ; Initialide chrget
          lda  #$00           ; On efface le basic input buffer 
          ldy  #$59           ;  situé à $200 long de 89 bytes ($59)
clear     sta  b_inpbuff,y    ;  en plaçant des $00 partout
          dey                 ;  et ce jusqu'au
          bne  clear          ;  dernier.
          lda  #<ptext
          sta  $22
          lda  #>ptext
          sta  $23
          lda  #ptextend-ptext
          jsr  b_strout       ; Affiche la chaine(z)
          jsr  b_prompt       ; Affiche un "?" et attend une entrée.
          stx  $7a            ; X et Y pointe sur $01ff au retour.
          sty  $7b
          jsr  b_chrget       ; Lecture du buffer.
          jsr  b_ascflt       ; Conversion la chaine ascii en 200 en float.
          pla                 ;  dans $22(lsb) et $23(msb)
          tax
          pla
          rts
          .bend
            
main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       bookinfo
          jsr       akey
          jsr       cls
          jsr       help
          jsr       akey
          lda       #b_crlf
          jsr       $ffd2
          jsr       p028ex05
          #enable
;          #uppercase
;          #c64col
;          jsr       cls
;          jmp      b_warmstart
          rts
          .bend


bookinfo  .block      
          #lowercase
          jsr       cls
          #print    line
          #print    headera
          #print    headerb
          #print    line
          rts                      
          .bend  

help      .block      
          #lowercase
          jsr       cls
          #print    shortcuts
          #print    helptext
          #print    line
          rts
          .bend        

          .include "string-fr.asm"
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
          .include "map-c64-kernal.asm"
          .include "map-c64-vicii.asm" 
          .include "map-c64-basic2.asm"
          .include "lib-c64-vicii.asm"
          .include "lib-c64-basic2.asm"
          .include "lib-c64-std-showregs.asm"
          .include "lib-cbm-pushpop.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"

