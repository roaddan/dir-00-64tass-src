affichemesg    .macro msgptr
               jsr  push
               ldx  #<blankmsg
               ldy  #>blankmsg
               jsr  putscxy
               ldx  #<\msgptr
               ldy  #>\msgptr
               jsr  putscxy
               jsr  pop
               .endm

flashfkey      .macro fkeyptr
               php
               pha
               txa
               pha
               lda  \fkeyptr
               pha
               lda  #146
               sta  \fkeyptr+15
               lda  #flashcol
               sta  \fkeyptr
               ldx  #<\fkeyptr
               ldy  #>\fkeyptr
               jsr  putscxy
               jsr  delay
               lda  #18
               sta  \fkeyptr+15
               pla
               sta  \fkeyptr
               ldx  #<\fkeyptr
               ldy  #>\fkeyptr
               jsr  putscxy
               pla
               tax
               pla
               plp
               .endm

pushall        .macro
               jsr  push
               .endm
popall         .macro
               jsr  pop
               .endm