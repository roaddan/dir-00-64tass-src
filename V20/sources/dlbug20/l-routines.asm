bittest   .block
          jsr  pushregs
          lda  #%00000010
          ldy  #$10
          sta  myflags
retest    dey
          bne  testflg
          jmp  outmain
testflg   lda  myflags
          eor  #%00000010
          sta  myflags
          #outcar '%'
          jsr  putabin
          #outcar ' '
          lda  #%00000010
          bit  myflags
          bne  ison
          beq  isoff
          jmp  retest
ison      #print biton
          jmp retest
isoff     #print bitoff
          jmp retest
          jsr  popregs
          rts
          .bend