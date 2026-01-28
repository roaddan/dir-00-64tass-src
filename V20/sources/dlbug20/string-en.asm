rtitle         .byte 32,snoir,revson        ;0-2
               .text " CPU REGISTERS HEX " ;3-23
               .byte snoir,revsoff,32,$0d
               .byte 0  
rlable         .byte 32,sbleu,revsoff
               .text " PC  RA RX RY SR SP"
               .byte snoir,revsoff,32,$0d
               .byte 0  
rvalues         .byte 32,srouge,revsoff        ;0-2 - 0
               .text "0000 00 00 00 00 00" ;3-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0  
rbline         .byte 32,snoir,revsoff        ;0-2
               .byte 192,192,192,192,192     ;3-8   ;1
               .byte 192,192,192,192,192     ;9-13
               .byte 192,192,192,192,192     ;14-18
               .byte 192,192,192,192         ;19-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0      
