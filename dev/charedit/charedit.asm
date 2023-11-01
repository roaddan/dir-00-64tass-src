                .include "header-c64.asm"
                .include "macros-64tass.asm"
                .enc    none

main            .block
                jsr push
reload          jsr screendis
                jsr scrmaninit
;                lda #$0f
;                sta $d020
;                lda #24
;                sta 53272
;                lda #152
;                sta 53270
                #printcxy data
                #printcxy data2
                #setborder vvert
                #setbackground vvert
                #locate 1,20
                jsr screenena
                jsr pop
                rts
               .bend
data           .byte 1,0,0
               .text "allo"
               .byte 0
data2          .byte 3,3,4
               .text "allo"
               .byte 0
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm"
               .include "map-c64-basic2.asm"
               .include "lib-c64-vicii.asm"
               .include "lib-c64-basic2.asm" 
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-disk.asm"
;               .include "lib-c64-text-sd.asm"
;               .include "lib-c64-text-mc.asm"
;               .include "lib-c64-showregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
