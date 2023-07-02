screendis      .block
               php
               pha
               lda  $d011
               and  #%11101111
               sta  $d011
               pla
               plp
               rts
               .bend

screenena      .block
               php
               pha
               lda  $d011
               ora  #%00010000
               sta  $d011
               pla
               plp
               rts
               .bend
