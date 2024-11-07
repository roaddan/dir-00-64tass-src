;-------------------------------------------------------------------------------
           Version = "20241105-205257"
;-------------------------------------------------------------------------------           
;          .include    "header-c64.asm"
          .include    "macros-64tass.asm"

          .enc      none
;-------------------------------------------------------------------------------           
; ********************************* Page 046 ***********************************
;-------------------------------------------------------------------------------
; New commands for basic:
;    Two-byte token version allowing possible 255 new commands. 
; Commodore 64 version.
; 
; Comments indicate changes needes for VIC-20 version.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Equates for the Commodore 64
;-------------------------------------------------------------------------------
ntok      =    $a57c
nlst      =    $a724
ochr      =    $ab47
lret1     =    $a6ef
lret2     =    $a6f3
; ********************************* Page 047 ***********************************
nstt      =    $a7ae
ncmd      =    $a7e7
evalp     =    $aef1
nchk      =    $ad8d
nfnc      =    $ae8d
eval      =    $ad9e
f1tx      =    $b7a1
syntax    =    $af08
breg      =    $d020
sreg      =    $d021
kreg      =    $028a
cstrt     =    $e394
rvect     =    $e453
f1t57     =    $bbca
intf1     =    $bccc
subf1     =    $b850
chklp     =    $aefa
chkcm     =    $aefd
chkrp     =    $aef7
f1div     =    $bb0f
nerr      =    $a43a
errcnt    =    $a447
ready     =    $a474
;-------------------------------------------------------------------------------
; Equates for the VIC-20
;-------------------------------------------------------------------------------
;ntok      =    $c57c
;nlst      =    $c724
;ochr      =    $cb47
;lret1     =    $c6ef
;lret2     =    $c6f3
;nstt      =    $c7ae
;ncmd      =    $c7e7
;evalp     =    $cef1
;nchk      =    $cd8d
;nfnc      =    $ce8d
;eval      =    $cd9e
;f1tx      =    $b7a1
;syntax    =    $cf08
;breg      =    $900f
;sreg      =    $900f
;kreg      =    $028a
;cstrt     =    $e378
;rvect     =    $e45b
;f1t57     =    $dbca
;intf1     =    $dccc
;subf1     =    $d850
;chklp     =    $cefa
;; ********************************* Page 48 ***********************************
;chkcm     =    $cefd
;chkrp     =    $cef7
;f1div     =    $db0f
;nerr      =    $c43a
;errcnt    =    $c447
;ready     =    $c474
;-------------------------------------------------------------------------------
; Starting location of command package on the C-64 is $c000 (49152).
; Starting location of command package on the VIC-20 is $6200 (25088).
; Origin for the commodore 64.
          *=$c000
; Origin for the commodore VIC-20.
;          *=$6200
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Setup vectors to new routines.
; To change vectors:
;    for Commodore 64    - sys 49162
;    for VIC-20          - sys 25098
;-------------------------------------------------------------------------------
; On the VIC-20 only :
;    Run the following Basic program to reserve memory for command package at 
;    top of memory.
;    If you change the starting location of your VIC commands package, then modify 
;    the pokes to 781 and 782 accordingly. 
;    The following program resets the top of memory for basic to $5fff.
;
;         POKE 783,0     :REM CLEAR THE CARRY
;         POKE 781,255   :REM X-REG TO $FF
;         POKE 782,95    :REM Y-REG TO $5F
;         SYS 65433      :REM TO DO MEMTOP
;         SYS 58232      :REM BASIC CLOD START
;-------------------------------------------------------------------------------
; ********************************* Page 49 ************************************
errx      =    $9100
tokx      =    $9200
listx     =    $9300
comx      =    $9400
funcx     =    $9500

errv      .word     errx
tokv      .word     tokx
lstv      .word     listx
comv      .word     comx
fncv      .word     funcx
;-------------------------------------------------------------------------------
          sei
          lda  errv
          sta  $3000     ; ($3000) =
          lda  errv+1    ; Error message vector
          sta  $0301     ; 
          lda  tokv
          sta  $0304     ; ($0304) =
          lda  tokv+1    ; Tokenization vector
          sta  $0305     ;
          lda  lstv
          sta  $0306     ; ($0306) =
          lda  lstv+1    ; List tokens vector
          sta  $0307     ;
          lda  comv
          sta  $0308     ; ($0308) =
          lda  comv+1    ; Command vector
          sta  $0309     ;
          lda  fncv
          sta  $030a     ; ($030a) =
          lda  fncv+1    ; Function vector
          sta  $030b     ;
;-------------------------------------------------------------------------------
; Table of new keywords
;
; No abbreviations (with shifted key) permitted because normal tokenization 
; throws away bytes >= $#80.
;
; Basic keywords embedded in new commands only permitted on C-64 if normal 
; tokenization routine is modified. See "modtok" routine for method. 
;
; With the two byte tokens used the first token is allways $60 while the value 
; for the second is shown following the command or function name below.
;
; ********************************* Page 50 ************************************
;
; Many commands are not actually implemented - they are listed here to provide 
; a framework you can build on.
;
; The new keywords must be listed in the order of:
;         1) New commands.
;         2) New function with one argument.
;         3) New function with two or more arguments.
;
; NOTE: Note that tokens begin with $01 - not with $00.
;-------------------------------------------------------------------------------
adrtok    .word     toktab
toktab    .text     "ADUM"
          .byte     $d0       ; ADUMP   $01
          .text     "APPN"
          .byte     $c4       ; APPND   $02
; 'AUTON' - Embeded keyword 'TO'
          .text     "AUTO"
          .byte     $ce       ; AUTON   $03
          .text     "BO"
          .byte     $d8       ; BOX     $04
          .text     "CAS"
          .byte     $c5       ; CASE    $05
          .text     "CHANG"
          .byte     $c5       ; CHANGE  $06
          .text     "CIRCL"
          .byte     $c5       ; CIRCLE  $07
          .text     "COLLID"
          .byte     $c5       ; COLLIDE $08
          .text     "COMG"
          .byte     $d4       ; COMGT   $09
          .text     "COP"
          .byte     $d9       ; COPY    $0a
          .text     "DE"
          .byte     $cc       ; DEL     $0b
          .text     "DLA"
          .byte     $d9       ; DLAY    $0c
          .text     "DRA"
          .byte     $d7       ; DRAW    $0d
          .text     "DUM"
          .byte     $d0       ; DUMP    $0e
          .text     "ERAS"
          .byte     $c5       ; erase   $0f
; ********************************* Page 051 ************************************
          .text     "GFIN"
          .byte     $c4       ; GFIND   $12
          .text     "HEL"
          .byte     $d0       ; HELP    $13
          .text     "HIME"
          .byte     $cd       ; HIMEM   $14
          .text     "HIRE"
          .byte     $d3       ; HIRES   $15
          .text     "HPE"
          .byte     $ce       ; HPEN    $16
          .text     "HTA"
          .byte     $c2       ; HTAB    $17
          .text     "INSER"
          .byte     $d4       ; INSERT  $18
          .text     "LABE"
          .byte     $cc       ; LABEL   $19
          .text     "LIN"
          .byte     $c5       ; LINE    $1a
          .text     "LOME"
          .byte     $cd       ; LOMEM   $1b
          .text     "MERG"
          .byte     $c5       ; MERGE   $1c
          .text     "MO"
          .byte     $c4       ; MOD     $1d
          .text     "MOV"
          .byte     $c5       ; MOVE    $1e
          .text     "TAPE"
          .byte     $cd       ; TAPEM   $1f
          .text     "MULTI"
          .byte     $c3       ; MULTIC  $20
          .text     "OL"
          .byte     $c4       ; OLD     $21
; 'PAINTR' - Embeded keyword 'INT'
          .text     "PAINT"
          .byte     $d2       ; PAINTR  $22
          .text     "PFKE"
          .byte     $d9       ; PFKEY   $23
; 'POINTR' - Embeded keyword 'INT'
          .text     "POINT"
          .byte     $d2       ; POINTR  $24
          .text     "PO"
          .byte     $d0       ; POP     $25
          .text     "PRO"
          .byte     $c3       ; PROC    $26
          .text     "PRTUSN"
          .byte     $c7       ; PRTUSNG $27
          .text     "RENU"
          .byte     $cd       ; RENUM   $28
          .text     "REPEA"
; ********************************* Page 52 ************************************
          .byte     $d4       ; REPEAT  $29
          .text     "RLS"
          .byte     $d4       ; RLST    $2A
          .text     "SE"
          .byte     $d4       ; SET     $2B
          .text     "SINGL"
          .byte     $c5       ; SINGLE  $2C
          .text     "SPRITE"
          .byte     $c3       ; SPRITEC $2D
          .text     "SPRITE"
          .byte     $c4       ; SPRITED $2E
          .text     "SpRITE"
          .byte     $cd       ; SPRITEM $2F
          .text     "SR"
          .byte     $d4       ; SRT     $30
          .text     "TRAC"
          .byte     $c5       ; TRACE   $31
          .text     "UNLS"
          .byte     $d4       ; UNLST   $32
          .text     "UNN"
          .byte     $d7       ; UNNW    $33
          .text     "VDUM"
          .byte     $d0       ; VDUMP   $34
          .text     "VPE"
          .byte     $ce       ; VPEN    $35
          .text     "VTA"
          .byte     $c2       ; VTAB    $36
          .text     "WHIL"
          .byte     $c5       ; WHILE   $37
          .text     "COL"
          .byte     $c4       ; COLD    $38
          .text     "BRD"
          .byte     $d2       ; BRDR    $39
          .text     "SCREE"
          .byte     $ce       ; SCREEN  $3A
          .text     "VBAC"
          .byte     $cb       ; VBACK   $3B
          .text     "KEY"
          .byte     $d3       ; KEYS    $3C
          .text     "FRA"
          .byte     $c3       ; FRAC    $3D
          .text     "JO"
          .byte     $d9       ; JOY     $3E
          .text     "PEN"
          .byte     $d8       ; PENX    $3F
          .text     "PEN"
          .byte     $d9       ; PENY    $40
          .text     "DI"
          .byte     $d6       ; DIV     $41
; ********************************* Page 53 ************************************
          .byte     $00       ; END of keyword list
;-------------------------------------------------------------------------------
; Equates specify where commands end, function begin and end, and which 
; functions only have one argument.
fncone    .byte     $3d  ; Last command Token+1 (or first function token)
twoarg    .byte     $3e  ; First token for functions that needs tow or more 
                         ; arguments.
endfnc    .byte     $42  ; Last token plus one.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Command address table:
;
; Adresses used in the table are one less than actual start of command because 
; the address is pushed onto the stack.
; 
; RTS, witch adds one to the address it pulls, is used to jump to tye actual 
; routine.
;-------------------------------------------------------------------------------
comadr    .word     adump-1
          .word     appnd-1
          .word     auton-1
          .word     box-1
          .word     case-1
          .word     change-1
          .word     circle-1
          .word     collid-1
          .word     comgt-1
          .word     copy-1
          .word     del-1
          .word     dlay-1
          .word     draw-1
          .word     dump-1
          .word     erase-1
          .word     find-1
          .word     gchang-1
          .word     gfind-1
          .word     help-1
          .word     himem-1
          .word     hires-1
; ********************************* Page 54 ************************************          
          .word     hpen-1
          .word     htab-1
          .word     insert-1
          .word     label-1
          .word     line-1
          .word     lomem-1
          .word     merge-1
          .word     mod-1
          .word     mode-1
          .word     tapem-1
          .word     multic-1
          .word     old-1
          .word     paintr-1
          .word     pfkey-1
          .word     pointr-1
          .word     pop-1
          .word     proc-1
          .word     prtusn-1
          .word     renum-1
          .word     repeat-1
          .word     rlst-1
          .word     set-1
          .word     single-1
          .word     spritc-1
          .word     spritd-1
          .word     spritm-1
          .word     srt-1
          .word     trace-1
          .word     unlst-1
          .word     unnw-1
          .word     vdump-1
          .word     vpen-1
          .word     vtab-1
          .word     while-1
          .word     cold-1
          .word     brdr-1
          .word     screen-1
          .word     vback-1
          .word     keys-1
;-------------------------------------------------------------------------------
; Function address table
;-------------------------------------------------------------------------------
fncadr    .word     frac
          .word     joy
          .word     penx
          .word     peny
          .word     div
; ********************************* Page 55 ************************************
;-------------------------------------------------------------------------------
; Table of address of new error messages.
;-------------------------------------------------------------------------------
errtab    .word     err1
;-------------------------------------------------------------------------------
; New error massages
;-------------------------------------------------------------------------------
err1      .text     "INVALID KEY IPTIO"
          .byte     $ce       ; Invalid key option
;-------------------------------------------------------------------------------
; Tokenization routine for new commands
;-------------------------------------------------------------------------------
tokx      jsr  ntok      ; Handle normal tokens.
          ldx  #$00      ; Set input index.
          ldy  #$04      ; Set output index.
          sty  $0f       ; Flag for data token.
charlp    lda  $0200,x   ; Next char from buffer.
          cmp  #$80      ; If already a token.
          bcs  store     ; then skip.
          cmp  #$20      ; Test for space.
          beq  store     ;
          sta  $08       ; Save for possible quote.
          cmp  #$22      ; Is it quote?
          beq  quote     
          bit  $0f       ; See if inside data.
          bvs  store     ; Yes - branch
          cmp  #$30      ; See if numeric.
          bcc  notnum
          cmp  #$3c      ; Branch if number.
          bcc  store     
notnum    lda  adrtok+1
          sta  $fd
          sta  $ff
          sty  $71       ; Save output pointer
          lda  adrtok    ; Set Pointers
          tay            ;   to tokeen table
          dey            ;   in ($fc) and
          sty  $fe       ;   ($fe).
          dey
          sty  $fc
          ldy  #$01
          sty  $0b       ; Init token index.
          dey
          stx  $7a       ; Save input index.
; ********************************* Page 56 ************************************
          dex
nextup    iny            ; Next character in table.
          bne  notinc
          inc  $ff       ; Move to next table.
          inc  $fd       ; Page after 256 bytes
notinc    inx            ; Next character in buffer
notend    lda  $0200,x
          sec
          sbc  ($fe),y
          beq  nextup    ; If buffer and table match.
          cmp  #$80      ; If only high bit off
          bne  nomtch    ; No match
          lda  #$60      ; Two-byte token-lst byte fixed.
          ldy  $71       ; Output index.
          iny
          sta  $01fb,y   ; Store the $60 token.
          inc  $71
          lda  $0b       ; 2nd byte token.
repeet    ldy  $71       ; Reset output index.
store     inx            ; Input index.
          iny            ; Output index.
          sta  $01fb,y   ; Store char.
          lda  $01fb,y
          beq  done      ; If end of buffer.
          sec
          sbc  #$3a      ; See if colon.
          beq  colon
          cmp  #$49      ; See if "DATA" token.
          bne  nodat
colon     sta  $0f       ; Sat data flag to $49 for bvs.
          bne  charlp
nodat     sec
          sbc  #$55      ; See if REM
          bne  charlp
          sta  $08       ; If REM set $00 termiator.
tstend    lda  $0200,x   ; Next char from input buffer.
          beq  store
          cmp  $08       ; = terminator?
          beq  store
;-------------------------------------------------------------------------------
quote     iny            ; Output index.
          sta  $01fb,y   
          inx
          bne  tstend    ; Unconditional.
nomtch    ldx  $7a
          inc  $0b       ; Token coount.
tokadv    iny
; ********************************* Page 057 *********************************** 
          bne  notovr
          inc  $ff       ; Increment Token
          inc  $fd       ; Inchement Table page
notovr    lda  ($fc),y   
          bpl  tokadv    ; Loop intil end-of-token byte.
          lda  ($fe),y
          bne  notend    ; Fall through if $00 end.
          lda  $0200,x   ; END-OF-TABLE.
          bpl  repeet    ; Try next char in buffer
done      sta  $01fd,y
          lda  #$01
          sta  $7b
          lda  #$ff
          sta  $7a
          rts
;-------------------------------------------------------------------------------
; List front-end to handle listing of new keywords through detokenization.
;-------------------------------------------------------------------------------
listx     bmi  onetok    ; One byte token.
          cmp  #$60      ; Double token?
          beq  lsttok    ; Yes - Branch.
          bne  prtone    ; Not a token.
onetok    bit  $0f       ; In quote?
          bmi  prtone
tstnls    cmp  #$ff      ; PI?
          beq  prtone    ; No - do new token.
          jmp  nlst      ; No - do token.
lsttok    lda  adrtok+1  ; Set pointer
          sta  $ff       ;   to token table
          dec  $ff
          lda  adrtok    ;   in ($fe)
          sta  $fe
          iny            ; get second byte of token
          lda  ($5f),y
          sty  $49       ; Save index into line.
          tax
          ldy  #$ff      ; Set index into keyword table.
lloop1    dex            ; If x=0 then
          beq  match     ; Keyword match token.
lloop2    iny
          bne cont1
; ********************************* Page 058 ***********************************           


;-------------------------------------------------------------------------------
; Temporary sub-routine declarations
;-------------------------------------------------------------------------------

adump     .block
          rts
          .bend
appnd     .block
          rts
          .bend
auton     .block
          rts
          .bend
box       .block
          rts
          .bend
case      .block
          rts
          .bend
change    .block
          rts
          .bend
circle    .block
          rts
          .bend
collid    .block
          rts
          .bend
comgt     .block
          rts
          .bend
copy      .block
          rts
          .bend
del       .block
          rts
          .bend
dlay      .block
          rts
          .bend
draw      .block
          rts
          .bend
dump      .block
          rts
          .bend
erase     .block
          rts
          .bend
find      .block
          rts
          .bend
gchang    .block
          rts
          .bend
gfind     .block
          rts
          .bend
help      .block
          rts
          .bend
himem     .block
          rts
          .bend
hires     .block
          rts
          .bend
; ********************************* Page 054          
hpen      .block
          rts
          .bend
htab      .block
          rts
          .bend
insert    .block
          rts
          .bend
label     .block
          rts
          .bend
line      .block
          rts
          .bend
lomem     .block
          rts
          .bend
merge     .block
          rts
          .bend
mod       .block
          rts
          .bend
mode      .block
          rts
          .bend
tapem     .block
          rts
          .bend
multic    .block
          rts
          .bend
old       .block
          rts
          .bend
paintr    .block
          rts
          .bend
pfkey     .block
          rts
          .bend
pointr     .block
          rts
          .bend
pop       .block
          rts
          .bend
proc      .block
          rts
          .bend
prtusn    .block
          rts
          .bend
renum     .block
          rts
          .bend
repeat    .block
          rts
          .bend
rlst      .block
          rts
          .bend
set       .block
          rts
          .bend
single    .block
          rts
          .bend
spritc     .block
          rts
          .bend
spritd    .block
          rts
          .bend
spritm    .block
          rts
          .bend
srt       .block
          rts
          .bend
trace     .block
          rts
          .bend
unlst     .block
          rts
          .bend
unnw      .block
          rts
          .bend
vdump     .block
          rts
          .bend
vpen      .block
          rts
          .bend
vtab      .block
          rts
          .bend
while     .block
          rts
          .bend
cold     .block
          rts
          .bend
brdr      .block
          rts
          .bend
screen    .block
          rts
          .bend
vback     .block
          rts
          .bend
keys      .block
          rts
          .bend
;-------------------------------------------------------------------------------
; Function declarations
;-------------------------------------------------------------------------------
frac      .block
          rts
          .bend
joy       .block
          rts
          .bend
penx      .block
          rts
          .bend
peny      .block
          rts
          .bend
div       .block
          rts
          .bend


;-------------------------------------------------------------------------------
; Je mets les librairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------     
;          .include "toolkitbasic.asm"
;          .include "map-c64-kernal.asm"
;          .include "map-c64-vicii.asm" 
;          .include "map-c64-basic2.asm"
;          .include "lib-c64-basic2.asm"
;;          .include "lib-c64-showregs.asm"
;          .include "lib-cbm-pushpop.asm"
;          .include "lib-cbm-mem.asm"
;          .include "lib-cbm-hex.asm"
;          .include "lib-cbm-keyb.asm"

