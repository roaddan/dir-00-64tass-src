;-----------------------------------------------------------
; Version 20240704-234304f
;-----------------------------------------------------------
.include       "l-bashead-v20e.asm"
.enc "none"
;-----------------------------------------------------------
TITLELINE=1
BINLINE=5
BINCOLM=6
XVAL=$00
XCPX=$00
DIFF=$5
main           
               #tolower
               #scrcolors vbleu, vnoir
               #color vblanc
               #printxy string3
               #color vmauve               
               #printxy string1
               #color vblanc              
               #printxy string2
               #color vvert               
               #printxy string5
               #color vvert               
               #printxy string6
               #color vmauve              
               #printxy string4
               #color vjaune              
               #printxy string7
               #color vjaune              
               #printxy string8
               #color vblanc               
               lda #XVAL            ; initialise ... 
               sta count            ; ...le compteur
next           lda count            ; Charge le compteur
               sec
               sbc tstval
               sta result
               ldx count
               lda #$00
               pha                  ;s=a
               plp                  
               cpx tstval
               php
               pla
               jsr atobin
               pha
               #color vjaune               
               #printfmtxy BINCOLM, BINLINE, "%", binstr
               txa
               pha
               jsr atohex
               #color vocean               
               #printfmtxy 5, 9, "$", hexstr

               pla
               jsr atobin
               #color vocean               
               #printfmtxy 10, 9, "%", binstr
               lda tstval
               pha
               jsr atohex
               #color vocean               
               #printfmtxy 5, 10, "$", hexstr
               pla
               jsr atobin
               #color vocean               
               #printfmtxy 10, 10, "%", binstr
               lda result
               pha
               jsr atohex
               #color vocean               
               #printfmtxy 5, 12, "$", hexstr
               pla
               jsr atobin
               #color vocean               
               #printfmtxy 10, 12, "%", binstr
               pla
               jsr atohex
               #color vocean               
               #printfmtxy BINCOLM+10, BINLINE, "$", hexstr
               lda count
               clc
               adc #DIFF
               sta count
               lda tstval
               sec
               sbc #DIFF
               sta tstval
               #locate 1,25
               pha
               jsr getkey
               cmp  #'q'
               bne continue
               jmp out
continue       pha
               #locate 6,18
               pla
               jsr atohex
               #printfmtxy 15, 18, "$", hexstr
               #outcar 32
               jsr chrout
               jmp next
               #printwordbin adresse
out            jsr getkey
               rts 

delay65536     .block
               jsr pushregs
               ldx #$00
               ldy #$00
waity          dey
               bne waity
waitx          dex
               bne waity
               jsr popregs
               rts
               .bend

string0        .text    1,1,"Par: Daniel Lafrance",0
string1        .text    1,0,"Test de Drapeaux CPU",0
string2        .text    BINCOLM-5,BINLINE-3,"FLAGS:NV-BDIZC",0
string3        .text    1,21,"Par: Daniel Lafrance",0
string4        .text    BINCOLM+9,BINLINE,"(   )",0
string5        .byte    BINCOLM+1,BINLINE-2,94,94,32,94,94,94,94,94,0
string6        .byte    BINCOLM+1,BINLINE-1,125,125,'?',125,125,125,125,125,0
string7        .text    4,18,"Getkey() = $",0  
string8        .byte    0,9,32,32,32,32,'$',13,32,32,32,'-','$',32,32,32,32,'-'
               .byte    13,32,32,32,32,32,45,45,45,32,32,45,45,45,45,45,45,45,45,45,13
               .byte    32,32,32
               .null    "=$    ="  
count          .byte    XVAL
tstval         .byte    XCPX
result         .byte    0
row            .byte    0
lin            .byte    0
adresse        .word    main     
     
  
.include       "l-push.asm" 
.include       "l-string.asm" 
.include       "l-mem.asm"                
.include       "l-math.asm"                
.include       "l-conv.asm" 
.include       "l-keyb.asm"         
.include       "e-vars.asm"
.include       "m-v20-utils.asm"
.include       "e-float.asm"
.include       "e-v20-kernal-map.asm"
