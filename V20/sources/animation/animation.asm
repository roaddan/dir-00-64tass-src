;-----------------------------------------------------------
Version = "20260123-101151"
;-----------------------------------------------------------
     .include  "e-v20-bashead-ex.asm"
     .include  "l-v20-bashead-ex.asm"

     .enc "none" 
;-----------------------------------------------------------
main      .block        
          #outcar locase
          ;#scrcolors border, fond, char
          #scrcolors vbleup, vnoir, vbleu
          #outcar revson
          #color vblanc
          #printxy string3
          #color vblanc               
          #printxy string1
          #outcar revsoff
          #color vvert               
          #printxy string2
          #color vvert               
          #printxy string5
          #color vvert               
          #printxy string6
          #color vbleu             
          #printxy string4
          #color vrouge              
          #printxy string7
          #color vjaune              
          #printxy string8
          jsr getkey
          #outcar upcase
          #c64blanc
          lda #147
          jsr $ffd2
          rts 
          .bend



count     .byte     XVAL
tstval    .byte     XCPX
result    .byte     0
row       .byte     0
lin       .byte     0
adresse   .word     $1234     
     

     .include  "string-fr.asm"

     .include  "e-v20-vic.asm"
     .include  "m-v20-utils.asm"
     .include  "l-v20-bitmap.asm"
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
