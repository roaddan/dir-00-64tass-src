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
