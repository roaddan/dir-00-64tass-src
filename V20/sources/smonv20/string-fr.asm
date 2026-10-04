;-----------------------------------------------------------------------------
; message table; last character has high bit set
;-----------------------------------------------------------------------------
msgbas  =*
msg2      .byte $0d,$20,31,18     ; header for registers
          .text " supermon sur vic20 "
          .byte 146,$0d,31        ; header for registers
          .text "   pc  sr ac xr yr sp"
          .byte 144,$0d,$00
msg3      .byte $1d,$3f,$00       ; syntax error: move right, display "?"
msg4      .text "..sys"           ; sys call to enter monitor
          .byte $20,$00
msg5      .byte $3a,$12,$00       ; ":" then rvs on for memory ascii dump
msg6      .text " erro"           ; i/o error: display " error"
          .byte "r",$00
msg7      .byte $41,$20,$00       ; assemble next instruction: "a " + addr
msg8      .text "  "              ; pad non-existent byte: skip 3 spaces
          .byte $20,$00
msg9      .byte 28,32,32,32,32,32,18
          .text "!h pour aide"
          .byte 146,144,0

mneuprfx       .byte $0d,sbleu
               .fill 8,$20
               .byte 0

backspace      .byte 146,144,157,157,32,32,157,157,145,0

hstitle        .byte 18,tleft,31
               .text "  Aide Super-Mon  "
               .byte 144,tright,146,0

hsfoot         .byte 18,leftb,146,28
               .text " Appuyez une clef "
               .byte 144,18,rightb,146,0

keyout         .null $0d,28,"--appuyez une clef!--"

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

                    ;"------------------"
hs1a           .null "[a]ssembleur"
hs1b           .null "a ADDR MNEUMO OPER"
hs1c           .null "[d]esassembleur"
hs1d           .null "d [debut [fin]]"
hs1e           .null "[f]=emplir memoire"
hs1f           .null "f debut fin code"
hs1g           .null "[m]emoire v/e"
hs1h           .null "m [debut [fin]]"
hs1i           .null ">AAAA XX XX ... XX"
hs1j           .null "[r]egsistres v/e"
hs1k           .null "[;]init registres"
hs1l           .null "[G]oto adresse"
hs1m           .null "g [AAAA]"

hs1vect        .word     hsvide,hs1a,hs1b,hsvide
               .word     hs1c,hs1d,hsvide
               .word     hs1e,hs1f,hsvide
               .word     hs1g,hs1h,hs1i,hsvide
               .word     hs1j,hs1k,hsvide
               .word     hs1l,hs1m,$ffff
    
hs2a           .null "[r]un Executer"
hs2b           .null "r [AAAA] ou PC"
hs2c           .null "[j]sr sous-routine"
hs2d           .null "j [AAAA] ou PC"
hs2e           .null "[h]unt recherche"
hs2f           .null "h BBBB EEEE BB..BB"
hs2g           .null "[t]ransfert mem."
hs2h           .null "t BBBB EEEE DDDD"
hs2i           .null "[c]ompare mem."
hs2j           .null "c BBBB EEEE DDDD"
hs2k           .null "Conversion [$+&%]"
hs2l           .null " [$]hex.  [&]oct."
hs2m           .null " [+]dec.  [%]bin."

hs2vect   .word     hsvide,hs2a,hs2b,hsvide
          .word     hs2c,hs2d,hsvide
          .word     hs2e,hs2f,hsvide
          .word     hs2g,hs2h,hsvide
          .word     hs2i,hs2j,hsvide
          .word     hs2k,hs2l,hs2m,$ffff

hs3a           .null "[s]auve fichier"
hs3b           .text "s"
               .byte 34
               .text "fnm"
               .byte 34
               .null ",d,BBBB,EEEE"

hs3c           .null "[l]lire fichier"
hs3d           .text "l"
               .byte 34
               .text "fnm"
               .byte 34
               .null ",d,BBBB"

hs3e           .null "[v]erifier fichier"
hs3f           .text "v"
               .byte 34
               .text "fnom"
               .byte 34
               .null "d,BBBB"

hs3g           .null "@ etat du lecteur"
hs3h           .null "[x] Basic warmboot"

hs3vect        .word     hsvide,hs3a,hs3b,hsvide
               .word     hs3c,hs3d,hsvide
               .word     hs3e,hs3f,hsvide
               .word     hs3g,hsvide,hs3h,$ffff

hs4a           .null "   Informations"
hs4b           .null "Demarrer:SYS 40960"
hs4c           .null "v/e = voir/editer"
hs4d           .null "d=Lecteur"
hs4e           .null "BBBB= Adr. debut"
hs4f           .null "EEEE= Adr. fin"
hs4g           .null "DDDD= Adr. destin."
hs4h           .null "BB=Octet Hex"
hs4i           .null "Autres commandes:"
hs4j           .null "!c=cls,!d=listfich"
hs4k           .null "!g=Credits,!h=aide"
hs4l           .null "!m=Masque du bit 8"
hs4m           .null "!8/!9=sel. disque"
hs4n           .null "!1=sel. cassette"

hs4vect   .word     hsvide,hs4a,hsvide,hs4c,hsvide
          .word     hs4d,hs4e,hs4f,hs4g,hs4h,hsvide
          .word     hs4i,hs4j,hs4k,hs4l,hs4m
          .word     hsvide,hs4b,$ffff

gs1t           .null " Credits SuperMon"
gs1a           .null "Version originale:"
gs1b           .byte srouge
               .text "*SuperMon+64 1985*"
               .byte snoir,0
gs1c           .byte srouge
               .text "* J. Butterfield *"
               .byte snoir,0
gs1d           .byte srouge
               .text "*1936-2007 R.I.P.*"
               .byte snoir,0
gs1e           .null "Adaptation Vic20:"
gs1g           .null " Daniel Lafrance"
;gs1h           .null "github.com/roaddan"
gs1h           .null format("  Lancez j$%X",greetme)
gs1i           .null "Utilise 8k + bnk 5"
gs1j           .null "Utilisez VICE emu."
gs1k           .null "ou cartouche type"
gs1l           .null "Penultimate+,+2,+3"
gs1m           .byte svert
               .text "voir:             "
               .byte snoir,0
gs1n           .byte svert
               .text "www.tfw8b.com/shop"
               .byte snoir,0
gs1vect   .word     hsvide,gs1a,hsvide
          .word     gs1b,gs1c,gs1d,hsvide
          .word     gs1e,gs1g,gs1h,hsvide
          .word     gs1i,hsvide,gs1j
          .word     gs1k,gs1l,gs1m,gs1n,$ffff

auteur         .byte 14,13,13
               .text " Adaptation Vic20:" 
               .byte 13,28 
               .text "   Daniel Lafrance," 
               .byte 13,144 
               .text "   Octobre 2026," 
               .byte 13 
               .text "   Trois-Rivieres," 
               .byte 13 
               .text "   Quebec, Canada."
               .byte 13,13,0
github         .text "github.com/roaddan"
               .byte 13,173,192,62
               .text "/dir-00-64tass-src"
               .byte 13,32,32,173,192,62
               .text "/V20"
               .byte 13,32,32,32,32,173,192,62
               .text "/sources"
               .byte 13,32,32,32,32,32,32,173,192,62
               .text "/smonv20"
               .byte 0
               