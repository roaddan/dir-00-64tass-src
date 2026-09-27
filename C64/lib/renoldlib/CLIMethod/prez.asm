;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
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
                