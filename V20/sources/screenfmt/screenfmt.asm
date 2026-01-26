;-----------------------------------------------------------
Version = "20260123-101151b"
;-----------------------------------------------------------
.include  "l-v20-bashead-ex.asm"
.enc "none"
;-----------------------------------------------------------
main           .block
               #scrcolors vocean, vbleu, vblanc
               #print ligne
               rts
               .bend
regdemo        .block

               .bend

text0          .byte $0d
               .text " CPU REGISTERS HEX "
               .byte 0
text1          .byte $0d
               .text "  pc  ra rx ry sr sp "
               .byte 0
text2          .byte $0d
               .text " 0000 00 00 00 00 00 "
               .byte 0
text3          .byte $0d
               .text " "
               .byte 0
ligne          .byte 192,192,192,192,192,192
               .byte 192,192,192,192,192,192
               .byte 192,192,192,192,192,192
               .byte 0               

;-----------------------------------------------------------
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
;     .include  "l-v20-math.asm"           
;     .include  "l-v20-conv.asm" 
;     .include  "l-v20-keyb.asm" 
     .include  "e-v20-page0.asm"
     .include  "e-v20-vars.asm"
     .include  "m-v20-utils.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"

