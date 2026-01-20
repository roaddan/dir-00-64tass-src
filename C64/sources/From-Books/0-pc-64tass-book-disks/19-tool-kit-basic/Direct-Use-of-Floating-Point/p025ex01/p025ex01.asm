;-------------------------------------------------------------------------------
           Version = "20241028-220934"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p025ex01  .block
          pha
          txa
          pha
          lda  #$05
          ldx  #$03
          jsr  b_putint
          pla
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
          jsr  kbflushbuff
          jsr  anykey
          rts
          .bend

main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       help
          jsr       p025ex01
          jsr       akey
          #enable
          #uppercase
;          #graycolor
;          jmp      b_warmstart
          jsr       cls
          rts
          .bend
            
help      .block      
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
