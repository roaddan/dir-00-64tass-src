
mneuprfx       .byte $0d,sbleu
               .fill 8,$20
               .byte 0

helpscrp1      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " Aide SuperMon P1 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[a]ssembleur      "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "a ADDR MNEUMO OPER"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[d]esassembleur   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "d [debut [fin]]   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[f]=emplir memoire"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "f debut fin code  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[m]emoire v/e     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "m [debut [fin]]   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text ">AAAA XX XX ... XX"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[r]egsistres v/e  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[;]init registres "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[G]oto adresse    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "g [AAAA]          "
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text " Appuyez une clef "
               .byte 144,18,bright,146,$0d

               .byte 0

helpscrp2      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " Aide SuperMon P2 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[r]un    programme"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "r AAAA            "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[j]sr sous-routine"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "j AAAA            "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[h]unt recherche  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "h BBBB EEEE BB..BB"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[t]ransfert mem.  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "t BBBB EEEE DDDD  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[c]ompare mem     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "c BBBB EEEE DDDD  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Conversion [$+&%] "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " [$]hex.  [&]oct. "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " [+]dec.  [%]bin. "
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text " Appuyez une clef "
               .byte 144,18,bright,146,$0d

               .byte 0

helpscrp3      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " Aide SuperMon P3 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[s]auvegarde mem. "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "s"
               .byte 34
               .text "fnom"
               .byte 34
               .text "d,BBBB,EEEE"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[l]oad charger mem"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "l"
               .byte 34
               .text "fnom"
               .byte 34
               .text "d,BBBB     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[v]erifier fichier"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "v"
               .byte 34
               .text "fnom"
               .byte 34
               .text "d,BBBB     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "@ etat du lecteur "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[x] aller a Basic "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text " Appuyez une clef "
               .byte 144,18,bright,146,$0d

               .byte 0

helpscrp4      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " Aide SuperMon P4 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,hleft,146,31
               .text "   Informations   "
               .byte 144,18,hright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Demarrer:SYS 40960"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "v/e = voir/editer "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "d=Lecteur"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "BBBB= Adr. debut  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "EEEE= Adr. fin    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "DDDD= Adr. destin."
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "BB=Octet          "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Autres commandes: "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "!c=cls,!d=listfich"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "!g=Credits,!h=aide"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text " Appuyez une clef "
               .byte 144,18,bright,146,$0d

               .byte 0

backspace      .byte 157,157,32,32,157,157,145,0

greetings      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " Credits SuperMon "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Version originale:"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " Supermon64 1983  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " Jim Butterfield  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " 1936-2007 R.I.P. "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,hleft
               .fill 18,hline
               .byte hright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Version Vic20:    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " Adaptation:      "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " Daniel Lafrance  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text format(" %s  ",version)
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Utilise bank 0 & 5"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "sur emulateur VICE"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " ou la cartouche  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Penultimate+,+2,+3"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "www.tfw8b.com/shop"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text " Appuyez une clef "
               .byte 144,18,bright,146,$0d

               .byte 0
Auteur         .text "Adaptation Vic20: Mars 2026, Daniel Lafrance, 3RV, Quebec, Canada"