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
               #changebord cbleupale
               #changeback cbleu
               #color cbleupale
               .endm

mycolor        .macro
               #changebord cbleupale
               #changeback cbleu
               #color cblanc
               .endm

c64col         .macro
               #changebord cbleupale
               #changeback cbleu
               #color cbleupale
               .endm

v20col         .macro
               #changebord ccyan
               #changeback cblanc
               #color cbleu
               .endm

graycolor      .macro
               #changebord cgrismoyen
               #changeback cgrisfonce
               #color cgrispale
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
isx            ldx  #<\pointer
isy            ldy  #>\pointer
               jsr  puts
               jsr  pull
               .endm

println        .macro pointer
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

printcxy       .macro pointer
               ldx #<\pointer 
               ldy #>\pointer
               jsr putscxy
               .endm

printfmt       .macro prefix, pointer
               lda  #\prefix
               jsr  putch
               #print \pointer
               .endm

printpos       .macro x,y,pointer
               #locate \x,\y
               #print \pointer
               .endm


printfmtxy     .macro x,y,prefix,pointer
               #locate \x,\y
               #printfmt \prefix,\pointer
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
