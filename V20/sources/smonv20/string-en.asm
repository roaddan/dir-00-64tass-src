
mneuprfx       .byte $0d,sbleu
               .fill 8,$20
               .byte 0

backspace      .byte 157,157,32,32,157,157,145,0

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


hstitle        .byte 18,tleft,146,156
               .text " SuperMon Help P1 "
               .byte 144,18,tright,146,0

hsfoot         .byte 18,bleft,146,28
               .text "    Press a key   "
               .byte 144,18,bright,146,0

hsempty        .byte 18,vline
               .fill 18,32
               .byte vline,146,0

hsitemhead     .byte 29,18,vline,0
hsemty         .fill 18,32
               .byte 0
hsitemfoot     .byte vline,146,0

horline        .byte 29,18,hleft
               .fill 18,hline
               .byte hright,146,0

hs1a           .byte 3,1
               .null "[a]ssembler       "
hs1b           .byte 3,4
               .null "a ADDR MNEUMO OPER"
hs1c           .byte 3,5
               .null "[d]esassembler    "
hs1d           .byte 3,6
               .null "d [start [end]]   "
hs1e           .byte 3,7
               .null "[f]ill memory     "
hs1f           .byte 3,8
               .null "f start end code  "
hs1g           .byte 3,9
               .null "[m]emory v/e      "
hs1h           .byte 3,10
               .null "m [start [end]]   "
hs1i           .byte 3,11
               .null ">AAAA XX XX ... XX"
hs1j           .byte 3,12
               .null "[r]egsisters v/e  "
hs1k           .byte 3,13
               .null "[;]init registers "
hs1l           .byte 3,14
               .null "[G]oto address    "
hs1m           .byte 3,15
               .null "g [AAAA]          "

hs1vect   .word hs1a,hs1b,hs1c,hs1d,hs1e,hs1f,hs1g,hs1h
          .word hs1i,hs1j,hs1k,hs1l,hs1m,$ffff
          

    
hs2a           .byte 3,4
               .null "[r]un program     "
hs2b           .byte 3,5
               .null "r AAAA            "
hs2c           .byte 3,6
               .null "[j]sr sub-routine "
hs2d           .byte 3,7
               .null "j AAAA            "
hs2e           .byte 3,8
               .null "[h]unt for bytes  "
hs2f           .byte 3,9
               .null "h BBBB EEEE BB..BB"
hs2g           .byte 3,10
               .null "[t]ransfer memory "
hs2h           .byte 3,11
               .null "t BBBB EEEE DDDD  "
hs2i           .byte 3,12
               .null "[c]ompare memory  "
hs2j           .byte 3,13
               .null "c BBBB EEEE DDDD  "
hs2k           .byte 3,14
               .null "Conversion [$+&%] "
hs2l           .byte 3,15
               .null " [$]hex.  [&]oct. "
hs2m           .byte 3,16
               .null " [+]dec.  [%]bin. "
hs2n           .byte 3,17
               .null "    Press a key   "

hs3a           .byte 3,4
               .null "[s]ave memory     "
hs3b           .byte 3,5
               .text "s"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB,EEEE"
               .byte 0
hs3c           .byte 3,6
               .null "[l]oad into memory"
hs3d           .byte 3,0
               .text "l"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB     "
               .byte 0
hs3e           .byte 3,7
               .null "[v]erify file/mem "
hs3f           .text "v"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB     "
               .byte 0
hs3g           .byte 3,8
               .null "@ drive status    "
hs3h           .byte 3,9
               .null "[x] Back to Basic "

hs4a           .byte 3,4
               .null "   Information    "
hs4b           .byte 3,5
               .null "Startup: SYS 40960"
hs4c           .byte 3,6
               .null "v/e = view/edit   "
hs4d           .byte 3,7
               .null "d=Drive number    "
hs4e           .byte 3,8
               .null "BBBB=Begin Address"
hs4f           .byte 3,9
               .null "EEEE=End Address  "
hs4g           .byte 3,10
               .null "DDDD=Dest. Address"
hs4h           .byte 3,11
               .null "BB=Byte           "
hs4i           .byte 3,12
               .null "More Commande:    "
hs4j           .byte 3,13
               .null "!c=cls,!d=listfile"
hs4k           .byte 3,14
               .null "!g=Credits,!h=help"
    
gs1t           .byte 3,4
               .null " Credits SuperMon "
gs1a           .byte 3,4
               .null "Original Version: "
gs1b           .byte 3,5
               .null " Supermon64 1983  "
gs1c           .byte 3,6
               .null " Jim Butterfield  "
gs1d           .byte 3,7
               .null " 1936-2007 R.I.P. "
gs1f           .byte 3,8
               .null "Vic20 Version:    "
gs1g           .byte 3,9
               .null " Port:            "
gs1h           .byte 3,10
               .null " Daniel Lafrance  "
gs1i           .byte 3,11
               .null format(" %s  ",version)
gs1j           .byte 3,12
               .null "Uses banks 0 & 5  "
gs1k           .byte 3,13
               .null " on VICE emulator "
gs1l           .byte 3,14
               .null " or on cartridge  "
gs1m           .byte 3,15
               .null "Penultimate+,+2,+3"
gs1n           .byte 3,16
               .null "www.tfw8b.com/shop"
    