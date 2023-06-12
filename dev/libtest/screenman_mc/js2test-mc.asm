               VERSION="20230611-222455"
               .include "header-c64.asm"
               .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
 ;             jsr initnmi        ; À utiliser avec TMPreu
 ;             jsr setmyint
 ;             rts
               jsr  screendis
               jsr scrmaninit
               jsr js_init
               lda #$80
               sta curcol
               lda #0
               sta vicbackcol
               lda #vvert
               sta vicbordcol
               jsr cls
               lda #$20
               ora #%00000000
               ldy #$04
               ldx #$04
               jsr memfill
               lda #$00
               ldy #$d8
               jsr memfill
               jsr sprt_init
goagain        jsr setinverse
               #printcxy bstring1
               #printcxy bstring2
               #printcxy bstring3
               #printcxy bstring4
               jsr clrinverse
               #printcxy js_status1
               #printcxy js_status2
               #printcxy js_status3
               #printcxy js_status4
               #printcxy js_status5
               #printcxy js_status6
               #printcxy version
               ldx #$00
               ldy #$0f
               jsr gotoxy
               lda #vjaune
               jsr setcurcol
               ldx #$00
               jsr setbkcol
               jsr screenena
looper         jsr js_scan
               jsr putjs2val
               jsr js_showvals
;              jsr js_updatecurs
               jsr sprt_move
loopit         pha
               lda js_2fire
               beq nochange  
               jsr putjs2val                 
               lda vicbordcol
               clc
               adc #$0
               and #$0f
               sta vicbordcol
               lda js_2y
               cmp #$04
               bne toborder
               lda js_2x
               cmp #$0b
               bmi toborder
               cmp #$1d
               bpl toborder
               inc sprt_ptr
               lda sprt_ptr
               cmp #9         
               bcc drawsptr
               lda #$00
drawsptr       sta sprt_ptr
               jsr sprt_init
toborder       lda vicbordcol
               sec
               adc #0
               and #$0f
               sta $d029
               lda #$00
               sta js_2fire    
nochange       inx 
               pla
               jsr kstop
               bne looper
               jmp looper
               jsr k_warmboot
out            rts

putjs2val      php
               pha
               ldx #$16
               ldy #$11
               jsr gotoxy
               lda #vvert1
               jsr setcurcol
               lda js_2status
               jsr putabinfmt
               pla 
               plp
               rts 

onebyte        .byte   0    
               .enc    screen
bstring1       .byte   vblanc,bkcol3,0,0        
;                                111111111122222222223333333333
;                       0123456789012345678901234567890123456789    
               .null   "      Visualisation du port jeu #2      "
bstring2       .byte   vblanc,bkcol1,0,1
               .null   " Programme assembleur pour 6510 sur C64 "
bstring3       .byte   vnoir,bkcol2,0,2
               .null   "   par Daniel Lafrance (c) 2021-2023    "
bstring4       .byte   vcyan,bkcol3,11,4
               .null   " Changer pointeur "
js_status1     .byte   vcyan,bkcol0,19,22
               .null   "   up <----1> haut "
js_status2     .byte   vbleu1,bkcol0,19,21
               .null   " down <---2-> bas "
js_status3     .byte   vrose,bkcol0,19,20
               .null   " left <--4--> gauche"
js_status4     .byte   vjaune,bkcol0,19,19
               .null   "right <-8---> droite"
js_status5     .byte   vblanc,bkcol0,19,18
               .null   " Fire <1----> Feu"
js_status6     .byte   vgray2,bkcol0,1,23
               .null   "+-> Etat de JS2:     %---FRLDU EOR #$1F"
version        .byte   vnoir,bkcol3,0,24
               .null   format("        Version: %s        ",VERSION)
               .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include "map-c64-kernal.asm"
               .include "map-c64-vicii.asm" 
               .include "lib-c64-vicii.asm" 
               .include "lib-cbm-pushpop.asm"
               .include "lib-cbm-mem.asm"
               .include "lib-cbm-hex.asm"
;               .include "lib-c64-text-sd.asm"
               .include "lib-c64-text-mc.asm"
               .include "lib-c64-showregs.asm"               
               .include "lib-c64-joystick.asm"
               .include "lib-c64-spriteman.asm"
                
               
