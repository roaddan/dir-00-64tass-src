;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Fill.asm
; Book Page.: 55
;---------;---------;---------;---------;---------;---------;---------;---------
; Description : Fill memory with byte
;---------;---------;---------;---------;---------;---------;---------;---------
;*= $801
;.word (+), 10
;.null $9e, "2061"
;+ .word 0
;                .include "c64_map.asm"
;main            jsr   fill  
;                rts  
;*=$012c
                                ;kfunctions     |axy, Input        
                                ;               |AXY, Outuut
*=$7000            
; Uses $fb and $fc, stote top address in 828 and 829            
fill            jsr     $aefd            
                ; scan past coma            
                jsr     $ad8a
                ; Read number and put into FAC
                jsr     $b7f7
                ; get number from fac and put it in $14 and $15
                lda     $14
                sta     $fb
                lda     $15
                sta     $fc
                jsr     $aefd
                ; scan past coma            
                jsr     $ad8a
                jsr     $b7f7
                lda     $14
                sta     828
                lda     $15
                sta     829
                jsr     $aefd
                jsr     $ad8a
                jsr     $b7f7
                lda     $15
                beq     more
                jmp     $b248
                ; $b248 is iqant error
more            lda     $14
                sta     830
loop            ldy     #$0
                lda     830
                sta     ($fb),y
                jsr     add
                lda     $fb
                cmp     828
                beq     check
                jmp     loop
check           lda     $fc                
                cmp     829
                beq     finish
                jmp     loop
add             inc     $fb                
                beq     fcplus1
                rts
fcplus1         inc     $fc
                rts
finish          rts                
     