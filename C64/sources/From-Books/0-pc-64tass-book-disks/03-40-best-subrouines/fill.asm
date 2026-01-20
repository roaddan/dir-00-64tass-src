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
;               .include "c64_lib_mem.asm"
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
loaded          .text   "Program FILL.asm en memoire a 28672."
                .byte   0
                .bend
*=$7000         ;28672
fill            .block
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta zpage1
                lda $15
                sta zpage1+1
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $14
                sta 828
                lda $15
                sta 829
                jsr b_chk4comma ;$aefd
                jsr b_frmnum    ;$ad8a
                jsr b_getadr    ;$b7f7
                lda $15
                beq more
                jmp b_fcerr
more            lda $14
                sta 830
loop            ldy #0                
                lda 830
                sta (zpage1),y
                jsr add
                lda zpage1
                cmp 828
                beq check
                jmp loop
check           lda zpage1+1
                cmp 829
                beq finish
                jmp loop
add             inc zpage1               
                beq fcplus1                
                rts
fcplus1         inc zpage1+1                
                rts                    
finish          rts
                .bend                
 