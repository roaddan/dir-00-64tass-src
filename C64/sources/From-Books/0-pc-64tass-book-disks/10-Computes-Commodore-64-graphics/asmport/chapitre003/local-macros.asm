poke           .macro addr,val
               lda   #\val
               sta   \addr
               .endm
            