                VERSION="20230326-115700"

                .include "header-c64.asm"
                .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
                ;jsr     initnmi        ; À utiliser avec TMPreu
                ;jsr     setmyint
                jsr     sd_setvectors
                ;rts
                jsr     scrmaninit
                jsr     js_init
                lda     #$80
                sta     curcol
                lda     #0
                sta     bakcol
                lda     #vbleu
                sta     brdcol
                jsr     cls
                lda     #$20
                ora     #%00000000
                ldy     #$04
                ldx     #$04
                jsr     memfill
                lda     #$00
                ldy     #$d8
                jsr     memfill
                jsr     sprt_init
goagain         ldx     #<bstring1 
                ldy     #>bstring1
                jsr     putscxy
                ldx     #<bstring2 
                ldy     #>bstring2
                jsr     putscxy
                ldx     #<bstring3 
                ldy     #>bstring3
                jsr     putscxy
                ;ldx     #<bstring4 
                ;ldy     #>bstring4
                ;jsr     mc_putscxy
                ldx     #<js_status1 
                ldy     #>js_status1
                jsr     putscxy
                ldx     #<js_status2 
                ldy     #>js_status2
                jsr     putscxy
                ldx     #<js_status3 
                ldy     #>js_status3
                jsr     putscxy
                ldx     #<js_status4 
                ldy     #>js_status4
                jsr     putscxy
                ldx     #<js_status5 
                ldy     #>js_status5
                jsr     putscxy
                ldx     #<js_status6 
                ldy     #>js_status6
                jsr     putscxy
                ;rts
                ldx     #$00
                ldy     #$0f
                jsr     gotoxy
                lda     #vjaune
                jsr     setcurcol
                ldx     #$00
                jsr     setbkcol
;                lda     #$00
;nextcar         jsr     mc_putch
;                clc
;                adc     #$01
;                cmp     #64
;                bne     nextcar
looper          jsr     js_scan
                jsr     js_showvals
                jsr     js_updatecurs
                jsr     sprt_move
                ;lda     #$0
                ;sta     c64u_addr1+1
                ;lda     #$00
                ;sta     c64u_addr1
                ;ldy     #10
                ;ldx     #05
                ;jsr     c64u_xy2addr
                ;ldy     c64u_addr2
                ;ldx     c64u_addr2+1
                ;ldx     js_2pixx+1
                ;ldy     js_2pixx
                ;lda     js_2fire
                ;jsr     showregs
                pha
                lda     js_2fire
                and     #$0f
                ;sta     vborder
                eor     #$0f
                beq     nochange
                sta     $d029
                jsr     push
                ldx     #3
                ldy     #22
                jsr     putabinxy
                jsr     pop
nochange        pla
                jmp     looper
                jsr     kstop
                bne     looper
                jsr     k_warmboot
out             rts
                .enc    screen
bstring1        .byte   vvert1,bkcol2,0,0        
                        ;          111111111122222222223333333333
                        ;0123456789012345678901234567890123456789    
                .text   "      Visualisation du port jeu #2      "
                .byte   0
bstring2        .byte   vbleu1,bkcol3,0,1
                .text   "     Programme assembleur pour 6502     "
                .byte   0
bstring3        .byte   vrose,bkcol1,0,2
                .text   "      par Daniel Lafrance (2021) C      "
                .byte   0
bstring4        .byte   vjaune,bkcol1,0,3
                .text   "    Ce programme utilise le port #2     "
                .byte   0
js_status1      .byte   vvert1,bkcol0,19,22
                .text   "   up <----1> haut "
                .byte   0
js_status2      .byte   vbleu1,bkcol0,19,21
                .text   " down <---2-> bas "
                .byte   0
js_status3      .byte   vrose,bkcol0,19,20
                .text   " left <--4--> gauche"
                .byte   0
js_status4      .byte   vjaune,bkcol0,19,19
                .text   "right <-8---> droite"
                .byte   0
js_status5      .byte   vblanc,bkcol0,19,18
                .text   " Fire <1----> Feu"
                .byte   0
js_status6      .byte   vcyan,bkcol0,1,23
                .text   "+-> Joystick status: %---FRLDU EOR #$1F"
                .byte   0

                .bend
                
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .include        "map-c64-basic2.asm"
                .include        "map-c64-kernal.asm"
                .include        "map-c64-vicii.asm"
                .include        "lib-cbm-pushpop.asm"
                .include        "lib-cbm-mem.asm"
                .include        "lib-cbm-hex.asm"
;                .include        "butils.asm"
;                .include        "initnmi.asm"
;                .include        "memutils.asm"
                .include        "lib-c64-text-sd.asm"
                .include        "lib-c64-showregs.asm"                
                .include        "lib-c64-joystick.asm"
                .include        "lib-c64-spriteman.asm"
                