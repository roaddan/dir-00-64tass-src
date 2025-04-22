;-------------------------------------------------------------------------------
                Version = "20250421-232831"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
               .include    "strings_fr.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr scrmaninit
               #uppercase
               #toupper
               #disable
               ;jsr aide
               ;jsr anykey
               #mycolor
               jsr  libtest03
               jsr  anykey   
               #enable
               #uppercase
               ;jsr  cls
               #mycolor
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
               jsr  anykey
               jsr  cls
               rts  
               .bend                              
*=$4001

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
libtest03      .block 
               php
               pha
nexta          #printcxy    dataloc
               #color ccyan
               ;#loadaxmem     valeur
               ;jsr  b_pr_ax_str
again          ;#locate   0,8
               ;jsr  b_getascnum
               ;jsr  showregs
               ;#locate   1,10
               ;ldy  #$55
               ;jsr  b_printbuff
               ;jsr  showregs
               ;jsr  b_mul2fptoasc
               ;jsr  anykey
               lda  #$00
               ldx  #$10
               ;#loadaxmem $0000
               jsr  showregs
               #locate   0,0
               jsr  b_praxstr 
out            pla
               plp
               rts
car            .byte     166
valeur         .word     12346
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
               .include  "map-c64-kernal.asm"
               .include  "map-c64-vicii.asm" 
               .include  "map-c64-basic2.asm"
               .include  "lib-c64-basic2.asm"
               .include  "lib-c64-basic2-math.asm"
               .include  "lib-cbm-pushpop.asm"
               .include  "lib-cbm-mem.asm"
               .include  "lib-cbm-hex.asm"
               .include  "lib-cbm-keyb.asm"
               .include  "lib-c64-showregs.asm"
