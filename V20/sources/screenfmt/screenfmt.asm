;-----------------------------------------------------------
Version = "20260123-101151b"
;-----------------------------------------------------------
.include  "l-v20-bashead-ex.asm"
.enc "none"
;-----------------------------------------------------------
main           .block
               #scrcolors vocean, vbleu, vblanc
               rts
               .bend

 

;-----------------------------------------------------------
;     .include  "l-v20-push.asm" 
;     .include  "l-v20-string.asm" 
;     .include  "l-v20-mem.asm"           
;     .include  "l-v20-math.asm"           
;     .include  "l-v20-conv.asm" 
;     .include  "l-v20-keyb.asm"         
     .include  "e-v20-vars.asm"
     .include  "m-v20-utils.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"

