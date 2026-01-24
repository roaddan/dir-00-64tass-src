;-----------------------------------------------------------
Version = "20260123-101151"
;-----------------------------------------------------------
     .include  "l-v20-bashead-ex.asm"
     .include  "m-v20-utils.asm"

     .enc "none"
;-----------------------------------------------------------
main      .block        
          #outcar locase
          #scrcolors vrose, vnoir, vbleu1
          #outcar revson
          #color vrouge
          #printxy string3
          #color vrouge               
          #printxy string1
          #outcar revsoff
          #color vvert               
          #printxy string2
          #color vvert               
          #printxy string5
;          #color vvert               
;          #printxy string6
          #color vmauve              
          #printxy string4
          #color vrouge              
          #printxy string7
          #color vjaune              
          #printxy string8
          jsr getkey
          rts 
          .bend



TITLELINE=0
BINLINE=6
BINCOLM=6
XVAL=$10
XCPX=$40
DIFF=$03

string1   .byte     1,TITLELINE
          .null     " Tests drapeaux CPU "
string2   .byte     BINCOLM-5,BINLINE-3 
          .null     "flags:nv-bdizc"
string3   .byte     1,22
          .null     "par: Daniel Lafrance"
string4   .byte     BINCOLM+9,BINLINE+1 
          .null     "(   )"
string5   .byte     BINCOLM+1,BINLINE-2
          .byte     94,94,94,94,94,94,94,94,0
string6   .byte     BINCOLM+1,BINLINE-1
          .byte     125,125,125,125,125,125,125,125,0
string7   .byte     BINCOLM,BINLINE+3 
          .null     "x=$   cpx #$"  
string8   .byte     BINCOLM,BINLINE+5 
          .null     "$   - $   = $"  

count     .byte     XVAL
tstval    .byte     XCPX
result    .byte     0
row       .byte     0
lin       .byte     0
adresse   .word     $1234     
     
;     .include  "l-v20-bitmap.asm"
     .include  "l-v20-conv.asm"
     .include  "l-v20-disk.asm"
;     .include  "l-v20-drawbox.asm"
;     .include  "l-v20-float.asm"
     .include  "l-v20-keyb.asm"
     .include  "l-v20-math.asm"
     .include  "l-v20-mem.asm"
     .include  "l-v20-opcodes.asm"
     .include  "l-v20-opcycles.asm"
     .include  "l-v20-oplenght.asm"
     .include  "l-v20-opmneumo.asm"
     .include  "l-v20-opmodes.asm"
     .include  "l-v20-push.asm"
     .include  "l-v20-screen.asm"
;     .include  "l-v20-showregs.asm"
     .include  "l-v20-string.asm"
;     .include  "l-v20-vectors.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
     .include  "e-v20-bascmd-map.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-page0.asm"
     .include  "e-v20-vars.asm"
