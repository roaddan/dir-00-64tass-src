poke           .macro addr,val
               php
               pha
               lda   #\val
               sta   \addr
               pla
               plp
               .endm
peek           .macro addr,val
               lda   \addr
               .endm

incadr16       .macro ptr
               #ldzp1data \ptr
               jsr   inczp1
               #stzp1data \ptr

               .endm