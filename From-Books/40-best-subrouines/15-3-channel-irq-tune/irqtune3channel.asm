;-------------------------------------------------------------------------------
                Version = "20230327-214534-a"
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
                jsr irqtune3channel
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

headerb         .text          "         irqtune3channel (p79)"
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
helptext        .text   format(" irqtune3channel: SYS%5d",irqtune3channel)
                .byte   $0d
                .text   format(" ex.: SYS%5d",irqtune3channel)
                .byte   $0d,0
                .bend
*=$6000

irqtune3channel .block
                sei
                lda #<main
                sta 788
                lda #>main
                sta 789
                lda #$0f        ; #15
                sta sidsigvol   ; $d418 ; 54296 - Volume and Filter selectv register.
                                ;         Bits 0-3: Select output volume (0-15).
                                ;         Bit 4: Select low-pass filter, 1=low-pas on.
                                ;         Bit 5: Select band-pass filter, 1=band-pas on.
                                ;         Bit 6: Select high-pass filter, 1=high-pas on.
                                ;         Bit 7: Disconnect output of voice 3, 1=voice 3 off.
                lda #19
                sta sid1control ; $d404 ; 54276 - Voice 1 Voice control register.
                lda #64
                sta sid1atkdec  ; $d405 ; 54277 - 0-3: Voice 1 Decay duration, 4-7: Attack duration.
                sta sid1stnrel  ; $d406 ; 54278 - 0-3: Voice 1 Rel. duration, 4-7: Sustain duration.
                sta sid2atkdec  ; $d40c ; 54284 - Voice 2 0-3: Decay duration, 4-7: Attack duration.
                sta sid2stnrel  ; $d40d ; 54285 - Voice 2 0-3: Rel. duration, 4-7: Sustain duration.
                lda #33
                sta sid2control ; $d40b ; 54283 - Voice 2 Voice control register.
                lda #0
                sta 251
                sta 252
                sta 253
                cli
                rts
main            ldx 251
                ldy 252
                lda tune,x
                sta sid1flow    ; $d400 ; 54272 - Voice 1 Low freq register low byte.
                lda tune1-2,x
                sta sid2flow    ; $d407 ; 54279 - Voice 2 Low freq register low byte.
                lda tune1-1,x
                sta sid2fhigh   ; $d408 ; 54280 - Voice 2 High freq register high byte.
                lda tune+1,x
                sta sid1fhigh   ; $d401 ; 54273 - Voice 1 High freq register high byte.
                lda 253
                cmp #10
                bcs nextdelay
                inc 253
                jmp irq     ; $ea31
nextdelay       lda #0
                sta 253
                inx
                inx
                iny
                stx 251
                sty 252
                cpx #48
                bcs re
                jmp irq     ; $ea31
re              ldx #0
                sta 251
                sta 252
                jmp irq     ; $ea31


tune            .byte 198, 45,  0,  0,198, 45, 52, 43
                .byte 126, 38,  0,  0,126, 38, 75, 34
                .byte 126, 38, 75, 34,141, 30,214, 28
                .byte   0,  0,214, 28,141, 30, 75, 34
                .byte 227, 22,177, 25,141, 30,214, 28
                .byte 177, 25,227, 22,  0,  0,  0,  0
                .byte   0,  0,  0,  0

tune1           .byte 114, 11,  0,  0,114, 11,205, 10
                .byte 159,  9,  0,  0,159,  9,147,  8
                .byte 159,  9,147,  8,163,  7, 53,  7
                .byte   0,  0, 53,  7,163,  7,147,  8
                .byte 185,  5,108,  6,163,  7, 53,  7
                .byte 108,  6,185,  5,  0,  0,  0,  0
                .byte   0,  0,  0,  0

                .bend
byte            .byte 0
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
                .include "map-c64-kernal.asm"
                .include "map-c64-vicii.asm"
                .include "map-c64-sid.asm" 
                .include "map-c64-basic2.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 