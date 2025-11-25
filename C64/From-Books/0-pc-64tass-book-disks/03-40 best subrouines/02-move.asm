*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "c64_map_kernal.asm"
               .include "c64_map_vicii.asm" 
               .include "c64_map_basic2.asm"
               .include "c64_lib_basic2.asm"
               .include "c64_lib_pushpop.asm"
               .include "c64_lib_mem.asm"
               .include "c64_lib_hex.asm"
;               .include "c64_lib_text_sd_new.asm"
;               .include "c64_lib_text_mc.asm"
;               .include "c64_lib_showregs.asm"                
;               .include "c64_lib_joystick.asm"
;               .include "c64_lib_spriteman.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .enc    "none"
main            .block
                jsr scrmaninit
                jsr cls
                lda <#loaded
                ldy >#loaded
                jsr puts
                rts                   
loaded          .text   "Program MOVE.asm en memoire a 24576."
                .byte   0
                .bend
*=$6000         ;24576
move            .block
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta temp
                lda $15
                sta temp+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta temp+2
                lda $15
                sta temp+3
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta temp+4
                lda $15
                sta temp+5
                lda temp
                sta zpage1
                lda temp+1
                sta zpage1+1
                lda temp+4
                sta zpage2
                lda temp+5
                sta zpage2+1
                ldy #$00
loop            lda (zpage1),y                
                sta (zpage2),y
                jsr inczp1
                jsr inczp2
                lda zpage1
                cmp temp+2
                beq check
                jmp loop
check           lda zpage1+1                
                cmp temp+3                
                beq finish
                jmp loop
finish          rts
temp            .byte 0,0,0,0,0,0
                .bend                
 