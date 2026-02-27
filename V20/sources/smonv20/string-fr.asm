;stattitle      .byte sbleu, revson
;               .text "Statistiques programme"
;               .byte eot
;startaddr      .byte 145, snoir
;               .null format("debut prog----->%5d",bcmd1)
;endaddr        .null format("fin prog------->%5d",prgend)
;sizeprg        .null format("taille prog---->%5d",(prgend-bcmd1+1))

;mainaddr       .byte $0d, sbleu
;               .null format("adresse main--->%5d",main)

;varsstart      .byte $0d, srouge
;               .null format("debut vars----->%5d",mybyte)
;varsend        .null format("fin vars------->%5d",libre)
;sizevars       .text format("taille vars---->%5d",libre-mybyte+1)
;               .byte revsoff, snoir,eot
               
rtitle         .byte revsoff,176,snoir,revson
               .text " cpu registers hex "
               .byte snoir,revsoff,174,$0d
               .byte eot 

rlable         .byte 221,sbleu,revsoff
               .text " pc  ra rx ry sr sp"
               .byte snoir,revsoff,221,$0d
               .byte eot  

rvalues        .byte 221,srouge,revsoff 
               .text "0000 00 00 00 00 00"
               .byte snoir,revsoff,221,$0d
               .byte eot 

rbline         .byte 173,snoir,revsoff        ;0-2
               .byte 192    ;9-13
               .text "sortir=[une-clef]"
               .byte 192         ;19-23
               .byte snoir,revsoff,189,$0d    ;24-27
               .byte eot   

mvaide1        .byte revsoff,176,snoir,revson
               .text " affichage  memoire "
               .byte snoir,revsoff,174
               .byte eot
mvaide2        .byte 221,snoir
               .text " crs up/dn -/+ 64   "
               .byte snoir,221
               .byte eot
mvaide3        .byte 221,snoir
               .text " crs lf/rt -/+ 128  "
               .byte snoir,221
               .byte eot
mvaide4        .byte 221,snoir
               .text " f1/f3     -/+ 4096 "
               .byte snoir,221
               .byte eot
mvaide5        .byte  221,snoir
               .text " esc = main memu    "
               .byte snoir,221 
               .byte eot
mvaide6        .byte 173,snoir
               .byte 192,192,192,192,192
               .byte 192,192,192,192,192
               .byte 192,192,192,192,192
               .byte 192,192,192,192,192
               .byte snoir,189
               .byte eot
biton          .text "bit is on."
               .byte 13,eot
bitoff         .text "bit is off."
               .byte 13,eot

mneuprfx       .byte $0d,sbleu
               .fill 8,$20
               .byte 0

helpscr        .byte 19,29 
               .byte 18,tleft,hline,146
               .text " Aide Super-Mon "
               .byte 18,hline,tright,146,$0d

               .byte 29,18,vline
               .text "a = assembler     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "a ADDR MNEUMO OPER"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "r = v/e regsistres"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "m = v/e memoire   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "m [debut [fin]]   "
               .byte vline,146,$0d

               .byte 29,18,hleft,146
               .text " Autres Commandes "
               .byte 18,hright,146,$0d

               .byte 29,18,vline
               .text " !c=cls   !?=aide "
               .byte vline,146,$0d

               .byte 29,18,hleft
               .fill 18,hline
               .byte hright,146,$0d

               .byte 29,18,vline
               .text "v/e = voir/editer "
               .byte vline,146,$0d

               .byte 29,18,bleft
               .fill 18,hline
               .byte bright,146,$0d
               .byte 0
backspace      .byte 157,157,32,32,157,157,145,0
