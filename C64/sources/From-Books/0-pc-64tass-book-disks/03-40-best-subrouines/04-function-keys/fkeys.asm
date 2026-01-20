;-------------------------------------------------------------------------------
Version = "20230322-002000-a"
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
                .text          "              FKEYS (p26)"
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
                .text   format("  FKEYS  : SYS%5d (for two others)",loader)
                .byte   $0d
                .byte   0
                .bend
*=$6000
loader          .block
                sei
                lda #<fkeys
                sta cinv
                lda #>fkeys
                sta cinv+1
                cli
                rts
                .bend
fkeys           .block
                pha
                txa
                pha
                tya
                pha
                lda lstx
                cmp zpage1
                beq out
                sta zpage1
                cmp #$03
                bne a6026
                lda #$30
                sta fkeydef
                jmp a6047
a6026           cmp #$04
                bne a6032
                lda #$00
                sta fkeydef
                jmp a6047
a6032           cmp #$05
                bne a603e
                lda #$10
                sta fkeydef
                jmp a6047
a603e           cmp #$06
                bne out
                lda #$20
                sta fkeydef
a6047           lda shflag
                cmp #$01
                bne a6057
                lda fkeydef
                clc
                adc #$08
                sta fkeydef
a6057           ldx #$00
                ldy fkeydef
a605c           lda fkeydef+1,y
                sta kbbuff,x
                inx
                iny
                cpx #$08
                bne a605c
                stx ndx
out             pla
                tay
                pla
                tax
                pla
                jmp $ea31

fkeydef         .byte $00, $4c, $49, $53, $54, $0d, $04, $04
                .byte $04, $52, $55, $4e, $0d, $04, $04, $04
                .byte $04, $50, $52, $49, $4e, $54, $04, $04
                .byte $04, $54, $48, $45, $4e, $04, $04, $04
                .byte $04, $4c, $4f, $41, $44, $04, $04, $04
                .byte $04, $53, $41, $56, $45, $04, $04, $04
                .byte $04, $56, $45, $52, $49, $46, $59, $04
                .byte $04, $47, $4f, $54, $4f, $04, $04, $04
                .byte $04, $00, $00, $00, $00, $00, $ff, $00
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
