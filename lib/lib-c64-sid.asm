;-----------------------------------------------------------------------------
; Joue un BEEP sur le SID.
;-----------------------------------------------------------------------------
;                   reg,valeur
sid_v1offset     =  0
sid_v2offset     =  7
sid_v3offset     =  14
vic_son         .byte   sid_v1offset + 24,  8        ; sid+24=54296,  15 Volume.
                .byte   sid_v1offset +  5,  190      ; sid+ 5=54277, 190 A.D.S = 0.
                .byte   sid_v1offset +  6,  248      ; sid+ 6=54278, 248 S=Max, r=15
                .byte   sid_v1offset +  1,  $10      ; 
                .byte   sid_v1offset +  0,  $c4      ; 
                .byte   sid_v1offset +  4,  %00010001; sid+ 4=54276,  17 V1S = Triangle.
                .byte   $ff,  $ff
                    
vic_son2        .byte   sid_v2offset + 4,    8      ; sid+24=54296,  15   Volume.
                .byte   sid_v2offset + 5,  190      ; sid+ 5=54277, 190   A.D.S = 0.
                .byte   sid_v2offset + 6,  248      ; sid+ 6=54278, 248   S=Max, r=15
                .byte   sid_v2offset + 1,  $15      ; sid+ 1=54273,  20   Frequence = 40 * 256
                .byte   sid_v2offset + 0,  $20      ; sid+ 1=54273,  20   Frequence = 40 * 256
                .byte   sid_v2offset + 4,  %00100001; sid+ 4=54276,  17   V1S = Triangle.
                .byte   $ff,  $ff
               
vic_son3        .byte   sid_v3offset + 4,    8      ; sid+24=54296,  15   Volume.
                .byte   sid_v3offset + 5,  190      ; sid+ 5=54277, 190   A.D.S = 0.
                .byte   sid_v3offset + 6,  248      ; sid+ 6=54278, 248   S=Max, r=15
                .byte   sid_v3offset + 1,  $19      ; sid+ 1=54273,  20   Frequence = 40 * 256
                .byte   sid_v3offset + 0,  $1f      ; sid+ 1=54273,  20   Frequence = 40 * 256
                .byte   sid_v3offset + 2,  %11111111; sid+ 4=54276,  17   V1S = Triangle.
                .byte   sid_v3offset + 4,  %01000001; sid+ 4=54276,  17   V1S = Triangle.
                .byte   $ff,  $ff



;-------------------------------------------------------------------------------
; Octave 3
;-------------------------------------------------------------------------------
;do3   = $0862 ;  130,83Hz NTSC (hex): hi: $08, lo: $62 ; (dec): lo: 98, Hi:  8
;dod3  = $08E2 ;  138,60Hz NTSC (hex): hi: $08, lo: $E2 ; (dec): lo:226, Hi:  8
;re3   = $0969 ;  146,83Hz NTSC (hex): hi: $09, lo: $69 ; (dec): lo:105, Hi:  9
;red3  = $09F8 ;  155,58Hz NTSC (hex): hi: $09, lo: $F8 ; (dec): lo:248, Hi:  9
;mi3   = $0A90 ;  164,83Hz NTSC (hex): hi: $0A, lo: $90 ; (dec): lo:144, Hi: 10
;fa3   = $0B31 ;  174,63Hz NTSC (hex): hi: $0B, lo: $31 ; (dec): lo: 49, Hi: 11
;fad3  = $0BDB ;  185,00Hz NTSC (hex): hi: $0B, lo: $DB ; (dec): lo:219, Hi: 11
;sol3  = $0C8F ;  196,00Hz NTSC (hex): hi: $0C, lo: $8F ; (dec): lo:143, Hi: 12
;sold3 = $0D4E ;  207,65Hz NTSC (hex): hi: $0D, lo: $4E ; (dec): lo: 78, Hi: 13
;la3   = $0E19 ;  220,00Hz NTSC (hex): hi: $0E, lo: $19 ; (dec): lo: 25, Hi: 14
;lad3  = $0EF0 ;  233,10Hz NTSC (hex): hi: $0E, lo: $F0 ; (dec): lo:240, Hi: 14
;si3   = $0FD3 ;  246,95Hz NTSC (hex): hi: $0F, lo: $D3 ; (dec): lo:211, Hi: 15
;-------------------------------------------------------------------------------
; Octave 4
;-------------------------------------------------------------------------------
;do4   = $10C4 ;  261,65Hz NTSC (hex): hi: $10, lo: $C4 ; (dec): lo:196, Hi: 16
;dod4  = $11C3 ;  277,20Hz NTSC (hex): hi: $11, lo: $C3 ; (dec): lo:195, Hi: 17
;re4   = $12D1 ;  293,65Hz NTSC (hex): hi: $12, lo: $D1 ; (dec): lo:209, Hi: 18
;red4  = $13F0 ;  311,15Hz NTSC (hex): hi: $13, lo: $F0 ; (dec): lo:240, Hi: 19
;mi4   = $1520 ;  329,65Hz NTSC (hex): hi: $15, lo: $20 ; (dec): lo: 32, Hi: 21
;fa4   = $1661 ;  349,25Hz NTSC (hex): hi: $16, lo: $61 ; (dec): lo: 97, Hi: 22
;fad4  = $17B6 ;  370,00Hz NTSC (hex): hi: $17, lo: $B6 ; (dec): lo:182, Hi: 23
;sol4  = $191F ;  392,00Hz NTSC (hex): hi: $19, lo: $1F ; (dec): lo: 31, Hi: 25
;sold4 = $1A9D ;  415,30Hz NTSC (hex): hi: $1A, lo: $9D ; (dec): lo:157, Hi: 26
;la4   = $1C32 ;  440,00Hz NTSC (hex): hi: $1C, lo: $32 ; (dec): lo: 50, Hi: 28
;lad4  = $1DE0 ;  466,20Hz NTSC (hex): hi: $1D, lo: $E0 ; (dec): lo:224, Hi: 29
;si4   = $1FA6 ;  493,90Hz NTSC (hex): hi: $1F, lo: $A6 ; (dec): lo:166, Hi: 31

sid_v1note      .macro xyimm
                jsr pushreg
                lda #<\xyimm
                sta sid+0
                lda #>\xyimm
                sta sid+1
                jsr popreg
                .endm

sid_prog        .macro xyimm
                jsr pushall
                ldx #<\xyimm
                ldy #>\xyimm
                jsr sid_progdata
                jsr popall
               .endm

sid_progtest    .block
                jsr pushall
                ldx #<vic_son
                ldy #>vic_son
                jsr sid_progdata
                jsr popall
                rts
                .bend

;-----------------------------------------------------------------------------
; Programme et configure le sid en fonction de données en mémoire.
; Les données se termines par un couple de $FF
; x (LSB) et Y(MSB) contiennet l'adresse du début des couples de données.
;-----------------------------------------------------------------------------
sid_progdata    .block
;                jsr pushall
                stx $fb
                sty $fc
                lda #$00
                tax
                tay
sid_progcmd     lda ($fb),y        ; On programme le SID pour le son.
                tax
                iny
                lda ($fb),y
                iny
                cpx #$ff
                beq sid_progout
                sta sid,x
                jmp sid_progcmd
sid_progout     
                ;jsr popall
                rts
                .bend

;-----------------------------------------------------------------------------
; clearsid : Remet à 0 tous les registres du SID.
;-----------------------------------------------------------------------------
sid_clear       .block
                php
                pha
                tya
                pha
                lda #$00
                ldy #$1d
sidclrreg       dey
                php
                sta sid,y
                plp
                bne sidclrreg  
                pla
                tay
                pla
                plp
                rts
                .bend

sid_v1off       .block
                php
                pha
                lda #%00010000
                sta vcreg1
                pla
                plp
                rts
                .bend

sid_v2off       .block
                php
                pha
                lda #%00010000
                sta vcreg2
                pla
                plp
                rts
                .bend

sid_v3off       .block
                php
                pha
                lda #%00010000
                sta vcreg3
                pla
                plp
                rts
                .bend

sid_alloff       .block
                php
                pha
                lda #%00010000
                sta vcreg1
                sta vcreg2
                sta vcreg3
                pla
                plp
                rts
                .bend  