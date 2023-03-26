                .include "header-c64.asm"
                .include "cbm-macros.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
                rts
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .include "kernal-map-c64.asm"
                .include "vicii-map.asm" 
                .include "c64-lib-pushpop.asm"
                .include "c64-lib-mem.asm"
                .include "c64-lib-hex.asm"
;                .include "c64-lib-text-sd-new.asm"
                .include "c64-lib-text-mc.asm"
                .include "c64-lib-showregs.asm"                
                .include "c64-lib-joystick.asm"
                .include "c64-lib-spriteman.asm"
                 
                
