*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
.include "stdio.asm"

main        jsr cpmem    
            rts    
    
cpmem       jsr mcpy
cpmem_src   .word $2000
cpmem_dst   .word $3000
cpmem_len   .word $0100
            rts