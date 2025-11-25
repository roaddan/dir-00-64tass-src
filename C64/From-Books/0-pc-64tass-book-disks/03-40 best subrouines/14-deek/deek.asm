;-------------------------------------------------------------------------------
                Version = "20230331-214836"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                
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
                jmp b_warmstart
                .bend
                 
help            .block      
                jsr cls
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

headerb         .text          "              deek (p77)"
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
helptext        .text   format(" deek : SYS%5d, address",deek)
                .byte   $0d
                .text   format(" ex.: SYS%5d(12*4096)",deek)
                .byte   $0d,0
                .bend
*=$033c

deek            .block
                jsr b_chk4comma ; $aefd : Check for coma.
                jsr b_frmnum    ; $ad8a ; Evaluate numeric expression and/or ...
                                ;         ... check for data type mismatch
                jsr b_getadr    ; $b7f7 ; Convert Floating point number to ...
                                ;         ...an Unsighed TwoByte Integer.
                lda $14         ; Integer line number value LSB <LINNUM
                sta zpage1      ; zeropage 1 low byte
                lda $15         ; Integer line number value LSB >LINNUM
                sta zpage1+1    ; zeropage 1 high byte
                ldy #$00
                lda (zpage1),y
                iny
                tax
                lda (zpage1),y
                jmp b_putint    ; $bdcd ; Print fix point value.
                .bend
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$c000        
                .include "map-c64-kernal.asm"
                .include "map-c64-vicii.asm" 
                .include "map-c64-basic2.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 