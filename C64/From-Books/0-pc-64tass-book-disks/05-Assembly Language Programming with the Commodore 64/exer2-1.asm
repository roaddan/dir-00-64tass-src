;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Exercise 2-1
; Adding 2 mem cell to another.
;------------------------------
*=$c000 ; 49152
add1    =   $c234
add2    =   $c235
summ    =   $cf00
start   lda add1
        clc
        adc add2
        sta summ
        rts