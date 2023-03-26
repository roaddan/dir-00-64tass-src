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
                