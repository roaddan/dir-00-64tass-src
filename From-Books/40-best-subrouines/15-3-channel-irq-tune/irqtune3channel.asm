;-------------------------------------------------------------------------------
                Version = "20230511-082548"
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
;                jsr anykey
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

shortcuts .text          " -------- S H O R T - C U T S ---------"
          .byte   $0d
          .text   format(" run=SYS%5d, help=SYS%5d",main, help)
          .byte   $0d
          .text   format(" cls=SYS%5d",cls)
          .byte   $0d,0
line      .text          " --------------------------------------"
          .byte   $0d,0
helptext  .text   format(" irqtune3channel: SYS%5d",irqtune3channel)
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
                lda #$0a        ; #0-15 $00-$0f
                sta sidsigvol   ; $d418 ; 54296 - Volume and Filter selectv register.
                                ;         Bits 0-3: Select output volume (0-15).
                                ;         Bit 4: Select low-pass filter, 1=low-pas on.
                                ;         Bit 5: Select band-pass filter, 1=band-pas on.
                                ;         Bit 6: Select high-pass filter, 1=high-pas on.
                                ;         Bit 7: Disconnect output of voice 3, 1=voice 3 off.
                lda #33
                sta sidv1control; $d404 ; 54276 - Voice 1 Voice control register.
                lda #33
                sta sidv2control; $d40b ; 54283 - Voice 2 Voice control register.
                lda #19
                sta sidv3control; $xxxx ; ddddd - Voice 3 Voice control register.
                lda #64
                sta sidv1atkdec ; $d405 ; 54277 - Voice 1 0-3: Decay duration, 4-7: Attack duration.
                sta sidv1stnrel ; $d406 ; 54278 - Voice 1 0-3: Rel. duration, 4-7: Sustain duration.
                sta sidv2atkdec ; $d40c ; 54284 - Voice 2 0-3: Decay duration, 4-7: Attack duration.
                sta sidv2stnrel ; $d40d ; 54285 - Voice 2 0-3: Rel. duration, 4-7: Sustain duration.
                ;sta sidv3atkdec ; $xxxx ; ddddd - Voice 3 0-3: Decay duration, 4-7: Attack duration.
                ;sta sidv3stnrel ; $xxxx ; ddddd - Voice 3 0-3: Rel. duration, 4-7: Sustain duration.
                lda #0
                sta 251
                sta 252
                sta 253
                cli
                rts


main            ldx 251
                ldy 252
                lda tune1,x
                sta sidv1flow   ; $d400 ; 54272 - Voice 1 Low freq register low byte.
                lda tune1+1,x
                sta sidv1fhigh  ; $d401 ; 54273 - Voice 1 High freq register high byte.
                lda tune2,x
                sta sidv2flow   ; $d407 ; 54279 - Voice 2 Low freq register low byte.
                lda tune2+1,x
                sta sidv2fhigh  ; $d408 ; 54280 - Voice 2 High freq register high byte.
                ;lda tune3,x
                ;sta sidv3flow   ; $xxxx ; ddddd - Voice 3 Low freq register low byte.
                ;lda tune3+1,x
                ;sta sidv3fhigh  ; $xxxx ; ddddd - Voice 3 High freq register high byte.
                lda 253
                cmp #32
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

                ;     lof,hif,    
tune1           
          .word     do1
          .word     silence
          .word     re1
          .word     silence
          .word     mi1
          .word     silence
          .word     fa1
          .word     silence
          .word     sol1
          .word     silence
          .word     la1
          .word     silence
          .word     si1
          .word     silence
          .word     do2
          .word     silence
          .word     si1
          .word     silence
          .word     la1
          .word     silence
          .word     sol1
          .word     silence
          .word     fa1
          .word     silence
          .word     mi1
          .word     silence
          .word     re1
          .word     silence
          .word     do1
          .word     silence

tune2
          .word     la5
          .word     lad5
          .word     si5
          .word     do5
          .word     dod5
          .word     re5
          .word     red5
          .word     mi5
          .word     fa5
          .word     fad5
          .word     sol5
          .word     sold5
          .word     la6
          .word     lad6
          .word     si6
          .word     do6
          .word     dod6
          .word     re6
          .word     red6
          .word     mi6
          .word     fa6
          .word     fad6
          .word     sol6
          .word     sold6
          .word     la7
          .word     lad7
          .word     0
          .word     0
          .word     0
          .word     0

tune3      .word fa6 
          .word silence
          .word fa6
          .word mi6
          .word re6
          .word silence
          .word re6
          .word do6
          .word re6
          .word do6
          .byte 141, 30
          .byte 214, 28
          .byte   0,  0
          .byte 214, 28
          .byte 141, 30
          .word do6
          .byte 227, 22
          .byte 177, 25
          .byte 141, 30
          .byte 214, 28
          .byte 177, 25
          .byte 227, 22
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0

tune4
          .byte 114, 11
          .byte   0,  0
          .byte 114, 11
          .byte 205, 10
          .byte 159,  9
          .byte   0,  0
          .byte 159,  9
          .byte 147,  8
          .byte 159,  9
          .byte 147,  8
          .byte 163,  7
          .byte  53,  7
          .byte   0,  0
          .byte  53,  7
          .byte 163,  7
          .byte 147,  8
          .byte 185,  5
          .byte 108,  6
          .byte 163,  7
          .byte  53,  7
          .byte 108,  6
          .byte 185,  5
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0

tune5           .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
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
                .include "map-c64-sid-notes-ntsc.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 