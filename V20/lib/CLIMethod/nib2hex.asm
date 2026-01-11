;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
nib2hex         php
                clc
                and     #$0f
                adc     #$30
                cmp     #$3A
                bmi     nib2hex_l
                clc
                adc     #7
nib2hex_l       plp                
                rts
                