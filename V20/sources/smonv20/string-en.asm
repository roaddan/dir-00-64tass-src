;-----------------------------------------------------------------------------
; message table; last character has high bit set
;-----------------------------------------------------------------------------
msgbas  =*
msg2      .byte $0d,$20,31,18     ; header for registers
          .text " supermon for vic20 "
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
          .text "!h for help"
          .byte 146,144,0

mneuprfx       .byte $0d,sbleu
               .fill 8,$20
               .byte 0

backspace      .byte 146,144,157,157,32,32,157,157,145,0

hstitle        .byte 18,tleft,31
               .text "  Super-Mon Help  "
               .byte 144,tright,146,0

hsfoot         .byte 18,bleft,146,28
               .text "  Press any key!  "
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
hs1a           .null "[a]ssembler"
hs1b           .null "a ADDR MNEUMO OPER"
hs1c           .null "[d]esassembler"
hs1d           .null "d [start [end]]"
hs1e           .null "[f]ill memory"
hs1f           .null "f start end code"
hs1g           .null "[m]emory v/e"
hs1h           .null "m [start [end]]"
hs1i           .null ">AAAA XX XX ... XX"
hs1j           .null "[r]egsisters v/e"
hs1k           .null "[;]init registers"
hs1l           .null "[g]oto address"
hs1m           .null "g [AAAA] or PC"

hs1vect        .word     hsvide,hs1a,hs1b,hsvide
               .word     hs1c,hs1d,hsvide
               .word     hs1e,hs1f,hsvide
               .word     hs1g,hs1h,hs1i,hsvide
               .word     hs1j,hs1k,hsvide
               .word     hs1l,hs1m,$ffff
    
hs2a           .null "[r]un program"
hs2b           .null "r AAAA"
hs2c           .null "[j]sr sub-routine"
hs2d           .null "j AAAA"
hs2e           .null "[h]unt for bytes"
hs2f           .null "h BBBB EEEE BB..BB"
hs2g           .null "[t]ransfer memory"
hs2h           .null "t BBBB EEEE DDDD"
hs2i           .null "[c]ompare memory"
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

hs3a           .null "[s]ave memory"
hs3b           .text "s"
               .byte 34
               .text "fnam"
               .byte 34
               .null "d,BBBB,EEEE"

hs3c           .null "[l]oad into memory"
hs3d           .text "l"
               .byte 34
               .text "fnam"
               .byte 34
               .null "d,BBBB"

hs3e           .null "[v]erify file/mem"
hs3f           .text "v"
               .byte 34
               .text "fnam"
               .byte 34
               .null "d,BBBB"

hs3g           .null "[@] drive status"
hs3h           .null "[x] Basic warmboot"

hs3vect        .word     hsvide,hs3a,hs3b,hsvide
               .word     hs3c,hs3d,hsvide
               .word     hs3e,hs3f,hsvide
               .word     hs3g,hsvide,hs3h,$ffff

hs4a           .null "   Information"
hs4b           .null "Startup: SYS 40960"
hs4c           .null "v/e = view/edit."
hs4d           .null "d=Drive number."
hs4e           .null "BBBB=Begin Address"
hs4f           .null "EEEE=End Address."
hs4g           .null "DDDD=Dest. Address"
hs4h           .null "BB=Byte."
hs4i           .null "More Commands:."
hs4j           .null "!c=cls,!d=listfile"
hs4k           .null "!g=Credits,!h=help"
hs4l           .null "!m=bit 8 mask togl"
    
hs4vect   .word     hsvide,hs4a,hsvide,hs4c,hsvide
          .word     hs4d,hs4e,hs4f,hs4g,hs4h,hsvide
          .word     hs4i,hsvide,hs4j,hs4k,hs4l,hsvide,hs4b,$ffff

gs1t           .null " SuperMon Credits "
gs1a           .null "Original Version:"
gs1b           .byte sbleu
               .text " SuperMon+64 1985"
               .byte snoir,0
gs1c           .byte srouge
               .text " Jim Butterfield"
               .byte snoir,0
gs1d           .byte srouge
               .text " 1936-2007 R.I.P."
               .byte snoir,0
gs1e           .null "Vic20 port by:"
gs1g           .null " Daniel Lafrance"
;gs1h           .null "github.com/roaddan"
gs1h           .null format("  Look at: $%X",auteur)
gs1i           .null "Uses banks 0 & 5."
gs1j           .null "Use VICE emulator"
gs1k           .null "or cartridge like"
gs1l           .null "Penultimate+,+2,+3"
gs1m           .null "See:"
gs1n           .null "www.tfw8b.com/shop"

gs1vect   .word     hsvide,gs1a,hsvide
          .word     gs1b,gs1c,gs1d,hsvide
          .word     gs1e,gs1g,gs1h,hsvide
          .word     gs1i,hsvide,gs1j
          .word     gs1k,gs1l,gs1m,gs1n,$ffff

auteur         .null "adaptation vic20: mars 2026, daniel lafrance, 3rv, quebec, canada"
github         .null "https://github.com/roaddan/dir-00-64tass-src/tree/main/v20/sources/smonv20"
