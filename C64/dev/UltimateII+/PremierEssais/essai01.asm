;-------------------------------------------------------------------------------
                Version = "20250403-233301 t1"
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
               pha
;               lda vicbordcol
;               sta byte
;               lda #$10
;               sta vicbordcol
               jsr  cls
               #printcxy uiiidenttxt
               jsr  waituiinotbusy
               lda  uiiidenreg
               jsr  putahexfmt
               #printcxy uiistatustxt
               ldy  #>uiiidcmd
               ldx  #<uiiidcmd
               jsr  uiisndcmd 
showstatus     #printcxy uiistatusval
               lda  uiistatreg
               jsr  putabinfmt
               #printcxy uiiresponse
moredata       jsr  isuiidataavail
               bcc  nodata
               jsr  uiireaddata
               jsr  putch
               jmp  moredata
nodata         jmp  showstatus
               jsr  anykey
;               lda byte
;               sta vicbordcol
               pla
               rts
               .bend

byte           .byte 0
               .include    "./strings_fr.asm"
uiiy           =    0
uiix           =    1      
uiiidenttxt    .byte     1,uiix,uiiy
               .null     "Ultimate II + id....: " 
uiistatustxt   .byte     1,uiix,uiiy+1
               .null     "Ultimate II + status: " 
uiistatusval   .byte     3,uiix+22,uiiy+1,0  
uiiresponse    .byte     3,uiix+22,uiiy+3,0
uiiidcmd       .byte     $01,$01,$00
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
