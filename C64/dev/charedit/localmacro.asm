
affichemesg    .macro msgptr
               jsr  pushreg
               ldx  #<blankmsg
               ldy  #>blankmsg
               jsr  putscxy
               ldx  #<\msgptr
               ldy  #>\msgptr
               jsr  putscxy
               jsr  popreg
               .endm

flashfkey      .macro fkeyptr
               jsr  pushreg
               lda  \fkeyptr
               pha
               lda  #146
               sta  \fkeyptr+18
               lda  #flashcol
               sta  \fkeyptr
               ldx  #<\fkeyptr
               ldy  #>\fkeyptr
               jsr  putscxy
               jsr  delay
               lda  #18
               sta  \fkeyptr+18
               pla
               sta  \fkeyptr
               ldx  #<\fkeyptr
               ldy  #>\fkeyptr
               jsr  putscxy
               jsr  popreg
               .endm
