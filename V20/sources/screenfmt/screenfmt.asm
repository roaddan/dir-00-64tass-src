;-----------------------------------------------------------
; Fichier: screenfmt.asm
; Auteur: Daniel Lafrance
; version: 0.0.1
; Révision: 20260203-103448
Version = "20260203-103448"
;-----------------------------------------------------------
.include  "l-v20-bashead-ex.asm"
.enc "none"
;-----------------------------------------------------------
main           .block
               #monoscreen 0,3
               #outcar 147
               rts
               .bend
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
;     .include  "e-v20-float.asm"
;     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
     .include  "e-v20-vic.asm"

