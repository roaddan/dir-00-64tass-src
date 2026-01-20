;-------------------------------------------------------------------------------
           Version = "20241028-220934"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none
p026ex02  .block
          pha
          txa
          pha
          #v20col
;          jsr       cls
          jsr  b_intcgt       ; Initialide chrget
          lda  #$00           ; On efface le basic input buffer 
          ldy  #$59           ;  situé à $200 long de 89 bytes ($59)
clear     sta  b_inpbuff,y    ;  en plaçant des $00 partout
          dey                 ;  et ce jusqu'au
          bne  clear          ;  dernier.
          jsr  kbflushbuff
          jsr  b_prompt       ; Affiche un "?" et attend une entrée.
          stx  $7a            ; X et Y pointe sur $01ff au retour.
          sty  $7b
          jsr  b_chrget       ; Lecture du buffer.
          jsr  b_ascflt       ; Conversion la chaine ascii en 200 en float.
          jsr  b_facasc       ; Convertie FAC1 en ascii à $0100.
          ldy  #$ff           ; Cherche la fin de la chaine de caractère ($00)
fndend    iny                 ; De 
          lda  $0100,y        ; Lie le caractère.
          bne  fndend         ; Ce n'est pas un $00, on cherche encore.
          iny                 ; On ajuste le compte. 
          tya                 ; On met le compte dans acc.
          pha                 ; On le sauvegarde.
          lda  #$00           ; On place l'adresse de la chaine $0100
          sta  $22            ;  le $00 dans $22(lsb)
          lda  #$01           ;  et le $01      
          sta  $23            ;  dans $23(msb)
          pla                 ; On récupère le compte.
          jsr  b_strout       ; Affiche la chaine(z) dont l'adresse est
          pla                 ;  dans $22(lsb) et $23(msb)
          tax
          pla
          rts
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

main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       help
          jsr       p026ex02
;          jsr       akey
          #enable
;          #uppercase
;          jsr       cls
;          #graycolor
;          #c64col
;          jmp      b_warmstart
          rts
          .bend
            
help           .block      
          #lowercase
          jsr       cls
          #print    line
          #print    headera
          #print    headerb
          #print    line
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
          .include "lib-cbm-pushpop.asm"
          .include "lib-c64-std-showregs.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"
