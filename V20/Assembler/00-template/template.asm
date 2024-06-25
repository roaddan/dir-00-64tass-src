;-----------------------------------------------------------
; Version 20240624-171100-a
;-----------------------------------------------------------
.include       "header-v20ex.asm"
.include       "macros-64tass.asm"
.enc none
;-----------------------------------------------------------
TITLELINE=1
BINLINE=6
BINCOLM=6
XVAL=$10
XCPX=$40
DIFF=$03
main           jsr scrmaninit
               #tolower
               #scrcolors vbleu, vnoir
               #color vblanc
               #locate 1,21
               #print string3
               #color vred               
               #locate 1,0
               #print string1
               #color vgreen               
               #locate BINCOLM-5,BINLINE-3
               #print string2
               #color vgreen               
               #locate BINCOLM+1,BINLINE-2,
               #print string5
               #color vgreen               
               #locate BINCOLM+1,BINLINE-1
               #print string6
               #color vmauve              
               #locate BINCOLM+9,BINLINE+1
               #print string4
               #color vjaune              
               #locate 4,18
               #print string7
               #color vjaune              
               #locate 0,12
               #print string8
               #locate 2,9
;               #color vwhite               
;               #printwordbin adresse
               lda #XVAL   ; initialise ... 
               sta count   ; ...le compteur
next           lda count
               sec
               sbc tstval
               sta result
               ldx count
               lda #$00
               pha
               plp
               cpx tstval
               php
               pla
               jsr atobin
               pha
               #color vyellow               
               #printfmtxy BINCOLM, BINLINE+1, "%", abin
               txa
               pha
               jsr a2hex
               #color vcyan               
               #printfmtxy 2, 12, "$", a2hexstr
               pla
               jsr atobin
               #color vcyan               
               #printfmtxy 7, 12, "%", abin
               lda tstval
               pha
               jsr a2hex
               #color vcyan               
               #printfmtxy 2, 13, "$", a2hexstr
               pla
               jsr atobin
               #color vcyan               
               #printfmtxy 7, 13, "%", abin
               lda result
               pha
               jsr a2hex
               #color vcyan               
               #printfmtxy 2, 15, "$", a2hexstr
               pla
               jsr atobin
               #color vcyan               
               #printfmtxy 7, 15, "%", abin
               pla
               jsr a2hex
               #color vcyan               
               #printfmtxy BINCOLM+10, BINLINE+1, "$", a2hexstr
               inc count
               lda tstval
               clc
               adc #DIFF
               sta tstval
               #locate 1,25
               pha
               jsr getkey
               cmp  #'q'
               beq out
               pha
               #locate 6,18
               pla
               jsr a2hex
               #printfmtxy 15, 18, "$", a2hexstr
               jmp next
;ici            jmp ici
out            rts 

delay65536     .block
               jsr push
               ldx #$00
               ldy #$00
waity          dey
               bne waity
waitx          dex
               bne waity
               jsr pop
               rts
               .bend

string1        .null     "Test de Drapeaux CPU"
string2        .null     "FLAGS:NV-BDIZC"
string3        .null     "Par: Daniel Lafrance"
string4        .null     "(   )"
string5        .byte     94,94,32,94,94,94,94,94,0
string6        .byte     125,125,'?',125,125,125,125,125,0
string7        .null     "Getkey() = $"  
string8        .byte     32,32,'$',13,32,'-','$',32,32,32,'-'
               .byte     13,32,32,45,45,45,32,32,45,45,45,45,45,45,45,45,45,13
               .byte     32
               .null     "=$   ="  
count          .byte     XVAL
tstval         .byte     XCPX
result         .byte     0
row            .byte     0
lin            .byte     0
adresse        .word     main     
     
  
.include       "map-vic20-kernal.asm"
.include       "map-vic20-vic.asm"
.include       "map-vic20-basic2.asm"
.include       "lib-vic20-basic2.asm"
.include       "lib-cbm-pushpop.asm"          
.include       "lib-cbm-mem.asm"                
.include       "lib-cbm-hex.asm" 
.include       "lib-cbm-keyb.asm"         
