;-----------------------------------------------------------
Version = "20240704-2343040a"
;-----------------------------------------------------------
.include  "m-v20-utils.asm"
.include  "e-v20-bashead-ex.asm"
.include  "l-v20-bashead-ex.asm"
.enc "none"
;-----------------------------------------------------------
main        .block
            #lowercase
            #scrcolors vbleu, vnoir, vblanc
            #color 6
            lda   couleur
            jsr   vicforegnd
            jsr   vicbackgnd
continue    #print moi
            jsr getkey
            cmp  #133     ; F1 key
            beq out
            inc   couleur
            lda   couleur
            jsr   vicforegnd
            jsr   vicbackgnd
            jmp continue
out         jsr vicnormal 
            rts 
            .bend
moi         .byte $0d
            .null "Une clef pour changer."
couleur     .byte 0
  
.include  "l-v20-vic.asm"
.include  "l-v20-push.asm" 
.include  "l-v20-string.asm" 
.include  "l-v20-mem.asm"           
.include  "l-v20-math.asm"           
.include  "l-v20-conv.asm" 
.include  "l-v20-keyb.asm"         
.include  "e-v20-page0.asm"
.include  "e-v20-vars.asm"
.include  "e-v20-vic.asm"
.include  "e-v20-basic-map.asm"
.include  "e-v20-kernal-map.asm"

