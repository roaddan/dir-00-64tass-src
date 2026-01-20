; mul 8x8 16 bit result for when you can't afford big tables
; by djmips 
;
; inputs are mul1 and X.  mul1 and mul2 should be zp locations
; A should be zero entering but if you want it will factor in as 1/2 A added to the result.
;
; output is 16 bit in A : mul1   (A is high byte)
;
; length = 65 bytes 
; total cycles worst case = 113
; total cycles best case = 97
; avg = 105
; inner loop credits Damon Slye CALL APPLE, JUNE 1983, P45-48.

MUL:
     cpx #$00
     beq zro
     dex          ; decrement mul2 because we will be adding with carry set for speed (an extra one)
     stx mul2	
     ror mul1
     bcc b1
     adc mul2
b1:  ror
     ror mul1
     bcc b2
     adc mul2
b2:  ror
     ror mul1
     bcc b3
     adc mul2
b3:  ror
     ror mul1
     bcc b4
     adc mul2
b4:  ror
     ror mul1
     bcc b5
     adc mul2
b5:  ror
     ror mul1
     bcc b6
     adc mul2
b6:  ror
     ror mul1
     bcc b7
     adc mul2
b7:  ror
     ror mul1
     bcc b8
     adc mul2
b8:  ror
     ror mul1
     inc mul2
     rts
     
zro: stx mul1
     tax
     rts     
