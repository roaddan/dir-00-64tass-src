                .include "header-c64.asm"
                .include "macros-64tass.asm"
                .enc    screen
main            lda #$00
                sta data_start
                lda #$04
                sta data_start+1
                lda #$00
                sta data_end
                lda #$08
                sta data_end+1
                sta driveno
                jsr memtofile
                jsr diskdir
                rts                
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
                .include "lib-cbm-disk.asm"
;                .include "lib-c64-text-sd.asm"
;                .include "lib-c64-text-mc.asm"
;                .include "lib-c64-showregs.asm"                
;                .include "lib-c64-joystick.asm"
;                .include "lib-c64-spriteman.asm"
