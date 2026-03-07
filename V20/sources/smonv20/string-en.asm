
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

hsvide         .fill 18,32
               .byte 0

hsempty        .byte 18,vline
               .fill 18,32
               .byte vline,146,0

hsih           .byte 18,0
hsif           .byte 146,0

horline        .byte 18,hleft
               .fill 18,hline
               .byte hright,146,0

hs1a           .null "[a]ssembler       "
hs1b           .null "a ADDR MNEUMO OPER"
hs1c           .null "[d]esassembler    "
hs1d           .null "d [start [end]]   "
hs1e           .null "[f]ill memory     "
hs1f           .null "f start end code  "
hs1g           .null "[m]emory v/e      "
hs1h           .null "m [start [end]]   "
hs1i           .null ">AAAA XX XX ... XX"
hs1j           .null "[r]egsisters v/e  "
hs1k           .null "[;]init registers "
hs1l           .null "[G]oto address    "
hs1m           .null "g [AAAA]          "

hs1vect        .word     hs1a,hs1b,hsvide
               .word     hs1c,hs1d,hsvide
               .word     hs1e,hs1f,hsvide
               .word     hs1g,hs1h,hs1i,hsvide
               .word     hs1j,hs1k,hsvide
               .word     hs1l,hs1m,$ffff
    
hs2a           .null "[r]un program     "
hs2b           .null "r AAAA            "
hs2c           .null "[j]sr sub-routine "
hs2d           .null "j AAAA            "
hs2e           .null "[h]unt for bytes  "
hs2f           .null "h BBBB EEEE BB..BB"
hs2g           .null "[t]ransfer memory "
hs2h           .null "t BBBB EEEE DDDD  "
hs2i           .null "[c]ompare memory  "
hs2j           .null "c BBBB EEEE DDDD  "
hs2k           .null "Conversion [$+&%] "
hs2l           .null " [$]hex.  [&]oct. "
hs2m           .null " [+]dec.  [%]bin. "

hs2vect   .word     hs2a,hs2b,hsvide
          .word     hs2c,hs2d,hsvide
          .word     hs2e,hs2f,hsvide
          .word     hs2g,hs2h,hsvide
          .word     hs2i,hs2j,hsvide
          .word     hs2k,hs2l,hs2m,$ffff

hs3a           .null "[s]ave memory     "
hs3b           .text "s"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB,EEEE"
               .byte 0
hs3c           .null "[l]oad into memory"
hs3d           .text "l"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB     "
               .byte 0
hs3e           .null "[v]erify file/mem "
hs3f           .text "v"
               .byte 34
               .text "fnam"
               .byte 34
               .text "d,BBBB     "
               .byte 0
hs3g           .null "@ drive status    "
hs3h           .null "[x] Back to Basic "

hs3vect        .word     hs3a,hs3b,hsvide
               .word     hs3c,hs3d,hsvide
               .word     hs3e,hs3f,hsvide
               .word     hs3g,hs3h,$ffff

hs4a           .null "   Information    "
hs4b           .null "Startup: SYS 40960"
hs4c           .null "v/e = view/edit   "
hs4d           .null "d=Drive number    "
hs4e           .null "BBBB=Begin Address"
hs4f           .null "EEEE=End Address  "
hs4g           .null "DDDD=Dest. Address"
hs4h           .null "BB=Byte           "
hs4i           .null "More Commands:    "
hs4j           .null "!c=cls,!d=listfile"
hs4k           .null "!g=Credits,!h=help"
    
hs4vect   .word     hs4a,hs4b,hs4c,hsvide
          .word     hs4d,hs4e,hs4f,hs4g,hs4h,hsvide
          .word     hs4i,hs4j,hs4k,$ffff

gs1t           .null " Credits SuperMon "
gs1a           .null "Original Version: "
gs1b           .null " Supermon64 1983  "
gs1c           .null " Jim Butterfield  "
gs1d           .null " 1936-2007 R.I.P. "
gs1e           .null "Vic20 Version:    "
gs1f           .null " Port:            "
gs1g           .null " Daniel Lafrance  "
gs1h           .null format(" %s  ",version)
gs1i           .null "Uses banks 0 & 5  "
gs1j           .null " on VICE emulator "
gs1k           .null " or on cartridge  "
gs1l           .null "Penultimate+,+2,+3"
gs1m           .null "www.tfw8b.com/shop"

gs1vect   .word     gs1a,hsvide
          .word     gs1b,gs1c,gs1d,gs1e,hsvide
          .word     gs1f,gs1g,gs1h,hsvide
          .word     gs1i,gs1j,gs1k,gs1l,gs1m,$ffff
