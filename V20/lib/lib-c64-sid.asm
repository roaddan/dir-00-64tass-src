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
; Les données se termines par un couple de $FF.
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

sid_tada        .block
                #sid_prog vic_son
                jsr ti_dcroche
                #sid_v1note re4
                jsr ti_dcroche
                #sid_v1note mi4
                jsr ti_dcroche
                #sid_v1note fa4
                jsr ti_dcroche
                #sid_v1note sol4
                jsr ti_dcroche
                #sid_v1note la4
                jsr ti_dcroche
                #sid_v1note si4
                jsr ti_dcroche
                #sid_v1note do5
                #sid_prog vic_son2
                #sid_prog vic_son3
                jsr ti_blanche
                jsr sid_alloff
                rts
                .bend

sid_guitar        .block
                #sid_prog vic_son
                jsr ti_dcroche
                #sid_v1note mi3
                jsr ti_blanche
                #sid_v1note la3
                jsr ti_blanche
                #sid_v1note re4
                jsr ti_blanche
                #sid_v1note sol4
                jsr ti_blanche
                #sid_v1note si4
                jsr ti_blanche
                #sid_v1note mi5
                jsr ti_ronde
                jsr sid_alloff
                rts
                .bend



sid_lib_vector  .word   sid_v1off,sid_v2off,sid_v3off

ti_dcroche  .block
            php
            pha
            txa
            pha
            ldx #$10
            jsr delai
            pla
            tax
            pla
            plp
            rts
            .bend

ti_croche   .block
            jsr ti_dcroche
            jsr ti_dcroche
            rts
            .bend

ti_noire    .block
            jsr ti_croche
            jsr ti_croche
            rts
            .bend

ti_blanche  .block
            jsr ti_noire
            jsr ti_noire
            rts
            .bend

ti_ronde    .block
            jsr ti_blanche
            jsr ti_blanche
            rts
            .bend


ti_vector   .byte   $20, <ti_dcroche,>ti_dcroche
            .byte   $20, <ti_croche,>ti_croche
            .byte   $20, <ti_noire,>ti_noire
            .byte   $20, <ti_blanche,>ti_blanche
            .byte   $20, <ti_ronde,>ti_ronde

            jsr ti_vector
