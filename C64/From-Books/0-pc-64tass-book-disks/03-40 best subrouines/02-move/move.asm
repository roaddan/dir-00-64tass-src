;-------------------------------------------------------------------------------
Version = "20230321-080800-a"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                .include "header-c64.asm"
                .include    "macros-64tass.asm"
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
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d,$0d
                .text          "              MOVE (p20)"
                .byte   $0d
                .text          "       (c) 1979 Brad Templeton"
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
                .text   format("  MOVE  : SYS%5d,start,end,dest.",move)
                .byte   $0d
                .text   format("     ex.: SYS%5d,1024,2024,55296",move)
                .byte   $0d,0
                .bend

move            .block
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda linnum
                sta temp
                lda linnum+1
                sta temp+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda linnum
                sta temp+2
                lda linnum+1
                sta temp+3
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda linnum
                sta temp+4
                lda linnum+1
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
           
 