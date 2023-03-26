;-------------------------------------------------------------------------------
Version = "20230321-080800-b"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                .include    "header-c64.asm"
                .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
memoire         = $1000
                .enc    none
main            .block
                jsr scrmaninit
                jsr help
                rts
                .bend

help            .block      
                jsr cls
                #print helptxt
                #print shortcuts
                #print helptxt2
                rts                                
helptxt                       ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d,$0d
                .text          "              FILL (p17)"
                .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
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
helptxt2        .byte   $0d
                .text   format("  FILL  : SYS%5d,start,end,byte",fill)
                .byte   $0d
                .text   format("     ex.: SYS%5d,1024,2024,1",fill)
                .byte   $0d

                .byte   0
                .bend

fill            .block
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda linnum
                sta zpage1
                lda linnum+1
                sta zpage1+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda linnum
                sta tbuffer
                lda linnum+1
                sta tbuffer+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda linnum+1
                beq more
                jmp b_fcerr
more            lda linnum
                sta tbuffer+2
loop            ldy #0                
                lda tbuffer+2
                sta (zpage1),y
                jsr add
                lda zpage1
                cmp tbuffer
                beq check
                jmp loop
check           lda zpage1+1
                cmp tbuffer+1
                beq finish
                jmp loop
add             inc zpage1               
                beq fcplus1                
                rts
fcplus1         inc zpage1+1                
                rts                    
finish          rts
                .bend                
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .include    "map-c64-kernal.asm"
                .include    "map-c64-vicii.asm" 
                .include    "map-c64-basic2.asm"
                .include    "lib-c64-basic2.asm"
                .include    "lib-cbm-pushpop.asm"
                .include    "lib-cbm-mem.asm"
                .include    "lib-cbm-hex.asm"

 