                .include "header-c64.asm"
                .include "macros-64tass.asm"
                .enc    none

main            .block
                lda #$00
                sta dsk_data_s
                lda #$04
                sta dsk_data_s+1
                lda #$00
                sta dsk_data_e
                lda #$08
                sta dsk_data_e+1
                lda #$08
                sta dsk_dev
                lda #$00
                sta dsk_lfsno
                lda #<fname
                sta dsk_fnptr
                lda #>fname
                sta dsk_fnptr+1
                lda #fname_end-fname
                sta dsk_fnlen    
                jsr memtofile
                lda #$0d
                jsr putch
                jsr diskerror
                jsr diskdir
                jsr filetomem
                
                rts 
fname           .byte 64
                .text "0:daniel"      
fname_end       .byte 0
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
                .include "lib-cbm-disk.asm"
;                .include "lib-c64-text-sd.asm"
;                .include "lib-c64-text-mc.asm"
;                .include "lib-c64-showregs.asm"                
;                .include "lib-c64-joystick.asm"
;                .include "lib-c64-spriteman.asm"
