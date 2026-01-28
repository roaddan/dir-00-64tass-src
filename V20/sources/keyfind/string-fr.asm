spaces         .null "     "
bonjour        .byte $0d,$0d,32,32,revson
               .text " bonjour & merci! "
               .byte revsoff,$0d,0
texte0         .byte 32,snoir,revson        ;0-2
               .text "chercheur code clef" ;3-23
               .byte snoir,revsoff,32,$0d
               .byte 0  
texte1         .byte 32,sbleu,revsoff
               .text " [esc] pour sortir "
               .byte snoir,revsoff,32,$0d
               .byte 0  
ligne          .byte 32,snoir,revsoff        ;0-2
               .byte 192,192,192,192,192     ;3-8   ;1
               .byte 192,192,192,192,192     ;9-13
               .byte 192,192,192,192,192     ;14-18
               .byte 192,192,192,192         ;19-23
               .byte snoir,revsoff,32    ;24-27
               .byte 0      

