;-------------------------------------------------------------------------------
                Version = "20240620-222425"
;-------------------------------------------------------------------------------
                .include    "header-c64.asm"
                .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    none
                
main            .block
                jsr scrmaninit
                jsr help
                jsr anykey
                jsr releasekey
                jsr graph
                jsr anykey
                jsr releasekey
                jsr clg
                jsr anykey
                jsr releasekey
                jsr nrm
                jsr getkey
;                jsr anykey
;                jsr releasekey
                jsr scrmaninit
                jsr help
                rts
                .bend
help            .block      
                jsr cls
                lda #14
                jsr putch
                #print line
                #print headera
                #print headerb
                #print shortcuts
                #print helptext
                #print line
                rts                                
headera                       ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d
                .text          "          ISBN 0-7156-1899-7"
                .byte   $0d,0

headerb         .text          "              graph (p78)"
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
helptext        .text   format(" Prepare to graph  : SYS%5d",graph)
                .byte   $0d
                .text   format(" graph.....: SYS%5d",graph)
                .byte   $0d
                .text   format(" clg.......: SYS%5d,fgcol,bgcol",clg)
                .byte   $0d
                .text   format(" nrm.......: SYS%5d",nrm)
                .byte   $0d
                .text   format(" plot......: SYS%5d",gplot)
                .byte   $0d
                .text   format(" anykey....: SYS%5d",anykey)
                .byte   $0d
                .text   format(" releasekey: SYS%5d",releasekey)
                .byte   $0d,0
                .bend
*=$c000
;-------------------------------------------------------------------------------- 
; 18 - GRAPH page 78
;-------------------------------------------------------------------------------- 
graph        .block
                pha
                lda #$16
                sta cia2pra   ;56576
                lda #8
                sta vicmemptr ;53272
                lda vicctrl0v ; 53265
                ora #32
                sta vicctrl0v ; 53265
                pla
                rts
                .bend
*=$c016
;-------------------------------------------------------------------------------- 
; 19 - NRM page 80
;-------------------------------------------------------------------------------- 
nrm             .block
;                pha
                lda #21
                sta vicmemptr ; 53272
                lda #27
                sta vicctrl0v ; 53265
                lda #23
                sta cia2pra   ;56576
;                pla
                rts
                .bend
;-------------------------------------------------------------------------------- 
; 20 - CLG page 81
;-------------------------------------------------------------------------------- 
clg             .block
                php
                pha
                ;jsr $aefd
                ;jsr $ad8a
                ;jsr $b7f7
                ;lda $15
                ;beq more
                ;jmp $b248
more            ;lda $14
                lda colour
                and #$0f
                sta colour
                sta fin
                inc colour
                ;jsr $aefd
                ;jsr $ad8a
                ;jsr $b7f7
                ;lda $15
                ;beq more1
                ;jmp $b248
more1           ;lda $14
                lda #1
                asl a
                asl a
                asl a
                asl a
                ora fin
                sta fin
                lda #0
                sta $60
                lda #96
                sta $fc
                ldy #0
                lda #0
loop            sta ($fb),y
                iny
                bne loop
                inc $fc
                ldx $fc
                cpx #128
                bne loop
                lda fin
                ldx #0
loop1           sta $4000,x
                sta $4100,x
                sta $4200,x
                sta $4300,x
                inx
                bne loop1
                pla
                plp
                rts
                .bend
fin             .byte 0
colour          .byte 2

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
*=$c08a
;-------------------------------------------------------------------------------
gplot          .block
set            lda  #true
set1           sta  rsflag
               jsr  checkcom
               jsr  coord
               cpx  #200
               bcs  toobig
               lda  xcoord
               cmp  #<320
               lda  ycoord
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
table          .word     0*n,  1*n,   2*n,  3*n  
               .word     4*n,  5*n,   6*n,  7*n
               .word     8*n,  9*n,  10*n, 11*n 
               .word     12*n, 13*n, 14*n, 15*n
               .word     16*n, 17*n, 18*n, 19*n 
               .word     20*n, 21*n, 22*n, 23*n 
               .word     24*n
ormask         .byte     $80, $40, $20, $10, $08, $04, $02, $01
andmask        .byte     $7f, $bf, $df, $ef, $f7, $fb, $fd, $fe
rsflag         .byte     $0 , $c2, $c9, $f0, $08, $20
               .bend

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
           
 