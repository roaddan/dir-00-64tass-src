;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 4-6
; Adding two 16 bits numbers.
;------------------------------
*=$c000 ; 49152
num1l   =   $01
num1h   =   $02
num2l   =   $03
num2h   =   $04
suml    =   $05
sumh    =   $06
start   clc
        lda num1l
        adc num2l
        sta suml
        lda num1h
        adc num2h
        sta sumh
        ret
        
        