.include  "header-v20ex.asm"
;-----------------------------------------------------------
TITLELINE=1
BINLINE=6
BINCOLM=6
XVAL=$10
XCPX=$40
DIFF=$03
main            jsr scrmaninit
                #scrcolors vbleu, vnoir
                #color vblanc
                #printxy string3
;                #color vred               
;                #printxy string1
;                #color vgreen               
;                #printxy string2
;                #color vgreen               
;                #printxy string5
;                #color vgreen               
;                #printxy string6
;                #color vmauve              
;                #printxy string4
;                #color vjaune              
;                #printxy string7
;                #color vjaune              
;                #printxy string8
;                #locate 2,9
;                #color vwhite               
;                #printwordbin adresse
                lda #XVAL    ; initialise ... 
                sta count   ; ...le compteur
next            lda count
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
                #printfmtxy BINCOLM+11, BINLINE+3, "$", a2hexstr
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
                jsr delay65536
ici             jmp ici
                rts 


delay65536      .block
                jsr push
                ldx #$00
                ldy #$00
waity           dey
                bne waity
waitx           dex
                bne waity
                jsr pop
                rts
                .bend


string1        .null    BINCOLM-4,TITLELINE,"test drapeaux cpu"
string2        .null    BINCOLM-5,BINLINE-3,"flags:nv-bdizc"
string3        .null    1,21,"par: daniel lafrance"
string4        .null    BINCOLM+9,BINLINE+1, "(   )"
string5        .byte    BINCOLM+1,BINLINE-2,94,94,94,94,94,94,94,94,0
string6        .byte    BINCOLM+1,BINLINE-1,125,125,125,125,125,125,125,125,0
string7        .null    BINCOLM,BINLINE+3, "x=$   cpx #$"  
string8        .null    BINCOLM,BINLINE+5, "$   - $   = $"  
count          .byte    XVAL
tstval         .byte    XCPX
result         .byte    0
row            .byte    0
lin            .byte    0
adresse        .word     $1234     
     
.include       "macros-64tass.asm"
.include       "map-vic20-kernal.asm"
.include       "map-vic20-vic.asm"
.include       "map-Vic20-basic2.asm"
.include       "lib-Vic20-basic2.asm"
.include       "lib-cbm-pushpop.asm"          
.include       "lib-cbm-mem.asm"                
.include       "lib-cbm-hex.asm"          
  
