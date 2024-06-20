.include  "header-v20ex.asm"
;.include  "header-c64.asm"
.include       "cbm-macros.asm"
.include       "kernal-map-vic20.asm"
.include       "vic-map.asm"
.include       "basic2-map-Vic20.asm"
.include       "basic2-lib-Vic20.asm"
.include       "c64-lib-pushpop.asm"          
.include       "c64-lib-mem.asm"                
.include       "c64-lib-hex.asm"          

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
                #printxy 1,21,string3
                #color vred               
                #printxy BINCOLM-4,TITLELINE,string1
                #color vgreen               
                #printxy BINCOLM-5,BINLINE-3,string2
                #color vgreen               
                #printxy BINCOLM+1,BINLINE-2,string5
                #color vgreen               
                #printxy BINCOLM+1,BINLINE-1,string6
                #color vmauve              
                #printxy BINCOLM+9,BINLINE+1, string4
                #color vjaune              
                #printxy BINCOLM,BINLINE+3, string7
                #color vjaune              
                #printxy BINCOLM,BINLINE+5, string8
                ;#locate 2,9
                ;#color vwhite               
                ;#printwordbin adresse
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


string1        .null    "test drapeaux cpu"
string2        .null    "flags:nv-bdizc"
string3        .null    "par: daniel lafrance"
string4        .null    "(   )"
string5        .byte    94,94,94,94,94,94,94,94,0
string6        .byte    125,125,125,125,125,125,125,125,0
string7        .null    "x=$   cpx #$"  
string8        .null    "$   - $   = $"  
count          .byte    XVAL
tstval         .byte    XCPX
result         .byte    0
row            .byte    0
lin            .byte    0
adresse        .word     $1234     
     
  
