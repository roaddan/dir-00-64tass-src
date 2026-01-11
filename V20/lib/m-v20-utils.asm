;--------------------------------------
; Scripteur ......: Daniel Lafrance
;                 : Québec, Canada.
; Nom du fichier .: m-v20-utils.asm
; Version.........: 0.0.1
; Dernière m.à j. : 20260110
;--------------------------------------
; Enable character case change with 
; [C=]+[SHIFT]
;--------------------------------------
enable         .macro
               php
               pha
               lda  #$09
               jsr  $ffd2
               pla
               plp
               .endm
;--------------------------------------
loadxymem      .macro xyadd
               php
               ldx  \xyadd
               ldy  \xyadd+1
               plp
               .endm
;--------------------------------------
loadxyimm      .macro xyimm
               php
               ldx  #>\xyimm
               ldy  #<\xyimm
               plp
               .endm
;--------------------------------------
; Disable character case chamge with 
; [C=]+[SHIFT]
;--------------------------------------
disable        .macro
               php
               pha
               lda  #$08
               jsr  $ffd2
               pla
               plp
               .endm

;--------------------------------------
; Select lowercase character set.
;--------------------------------------
tolower        .macro
               php
               pha
               lda  #14
               jsr  $ffd2
               pla
               plp
               .endm
;--------------------------------------
; Select UPPERCASE character set.
;--------------------------------------
toupper        .macro
               php
               pha
               lda  #b_uppercase
               jsr  $ffd2
               pla
               plp
               .endm
;--------------------------------------
lowercase      .macro
               php
               pha
               lda  #14
               sta  characterset
               jsr  $ffd2
               pla
               plp
               .endm
;--------------------------------------               
uppercase      .macro
               php
               pha
               lda  #b_uppercase
               sta  characterset
               jsr  $ffd2
               pla
               plp
               .endm
;--------------------------------------
changebord     .macro c
               pha
               lda  #\c
               sta  $d020
               pla
               .endm
;--------------------------------------
changeback     .macro c
               pha
               lda  #\c
               sta  $d021
               pla
               .endm
;--------------------------------------
c64color       .macro
               jsr  pushreg
               #changebord cbleupale
               #changeback cbleu
               #color cbleupale
               jsr  popreg
               .endm
;--------------------------------------
mycolor        .macro
               jsr  pushreg
               #changebord cvert
               #changeback cbleu
               #color cblanc
               jsr  popreg
               .endm
;--------------------------------------
c64col         .macro
               jsr  pushreg
               #changebord cbleupale
               #changeback cbleu
               #color cblanc
               jsr  popreg
               .endm
;--------------------------------------
v20col         .macro
               jsr  pushreg
               #changebord ccyan
               #changeback cblanc
               #color cbleu
               jsr  popreg
               .endm
;--------------------------------------
graycolor      .macro
               jsr  pushreg
               #changebord cgrismoyen
               #changeback cgrisfonce
               #color cgrispale
               jsr  popreg
               .endm
;--------------------------------------
setzpage1      .macro addr
               pha
               lda  \addr
               sta  $fb
               lda  \addr+1
               sta  $fc
               pla
               .endm
;--------------------------------------
setzpage2      .macro addr
               pha
               lda  \addr
               sta  $fd
               lda  \addr+1
               sta  $fe
               pla
               .endm
;--------------------------------------
scrcolors      .macro fg, bg         
               pha
               lda #(\bg*16+(\fg|8))
               sta  vicscrbrd
               pla
               .endm
;--------------------------------------
color          .macro    col
               pha
               lda  #\col
               sta  bascol
               pla
               .endm
;--------------------------------------
print          .macro strptr
               jsr  pushreg
               ldx  #<\strptr
               ldy  #>\strptr
               jsr  puts
               jsr  popreg
               .endm
;--------------------------------------
println        .macro strptr
               jsr  pushreg
               ldx  #<\strptr
               ldy  #>\strptr
               jsr  puts
               lda  #$0d
               jsr  putch
               jsr  popreg
               .endm
;--------------------------------------
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
;--------------------------------------
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
;--------------------------------------
printxy        .macro strptr
               jsr  pushreg
               ldx  #<\strptr 
               ldy  #>\strptr
               jsr  putsxy
               jsr  popreg
               .endm
;--------------------------------------
printcxy       .macro strptr
               jsr  pushreg
               ldx  #<\strptr 
               ldy  #>\strptr
               jsr  putscxy
               jsr  popreg
               .endm
;--------------------------------------
printfmt       .macro prefix, strptr
               jsr  pushreg
               lda  #\prefix
               jsr  putch
               #print \strptr
               jsr  popreg
               .endm
;--------------------------------------
printpos       .macro x,y,strptr
               jsr  pushreg
               #locate \x,\y
               #print \strptr
               jsr  popreg
               .endm

;--------------------------------------
printfmtxy     .macro x,y,prefix,strptr
               jsr  pushreg
               #locate \x,\y
               #printfmt \prefix,\strptr
               jsr  popreg
               .endm
;--------------------------------------
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

;--------------------------------------
; fichier......: m-utils.asm (seq)
; type fichier.: macros
; auteur.......: daniel lafrance
; version......: 0.0.1
; revision.....: 20151126
;--------------------------------------
; Affichage d'un caractere par kernal
;--------------------------------------
outcar  .macro carno
        php
        pha
        lda #\carno
        jsr chrout
        pla
        plp
        .endm        
;--------------------------------------
; Affiche une chaine par le kernal
;--------------------------------------
outstr  .macro string
        jsr pushregs
        ldy #>\string+1
        ldx #<\string
        jsr putsyx
        jsr popregs
        .endm
;--------------------------------------
; Affiche une chaine par le kernal
;--------------------------------------
outstrxy  .macro string
        jsr pushregs
        ldx \string
        ldy \string+1
        jsr gotoxy
        ldy #>\string+2
        ldx #<\string+2
        jsr putsyx
        jsr popregs
        .endm
;--------------------------------------
; charge le contenu du ptr dans $YYXX
;--------------------------------------
ldyxptr .macro pointeur
        php
        ldy \pointeur+1
        ldx \pointeur
        plp
        .endm
;--------------------------------------
; charge le contenu du ptr dans $YYXX
;--------------------------------------
styxptr .macro pointeur
        php
        sty \pointeur+1
        stx \pointeur
        plp
        .endm
;--------------------------------------
; charge la valeur 16 bits dans $yyxx
;--------------------------------------
ldyximm .macro immval
        php
        ldy #>\immval
        ldx #<\immval
        plp
        .endm
;--------------------------------------
; Macros pour peupler AAXX.
;--------------------------------------
loadaxmem .macro axadd
        php
        ldx  \axadd   ;lsb adr dans X.
        lda  \axadd+1 ;msb adr dans A.
        plp
        .endm
loadaximm .macro aximm
         php
         ldx  #<\aximm ;LSB val dans x.
         lda  #>\aximm ;MSB val dans a.
         plp
         .endm
;--------------------------------------
; charge un pointeur dans zpage1
;--------------------------------------
ptrtozp1 .macro immval
        jsr pushregs
        ldy #>\immval
        ldx #<\immval
        sty zp1+1
        stx zp1
        jsr popregs
        .endm
;--------------------------------------
; charge un pointeur dans zpage2
;--------------------------------------
ptrtozp2 .macro immval
        jsr pushregs
        ldy #>\immval
        ldx #<\immval
        sty zp2+1
        stx zp2
        jsr popregs
        .endm
;--------------------------------------
; Deplace le curseur a la position 
; (x,y).
;--------------------------------------
locate  .macro x,y
        jsr pushregs
        ldy #\x
        ldx #\y
        clc
        jsr plot
        jsr popregs
        .endm
;--------------------------------------
mpushr  .macro
        php
        pha
        txa
        pha
        tya
        pha
        .endm
;--------------------------------------
mpopr   .macro
        pla
        tay
        pla
        tax
        pla
        plp
        .endm        
;--------------------------------------
setloop .macro lcount
        pha
        lda  #<\lcount
        sta  loopcount
        lda  #>\lcount
        sta  loopcount+1
        pla
        .endm
;--------------------------------------