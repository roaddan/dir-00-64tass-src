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
                jmp b_warmstart
                rts
                .bend
                 
help            .block      
                jsr cls
                #print line
                #print header
                #print line
                #print shortcuts
                #print line
                #print helptext
                #print line
                rts                                
header                        ;0123456789012345678901234567890123456789
                .text          "     40 BEST MACHINE CODE ROUTINES"
                .byte   $0d
                .text          "          FOR THE COMMODORE 64"
                .byte   $0d
                .text          "       Book by Mark Greenshields."
                .byte   $0d,$0d
                .text          "            copy (p64)"
                .byte   $0d
                .text          "        (c) 1979 Brad Templeton"
                .byte   $0d,$0d
                .text          "     programmed by Daniel Lafrance."
                .byte   $0d
                .text   format("       Version: %s.",Version)
                .byte   $0d,0

shortcuts       .text          " -------- S H O R T - C U T S ---------"
                .byte   $0d
                .text   format(" run=SYS%5d, help=SYS%5d",main, help)
                .byte   $0d
                .text   format(" cls=SYS%5d",cls)
                .byte   $0d,0
line            .text          " --------------------------------------"
                .byte   $0d,0
                .bend
helptext        .text          " Copy :"
                .byte   $0d 
                .text   format("    SYS%5d,adress, no. of pages",copy)
                .byte   $0d,$0d 
                .text   format("    SYS%5d,8192,16",copy)
                .byte   $0d,$0d 
                .text   format("    SYS%5d,12288,4",copy)
                .byte   $0d,0

*=$6000

copy            .block
                jsr $aefd
                jsr $ad8a
                jsr $b7f7
                lda $14
                sta $fb
                lda $15
                sta $fc
                jsr $aefd
                jsr $b79e
                txa
                cmp #17
                bcc more
                jmp $b248
more            sta $fd
                lda #$00
                sta temp
                ldy #$00
                lda #$00
                sta $fe
                lda #208
                sta $ff
                lda #$00
                sta 56334
                lda #51
                sta $01
loop            lda ($fe),y
                sta ($fb),y
                iny
                bne loop
                inc temp
                lda temp
                cmp $fd
                bcs fin
                inc $fc
                inc $ff
                jmp loop
fin             lda #55
                sta $01
                lda #$01
                sta 56334
                rts
temp            .byte   0
                .bend
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
                .include "map-c64-kernal.asm"
                .include "map-c64-vicii.asm" 
                .include "map-c64-basic2.asm"
                .include "lib-c64-basic2.asm"
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
                .include "lib-cbm-keyb.asm"
           
 