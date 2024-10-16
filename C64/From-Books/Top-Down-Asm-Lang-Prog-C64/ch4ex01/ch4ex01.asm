;-------------------------------------------------------------------------------
                Version = "20241016-220013"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none
main           .block
               jsr  push
               jsr scrmaninit
               #disable
               jsr help
               jmp  mainout
               jsr anykey
               jsr ch3ex11
               #enable
               #uppercase
               jsr  cls
               #graycolor
;               jmp b_warmstart
mainout        
               jsr pop
               rts
               .bend
                 
;*=20000
help           .block      
               #lowercase
               jsr cls
               #print line
               #print headera
               #print headerb
               #print shortcuts
               #print helptext
               #print line
               rts                                
headera                              ;0123456789012345678901234567890123456789
               .text     $0d,        " TOP-DOWN ASSEMBLY LANGUAGE PROGRAMMING"
               .text     $0d,        "     For the Commodore Vic20 and 64"
               .text     $0d,        "           Book by KEN SKIER."
               .null     $0d,        "         ISBN 0-07-057864-8 PBK"
headerb        .text     $0d,        "            ch4ex01 (p.48)"
               .text     $0d,        "           (c) McGraw-hill"
               .text     $0d,        "     programmed by Daniel Lafrance."
               .null     $0d, format("       Version: %s.",Version)
shortcuts      .text     $0d,        " -------- S H O R T - C U T S ---------"
;               .text     $0d, format(" Main Run......: SYS%05d ($%04X)",main, main)
               .text     $0d, format(" This help.....: SYS%05d ($%04X)",help, help)
               .null     $0d, format(" Run  ch4ex0lI1..: SYS%05d ($%04X)",ch3ex11, ch3ex11),$0d
;               .null     $0D, format(" Clear screen..: SYS%05d ($%04X)",cls, cls)
helptext       .null     $0d, format(" Basic Example.: SYS%05d",ch3ex11), $0d
line           .null                 " --------------------------------------"
               .bend

;*=30000 ;$c400+24        ;To place the function at a specific place in memory.
;-------------------------------------------------------------------------------
; This function prints 8 'Z' characters at the cursor position using an indirect 
; pointer.
;-------------------------------------------------------------------------------

ch3ex11       .block
               pha
               jsr  cls
               #print qhelp
               lda  vicbordcol
               sta  byte
               lda  #$10
               sta  vicbordcol
               #print header
               jmp  another
;===============================================================================
; Example 11 on page 27 starts here
;-------------------------------------------------------------------------------
               jmp  init
pointer   .word     printit
init           ldx  #0
load           lda  #'Z'
useptr         jmp  (pointer)
; anything that would be inserted here will be jumped over by the pointer.
               .byte 00,00,00,00,00,00,00,00
printit        jsr  $ffd2
adhust         inx
test           cpx #9
branch         bne useptr
;-------------------------------------------------------------------------------
; Example stops here
;===============================================================================
another        jsr  getkey
               pha
               sec
               jsr  plot
               cpx  #24
               bne  nohead
               ;jsr  cls
               #locate 0,0
               #print qhelp
               #print header
nohead         lda  #13
               jsr  putch
               lda  #' '
               jsr  putch
               lda  #' '
               jsr  putch
               pla
               jsr  putch
               pha
               lda  #' '
               jsr  putch
               lda  #' '
               jsr  putch
               lda  #'%'
               jsr  putch
               pla
               jsr  putabin
               pha
               lda  #' '
               jsr  putch
               lda  #'$'
               jsr  putch
               pla
               jsr  putahex
               pha
               lda  #' '
               jsr  putch
               pla
               jsr  putadec
               ;pha
               ;lda  #' '
               ;jsr  putch
               ;pla
isitspecial    cmp  #27
               bpl  isitctrlh
               #print special
               pha
               ora  #%11000000
               jsr  putch
               pla     
               ;cmp  #$0c           ; Is it CTRL]+[L]
isitctrlh      cmp  #8             ; Is it CTRL]+[H]
               bne  isitctrln
               jsr  cls
               #locate 0,0
               #print qhelp
               #print header
isitctrln      cmp  #$14           ; Is it CTRL]+[N]    
               bne  isitctrlq
               jsr  help
isitctrlq      cmp  #$11           ; Is it [CTRL]+[Q]
               beq  doquit
               jmp  another
doquit         lda  byte
               sta  vicbordcol
               pla
               jsr  cls
               jsr  help
               rts
               .bend
byte           .byte     0
qhelp          .text     " Type a key to see char, bin, hex, dec.", 13
               .text     "  CTRL+H help, CTRL+Q quit, CTRL+L cls", 13, 0
header         .text     " chr %[binary] Hex Dec",13
               .null     "+---+---------+---+---+"
special        .null     "  CTRL+"                              
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$c800-1232     
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
