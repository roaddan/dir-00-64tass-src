;--------------------------------------
; Fichier : v20test1.asm
; Auteur..: Daniel Lafrance
version  = "20260131-192144"
;--------------------------------------
.enc "none"
     .include  "l-v20-bashead-ex.asm"
;--------------------------------------
main    .block
        #volume 4ws
here    jsr piano
        #voicesoff
        jmp here
        rts
        .bend

piano   .block
        jsr pushall
next    jsr getkey
testa   cmp #$41
        bne testw
        #sopplay v2do4
testw   cmp #$57
        bne tests
        #sopplay v2dod4
tests   cmp #$53
        bne teste
        #sopplay v2re4
teste   cmp #$45
        bne testd
        #sopplay v2red4
testd   cmp #$44
        bne testf
        #sopplay v2mi4
testf   cmp #$46
        bne testt
        #sopplay v2fa4
testt   cmp #$54
        bne testg
        #sopplay v2fad4
testg   cmp #$47
        bne testy
        #sopplay v2so4
testy   cmp #$59
        bne testh
        #sopplay v2sod4
testh   cmp #$48
        bne testu
        #sopplay v2la4
testu   cmp #$55
        bne testj
        #sopplay v2lad4
testj   cmp #$4a
        bne testk
        #sopplay v2si4
testk   cmp #$4b
        bne testesc
        #sopplay v2do5
testesc cmp #$5f
        beq out
        jmp next
out     jsr popall
        rts
        .bend


colortest  .block        
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

