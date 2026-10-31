
putmesg       .macro msgptr
               jsr  push
               ldx  #<blankmsg
               ldy  #>blankmsg
               jsr  putscxy
               ldx  #<\msgptr
               ldy  #>\msgptr
               jsr  putscxy
               jsr  pop
               .endm

brkpoint       .macro  char
               jsr   push
               ldx   #0
               ldy   #0
               jsr   plot
               #putmesg  brkmsg
               lda   #\char
               jsr   waitkey
               jsr   pop
               .endm

flashfkey      .macro fkeyptr
               jsr  push
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
               jsr  pop
               .endm
