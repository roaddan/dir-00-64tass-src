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
               #locate BINCOLM-4,TITLELINE
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
               #locate BINCOLM,BINLINE+3
               #print string7
               #color vjaune              
               #locate BINCOLM,BINLINE+5
               #print string8
               #locate 2,9
               #color vwhite               
               #printwordbin adresse
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
               jsr a2hex
               #color vcyan               
               #printfmtxy BINCOLM+2, BINLINE+3, "$", a2hexstr
               #printfmtxy BINCOLM, BINLINE+5, "$", a2hexstr
               lda tstval
               jsr a2hex
               #color vcyan               
;               #printfmtxy BINCOLM+11, BINLINE+3, "$", a2hexstr
               #printfmtxy BINCOLM+6, BINLINE+5, "$", a2hexstr
               lda result
               jsr a2hex
               #color vcyan               
               #printfmtxy BINCOLM+11, BINLINE+5, "$", a2hexstr
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
               jsr anykey
               jmp next
;ici            jmp ici
               rts 

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

string1        .null    "TEST DRAPEAUX CPU"
string2        .null    "FLAGS:NV-BDIZC"
string3        .null    "Par: Daniel Lafrance"
string4        .null    "(   )"
string5        .byte    94,94,32,94,94,94,94,94,0
string6        .byte    125,125,'?',125,125,125,125,125,0
string7        .null    "X=$   CPX #$"  
string8        .null    "$   - $   = $"  
count          .byte    XVAL
tstval         .byte    XCPX
result         .byte    0
row            .byte    0
lin            .byte    0
adresse        .word     $1234     
     
  
.include       "map-vic20-kernal.asm"
.include       "map-vic20-vic.asm"
.include       "map-vic20-basic2.asm"
.include       "lib-vic20-basic2.asm"
.include       "lib-cbm-pushpop.asm"          
.include       "lib-cbm-mem.asm"                
.include       "lib-cbm-hex.asm" 
.include       "lib-cbm-keyb.asm"         
