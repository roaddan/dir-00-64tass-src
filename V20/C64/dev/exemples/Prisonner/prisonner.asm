*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;example 1 ans 2
filla   lda     #$00
        tax
        tay
yloop   tya
xloop   sta     $0400,x
        sta     $0500,x
        sta     $0600,x
        sta     $0700,x
        sta     $D800,x
        sta     $D900,x
        sta     $DA00,x
        sta     $DB00,x
        inx
        bne     xloop
        iny

        bne     yloop
        rts
        
        