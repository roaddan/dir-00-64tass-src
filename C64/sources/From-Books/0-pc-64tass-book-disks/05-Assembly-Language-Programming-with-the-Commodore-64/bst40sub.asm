*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "c64_map_kernal.asm"
               .include "c64_map_vicii.asm" 
               .include "c64_map_basic2.asm"
               .include "c64_lib_basic2.asm"
               .include "c64_lib_pushpop.asm"
               .include "c64_lib_mem.asm"
               .include "c64_lib_hex.asm"
;               .include "c64_lib_text_sd_new.asm"
;               .include "c64_lib_text_mc.asm"
;               .include "c64_lib_showregs.asm"                
;               .include "c64_lib_joystick.asm"
;               .include "c64_lib_spriteman.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    "none"
main            .block
                jsr scrmaninit
                jsr cls
                lda <#header
                ldy >#header
                jsr puts
                lda <#filltext
                ldy >#filltext
                jsr puts
                lda <#movetext
                ldy >#movetext
                jsr puts
                lda <#clocktext
                ldy >#clocktext
                jsr puts
                rts                   
header                  ;0123456789012345678901234567890123456789
                .text   "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text   "          FOR THE COMMODORE 64"
                .byte   $0d
                .text   "        Book by Mark Greenshields"
                .byte   $0d
                .text   "      Programmed by Daniel Lafrance"
                .byte   $0d
                .text   "  ------------------------------------"
                .byte   $0d,$0d,0
filltext        .text   "  FILL test : SYS25000,1024,2024,1"
                .byte   $0d
                .text   "              SYS25000,55296,56296,1"
                .byte   $0d,0
movetext        .text   "  MOVE test : SYS25003,1024,2024,55296"
                .byte   $0d,0
clocktext       .text   "  CLOCK test: SYS25006,heures,minutes"
                .byte   $0d,$0d,0
                .bend

*=25000         ;28672
                jmp fill
                jmp move
                jmp clock
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
                jmp print
changeminute    lda #0                
                sta seconde                    
                inc minute          
                lda minute
                cmp #60
                bcs changeheure
                jmp print
changeheure     lda #0                
                sta minute
                inc heure
                lda heure
                cmp #24
                bcc print
                lda #0
                sta seconde
                sta minute
                sta heure
                jmp $ea31   ; IRQ interrupt entry
print           sec
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
