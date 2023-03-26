                .include "header-c64.asm"
                .include "macros-64tass.asm"

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
                jsr scrmaninit
                jsr push
                #printcxy auteur
                jsr pop
                ;jsr savetofile
                rts
                .bend
auteur          .byte   vnoir, 2, 24
                .null   "daniel Lafrance 2023"
msg             .byte   vnoir, 3, 24
                .null   "saving ... "
save2file       .block
                jsr push
                jsr $aefd
                jsr $e1d4
                jsr $aefd
                jsr $ad8a
                jsr $b7f7
                lda $14
                pha
                lda $15
                pha
                jsr $aefd
                jsr $ad8a
                jsr $b7f7
                ldx $14
                ldy $15
                pla
                sta $fc
                pla
                sta $fb
                lda #$fb
                jsr $e15f
                jsr pop
                rts
                .bend
savetofile      .block
                jsr push
                lda #1          ; Logical file number
                ldx #8          ; Device number
                ldy #255        ; No command
                jsr setlfs
                lda #$08        ; Filename lenght
                ldx #<fname     ; ptr to
                ldy #>fname     ;filename
                jsr setnam  
                lda #$00    
                sta $0a         ; 0=load/save 1=verify
                lda #$00 ;#<main      ; Le LSB ...  
                sta txttab      ; ... et ...
                lda #$e0 ;#>main      ; ... le MSB de l'adresse ...
                sta txttab+1    ; ... du debut dans txttab. 
                ldx #$00 ;#<prgend    ; Adresse de fin dans X ...
                ldy #$00 ;#>prgend    ; ... et Y.
                lda txttab      ; Le zeropage de txttab dans A.
                jsr push
                #printcxy msg   ; on affiche le message ...
                #print fname    ; ... de sauvegarde.
                jsr pop
                jsr save        ; On sauvegarde.
                lda #$01
                jsr close
                jsr pop
                rts
fname           .null   "kernal64"
prgend
                .bend


                
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .include "map-kernal-c64.asm"
                .include "map-vicii.asm"
                .include "map-basic2-c64.asm"
                .include "lib-basic2-c64.asm" 
                .include "lib-cbm-pushpop.asm"
                .include "lib-cbm-mem.asm"
                .include "lib-cbm-hex.asm"
;                .include "lib-c64-text-sd.asm"
;                .include "lib-c64-text-mc.asm"
                .include "lib-cbm-showregs.asm"                
                .include "lib-cbm-joystick.asm"
                .include "lib-c64-spriteman.asm"
