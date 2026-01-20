    .include "header-v20ex.asm"
    .include "m-v20-utils.asm"
;-----------------------------------------------------------
main    .block        
        jsr scrmaninit
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
        jsr getkey
        rts 
        .bend

delay65536
        .block
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
TITLELINE=1
BINLINE=6
BINCOLM=6
XVAL=$10
XCPX=$40
DIFF=$03


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
     
  
.include       "map-vic20-kernal.asm"
.include       "map-vic20-vic.asm"
;.include       "map-vic20-basic2.asm"
.include       "lib-vic20-basic2.asm"
.include       "lib-cbm-pushpop.asm"          
.include       "lib-cbm-mem.asm"        
;.include       "lib-cbm-hex.asm"
.include       "l-string.asm"
.include       "l-keyb.asm"
.include       "l-conv.asm"
.include        "l-math.asm"          
.include       "e-vars8000.asm"
.include       "e-v20map.asm"
.include        "e-float.asm"