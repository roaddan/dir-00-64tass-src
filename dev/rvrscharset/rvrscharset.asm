               .include "header-c64.asm"
               .include "macros-64tass.asm"
               .enc    none

main           .block
               jsr  push
               lda  #$31
               sta  fname+10    ; File suffix = 1 
               lda  #$ff        ; We reverse everythinh
               sta  xor
               jsr  rom2ram     ; Copy reversed charset to ram
               lda  #$00        ; Set charcolor (Background) to black
               sta  646
               sta  vicbordcol  ; set the border to black
               lda  #$01        ; Background (character) 
               sta  vicbackcol
               lda  #%00011000     ;#24
               sta  $d018          ;53272
               lda  #147
               jsr  putch
               lda  #14
               jsr  putch
               #locate 0,24
               #println  mesg00a
               #println  mesg00b
               #println  mesg00a
               #println  mesg01a
               #println  mesg01b
               #println  mesg02a
               #println  mesg02b
               #println  mesg02c
               #println  mesg03a
               #println  mesg03b
               #println  mesg03c
               #print    mesg04a
               #print    mesg04b
               #println  mesg04c
               #println  mesg04d
               #println  mesg04e
               #println  mesg05a
               #println  mesg05b
               #print    mesg00a
               locate 0,0
               jsr  pop
               rts
mesg00a        .null     b_ltblue, " ------------------------------------- ",b_black
mesg00b        .null     b_ltblue, "      Change made by this program.     ",b_black
mesg01a        .null     b_blue,   " 1) Obviously the lowercase character  ",b_black
mesg01b        .null     b_blue,   "    set is now selected.               ",b_black
mesg02a        .null     b_purple, " 2) The characterset has been modified ",b_black
mesg02b        .null     b_purple, "    so that the reverse characters are ",b_black
mesg02c        .null     b_purple, "    now displayed by default.          ",b_black
mesg03a        .null     b_ltred,  " 3) The background colour now selects  ",b_black
mesg03b        .null     b_ltred,  "    the character colour and vice-     ",b_black
mesg03c        .null     b_ltred,  "    versa.                             ",b_black
mesg04a        .null     b_orange, " 4) Pros: ",158,"i",28,"n",30,"d",31,"i",129
mesg04b        .null     b_orange, "v",144,"i",149,"d",150,"u",151,"a",153,"l",155
mesg04c        .null     b_orange, " character back-   ",b_black
mesg04d        .null     b_orange, "    ground colour is now available as  ",b_black
mesg04e        .null     b_orange, "    normal text mode.                  ",b_black
mesg05a        .null     b_red,    " 5) Cons: Only one character colour at ",b_black
mesg05b        .null     b_red,    "    the time per screen is available.  ",b_black
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
               lda  xor
               sta  skip+1
nexty          lda  (zpage1),y
skip           eor  #%00000000
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
xor            .byte     $00

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
               .bend 
fname          .byte 64
               .text "0:charset0"      
fname_end      .byte 0
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
