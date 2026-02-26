rtitle         .byte 32,snoir,revson        ;0-2
               .text " cpu registers hex " ;3-23
               .byte snoir,revsoff,32,$0d
               .byte 0  
rlable         .byte 32,sbleu,revsoff
               .text " pc  ra rx ry sr sp"
               .byte snoir,revsoff,32,$0d
               .byte 0  
rvalues         .byte 32,srouge,revsoff        ;0-2 - 0
               .text "0000 00 00 00 00 00" ;3-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0  
rbline         .byte 32,snoir,revsoff        ;0-2
               .byte 192,192
               .text "exit=[ctrl]-[x]"
               .byte 192,192    ;14-18
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0      
