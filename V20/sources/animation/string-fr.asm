;-----------------------------------------------------------------------------
; message table; last character has high bit set
;-----------------------------------------------------------------------------
TITLELINE=0
BINLINE=6
BINCOLM=6
XVAL=$10
XCPX=$40
DIFF=$03

string1   .byte     1,TITLELINE
          .null     "Essais Mathematiques"
string2   .byte     BINCOLM-5,BINLINE-3 
          .null     "flags:nv-bdizc"
string3   .byte     1,22
          .null     "par: Daniel Lafrance"
string4   .byte     BINCOLM+9,BINLINE+1 
          .null     "(   )"
string5   .byte     BINCOLM+1,BINLINE-2
          .byte     94,94,94,94,94,94,94,94,0
string6   .byte     BINCOLM+1,BINLINE-1
          .byte     125,125,125,125,125,125,125,125,0
string7   .byte     BINCOLM,BINLINE+3 
          .null     "x=$   cpx #$"  
string8   .byte     BINCOLM,BINLINE+5 
          .null     "$   - $   = $"  
