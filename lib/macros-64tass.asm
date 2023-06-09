
locate          .macro x,y
                jsr push
                ldx  #\x
                ldy  #\y
                jsr  gotoxy
                jsr pop
                .endm

scrcolors       .macro fg, bg         
                pha
                lda #(\bg*16+(\fg|8))
                sta  vicscrbrd
                pla
                .endm

color           .macro    col
                pha
                lda  #\col
                sta  bascol
                pla
                .endm

print           .macro pointer
                ldx  #<\pointer
                ldy  #>\pointer
                jsr  puts
                .endm

println         .macro pointer
                ldx  #<\pointer
                ldy  #>\pointer
                jsr  puts
                lda  #$0d
                jsr  putch
                .endm

printxy        .macro pointer
                ldx #<\pointer 
                ldy #>\pointer
                jsr putsxy
                .endm

printcxy        .macro pointer
                ldx #<\pointer 
                ldy #>\pointer
                jsr putscxy
                .endm

printfmt        .macro prefix, pointer
                lda  #\prefix
                jsr  putch
                #print \pointer
                .endm

printpos        .macro x,y,pointer
                #locate \x,\y
                #print \pointer
                .endm


printfmtxy      .macro x,y,prefix,pointer
                #locate \x,\y
                #printfmt \prefix,\pointer
                .endm

printwordbin    .macro adresse
                jsr  push
                lda  #<\adresse
                sta  $fb
                lda  #>\adresse
                sta  $fb+1
                ldy  #$01 
                lda  ($fb),y
                jsr  atobin
                #printfmt "%", abin
                dey
                lda  ($fb),y
                jsr  atobin
                #print abin
                jsr  pop
                .endm
