               .enc    screen

bstring1       .byte   vvert1,bkcol2,0,0        
                       ;          111111111122222222223333333333
                       ;0123456789012345678901234567890123456789    
               .text   "      Visualisation du port jeu #2      "
               .byte   0
bstring2       .byte   vbleu1,bkcol3,0,1
               .text   "     Programme assembleur pour 6502     "
               .byte   0
bstring3       .byte   vrose,bkcol1,0,2
               .text   "      par Daniel Lafrance (2021) C      "
               .byte   0
bstring4       .byte   vjaune,bkcol1,0,3
               .text   "    Ce programme utilise le port #2     "
               .byte   0
js_status1     .byte   vvert1,bkcol0,19,22
               .text   "   up <----1> haut "
               .byte   0
js_status2     .byte   vbleu1,bkcol0,19,21
               .text   " down <---2-> bas "
               .byte   0
js_status3     .byte   vrose,bkcol0,19,20
               .text   " left <--4--> gauche"
               .byte   0
js_status4     .byte   vjaune,bkcol0,19,19
               .text   "right <-8---> droite"
               .byte   0
js_status5     .byte   vblanc,bkcol0,19,18
               .text   " Fire <1----> Feu"
               .byte   0
js_status6     .byte   vcyan,bkcol0,1,23
               .text   "+-> Joystick status: %---FRLDU EOR #$1F"
               .byte   0
