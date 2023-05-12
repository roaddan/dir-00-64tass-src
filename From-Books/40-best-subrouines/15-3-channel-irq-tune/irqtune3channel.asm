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
                lda tune3,x
                sta sidv3flow   ; $xxxx ; ddddd - Voice 3 Low freq register low byte.
                lda tune3+1,x
                sta sidv3fhigh  ; $xxxx ; ddddd - Voice 3 High freq register high byte.
                lda 253
                cmp #1
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
la2       .word $01D4 ; NTSC (hex): high: $01, low: $D4 ; (dec): low:212, High:1
lad2      .word $01F0 ; NTSC (hex): high: $01, low: $F0 ; (dec): low:240, High:1
si2       .word $020D ; NTSC (hex): high: $02, low: $0D ; (dec): low:13, High:2
do2       .word $022C ; NTSC (hex): high: $02, low: $2C ; (dec): low:44, High:2
dod2      .word $024E ; NTSC (hex): high: $02, low: $4E ; (dec): low:78, High:2
re2       .word $0271 ; NTSC (hex): high: $02, low: $71 ; (dec): low:113, High:2
red2      .word $0296 ; NTSC (hex): high: $02, low: $96 ; (dec): low:150, High:2
mi2       .word $02BD ; NTSC (hex): high: $02, low: $BD ; (dec): low:189, High:2
fa2       .word $02E7 ; NTSC (hex): high: $02, low: $E7 ; (dec): low:231, High:2
fad2      .word $0313 ; NTSC (hex): high: $03, low: $13 ; (dec): low:19, High:3
sol2      .word $0342 ; NTSC (hex): high: $03, low: $42 ; (dec): low:66, High:3
sold2     .word $0373 ; NTSC (hex): high: $03, low: $73 ; (dec): low:115, High:3
la3       .word $03A8 ; NTSC (hex): high: $03, low: $A8 ; (dec): low:168, High:3
lad3      .word $03E0 ; NTSC (hex): high: $03, low: $E0 ; (dec): low:224, High:3
si3       .word $041B ; NTSC (hex): high: $04, low: $1B ; (dec): low:27, High:4
do3       .word $0459 ; NTSC (hex): high: $04, low: $59 ; (dec): low:89, High:4
dod3      .word $049C ; NTSC (hex): high: $04, low: $9C ; (dec): low:156, High:4
re3       .word $04E2 ; NTSC (hex): high: $04, low: $E2 ; (dec): low:226, High:4
red3      .word $052C ; NTSC (hex): high: $05, low: $2C ; (dec): low:44, High:5
mi3       .word $057B ; NTSC (hex): high: $05, low: $7B ; (dec): low:123, High:5
fa3       .word $05CE ; NTSC (hex): high: $05, low: $CE ; (dec): low:206, High:5
fad3      .word $0627 ; NTSC (hex): high: $06, low: $27 ; (dec): low:39, High:6
sol3      .word $0684 ; NTSC (hex): high: $06, low: $84 ; (dec): low:132, High:6
sold3     .word $06E7 ; NTSC (hex): high: $06, low: $E7 ; (dec): low:231, High:6
la4       .word $0751 ; NTSC (hex): high: $07, low: $51 ; (dec): low:81, High:7
lad4      .word $07C0 ; NTSC (hex): high: $07, low: $C0 ; (dec): low:192, High:7
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0

tune2
la5       .word $0EA2 ; NTSC (hex): high: $0E, low: $A2 ; (dec): low:162, High:14
lad5      .word $0F81 ; NTSC (hex): high: $0F, low: $81 ; (dec): low:129, High:15
si5       .word $106D ; NTSC (hex): high: $10, low: $6D ; (dec): low:109, High:16
do5       .word $1167 ; NTSC (hex): high: $11, low: $67 ; (dec): low:103, High:17
dod5      .word $1270 ; NTSC (hex): high: $12, low: $70 ; (dec): low:112, High:18
re5       .word $1388 ; NTSC (hex): high: $13, low: $88 ; (dec): low:136, High:19
red5      .word $14B2 ; NTSC (hex): high: $14, low: $B2 ; (dec): low:178, High:20
mi5       .word $15ED ; NTSC (hex): high: $15, low: $ED ; (dec): low:237, High:21
fa5       .word $173B ; NTSC (hex): high: $17, low: $3B ; (dec): low:59, High:23
fad5      .word $189C ; NTSC (hex): high: $18, low: $9C ; (dec): low:156, High:24
sol5      .word $1A13 ; NTSC (hex): high: $1A, low: $13 ; (dec): low:19, High:26
sold5     .word $1B9F ; NTSC (hex): high: $1B, low: $9F ; (dec): low:159, High:27
la6       .word $1D44 ; NTSC (hex): high: $1D, low: $44 ; (dec): low:68, High:29
lad6      .word $1F02 ; NTSC (hex): high: $1F, low: $02 ; (dec): low:2, High:31
si6       .word $20DA ; NTSC (hex): high: $20, low: $DA ; (dec): low:218, High:32
do6       .word $22CE ; NTSC (hex): high: $22, low: $CE ; (dec): low:206, High:34
dod6      .word $24E0 ; NTSC (hex): high: $24, low: $E0 ; (dec): low:224, High:36
re6       .word $2710 ; NTSC (hex): high: $27, low: $10 ; (dec): low:16, High:39
red6      .word $2964 ; NTSC (hex): high: $29, low: $64 ; (dec): low:100, High:41
mi6       .word $2BDA ; NTSC (hex): high: $2B, low: $DA ; (dec): low:218, High:43
fa6       .word $2E76 ; NTSC (hex): high: $2E, low: $76 ; (dec): low:118, High:46
fad6      .word $3139 ; NTSC (hex): high: $31, low: $39 ; (dec): low:57, High:49
sol6      .word $3426 ; NTSC (hex): high: $34, low: $26 ; (dec): low:38, High:52
sold6     .word $373F ; NTSC (hex): high: $37, low: $3F ; (dec): low:63, High:55
la7       .word $3A89 ; NTSC (hex): high: $3A, low: $89 ; (dec): low:137, High:58
lad7      .word $3E05 ; NTSC (hex): high: $3E, low: $05 ; (dec): low:5, High:62
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0
          .byte   0,  0

tune3     .byte 198, 45 ; f-5 
          .byte   0,  0
          .byte 198, 45 ; f-5
          .byte  52, 43
          .byte 126, 38
          .byte   0,  0
          .byte 126, 38
          .byte  75, 34
          .byte 126, 38
          .byte  75, 34
          .byte 141, 30
          .byte 214, 28
          .byte   0,  0
          .byte 214, 28
          .byte 141, 30
          .byte  75, 34
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
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 