
mneuprfx       .byte $0d,sbleu
               .fill 8,$20
               .byte 0

helpscrp1      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " SuperMon Help P1 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[a]ssembler       "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "a ADDR MNEUMO OPER"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[d]esassembler    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "d [start [end]]   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[f]ill memory     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "f start end code  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[m]emory v/e      "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "m [start [end]]   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text ">AAAA XX XX ... XX"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[r]egsisters v/e  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[;]init registers "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[G]oto address    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "g [AAAA]          "
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text "    Press a key   "
               .byte 144,18,bright,146,$0d

               .byte 0

helpscrp2      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " SuperMon Help P2 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[r]un program     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "r AAAA            "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[j]sr sub-routine "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "j AAAA            "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[h]unt for bytes  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "h BBBB EEEE BB..BB"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[t]ransfer memory "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "t BBBB EEEE DDDD  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[c]ompare memory  "
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
               .text "    Press a key   "
               .byte 144,18,bright,146,$0d

               .byte 0

helpscrp3      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " SuperMon Help P3 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[s]ave memory     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "s"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB,EEEE"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[l]oad into memory"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "l"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[v]erify file/mem "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "v"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB     "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "@ drive status    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "[x] Back to Basic "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text "    Press a key   "
               .byte 144,18,bright,146,$0d

               .byte 0

helpscrp4      .byte 19,17,29 
               .byte 18,tleft,146,156
               .text " SuperMon Help P4 "
               .byte 144,18,tright,146,$0d

               .byte 29,18,hleft,146,31
               .text "   Information    "
               .byte 144,18,hright,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "Startup: SYS 40960"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "v/e = view/edit   "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "d=Drive number    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "BBBB=Begin Address"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "EEEE=End Address  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "DDDD=Dest. Address"
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "BB=Byte           "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "More Commande:    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "!c=cls,!d=listfile"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,vline
               .text "!g=Credits,!h=help"
               .byte vline,146,$0d

               .byte 29,18,vline
               .fill 18,32
               .byte vline,146,$0d

               .byte 29,18,bleft,146,28
               .text "    Press a key   "
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
               .text "Original Version: "
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
               .text "Vic20 Version:    "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " Port:            "
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
               .text "Uses banks 0 & 5  "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " on VICE emulator "
               .byte vline,146,$0d

               .byte 29,18,vline
               .text " or on cartridge  "
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
               .text "    Press a key   "
               .byte 144,18,bright,146,$0d

               .byte 0
Auteur         .text "Adaptation Vic20: Mars 2026, Daniel Lafrance, 3RV, Quebec, Canada"