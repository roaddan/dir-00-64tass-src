;-------------------------------------------------------------------------------
           Version = "20241028-220934"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      "none"

p027ex04  .block
          jsr  push
          #v20col
          #print ttext 
          jsr  b_intcgt       ; Initialide chrget
          ldx  #<(floatnum-1)
          ldy  #>(floatnum-1)
          stx  $7a
          sty  $7b
          jsr  b_chrget
          jsr  b_ascflt
          jsr  b_facasc
          ldy  #$ff
sbufx     iny
          lda  $0100,y
          bne  sbufx
          iny
          tya
          pha
          lda  #$00
          sta  $22
          lda  #$01
          sta  $23
          pla
          jsr  b_strout
          lda  #b_crlf
          jsr  $ffd2
          jsr  pop
          rts
floatnum  .null     "25.35e3"
          .bend

main      .block
          jsr  scrmaninit
          #disable
          #v20col
          jsr  bookinfo
          jsr  akey
          jsr  cls
          jsr  help
          jsr  akey
          jsr  cls
          lda  #b_crlf
          jsr  $ffd2
          jsr  p027ex04
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

          .include "string-en.asm"
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


