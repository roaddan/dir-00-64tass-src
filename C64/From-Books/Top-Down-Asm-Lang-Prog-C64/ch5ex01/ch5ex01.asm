;-------------------------------------------------------------------------------
                Version = "20240725-132328"
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
;*=10000 ;$c000
main           .block
               jsr scrmaninit
               #disable
               jsr help
;               jmp  mainout
               jsr anykey
               ldx  #$00
nextx          inx
               txa
               cpx  #$00
               beq nonext
               jsr ch5ex01
               jmp  nextx
nonext         jsr  anykey
               #enable
               #uppercase
               jsr  cls
               #graycolor
;               jmp b_warmstart
mainout        rts
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
headerb        .text     $0d,        "            ch5ex01 (p.46)"
               .text     $0d,        "           (c) McGraw-hill"
               .text     $0d,        "     programmed by Daniel Lafrance."
               .null     $0d, format("       Version: %s.",Version)
shortcuts      .text     $0d,        " -------- S H O R T - C U T S ---------"
;               .text     $0d, format(" Main Run......: SYS%05d ($%04X)",main, main)
               .text     $0d, format(" This help.....: SYS%05d ($%04X)",help, help)
               .null     $0d, format(" Run  ch5ex01..: SYS%05d ($%04X)",ch5ex01, ch5ex01),$0d
;               .null     $0D, format(" Clear screen..: SYS%05d ($%04X)",cls, cls)
helptext       .null     $0d, format(" Basic Example.: SYS%05d",ch5ex01), $0d
line           .null                 " --------------------------------------"
               .bend

;*=30000 ;$c400+24        ;To place the function at a specific place in memory.
;-------------------------------------------------------------------------------
; This function prints 8 'Z' characters at the cursor position using an indirect 
; pointer.
;-------------------------------------------------------------------------------

ch5ex01        .block
tvput          jsr  push
               pha
               lda  #<scrnram
               sta  zpage1
               lda  #>scrnram
               sta  zpage1+1
               lda  #<colram
               sta  zpage2
               lda  #>colram
               sta  zpage2+1
               pla
               ldy  #0
onemore        sta  (zpage1),y
               sta  (zpage2),y
               iny
               cpy  #$00
               bne  onemore
               jsr  pop
               rts
tvptr     =    $fb
               .bend
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
