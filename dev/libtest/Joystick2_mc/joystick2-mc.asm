*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include  "c64_map_kernal.asm"
               .include  "c64_map_vicii.asm" 
               .include  "c64_lib_pushpop.asm"
               .include  "c64_lib_mem.asm"
               .include  "c64_lib_hex.asm"
;               .include  "c64_lib_text_sd_new.asm"
               .include  "c64_lib_text_mc.asm"
               .include  "c64_lib_showregs.asm"                
               .include  "c64_lib_joystick.asm"
               .include  "c64_lib_spriteman.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
 ;               jsr    initnmi        ; À utiliser avec TMPreu
 ;               jsr    setmyint
 ;               rts
                jsr     scrmaninit
                jsr     js_init
                lda     #$80
                sta     curcol
                lda     #0
                sta     vicbackcol
                lda     #vbleu
                sta     vicbordcol
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
goagain         jsr     setinverse
                ldx     #<bstring1 
                ldy     #>bstring1
                jsr     putscxy
                
                ldx     #<bstring2 
                ldy     #>bstring2
                jsr     putscxy
                ldx     #<bstring3 
                ldy     #>bstring3
                jsr     putscxy
                ldx     #<bstring4 
                ldy     #>bstring4
                jsr     putscxy
                jsr     clrinverse
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
 ;               rts
                ldx     #$00
                ldy     #$0f
                jsr     gotoxy
                lda     #vjaune
                jsr     setcurcol
                ldx     #$00
                jsr     setbkcol
;                lda     #$00
;nextcar         jsr     putch
;                clc
;                adc     #$01
;                cmp     #64
;                bne     nextcar
                
looper         ;jsr  showregs
               jsr  js_scan
               jsr     js_showvals
;               jsr     js_updatecurs
               jsr     sprt_move
loopit         
;               jsr     showregs
               ldx     #$16
               ldy     #$11
               jsr     gotoxy
               lda     #3
               jsr     setcurcol
               inc     onebyte
               lda     onebyte
               lda     js_2fire
               jsr     putabinfmt
;               jsr     showregs
;               jsr     putabin
;               jmp     loopit
;               rts
;               lda     #$0
;               sta     c64u_addr1+1
;               lda     #$00
;               sta     c64u_addr1
;               ldy     #10
;               ldx     #05
;               jsr     c64u_xy2addr
;               ldy     c64u_addr2
;               ldx     c64u_addr2+1
;               ldx     js_2pixx+1
;               ldy     js_2pixx
;               lda     js_2fire
;               jsr     showregs
               pha
               lda     js_2fire
               beq     nochange     
               lda     vicbordcol
               clc
               adc     #$0
               and     #$0f
               sta     vicbordcol
               lda     js_2y
               cmp     #$04
               bne     toborder
               lda  js_2x
               cmp  #$0b
               bmi  toborder
               cmp  #$1d
               bpl  toborder
               inc  sprt_ptr
               lda  sprt_ptr
               jsr  showregs
               cmp  #9         
               bcc  drawsptr
               lda  #$00
drawsptr       sta  sprt_ptr
               jsr     sprt_init
;               jsr  showregs    
toborder       lda     vicbordcol
               sec
               adc     #0
               and     #$0f
               sta     $d029
               lda     #$00
               sta     js_2fire    
nochange       ;jsr  showregs
               inx 
               pla
               jsr     kstop
               bne     looper
               jsr     k_warmboot
out            rts
onebyte        .byte   0    
               .enc    "screen"
bstring1       .byte   vjaune,bkcol0,0,0        
;                                 111111111122222222223333333333
;                       0123456789012345678901234567890123456789    
               .text   "      Visualisation du port jeu #2      "
               .byte   0
bstring2       .byte   vjaune,bkcol1,0,1
               .text   " Programme assembleur pour 6502 sur C64 "
               .byte   0
bstring3       .byte   vbleu1,bkcol2,0,2
               .text   "      par Daniel Lafrance (2021) C      "
               .byte   0
bstring4       .byte   vjaune,bkcol3,11,4
               .text   " Changer pointeur "
               .byte   0
js_status1     .byte   vvert1,bkcol0,19,22
               .text   "   up <----1> haut "
               .byte   0
js_status2     .byte   vbleu1,bkcol0,19,21
               .text   " down <---2-> bas "
               .byte   0
js_status3     .byte   vrose,bkcol0,19,20
               .text   " left <--4--> gauche"
               .byte   0
js_status4     .byte   vjaune,bkcol0,19,19
               .text   "right <-8---> droite"
               .byte   0
js_status5     .byte   vblanc,bkcol0,19,18
               .text   " Fire <1----> Feu"
               .byte   0
js_status6     .byte   vcyan,bkcol0,1,23
               .text   "+-> Etat de JS2:     %---FRLDU EOR #$1F"
               .byte   0
               .bend
                
                
