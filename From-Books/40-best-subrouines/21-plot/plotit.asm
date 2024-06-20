;-------------------------------------------------------------------------------
               Version = "20230327-214534-a"
;-------------------------------------------------------------------------------               .include    "header-c64.asm"
               
               .include    "header-c64.asm"
               .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc    none
main            .block
               jsr  scrmaninit
               jsr  help
               jsr  anykey
               ;jsr  plotit
               jmp  b_warmstart
               .bend
                
help            .block      
               jsr cls
               lda  #14
               jsr  putch
               #print line
               #print headera
               #print headerb
               #print shortcuts
               #print helptext
               #print line
               rts                              
headera                      ;0123456789012345678901234567890123456789
               .text          "     40 BEST MACHINE CODE ROUTINES"
               .byte   $0d
               .text          "          FOR THE COMMODORE 64"
               .byte   $0d
               .text          "       Book by Mark Greenshields."
               .byte   $0d
               .text          "          ISBN 0-7156-1899-7"
               .byte   $0d,0

headerb         .text          "            plotit (pxx)"
               .byte   $0d
               .text          "        (c) 1979 Brad Templeton"
               .byte   $0d
               .text          "     programmed by Daniel Lafrance."
               .byte   $0d
               .text   format("        Version: %s.",Version)
               .byte   $0d,0

shortcuts       .text          " -------- S H O R T - C U T S ---------"
               .byte   $0d
               .text   format(" run=SYS%5d, help=SYS%5d",main, help)
               .byte   $0d
               .text   format(" cls=SYS%5d",cls)
               .byte   $0d,0
line            .text          " --------------------------------------"
               .byte   $0d,0
helptext        .text   format(" Prepare to plotit  : SYS%5d",plotit)
               .byte   $0d
               .text   format(" plotit: SYS%5d, x coord, y coord",plotit)
               .byte   $0d
               .text   format(" ex.: SYS%5d",plotit)
               .byte   $0d
               .text   format("      for i=0to100:SYS%5d:next",plotit)
               .byte   $0d,0
               .bend
*=$c08a
;-------------------------------------------------------------------------------
xcoord    =    $14
ycoord    =    $15
temp      =    $fd
pscreen   =    $6000
checkcom  =    $aefd
coord     =    $b7eb
false     =    255
true      =    0
n         =    320
;-------------------------------------------------------------------------------
plotit         .block
set            lda  #true
set1           sta  rsflag
               jsr  checkcom
               jsr  coord
               cpx  #200
               bcs  toobig
               lda  xcoord
               cmp  #<320
               lda  xcoord
               sbc  #>320
               bcs  toobig
               txa
               lsr
               lsr
               lsr
               asl
               tay
               lda  table,y
               sta  temp
               lda  table+1,y
               sta  temp+1
               txa
               and  #%00000111
               clc
               adc  temp
               sta  temp
               lda  temp+1
               adc  #0
               sta  temp+1
               lda  xcoord
               and  #%00000111
               tay
               lda  xcoord
               and  #%11111000
               clc
               adc  temp
               sta  temp
               lda  temp+1
               adc  xcoord+1
               sta  temp+1
               lda  temp
               clc
               adc  #<pscreen
               sta  temp
               lda  temp+1
               adc  #>pscreen
               sta  temp+1
               ldx  #0
               lda  (temp,x)
               bit  rsflag
               bpl  set2
               and  andmask,y
               jmp  set3
set2           ora  ormask,y
set3           sta  (temp,x)
               rts
toobig         rts
table          .word      0*n,  1*n,  2*n,  3*n,  4*n
               .word      5*n,  6*n,  7*n,  8*n,  9*n
               .word     10*n, 11*n, 12*n, 13*n, 14*n
               .word     15*n, 16*n, 17*n, 18*n, 19*n
               .word     20*n, 21*n, 22*n, 23*n, 24*n
ormask         .byte     $80, $40, $20, $10, $08, $04, $02, $01
andmask        .byte     $7f, $bf, $df, $ef, $f7, $fb, $fd, $fe
rsflag         .byte     $0 
               .bend

byte           .byte     0
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
           
 