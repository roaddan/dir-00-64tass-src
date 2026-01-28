spaces         .null "     "
bonjour        .byte $0d
               .text "Thanks and good day."
               .byte $0d,0
texte0         .byte 32,snoir,revson        ;0-2
               .text "  key code finder  " ;3-23
               .byte snoir,revsoff,32,$0d
               .byte 0  
texte1         .byte 32,sbleu,revsoff
               .text "   [esc] to exit   "
               .byte snoir,revsoff,32,$0d
               .byte 0  
texte2         .byte 32,srouge,revsoff        ;0-2 - 0
               .text "    [ ] 000 $00    " ;3-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0  
ligne          .byte 32,snoir,revsoff        ;0-2
               .byte 192,192,192,192,192     ;3-8   ;1
               .byte 192,192,192,192,192     ;9-13
               .byte 192,192,192,192,192     ;14-18
               .byte 192,192,192,192         ;19-23
               .byte snoir,revsoff,32,$0d    ;24-27
               .byte 0      

