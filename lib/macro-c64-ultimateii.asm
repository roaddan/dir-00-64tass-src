uiimacsndcmd   .macro pointer
               jsr  push
               ldx  #<\pointer
               ldy  #>\pointer
               jsr  uiifsndcmd
               jsr  pull
               .endm