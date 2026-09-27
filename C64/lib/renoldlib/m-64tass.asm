;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
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

loadxymem      .macro xyadd
               php
               ldx  \xyadd
               ldy  \xyadd+1
               plp
               .endm

loadxyimm      .macro xyimm
               php
               ldx  #>\xyimm
               ldy  #<\xyimm
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
               jsr  pushreg
               #changebord cbleupale
               #changeback cbleu
               #color cbleupale
               jsr  popreg
               .endm

mycolor        .macro
               jsr  pushreg
               #changebord cvert
               #changeback cbleu
               #color cblanc
               jsr  popreg
               .endm

c64col         .macro
               jsr  pushreg
               #changebord cbleupale
               #changeback cbleu
               #color cblanc
               jsr  popreg
               .endm

v20col         .macro
               jsr  pushreg
               #changebord ccyan
               #changeback cblanc
               #color cbleu
               jsr  popreg
               .endm

graycolor      .macro
               jsr  pushreg
               #changebord cgrismoyen
               #changeback cgrisfonce
               #color cgrispale
               jsr  popreg
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
               jsr  pushreg
               ldx  #\x
               ldy  #\y
               jsr  gotoxy
               jsr  popreg
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

print          .macro strptr
               jsr  pushreg
               ldx  #<\strptr
               ldy  #>\strptr
               jsr  puts
               jsr  popreg
               .endm

println        .macro strptr
               jsr  pushreg
               ldx  #<\strptr
               ldy  #>\strptr
               jsr  puts
               lda  #$0d
               jsr  putch
               jsr  popreg
               .endm

print_xy        .macro x,y,strptr
                jsr  pushreg
                ldy  #\x
                ldx  #\y
                clc
                jsr  plot
                ldx  #<\strptr 
                ldy  #>\strptr
                jsr  puts
                jsr  popreg
                .endm

print_cxy       .macro c,x,y,strptr
                jsr pushreg
                lda bascol
                pha 
                lda #\c
                sta bascol
                ldy #\x
                ldx  #\y
                clc
                jsr  plot
                ldx  #<\strptr 
                ldy  #>\strptr
                jsr  puts
                pla
                sta  bascol
                jsr  popreg
                .endm

printxy        .macro strptr
               jsr  pushreg
               ldx  #<\strptr 
               ldy  #>\strptr
               jsr  putsxy
               jsr  popreg
               .endm

printcxy       .macro strptr
               jsr  pushreg
               ldx  #<\strptr 
               ldy  #>\strptr
               jsr  putscxy
               jsr  popreg
               .endm

printfmt       .macro prefix, strptr
               jsr  pushreg
               lda  #\prefix
               jsr  putch
               #print \strptr
               jsr  popreg
               .endm

printpos       .macro x,y,strptr
               jsr  pushreg
               #locate \x,\y
               #print \strptr
               jsr  popreg
               .endm


printfmtxy     .macro x,y,prefix,strptr
               jsr  pushreg
               #locate \x,\y
               #printfmt \prefix,\strptr
               jsr  popreg
               .endm

printwordbin   .macro adresse
               jsr  pushall
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
               jsr  popall
               .endm

