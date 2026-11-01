;-------------------------------------------------------------------------------
                Version = "20250405-231555"
;-------------------------------------------------------------------------------                
               .include    "h-header-c64.asm"
;               .include    "m-64tass.asm"
               .include    "m-c64-utils.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    'none'

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include    "strings_en.asm" 

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr scrmaninit
               #tolower
               #disable
;               jsr aide
;               jsr anykey
               #mycolor
               jsr essai01
               #enable
               #toupper
               jsr  cls
               #mycolor
;               jmp b_warmstart
               .bend
                 
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
aide           .block       
               #tolower
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
               #printregs 
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
               .include  "l-c64-ultimateii.asm"


               .include  "v-c64-vars.asm"
               .include  "v-cbm-vars.asm"
               .include  "v-c64-showregs.asm"


;*=$c000        
               .include  "e-c64-kernal.asm"
               .include  "e-c64-vicii.asm" 
               .include  "e-c64-basic2.asm"
               .include  "l-c64-basic2.asm"
               .include  "l-c64-vicii.asm"
               .include  "l-cbm-stack.asm"
               .include  "l-cbm-mem.asm"
               .include  "l-cbm-conv.asm"
               .include  "l-cbm-keyb.asm"
               .include  "l-c64-showregs.asm"
