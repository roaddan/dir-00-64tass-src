;-------------------------------------------------------------------------------
                Version = "20240710-181424-a"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none
               jsr  push
               jsr  main
               jsr  pop
               rts
*=$c000                                          
main           .block
               jsr scrmaninit
               #disable
               jsr help
               jsr anykey
               jsr ch3ex10
               #enable
               #uppercase
               jsr  cls
               #graycolor
;               jmp b_warmstart
               rts
               .bend
                 
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
headera                       ;0123456789012345678901234567890123456789
               .text          " Top-Down assembly language programming"
               .byte   $0d
               .text          "     For the Commodore Vic20 and 64"
               .byte   $0d
               .text          "           Book by Ken Skier."
               .byte   $0d
               .text          "         ISBN 0-07-057864-8 PBK"
               .byte   $0d,0

headerb        .text          "             ch3ex10 (p26)"
               .byte   $0d
               .text          "        (c) 1979 Brad Templeton"
               .byte   $0d
               .text          "     programmed by Daniel Lafrance."
               .byte   $0d
               .text   format("        Version: %s.",Version)
               .byte   $0d,0

shortcuts      .byte   $0d
               .text          " -------- S H O R T - C U T S ---------"
               .byte   $0d, $0d
               .text   format(" Main Run.....: SYS%05d ($%04X)",main, main)
               .byte   $0d
               .text   format(" This help....: SYS%05d ($%04X)",help, help)
               .byte   $0d
               .text   format(" Clear screen.: SYS%05d ($%04X)",cls, cls)
               .byte   $0d,0
helptext       .text   format(" Run ch3ex10..: SYS%05d ($%04X)",ch3ex10, ch3ex10)
               .byte   $0d, $0d
               .text   format(" Example......: SYS%05d",ch3ex10)
               .byte   $0d,0
line           .text          " --------------------------------------"
               .byte   $0d,0
               .bend

*=$c400+24        ;To place the function at a specific place in memory.
;-------------------------------------------------------------------------------
; This function copy 8 bytes from origin to (dest)ination.
;-------------------------------------------------------------------------------
origin = $2200
dest = $2210
ch3ex10       .block
               pha
               lda vicbordcol
               sta byte
               lda #$10
               sta vicbordcol
init           ldx  #0
get            lda  origin,x
put            sta  dest,x
adhust         inx
test           cpx #9
branch         bne get        ; Little bug in the original example stated ... 
                              ; ... "bne init" which was causing an endeless ...
                              ; ... loop.
               jsr anykey
               lda byte
               sta vicbordcol
               pla
               rts
               .bend
byte           .byte 0
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$c800        
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
