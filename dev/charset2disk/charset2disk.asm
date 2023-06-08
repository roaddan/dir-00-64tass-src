               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .enc    none

main           .block
               jsr  push
               lda  #147
               jsr  putch
               jsr  rom2ram
               jsr  savetodisk
               lda  #%00011000     ;#24
               sta  $d018          ;53272
               jsr  pop
               rts
               .bend

rom2ram        .block
               jsr  push
               ;get access to charrom
               lda  $dc0e          ;56334
               and  #%11111110     ;$fe ou 254
               sta  $dc0e          ;56334
               lda  $01
               and  #%11111011     ;$fb ou 251
               sta  $01
               ;copy rom to ram
               lda  chrom_s
               sta  zpage1
               lda  chrom_s+1
               sta  zpage1+1
               lda  chram_s
               sta  zpage2
               lda  chram_s+1
               sta  zpage2+1
               ldx  #$10           ; copie 8 page de 256 char.
               ldy  #$00
               sei
nexty          lda  (zpage1),y
               ;cmp  #$00
               ;bne  save
               ;eor  #$ff
               ;jmp  save
skip           eor  #%01010101
save           sta  (zpage2),y
               iny
               bne  nexty
               dex
               beq  out
               inc  zpage1+1
               inc  zpage2+1
               jmp  nexty
out            ; return charrom to normal use
               cli
               lda  $01
               ora  #%00000100     ;#$04
               sta  $01
               lda  $dc0e          ;56334
               ora  #%00000001     ;$01
               sta  $dc0e          ;56334
               jsr  pop
               rts
               .bend
chrom_s        .word     $d000     ;$d000 a $d800 53284
chram_s        .word     $2000     ;$2000 a $2800 8192 


savetodisk     .block
               jsr  push
               lda  #$00
               sta  dsk_data_s
               lda  #$20
               sta  dsk_data_s+1
               lda  #$00
               sta  dsk_data_e
               lda  #$30
               sta  dsk_data_e+1
               lda  #$08
               sta  dsk_dev
               lda  #$00
               sta  dsk_lfsno
               lda  #<fname
               sta  dsk_fnptr
               lda  #>fname
               sta  dsk_fnptr+1
               lda  #fname_end-fname
               sta  dsk_fnlen    
               jsr  memtofile
               lda  #$0d
               jsr  putch
               jsr  diskerror
               jsr  diskdir
               jsr  filetomem
               jsr  pop 
               rts   
fname          .byte 64
               .text "0:charset-fucked"      
fname_end      .byte 0
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
;               .include "lib-c64-text-sd.asm"
;               .include "lib-c64-text-mc.asm"
;               .include "lib-c64-showregs.asm"                
;               .include "lib-c64-joystick.asm"
;               .include "lib-c64-spriteman.asm"
