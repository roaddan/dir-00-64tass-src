;-------------------------------------------------------------------------------
Version = "20230320-180800-a"
;-------------------------------------------------------------------------------
                .include "header-c64.asm"
                .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
                jsr scrmaninit
                jsr help
                rts
                .bend

help            .block      
                jsr cls
                #print header
                #print shortcuts
                #print helptext
                rts                                
header                        ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d,$0d
                .text          "              PAUSE (p24)"
                .byte   $0d
                .text          "        (c)1979 Brad Templeton"
                .byte   $0d,$0d
                .text          "     Programmed by Daniel Lafrance."
                .byte   $0d
                .text   format("       Version: %s.",Version)
                .byte   $0d,0
shortcuts       .byte   $0d
                .text          " -------- S H O R T - C U T S ---------"
                .byte   $0d
                .text   format(" run=SYS%5d, help=SYS%5d",main, help)
                .byte   $0d
                .text   format(" cls=SYS%5d",cls)
                .byte   $0d
                .text          " --------------------------------------"
                .byte   $0d
                .byte   0
helptext        .byte   $0d
                .text   format("  PAUSE  : SYS%5d",pause)
                .byte   0
                .bend
*=960
pause           .block
                lda #<princ
                sta ibsout
                lda #>princ
                sta ibsout+1
                rts
princ           pha
                txa
                pha
                tya
                pha
loop            lda shflag                
                cmp #1
                beq loop
                pla
                tay
                pla
                tax
                pla
                jmp kd_chrout
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
*=$c000  
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
