*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
.include        "stdio.asm"
tmp = $8000
main2   ;point to nmi    
        lda #<tmp
        sta $0318
        lda #>tmp
        sta $0329
main    ;init screen
init    lda #$0
        sta 53280
        sta 53281
        lda #147
        jsr $ffd2
        lda #5
        jsr $ffd2
        lda #142
        jsr $ffd2

        ldy #0
loop    tya
        jsr printhc
space   lda #$20
        jsr $ffd2
        iny
        ;cpy #$10
        bne loop
        rts

printhc pha
        lda #11 ; light gray
        sta 646 ; next basic color
ln      pla
        pha
        and #$0f
        cmp #$0a
        bne hn
        lda #7  ; yellow
        sta 646
hn      pla
        pha
        and #$f0
        cmp #$a0
        bne ok2 
        lda #7  ;yellow
        sta 646
ok2     pla      
        pha
        lsr a
        lsr a
        lsr a
        lsr a
        jsr conv4        
        jsr $ffd2
        pla
        and #$0f
        jsr conv4
        jsr $ffd2
        rts
        
conv1   and #$0f
        tax
        lda table,x
        rts
table   .byte 48,49,50,51,52 ; 0-4        
        .byte 53,54,55,56,57 ; 5-9            
        .byte 65,66,67,68,69,70 ; a-f

conv2   cmp #10
        bcc number
        adc #6
number  adc #48        
        rts

conv3   sed
        clc
        adc #$90
        adc #$40
        cld
        rts

conv4   sed
        cmp #10
        adc #48
        cld
        rts