;--------------------------------------
; Fichier : v20test1.asm
; Auteur..: Daniel Lafrance
version  = "20260131-192144"
;--------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
;--------------------------------------

main
        .block        
        ldx #0
put     lda chr
        bne skipit      ; Charge le caractere a afficher.
        pha
        lda #(3*22)
        sta skipit+1
        sta go+1
        pla
skipit  sta $1000,x     ;Affiche le caractere.
        txa
        and #$07
        cmp #0
        bne go
        clc
        adc #$81

        and #%11110111

go      sta COLMEM,x
        inc chr
        inx
        bne put
        lda #$02
        sta kcol
        lda 147
        jsr $ffd2
        rts
        .bend
SCREEN  =   $1000
COLMEM  =   $9400
SCRBRD  =   36879
CARCOL  =   646
ZP2     =   $fd

chr       .byte     0
col       .byte     0
row       .byte     0
lin       .byte     0
adress    .byte     0     
;--------------------------------------
     .include  "l-v20-push.asm" 
     .include  "l-v20-string.asm" 
     .include  "l-v20-mem.asm"           
     .include  "l-v20-math.asm"           
     .include  "l-v20-conv.asm" 
     .include  "l-v20-keyb.asm" 
     .include  "l-v20-screen.asm"
     .include  "e-v20-vars.asm"
     .include  "m-v20-utils.asm"
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
     .include  "e-v20-vic.asm"

