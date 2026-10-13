;-------------------------------------------------------------------------------
                Version = "20250405-231555"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
               .include    "lib-c64-ultimateii.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    'none'

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include    "./strings_en.asm" 

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr scrmaninit
               #lowercase
               #disable
;               jsr aide
;               jsr anykey
               mycolor
               jsr essai01
               #enable
               #uppercase
               jsr  cls
               #mycolor
;               jmp b_warmstart
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
;*=$4001

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
essai01        .block
               php
               pha
               jsr  cls
               jsr  printstatic 
               #printcxy lbluiiidenreg
               lda  uiiidenreg
               jsr  putahexfmt
; sending a command
               #uiimacsndcmd uiicmdgetid
               #printcxy txtrespponse

               ;jsr  updatestatus
moredata       jsr  uiifreadrxdata
               cmp  #$00
               beq  nodata
               cmp  #$00
               beq  putit
               cmp  #$27
               bcc  putit
               ora  #%00100000
putit          jsr  putch
               jmp  moredata
nodata         jsr  uiifsenddataacc
               jsr  updatestatus
               jsr  showregs 
               jsr  anykey
               pla
               plp
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
printstatic    .block
               jsr  push 
               #printcxy lbluiititle
               #printcxy lbluiiidenreg
               #printcxy lbluiistatreg
               #printcxy defuiistatreg
               ;#printcxy lbluiirspdata
               #printcxy lbluiistadata
               #printcxy defuiistadata
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
updatestatus   .block
               jsr  push
               lda  #$03
               sta  a2hexcol
               #printcxy txtuiistatreg
               lda  uiicmdstat
               jsr  putabinfmt
               ;#printcxy txtuiirspdata
               ;lda  uiirxdata 
               ;jsr  putabinfmt
               #printcxy txtuiistadata
               lda  uiidatastat
               jsr  putabinfmt
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
               .include  "map-c64-kernal.asm"
               .include  "map-c64-vicii.asm" 
               .include  "map-c64-basic2.asm"
               .include  "lib-c64-basic2.asm"
               .include  "lib-cbm-pushpop.asm"
               .include  "lib-cbm-mem.asm"
               .include  "lib-cbm-hex.asm"
               .include  "lib-cbm-keyb.asm"
               .include  "lib-c64-showregs.asm"
