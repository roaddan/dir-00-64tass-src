;-----------------------------------------------------------
Version = "20240704-2343040a"
;-----------------------------------------------------------
.include  "m-v20-utils.asm"
.include  "e-v20-bashead-ex.asm"
.include  "l-v20-bashead-ex.asm"
.enc "none"
;-----------------------------------------------------------
userc =     7168-6144
main        .block
            #lowercase
            #scrcolors vbleu, vnoir, vblanc
            #color 6
            jsr   pushall
            lda   #$06
            jsr   vicforegnd
            lda   #$04
            jsr   vicbackgnd
            lda   #$02
            jsr   vicauxcol
            lda   #$01
            ldy   #$00
            ldx   #$00
            jsr   setcolram
            lda   #$00
            ldy   #$00
            ldx   #$00
            jsr   settxtram
            jsr   vicmcmode
            lda   #<uchar
            sta   zpage1
morec       lda   #>uchar
            sta   zpage1+1
            ldy   #$00
            lda   uchar,y
            sta   5120+userc,y
            iny
            cpy   #8
            bne   morec








            jmp   waitout



continue    inc   couleur
            lda   couleur
            jsr   vicforegnd
            jsr   vicbackgnd
            lda   #$00
            ldy   #$00
            ldx   #$00
more        #print moi
            jsr   setcolram
            jsr   settxtram
            inx
            txa
            tay
            jsr   getkey
            cmp   #133        ; F1 key
            bne   more
waitout     jsr   getkey
            cmp   #133        ; F1 key
            bne   waitout
out         jsr   vicnormal
            jsr   popall 
            rts 
            .bend
uchar       .byte  $1b,$1b,$1b,$1b,$00,$55,$aa,$ff

moi         .text "0123456789012345678912"
            .byte $0d, 145,0
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

