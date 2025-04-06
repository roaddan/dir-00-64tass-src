;-------------------------------------------------------------------------------
                Version = "20250403-233302"
;-------------------------------------------------------------------------------                
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
               .include    "lib-c64-ultimateii.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none

main           .block
               jsr scrmaninit
               #lowercase
               #disable
;               jsr aide
;               jsr anykey
               jsr essai01
               #enable
               #uppercase
               jsr  cls
               #graycolor
;               jmp b_warmstart
               .bend
                 
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
               jsr  updatestatus
nodata         ;jsr  anykey
               ;jmp  sendcommand
               pla
               plp
               rts
               .bend

printstatic    .block
               jsr  push
               #printcxy lbluiititle
               #printcxy lbluiiidenreg
               #printcxy lbluiistatreg
               #printcxy lbluiirspdata
               #printcxy lbluiistadata
               jsr  pop
               rts
               .bend

updatestatus   .block
               jsr  push

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
uiiy           =    0
uiix           =    1  
;===============================================
; Static text    
;===============================================
lbluiititle    .byte     1,uiix+7,uiiy
               .null     "1541 Ultimate II+" 
lbluiiidenreg  .byte     1,uiix+3 ,uiiy+2
               .null     "id register --------> " 
lbluiistatreg  .byte    1,uiix+3 ,uiiy+3
               .null     "cmd status reg. ----> " 
lbluiirspdata  .byte     1,uiix+3 ,uiiy+4.
               .null     "data status reg. ---> " 
lbluiistadata  .byte     1,uiix+3 ,uiiy+5
               .null     "response data reg. -> " 
;===============================================
; Value text    
;===============================================
txtuiiidenreg  .byte     3,uiix+25,uiiy+2,0
txtuiistatreg  .byte     3,uiix+25,uiiy+3,0  
txtuiirspdata  .byte     3,uiix+25,uiiy+4,0
txtuiistadata  .byte     3,uiix+25,uiiy+5,0



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
