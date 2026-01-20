;-------------------------------------------------------------------------------
           Version = "20241105-205257"
;-------------------------------------------------------------------------------           
;          .include    "header-c64.asm"
          .include    "macros-64tass.asm"

          .enc      none
;-------------------------------------------------------------------------------           
; ********************************* Page 65 ************************************
;-------------------------------------------------------------------------------
; New command for Basic
; One-byte token version
; Allowing new tokens $cc - $ce
; Commodore 64 version.
;-------------------------------------------------------------------------------     
;-------------------------------------------------------------------------------
; Equates for the Commodore 64
;-------------------------------------------------------------------------------
ntok      =    $a57c
nlst      =    $a724
ochr      =    $ab47
lret1     =    $a6ef
lret2     =    $a6f3
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
; ********************************* Page 66 ************************************
chkcm     =    $aefd
chkrp     =    $aef7
f1div     =    $bb0f
;-------------------------------------------------------------------------------
; Starting location of command package on the C-64 is $c000 (49152).
; Origin for the commodore 64.
          *=$c000
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Setup vectors to new routines.
; To change vectors:
;    for Commodore 64    - sys 49152
;-------------------------------------------------------------------------------
          sei
          lda  tokv
          sta  $0304          ; ($0304) =
          lda  tokv+1         ; Tokenization vector
          sta  $0305          ;
          lda  lstv
          sta  $0306          ; ($0306) =
          lda  lstv+1         ; List tokens vector
          sta  $0307          ;
          lda  comv
          sta  $0308          ; ($0308) =
          lda  comv+1         ; Command vector
          sta  $0309          ;
          lda  fncv
          sta  $030a          ; ($030a) =
          lda  fncv+1         ; Function vector
          sta  $030b          ;
          cli
          rts
;-------------------------------------------------------------------------------
tokv      .word     newtok
lstv      .word     newlst
comv      .word     newcom
fncv      .word     newfnc
;-------------------------------------------------------------------------------
; Table of new keywords
;
; No abbreviations (with shifted key) permitted because normal tokenization 
; throws away bytes >= $#80.
;
; Note: As currently constructed the program allows a maximum number of 
;       characters in token table of 255 since 8-bit regieter is used to index 
; ********************************* Page 67 ************************************
;       through table
;-------------------------------------------------------------------------------
; Token table.
;-------------------------------------------------------------------------------
toktab    .text     "COL"
          .byte     $c4            ; COLD    $cc
          .text     "BRD"
          .byte     $d2            ; BRDR    $ce
          .text     "SCREE"
          .byte     $ce            ; SCREEN  $cd
          .text     "VBAC"
          .byte     $cb            ; VBACK   $cf
          .text     "KEY"
          .byte     $d3            ; KEYS    $d0
          .text     "FRA"
          .byte     $c3            ; FRAC    $d1
          .text     "DI"
          .byte     $d6            ; DIV     $d2
          .byte     $00            ; END of keyword list
;-------------------------------------------------------------------------------
; Equates specify where commands end, function begin and end, and which 
; functions only have one argument.
fncone    .byte     $d1      ; Last command Token+1 (or first function token)
twoarg    .byte     $3e      ; First token for functions that needs tow or more 
                             ; arguments.
endfnc    .byte     $42      ; Last token plus one.
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
comadr    .word     cold-1
          .word     brdr-1
          .word     screen-1
          .word     vback-1
          .word     keys-1
;-------------------------------------------------------------------------------
; Function address table
;-------------------------------------------------------------------------------
fncadr    .word     frac
          .word     div
;-------------------------------------------------------------------------------
; Tokenization routine for new commands
;-------------------------------------------------------------------------------
; ********************************* Page 68 ************************************
newtok    jsr  ntok           ; Handle normal tokens.
          ldx  #$00           ; Set input index.
          ldy  #$04           ; Set output index.
          sty  $0f            ; Flag for data token.
charlp    lda  $0200,x        ; Next char from buffer.
          cmp  #$80           ; If already a token.
          bcs  store          ; then skip.
          cmp  #$20           ; Test for space.
          beq  store          ;
          sta  $08            ; Save for possible quote.
          cmp  #$22           ; Is it quote?
          beq  quote     
          bit  $0f            ; See if inside data.
          bvs  store          ; Yes - branch
          cmp  #$30           ; See if numeric.
          bcc  notnum
          cmp  #$3c           ; Branch if number.
          bcc  store     
notnum    sty  $71            ; Save output pointer
          ldy  #$00
          sty  $0b
          dey
          stx  $7a
          dex
nextup    iny                 ; Next character in table.
          inx
notend    lda  $0200,x
          sec
          sbc  toktab,y
          beq  nextup         ; If buffer and table match.
          cmp  #$80           ; If only high bit off
          bne  nomtch         ; No match
          lda  #$0b           ; Token value.
          clc
          adc  #$cc           ; Add start address to expanded tokens.
repeat    ldy  $71            ; Reset output index.
store     inx                 ; Input index.
          iny                 ; Output index.
          sta  $01fb,y        ; Store char.
          lda  $01fb,y
          beq  done           ; If end of buffer.
          sec
          sbc  #$3a           ; See if colon.
          beq  colon
          cmp  #$49           ; See if "DATA" token.
          bne  notdat
colon     sta  $0f            ; Sat data flag to $49 for bvs.
          bne  charlp
; ********************************* Page 69 ************************************
notdat     sec
          sbc  #$55           ; See if REM
          bne  charlp
          sta  $08            ; If REM set $00 termiator.
tstend    lda  $0200,x        ; Next char from input buffer.
          beq  store
          cmp  $08            ; = terminator?
          beq  store
;-------------------------------------------------------------------------------
quote     iny                 ; Output index.
          sta  $01fb,y   
          inx
          bne  tstend         ; Unconditional.
nomtch    ldx  $7a
          inc  $0b            ; Token count.
tokadv    iny
          lda  toktab-1,y
          bpl  tokadv
          lda  toktab,y
          bne  notend
          lda  $0200,x        ; end-of-table
          bpl  repeat
done      sta  $01fd,y
          lda  #$01
          sta  $7b
          lda  #$ff
          sta  $7a
          rts
;-------------------------------------------------------------------------------
; List front-end to handle listing of new keywords through detokenization.
;-------------------------------------------------------------------------------
newlst    bpl  prtone
          cmp  #$ff           ; PI?
          beq  prtone         ; No - do new token.
          bit  $0f            ; In quote ?
          bmi  prtone
          cmp  #$cc           ; Less than command?
; ********************************* Page 70 ************************************           
          bcs  lsttok         ; Yes if >= $cc
          jmp  nlst           ; no - do normal list detokenization.
lsttok    sec
          sbc  #$cb           ; #$cc = 1, $cd = 2, etc.
          tax
          sty  $49            ; Save index into line.
          ldy  #$ff           ; Set index into keyword table.
lloop1    dex                 ; If x=0 then
          beq  match          ; Keyword match token.
lloop2    iny
          lda  toktab,y       ; Next keyword char.
          bpl  lloop2         ; Same keyword.
          bmi  lloop1         ; End of keyword.
match     iny
          lda  toktab,y       ; Get keyword char.
          bne  cont2
          inc  $ff
cont2     lda  ($fe),y        ; Get a keyword char.
          bmi  endtok         ; Last char of token.
          jsr  ochr           ; Output all chars except last.
          bne  match          ; Unconditional.
endtok    jmp  lret1          ; Back to list.
prtone    jmp  lret2          ; Back to list.
;-------------------------------------------------------------------------------
; New command execution.
;-------------------------------------------------------------------------------
newcom    jsr  $0073          ; Chrget
          php
          cmp  #$cc           ; Less than command?
          bne  nrmxeq
          cmp  fncone         ; Greater than command?
          bcs  nrmxeq
          plp
          jsr  cmdnew
          jmp  nstt
;-------------------------------------------------------------------------------
cmdnew    sec
          sbc  #$cc
          asl
          tay
          lda  comadr+1,y
          pha
          lda  comadr,y
          pha
          jmp  $0073
;-------------------------------------------------------------------------------
; ********************************* Page 71 ************************************
nrmxeq    plp
          jmp  ncmd           ; Normal Commands           
;-------------------------------------------------------------------------------
; New function execution.
;-------------------------------------------------------------------------------
newfnc    lda  #$00
          sta  $0d            ; Indicate numeric result.
          jsr  $0073
          php
          cmp  fncone         ; Valid function
          bcc  nrmfnc         ;   token?
          cmp  endfnc         ;   for 2nd byte.
          bcs  nrmfnc
          plp
          pha
          cmp  twoarg         ; See if one-arg function.
          bcs  mltarg         ; No - branch
          jsr  $0073          ; Chrget the "(".
          jsr  evalp          ; Eval expression in parens
mltarg    pla                 ; Get index into
          sec                 ;   function
          sbc  fncone         ;   address table.
          asl
          tay
          lda  fncadr,y       ; Set up to
          sta  $55            ;   execute like
          lda  fncadr+1,y     ;   normal function.
          sta  $56
          jsr  $0054
          jmp  nchk           ; Check for numeric result
;-------------------------------------------------------------------------------
nrmfnc    plp
          jmp  nfnc           ; Normal Function
;-------------------------------------------------------------------------------
; Screen - Set screen background colour (C-64 Version)
;-------------------------------------------------------------------------------
screen    jsr  eval           ; Eval expression.
          jsr  f1tx           ; Convert FAC1 to X-reg 0-255.
          cpx  #$10           ; Valid Colour?
          bcs  syner1
          stx  sreg
; ********************************* Page 72 ************************************ 
          rts
syner1    jmp  syntax         ; Syntax error.
;-------------------------------------------------------------------------------
; Cold
;-------------------------------------------------------------------------------
cold      jmp  cstrt
;-------------------------------------------------------------------------------
; brdr - set border colour (C-64 Version)
;-------------------------------------------------------------------------------
brdr      jsr  eval           ; Eval expression.
          jsr  f1tx           ; Convert FAC1 to X-reg 0-255.
          cpx  #$10           ; Valid Colour?
          bcs  syner2
          stx  breg
          rts
syner2    jmp  syntax         ; Syntax error.
;-------------------------------------------------------------------------------
; vback - Reset vectors to normal settings
;-------------------------------------------------------------------------------
vback     sei
          jsr  rvect          ; init vectors.
          cli
          rts
;-------------------------------------------------------------------------------
; keys - Set keystroke autorepeat.
;    A - All Typomatic
;    N - None Typomatic
;    S - Normal Typomatic
;-------------------------------------------------------------------------------
keys      cmp  #$41           ; Is-it "A"?
          bne  nota
          lda  #$80
          bne  comkey
nota      cmp  #$4e           ; Is it "N"?
          bne notn
          lda  #$40
          bne  comkey
notn      cmp  #$53           ; Is it "S"?
          bne  syner3
          lda  #$00
comkey    sta  kreg
          jsr  $0073          ; Chrget end-of-statement
          rts
;-------------------------------------------------------------------------------
syner3    jmp  syntax         ; Error vector.
;-------------------------------------------------------------------------------
; ********************************* Page 72 ************************************ 
; frac - Return fractional part of number
;-------------------------------------------------------------------------------
frac      jsr  f1t57          ; Copy fac1 to $0057...
          jsr  intf1          ; FAC1 = INT(FAC1)
          lda  #$57
          ldy  #$00
          jsr  subf1          ; FAC1 = ($0057)-FAC1
          rts
;-------------------------------------------------------------------------------
; div - Return integer quotient.
;-------------------------------------------------------------------------------
div       jsr  $0073          ; Chrget the "(".
          jsr  chklp          ; Check for "(".
          jsr  eval           ; Eval 1st expression.
          jsr  f1t57          ; Copy fac1 to $0057...
          jsr  chkcm          ; Check for comme
          jsr  eval           ; Eval 2nd expression.
          jsr  chkrp          ; Check for ")".
          lda  #$57
          ldy  #$00
          jsr  f1div          ; FAC1 = ($0057)/FAC1 
          jsr  intf1          ; FAC1 = INT(FAC1)
          rts

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

