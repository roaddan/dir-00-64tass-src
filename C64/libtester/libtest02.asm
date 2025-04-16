;-------------------------------------------------------------------------------
                Version = "20250414-224259 "
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm" 
               .include    "macros-64tass.asm"
               .include    "strings_fr.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    'none'

*=$c000        
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr scrmaninit
               #uppercase
               #toupper
               #disable
               jsr aide
               #mycolor
               jsr libtest02
               #enable
               #uppercase
               ;jsr  cls
               #locate 0,0
               ; #c64color
               jsr  anykey
               jmp  k_warmstart
               rts
               .bend
                 
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
aide           .block
               jsr  push      
               #lowercase 
               jsr  cls
               #print line
               #print headera
               #print headerb
               #print line
               lda  #$0d
               jsr  putch
               #print line
               #print shortcuts
               #print aidetext
               #print line
               jsr  anykey
               jsr  pop
               rts  
               .bend                              

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
libtest02      .block 
               php
               pha
               jsr  cls
               lda  #166
               #printcxy    dataloc
               #color ccyan
               jsr  showregs
               jsr  anykey 
               jsr  victohighres 
               jsr  anykey
               jsr  vicbmpclear
               ldy  #$0f
nextc          tya
               jsr  setvicbmpbackcol
        b       iny
               tya
               dey
               jsr  setvicbmpforecol
               jsr  vicbmpclear
               dey
               cpy  #$00
               bpl  nextc
               jsr  anykey
               jsr  victonormal
               setloop $0000+(40*23)
roll           lda  car
               jsr  putch
               ;inc  car
               jsr  loop
               bne  roll
               jsr  showregs
               ;jsr  anykey
out            pla
               plp
               rts
car            .byte     32
               .bend

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
               ; Les constantes 
               ;===================================
               .include  "map-c64-kernal.asm"
               .include  "map-c64-vicii.asm" 
               .include  "map-c64-basic2.asm"

               ; Les routines
               ;===================================
               .include  "lib-c64-vicii.asm" 
               .include  "lib-c64-basic2.asm"
               .include  "lib-cbm-pushpop.asm"
               .include  "lib-cbm-mem.asm"
               .include  "lib-cbm-hex.asm"
               .include  "lib-cbm-keyb.asm"
               .include  "lib-c64-showregs.asm"
