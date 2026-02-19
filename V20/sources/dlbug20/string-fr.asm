
rtitle         .byte revsoff,176,snoir,revson
               .text " cpu registers hex "
               .byte snoir,revsoff,174,$0d
               .byte 0 

rlable         .byte 221,sbleu,revsoff
               .text " pc  ra rx ry sr sp"
               .byte snoir,revsoff,221,$0d
               .byte 0  

rvalues        .byte 221,srouge,revsoff 
               .text "0000 00 00 00 00 00"
               .byte snoir,revsoff,221,$0d
               .byte 0 

rbline         .byte 173,snoir,revsoff        ;0-2
               .byte 192    ;9-13
               .text "sortir=[une-clef]"
               .byte 192         ;19-23
               .byte snoir,revsoff,189,$0d    ;24-27
               .byte 0   

mvaide1        .byte revsoff,176,snoir,revson
               .text " affichage  memoire "
               .byte snoir,revsoff,174
               .byte 0
mvaide2        .byte 221,snoir
               .text " crs up/dn -/+ 64   "
               .byte snoir,221
               .byte 0
mvaide3        .byte 221,snoir
               .text " crs lf/rt -/+ 128  "
               .byte snoir,221
               .byte 0
mvaide4        .byte 221,snoir
               .text " f1/f3     -/+ 4096 "
               .byte snoir,221
               .byte 0
mvaide5        .byte  221,snoir
               .text " esc = main memu    "
               .byte snoir,221 
               .byte 0
mvaide6        .byte 173,snoir
               .byte 192,192,192,192,192
               .byte 192,192,192,192,192
               .byte 192,192,192,192,192
               .byte 192,192,192,192,192
               .byte snoir,189
               .byte 0
