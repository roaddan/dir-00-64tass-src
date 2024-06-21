;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
;        .include "butils.s"
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bcls
          .block
          php
          pha
          lda  #$93
          jsr  bputch
          pla
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bputch
          .block
          php
          jsr  $ffd2
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bputs
          .block
boutstr   =    $ab1e
          php
          sta ra
          sty ry
          jsr boutstr
          lda ra
          ldy ry
          plp
          rts
ra        .byte     0
ry        .byte     0
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bgotoxy
          .block
          php
          clc
          jsr kplot
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bcursor
          .block
bascol    =    $0286
          php
          pha
          bcc restore
          jsr kplot
          sty cx
          stx cy
          lda bascol
          sta bcol
          jmp out
restore   ldx cy
          ldy cx
          jsr kplot
          lda bcol
          sta bascol
out       pla
          plp
          rts
cx        .byte     $00
cy        .byte     $00
bcol      .byte     $00
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bcursave
          .block
          php
          sec
          jsr  bcursor
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bcurput
          .block
          php
          clc
          jsr  bcursor
          plp
          rts
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bputsxy
          .block
          php
          ;save start addr
          stx  straddr
          sty  straddr+1
          ;save a,y,x
          pha
          tya
          pha
          txa
          pha
          ;save zpage1
          lda  zpage1
          sta  zp1
          lda  zpage1+1
          sta  zp1+1
          ;set zpage1
          lda  straddr+1
          sta  zpage1+1
          lda  straddr
          sta  zpage1
          ; set z to zptr offset 0
          ldy  #$00
          ; load x param
          lda  (zpage1),y
          ;and save it
          sta  px
          ; next param
          iny
          ; looad y param
          lda  (zpage1),y
          ; and save it
          sta  py
          ; tfr a in x reg
          tax
          ; load x param in y
          ldy  px
          ; position cursor
          jsr  bgotoxy
          ; adjusting start addr
          clc
          inc  straddr
          lda  straddr
          sta  straddr
          bcc  norep1
          inc  straddr+1
norep1    inc  straddr
          bcc  norep2
          inc  straddr+1
norep2    lda  straddr
          ldy  straddr+1
          jsr  bputs
          lda  zp1+1
          sta  zpage1+1
          lda  zp1
          sta  zpage1
          pla
          tax
          pla
          tay
          pla
          plp
          rts
straddr   .word     $00
px        .byte     $00
py        .byte     $00
zp1       .word     $00
          .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
bputscxy
          .block
bascolor  =    $0286
          php
          ;save start addr
          stx  straddr
          sty  straddr+1
          ;save a,y,x
          pha
          tya
          pha
          txa
          pha
          ;save zpage1
          lda  zpage1
          sta  zp1
          lda  zpage1+1
          sta  zp1+1
          ;set zpage1
          lda  straddr+1
          sta  zpage1+1
          lda  straddr
          sta  zpage1
          ; set z to zptr offset 0
          ;save  current basiccolor
          lda  bascolor
          sta  bc
          ldy #$00
          ; load color param
          lda  (zpage1),y
          ; and set it
          sta  bascolor
          ; adjusting start addr
          clc
          inc  straddr
          bcc  norep1
          inc  straddr+1
norep1    ; get address of remainder
          lda  straddr
          ldy  straddr+1
          ; print string at x,y pos.
          jsr  bputsxy
          ; restoring basic color
          lda  bc
          sta  bascolor
          ; replacing zpage1 for basic
          lda  zp1+1
          sta  zpage1+1
          lda  zp1
          sta  zpage1
          pla
          tax
          pla
          tay
          pla
          plp
          rts
straddr  .word      $00
bc       .byte      $00
zp1      .word      $00
         .bend
