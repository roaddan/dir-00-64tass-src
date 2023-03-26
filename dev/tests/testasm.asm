*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
init            jmp     init_beg
init_beg        jsr     c64asm_init
                jsr     main
init_end        rts


main            jmp     main_beg
car             .byte   0,0,3,"a",0
col             .byte   3
main_beg        lda     car     
                pha     
                ;lda     $<car
                ;pha
                jsr     pokecar
                rts    

pokecar         jmp     pokecar_beg
pokecar_beg     tsx     
                lda     2,x    
                sta     ECRAN
pokecar_end     rts                
                
.include        "c64asmutils.asm"
