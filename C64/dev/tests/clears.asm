clears          pha
                jsr     fillscr
                .byte   $20,0,0,0
                jsr     gotoxy
                .byte   0,0
                pla
                rts     
