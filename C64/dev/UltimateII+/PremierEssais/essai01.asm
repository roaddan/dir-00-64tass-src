;-------------------------------------------------------------------------------
                Version = "20250405-231555 a"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
               .include    "lib-c64-ultimateii.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none

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
sendcommand    #uiimacsndcmd uiiidcmd
               #printcxy txtrespponse
moredata       jsr  uiireaddata
               cmp  #$00
               beq  nodata 
               jsr  putch
               jmp  moredata
nodata         jsr  uiisendack
               jsr  updatestatus
               jsr  showregs 
               jsr  anykey
               pla
               plp
               rts
               .bend

printstatic    .block
               jsr  push 
               #printcxy lbluiititle
               #printcxy lbluiiidenreg
               #printcxy lbluiistatreg
               #printcxy defuiistatreg
               #printcxy lbluiirspdata
               #printcxy lbluiistadata
               #printcxy defuiistadata
               jsr  pop
               rts
               .bend

updatestatus   .block
               jsr  push

               lda  #$03
               sta  a2hexcol
               #printcxy txtuiistatreg
               lda  uiistatreg
               jsr  putabinfmt
               #printcxy txtuiirspdata
               lda  uiirspdata
               jsr  putabinfmt
               #printcxy txtuiistadata
               lda  uiistadata
               jsr  putabinfmt
               jsr  pop
               rts
               .bend


byte           .byte 0
               .include    "./strings_fr.asm"
uiiy           =    1
uiix           =    1  
;===============================================
; Static text    
;===============================================
lbluiititle    .byte     1,uiix+9,uiiy,18
               .text     " 1541 Ultimate II + "
               .byte     146,0
lbluiiidenreg  .byte     1,uiix ,uiiy+2
               .null     format("Id register ------ $%04X -> ", uiiidenreg)
lbluiistatreg  .byte     1,uiix ,uiiy+4
               .null     format("Cmd status reg. -- $%04X -> ", uiistatreg) 
lbluiistadata  .byte     1,uiix ,uiiy+6
               .null     format("Response data reg. $%04X -> ", uiirspdata) 
lbluiirspdata  .byte     1,uiix ,uiiy+8.
               .null     format("Data status reg. - $%04X -> ", uiistadata) 
;===============================================
; Value text    
;===============================================
txtuiiidenreg  .byte     3,uiix+28,uiiy+2,0
defuiistatreg  .byte     3,uiix+29,uiiy+3
               .null     "AASSEPCB"
txtuiistatreg  .byte     3,uiix+28,uiiy+4,0  
txtuiirspdata  .byte     3,uiix+28,uiiy+6,0
defuiistadata  .byte     3,uiix+29,uiiy+7
               .null     "AASSEPCB"
txtuiistadata  .byte     3,uiix+28,uiiy+8,0
txtrespponse   .byte     3,uiix+9,uiiy+1,0


;uiictrlreg     =    $df1c     ;(Write)
;uiistatreg     =    $df1c     ;(Read)   default $00
;uiicmddata     =    $df1d     ;(Write)
;uiiidenreg     =    $df1d     ;(Read)   default $c9
;uiirspdata     =    $df1e     ;(Read only)
;uiistadata     =    $df1f     ;(Read only)

;===============================================
; list of commands
;===============================================
uiiidcmd       .byte     $01,$01,$00

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
