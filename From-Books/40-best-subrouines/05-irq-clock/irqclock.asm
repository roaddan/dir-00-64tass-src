;-------------------------------------------------------------------------------
Version = "20230319-090800-a"
;-------------------------------------------------------------------------------
                .include "header-c64.asm"
                .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    none
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
                .byte   $0d
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d,$0d
                .text          "             IRQCLOCK (p32)"
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
                .byte   $0d,0
helptext        .byte   $0d
                .text   format("  CLOCK : SYS%5d,heures,minutes",clock)
                .byte   $0d
                .text   format("     ex.: SYS%5d,7,30",clock)
                .byte   $0d,0
                .bend

clock           .block
                jsr b_chk4comma
                jsr b_getacc1lsb
                txa
                cmp #24
                bcs iqerr
                sta heure
                jsr b_chk4comma
                jsr b_getacc1lsb
                txa
                cmp #60
                bcs iqerr
                sta minute
                jmp setup
iqerr           jmp b_fcerr
setup           sei
                lda #<princ
                sta cinv
                lda #>princ
                sta cinv+1
                lda heure
                lda minute
                lda #0
                sta seconde
                lda #0
                sta compteur
                cli
                rts
princ           inc compteur
                lda compteur
                cmp #90
                bcs change
                jmp irq ; IRQ interrupt entry
change          lda #0
                sta compteur
                inc seconde
                lda seconde
                cmp #60
                bcs changeminute
                jmp printit
changeminute    lda #0                
                sta seconde                    
                inc minute          
                lda minute
                cmp #60
                bcs changeheure
                jmp printit
changeheure     lda #0                
                sta minute
                inc heure
                lda heure
                cmp #24
                bcc printit
                lda #0
                sta seconde
                sta minute
                sta heure
                jmp irq   ; IRQ interrupt entry
printit         sec
                jsr plot
                stx cursx
                sty cursy
                ldx #0
                ldy #30
                clc
                jsr plot
                ;lda #51                
                ;jsr chrout
                lda #0
                ldx heure
                jsr b_putint
                lda #":"                
                jsr chrout
                lda #0
                ldx minute
                jsr b_putint
                lda #":"                
                jsr chrout
                lda #0
                ldx seconde
                jsr b_putint
                ldx cursx
                ldy cursy
                clc
                jsr plot
                jmp irq   ; IRQ interrupt entry
heure           .byte   0
minute          .byte   0
seconde         .byte   0
compteur        .byte   0
cursx           .byte   0
cursy           .byte   0
                .bend 
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
*=$1000
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "map-c64-basic2.asm"
               .include "lib-c64-basic2.asm"
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
;               .include "lib-c64-text-sd.asm"
;               .include "lib-c64-text-mc.asm"
;               .include "lib-c64-showregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
