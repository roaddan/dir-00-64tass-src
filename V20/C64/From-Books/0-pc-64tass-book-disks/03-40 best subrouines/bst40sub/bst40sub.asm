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
                .text          "                bst40sub"
                .byte   $0d
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
                .text   format("  FILL  : SYS%5d,start,end,byte",fill)
                .byte   $0d
                .text   format("     ex.: SYS%5d,1024,2024,1",fill)
                .byte   $0d
                .text   format("          SYS%5d,55296,56296,1",fill)
                .byte   $0d,$0d
                .text   format("  MOVE  : SYS%5d,start,end,dest.",move)
                .byte   $0d
                .text   format("     ex.: SYS%5d,1024,2024,55296",move)
                .byte   $0d,$0d
                .text   format("  CLOCK : SYS%5d,heures,minutes",clock)
                .byte   $0d
                .text   format("     ex.: SYS%5d,7,30",clock)
                .byte   0
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
                sta 788
                lda #>princ
                sta 789
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
                jmp $ea31   ; IRQ interrupt entry
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
                jmp $ea31   ; IRQ interrupt entry
printit           sec
                jsr plot
                stx cursx
                sty cursy
                ldx #24
                ldy #34
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
                ;lda #":"                
                ;jsr chrout
                ;lda #0
                ;ldx seconde
                ;jsr b_putint
                ldx cursx
                ldy cursy
                clc
                jsr plot
                jmp $ea31   ; IRQ interrupt entry
heure           .byte   0
minute          .byte   0
seconde         .byte   0
compteur        .byte   0
cursx           .byte   0
cursy           .byte   0
                .bend
fill            .block
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta zpage1
                lda $15
                sta zpage1+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta 828
                lda $15
                sta 829
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $15
                beq more
                jmp b_fcerr
more            lda $14
                sta 830
loop            ldy #0                
                lda 830
                sta (zpage1),y
                jsr add
                lda zpage1
                cmp 828
                beq check
                jmp loop
check           lda zpage1+1
                cmp 829
                beq finish
                jmp loop
add             inc zpage1               
                beq fcplus1                
                rts
fcplus1         inc zpage1+1                
                rts                    
finish          rts
                .bend                
move            .block
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta temp
                lda $15
                sta temp+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta temp+2
                lda $15
                sta temp+3
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta temp+4
                lda $15
                sta temp+5
                lda temp
                sta zpage1
                lda temp+1
                sta zpage1+1
                lda temp+4
                sta zpage2
                lda temp+5
                sta zpage2+1
                ldy #$00
loop            lda (zpage1),y                
                sta (zpage2),y
                jsr inczp1
                jsr inczp2
                lda zpage1
                cmp temp+2
                beq check
                jmp loop
check           lda zpage1+1                
                cmp temp+3                
                beq finish
                jmp loop
finish          rts
temp            .byte 0,0,0,0,0,0
                .bend                
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
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
