*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

*=960
pause           .block
                lda #<princ
                sta 806
                lda #>princ
                sta 807
                rts
princ           pha
                txa
                pha
                tya
                pha
loop            lda 653                
                cmp #1
                beq loop
                pla
                tay
                pla
                tax
                pla
                jmp $f1ca
                .bend