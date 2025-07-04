;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------                
headera                       ;0123456789012345678901234567890123456789
               .text          "      Test de librairies pour C64."
               .byte     $0d,0
headerb        .text          "             essai00.prg "
               .byte     $0d
               .text          "       (c) 2025 Daniel Lafrance"
               .byte     $0d
               .text   format("       Version: %s",Version)
               .byte     $0d,0

shortcuts      .byte     $0d
               .byte     ucurkey,ucurkey
               .byte     rcurkey,rcurkey,rcurkey,rcurkey
               .byte     rcurkey,rcurkey,rcurkey,rcurkey,rcurkey      
               .text          " R A C C O U R C I S "
               .byte     $0d
               .text   format(" essai00..: SYS%05d ($%04X)",main, main)
               .byte     $0d
               .text   format(" Aide.....: SYS%05d ($%04X)",aide, aide)
               .byte     $0d
               .text   format(" Cls......: SYS%05d ($%04X)",cls, cls)
               .byte     $0d,0
aidetext       .text   format(" Execution: SYS%05d ($%04X)",essai00, essai00)
               .byte     $0d,0
line           .byte     $20,192,192,192,192,192,192,192,192,192
               .byte     192,192,192,192,192,192,192,192,192,192
               .byte     192,192,192,192,192,192,192,192,192,192
               .byte     192,192,192,192,192,192,192,192,192
               .byte     $0d,0
uiiconnected   .null     "Installed"
uiiunconnected .null     "Uninstalled"                  

uiiy           =    1
uiix           =    1  
;===============================================
; Static text    
;===============================================
lbluiititle    .byte     1,uiix+9,uiiy,18
               .text     " 1541 Ultimate II + "
               .byte     146,0
lbluiiidenreg  .byte     1,uiix ,uiiy+3
               .null     format("Identification..($%04X) -> ", uiiidenreg)
lbluiistatreg  .byte     1,uiix ,uiiy+5
               .null     format("Commande Status.($%04X) -> ", uiicmdstat) 
lbluiistadata  .byte     1,uiix ,uiiy+7
               .null     format("Data Response...($%04X) -> ", uiirxdata) 
lbluiirspdata  .byte     1,uiix ,uiiy+9.
               .null     format("Data Status.....($%04X) -> ", uiidatastat) 
;===============================================
; Value text    
;===============================================
txtuiiidenreg  .byte     3,uiix+28,uiiy+3,0
txtuiistatreg  .byte     3,uiix+27,uiiy+5,0  
txtuiistadata  .byte     3,uiix+27,uiiy+7,0
txtuiirspdata  .byte     3,uiix+27,uiiy+9,0

defuiistatreg  .byte     3,uiix+28,uiiy+4
               .null     "AASSEPCB"
defuiistadata  .byte     3,uiix+28,uiiy+6
               .null     "AASSEPCB"

txtrespponse   .byte     3,uiix+9,uiiy+1,0


;uiictrlreg     =    $df1c     ;(Write)
;uiistatreg     =    $df1c     ;(Read)   default $00
;uiicmddata     =    $df1d     ;(Write)
;uiiidenreg     =    $df1d     ;(Read)   default $c9
;uiirspdata     =    $df1e     ;(Read only)
;uiistadata     =    $df1f     ;(Read only)
