;-----------------------------------------------------------------------------
; message table; last character has high bit set
;-----------------------------------------------------------------------------
msgbas  =*
msg2      .byte $0d,$20,31,18     ; header for registers
          .text " SuperMon sur VIC20 "
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

backspace      .byte 157,157,32,32,157,157,145,0

;Auteur         .text "Adaptation Vic20: Mars 2026, Daniel Lafrance, 3RV, Quebec, Canada"


hstitle        .byte 18,tleft,146,156
               .text "  Aide Super-Mon  "
               .byte 144,18,tright,146,0

hsfoot         .byte 18,bleft,146,28
               .text " Appuyez une clef "
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
hs2i           .null "[c]ompare mem"
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

hs3a           .null "[s]auvegarde mem. "
hs3b           .text "s"
               .byte 34
               .text "fnom"
               .byte 34
               .null "d,BBBB,EEEE"

hs3c           .null "[l]oad charger mem"
hs3d           .text "l"
               .byte 34
               .text "fnom"
               .byte 34
               .null "d,BBBB"

hs3e           .null "[v]erifier fichier"
hs3f           .text "v"
               .byte 34
               .text "fnom"
               .byte 34
               .null "d,BBBB"

hs3g           .null "@ etat du lecteur"
hs3h           .null "[x] aller a Basic"

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


hs4vect   .word     hsvide,hs4a,hs4c,hsvide
          .word     hs4d,hs4e,hs4f,hs4g,hs4h,hsvide
          .word     hs4i,hs4j,hs4k,hsvide,hs4b,$ffff

gs1t           .null " Credits SuperMon"
gs1a           .null "Version originale:"
gs1b           .byte sbleu
               .text " Super-Mon64 1983 "
               .byte snoir,0
gs1c           .byte srouge
               .text " Jim Butterfield  "
               .byte snoir,0
gs1d           .byte srouge
               .text " 1936-2007 R.I.P. "
               .byte snoir,0
gs1e           .null "Adaptation Vic20:"
gs1g           .null " Daniel Lafrance"
gs1h           .null "github.com/roaddan"
;gs1h           .null format(" %s",version)
gs1i           .null "Utilise bank 0 & 5"
gs1j           .null "Utilisez VICE emu."
gs1k           .null "ou cartouche type"
gs1l           .null "Penultimate+,+2,+3"
gs1m           .null "voir:"
gs1n           .null "www.tfw8b.com/shop"

gs1vect   .word     hsvide,gs1a,hsvide
          .word     gs1b,gs1c,gs1d,hsvide
          .word     gs1e,gs1g,gs1h,hsvide
          .word     gs1i,hsvide,gs1j
          .word     gs1k,gs1l,gs1m,gs1n,$ffff

;Auteur         .null "Adaptation Vic20: Mars 2026, Daniel Lafrance, 3RV, Quebec, Canada"