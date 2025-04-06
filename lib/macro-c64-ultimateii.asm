uiimacsndcmd   .macro pointer
               jsr  push
               ldx  #<\pointer
               ldy  #>\pointer
               jsr  uiisndcmd
               jsr  pull
               .endm