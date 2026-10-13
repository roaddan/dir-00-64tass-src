*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .include        "c64_map_kernal.asm"
                .include        "c64_lib_pushpop.asm"
                .include        "c64_lib_mem.asm"
                .include        "c64_lib_hex.asm"
;                .include        "c64_lib_sd.asm"
                .include        "c64_lib_mc.asm"
                .include        "c64_lib_showregs.asm"                
                .include        "c64_lib_joystick.asm"
                .include        "c64_lib_spriteman.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
                jsr     setvectors
                jsr     scrmaninit
out             rts
                .bend