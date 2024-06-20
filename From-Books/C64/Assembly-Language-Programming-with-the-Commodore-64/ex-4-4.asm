;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 4-4
; Adding two 8 bits numbers
; keeping carry
;------------------------------
*=$c000 ; 49152
num1    =   $02
num2    =   $03
suml    =   $04
sumh    =   $05
start   clc
        lda num1
        adc num2
        sta suml
        lda #$00
        adc #$00
        sta sumh
        ret
        
        