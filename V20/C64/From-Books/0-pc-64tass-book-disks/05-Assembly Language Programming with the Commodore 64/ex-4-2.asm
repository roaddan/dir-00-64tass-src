;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 4-2
; Adding two 8 bits numbers.
;------------------------------
*=$c000 ; 49152
num1    =   $02
num2    =   $03
summ    =   $04
start   clc
        lda num1
        adc num2
        sta summ
        ret
        
        