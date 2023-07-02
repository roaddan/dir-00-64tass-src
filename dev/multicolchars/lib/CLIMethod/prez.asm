*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

.include        "stdio.asm"
carcol          .byte   0
count           .byte   19
 
main            jsr     clears
                jsr     fillscr
                .byte   32,0,1
                jsr     tlogo
                rts
                
tlogo           jsr     putchncxy
                .byte   166,30,2,2,2
                rts                
                