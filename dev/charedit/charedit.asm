                .include "header-c64.asm"
                .include "macros-64tass.asm"
                .include "localmacro.asm"
                .enc     none

main           .block
               jsr push
reload         jsr screendis
               jsr scrmaninit
;                lda #$0f
;                sta $d020
;                lda #24
;                sta 53272
;                lda #152
;                sta 53270
               jsr  staticscreen
               jsr screenena
               #affichemesg edit_msg       
               jsr  anykey
               #affichemesg save_msg
               jsr  anykey
               #affichemesg load_msg
               jsr  anykey
               #affichemesg copy_msg
               jsr  anykey
               #affichemesg clear_msg 
               jsr  anykey
               #affichemesg fill_msg
               jsr  anykey
               #affichemesg work_msg
               jsr  anykey
               #affichemesg rvrs_msg
               jsr  anykey
               #affichemesg invr_msg
               jsr  anykey
               #affichemesg flip_msg
               jsr  anykey
               #affichemesg scrollr_msg
               jsr  anykey
               #affichemesg scrolll_msg
               jsr  anykey
               #affichemesg scrollu_msg
               jsr  anykey
               #affichemesg scrolld_msg
               jsr  anykey
               #affichemesg save_fname_msg
               jsr  anykey
               #affichemesg load_fname_msg
               #locate 1,7
               jsr pop
               rts
               .bend

staticscreen   .block
               #changebord vmauve
               #changeback vrose
               #uppercase
               jsr  showlines
               jsr  showallchars
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showallchars   .block
               jsr push
               #locate   0,0
               ldx  #$00
nextc          txa  
               sta  scrnram,x
               inx
               cpx  #$80
               bne  nextc
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showlines      .block
               jsr  push
               #locate   0,4
               ldx  #40
               lda  #(192-128)
nextl          sta  scrnram+(40*4)-1,x
               sta  scrnram+(40*6)-1,x
               dex
               cpx  #$00

               bne  nextl
               jsr  pop
               rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "messages.asm"
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm"
               .include "map-c64-basic2.asm"
               .include "lib-c64-vicii.asm"
               .include "lib-c64-basic2.asm" 
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
               .include "lib-cbm-keyb.asm"
;               .include "lib-cbm-disk.asm"
;               .include "lib-c64-text-sd.asm"
;               .include "lib-c64-text-mc.asm"
;               .include "lib-c64-showregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
