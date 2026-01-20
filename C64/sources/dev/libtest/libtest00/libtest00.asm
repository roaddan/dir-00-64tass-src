;-------------------------------------------------------------------------------
               Version = "20250525-151829"
;-------------------------------------------------------------------------------                
               .include  "header-c64.asm"
               .enc      none

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr scrmaninit
               #uppercase
               #toupper
               #disable
               jsr aide
               jsr anykey
               #mycolor
               lda #$05 
               jsr libtest00
               #enable
               #uppercase
               jsr  cls
               #mycolor
;               jmp b_warmstart
               rts
               .bend
                 
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
aide           .block      
               #lowercase
               jsr cls
               #print line
               #print headera
               #print headerb
               #print line
               #print line
               #print shortcuts
               #print aidetext
               #print line
               rts  
               .bend  

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
libtest00      .block 
               php
               pha
               jsr  cls
               lda  #166
nexta          pha
               #printcxy    dataloc
               #color ccyan
               #setloop $0000+(256)
               jsr  cls
               jsr  clearregs
               jsr  showregs 
roll           jsr  bmtester
               jsr  inczp1
               jsr  deczp2
               ;jsr  anykey
               jsr  loop
               bne  roll
out            pla
               plp
               rts
car            .byte     166
               .bend

clearregs      .block
               lda  #$00
               sta  zpage1
               sta  zpage1+1
               sta  zpage2
               sta  zpage2+1
               tax
               tay               
               rts
               .bend
;-------------------------------------------------------------------------------
; Liste des chaines de charactères
;-------------------------------------------------------------------------------
               .include    "strings_fr.asm"

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$8000
               .include  "lib-cbm-pushpop.asm"
               .include  "lib-cbm-mem.asm"
               .include  "lib-cbm-hex.asm"
               .include  "lib-cbm-keyb.asm"
               .include  "lib-cbm-disk.asm"
               .include  "lib-cbm-chargen.asm"
               .include  "lib-c64-nmi.asm"

*=$c000        
               .include  "lib-c64-basic2.asm"
               .include  "lib-c64-basic2-math.asm"
               .include  "lib-c64-binmath.asm"
               .include  "lib-c64-vicii.asm" 
               .include  "lib-c64-showregs.asm"
               .include  "lib-c64-ultimateii.asm"

;               .include  "lib-c64-mc-spriteman.asm"
;               .include  "lib-c64-mc-joystick.asm"
;               .include  "lib-c64-mc-text.asm"
;               .include  "lib-c64-sd-text.asm"



               .include  "map-c64-kernal.asm"
               .include  "map-c64-basic2.asm"
               .include  "map-c64-vicii.asm" 
               .include  "macros-64tass.asm"
 
