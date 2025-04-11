; ------------------------------------------------------------------------------
; Enable character case chamge with [C=]+[SHIFT]
; ------------------------------------------------------------------------------
enable         .macro
               php
               pha
               lda  #$09
               jsr  $ffd2
               pla
               plp
               .endm

setloop        .macro lcount
               pha
               lda  #<\lcount
               sta  loopcount
               lda  #>\lcount
               sta  loopcount+1
               pla
               .endm


loadxy         .macro location
               php
               ldx  \location
               ldy  \location+1
               plp
               .endm

; ------------------------------------------------------------------------------
; Disable character case chamge with [C=]+[SHIFT]
; ------------------------------------------------------------------------------
disable        .macro
               php
               pha
               lda  #$08
               jsr  $ffd2
               pla
               plp
               .endm

; ------------------------------------------------------------------------------
; Select lowercase character set.
; ------------------------------------------------------------------------------
tolower        .macro
               php
               pha
               lda  #14
               jsr  $ffd2
               pla
               plp
               .endm

; ------------------------------------------------------------------------------
; Select UPPERCASE character set.
; ------------------------------------------------------------------------------
toupper        .macro
               php
               pha
               lda  #b_uppercase
               jsr  $ffd2
               pla
               plp
               .endm

lowercase      .macro
               php
               pha
               lda  #14
               sta  characterset
               jsr  $ffd2
               pla
               plp
               .endm
               
uppercase      .macro
               php
               pha
               lda  #b_uppercase
               sta  characterset
               jsr  $ffd2
               pla
               plp
               .endm

changebord     .macro c
               pha
               lda  #\c
               sta  $d020
               pla
               .endm

changeback     .macro c
               pha
               lda  #\c
               sta  $d021
               pla
               .endm

c64color       .macro
               jsr  push
               #changebord cbleupale
               #changeback cbleu
               #color cbleupale
               jsr  pull
               .endm

mycolor        .macro
               jsr  push
               #changebord cvert
               #changeback cbleu
               #color cblanc
               jsr  pull
               .endm

c64col         .macro
               jsr  push
               #changebord cbleupale
               #changeback cbleu
               #color cbleupale
               jsr  pull
               .endm

v20col         .macro
               jsr  push
               #changebord ccyan
               #changeback cblanc
               #color cbleu
               jsr  pull
               .endm

graycolor      .macro
               jsr  push
               #changebord cgrismoyen
               #changeback cgrisfonce
               #color cgrispale
               jsr  pull
               .endm

setzpage1      .macro addr
               pha
               lda  \addr
               sta  $fb
               lda  \addr+1
               sta  $fc
               pla
               .endm

setzpage2      .macro addr
               pha
               lda  \addr
               sta  $fd
               lda  \addr+1
               sta  $fe
               pla
               .endm

locate         .macro x,y
               jsr  push
               ldx  #\x
               ldy  #\y
               jsr  gotoxy
               jsr  pop
               .endm

scrcolors      .macro fg, bg         
               pha
               lda #(\bg*16+(\fg|8))
               sta  vicscrbrd
               pla
               .endm

color          .macro    col
               pha
               lda  #\col
               sta  bascol
               pla
               .endm

print          .macro pointer
               jsr  push
               ldx  #<\pointer
               ldy  #>\pointer
               jsr  puts
               jsr  pull
               .endm

println        .macro pointer
               jsr  push
               ldx  #<\pointer
               ldy  #>\pointer
               jsr  puts
               lda  #$0d
               jsr  putch
               jsr  pull
               .endm

printxy        .macro pointer
               jsr  push
               ldx  #<\pointer 
               ldy  #>\pointer
               jsr  putsxy
               jsr  pull
               .endm

printcxy       .macro pointer
               jsr  push
               ldx  #<\pointer 
               ldy  #>\pointer
               jsr  putscxy
               jsr  pull
               .endm

printfmt       .macro prefix, pointer
               jsr  push
               lda  #\prefix
               jsr  putch
               #print \pointer
               jsr  pull
               .endm

printpos       .macro x,y,pointer
               jsr  push
               #locate \x,\y
               #print \pointer
               jsr  pull
               .endm


printfmtxy     .macro x,y,prefix,pointer
               jsr  push
               #locate \x,\y
               #printfmt \prefix,\pointer
               jsr  pull
               .endm

printwordbin   .macro adresse
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

