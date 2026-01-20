;-----------------------------------------------------------------------------
; Programme........: Assembleur sous Basic 2.
; IDE..............: Sublime text, Make, 64TASS + 1541 Ultimate II + C64.
; Système..........: Commodore 64 et 64c.
; Programmeur......: Daniel Lafrance.
; Date de création.: Octobre 2025.
;-----------------------------------------------------------------------------
; Définition des constantes de couleurs.
;-----------------------------------------------------------------------------
            .include    "header-c64.asm"
;-----------------------------------------------------------------------------
noir    =   0
blanc   =   1
rouge   =   2
cyan    =   3
mauve   =   4
vert    =   5
bleu    =   6
jaune   =   7
orange  =   8
brun    =   9
rose    =   10
grisf   =   11
gris    =   12
vertp   =   13
bleup   =   14
grisp   =   15
;-----------------------------------------------------------------------------
; Constantes d'écran.
;-----------------------------------------------------------------------------
border  =   $d020
back    =   $d021
charcol =   $0286
vidram  =   $0400
colram  =   $d800
;-----------------------------------------------------------------------------
; Constantes SID.
;-----------------------------------------------------------------------------
sid     =   $d400
;-----------------------------------------------------------------------------
; Entete de demarrage de programme sous Basic 2.0 sur le Commodore 64.
; 11 octets de long.
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; Le programme principal main.
;-----------------------------------------------------------------------------
main        php             ; Sauvegarde les flags, ...
            pha             ; ... et les registres, ...
            txa
            pha
            tya
            pha
            lda $fb         ; ... et les pointeurs de zero page.
            pha
            lda $fc
            pha
            lda $fd
            pha
            lda $fe
            pha
;-----------------------------------------------------------------------------
; Met en place les couleurs de l'écran.
;-----------------------------------------------------------------------------
            lda #cyan       ; Bleu ocean pour ...
            sta border      ; ... la bordure, ...
            lda #blanc      ; ... blanc pour  ...
            sta back        ; ... le fond et  ...
            lda #noir       ; ... noir pour   ...
            sta charcol     ; ... les caractères.
            lda #147        ; 147 = Effacement d'éctan.
            jsr $ffd2       ; On efface l'écran
            ;-----------------------------------------------------------------
            ; Affiche le bonjour
            ;-----------------------------------------------------------------
            ;jsr delai
            jsr bonjour
            ;-----------------------------------------------------------------
            ; L'appel du programme ci-dessoous.
            ;-----------------------------------------------------------------
            ldx #20
loop        dex
            beq maindone
            jsr bip
            jsr delai
            jsr bip2
            jsr delai
maindone    nop
            ;-----------------------------------------------------------------
            ; Prépare le retour à basic.
            ;-----------------------------------------------------------------
            pla             ; On récupère les pointeurs zero-page, ...
            sta $fe
            pla
            sta $fd
            pla
            sta $fc
            pla
            sta $fb
            pla             ; ... les registres, ...
            tay
            pla
            tax
            pla
            plp
            rts
;-----------------------------------------------------------------------------
; delai
;-----------------------------------------------------------------------------
delai       php
            pha
            txa
            pha
            tya
            pha
            lda #$00
            tax
 delx       tay
 dely       iny
            cpy #$00
            bne dely
            inx
            cpx #$00
            bne delx
            pla
            tay
            pla
            tax
            pla
            plp
            rts           

;-----------------------------------------------------------------------------
; bonjour
;-----------------------------------------------------------------------------
bonjour     php
            pha
            tya
            pha
            ldy #>str0          ;on pointe la chaine
            lda #<str0  
            jsr $ab1e
            pla
            tay
            pla
            plp
            rts
str0        .null   "  [  sidtest02 par daniel lafrance.  ]"
;-----------------------------------------------------------------------------
; out2bit7.: Affiche une chaine de charactère dont le bit 7 du dernier 
;            charactère est à 1. %1xxxxxxx
; entrée...: adresse de la chaine : y=MSB, x=LSB.
; action...: Sauvegarde les registres et ZP1.
;-----------------------------------------------------------------------------
outbit7     php
            pha
            txa
            pha
            tya
            pha
            lda $fb
            pha
            lda $fc
            pha
            sty $fc             ; STRPTR dans ZP1.
            stx $fb
            ldy #$00            ; Offset à 0.
nextst7     lda ($fb),y         ; On charge le caractère. 
            iny                 ; Offset = offset +1
            pha                 ; Sauve une copie
            and #$7f            ; On masque le bit 7 pour ...
            jsr $ddf2           ; ... l'afficher.
            pla                 ; On reprend la copie.
            and #$80            ; Si le bit 7 est à 0 ...
            beq nextst7         ; ... on passe au prochain caractère.
            pla
            sta $fc
            pla
            sta $fb
            pla
            tay
            pla
            tax
            pla
            plp
            rts
;-----------------------------------------------------------------------------
; inczp1 : Incrémente le pointeur indirect ZP1.
;-----------------------------------------------------------------------------
inczp1      php
            pha
            lda $fb             ; Charge le LSB.
            clc
            adc #$01            ; On aditionne 1 à l'accumulateur.
            bcc norepzp1        ; Pas de report si le carry bit est à 0.
            inc $fc
norepzp1    sta $fb
            pla
            plp
            rts

;-----------------------------------------------------------------------------
; inczp2 : Incrémente le pointeur indirect ZP2.
;-----------------------------------------------------------------------------
inczp2      php
            pha
            lda $fb             ; Charge le LSB.
            clc
            adc #$01            ; On aditionne 1 à l'accumulateur.
            bcc norepzp2        ; Pas de report si le carry bit est à 0.
            inc $fe
norepzp2    sta $fd
            pla
            plp
            rts

;-----------------------------------------------------------------------------
; clearsid : Remet à 0 tous les registres du SID.
;-----------------------------------------------------------------------------
clearsid    php
            pha
            tya
            pha
            lda #$00
            ldy #$1d
clrsidreg   sta sid,y
            dey 
            bne clrsidreg  
            pla
            tay
            pla
            plp
            rts
;-----------------------------------------------------------------------------
; Joue un BEEP sur le SID.
;-----------------------------------------------------------------------------
;                   reg,valeur
bipson      .byte   24, 15      ; Volume au maximum.
            .byte   1,  20      ; Frequence = 20 * 256
            .byte   5,  0       ; A.D.S = 0.
            .byte   6,  15*16+9 ; S=Max, r=15
            .byte   4,  1+16    ; V1S = Triangle.
            .byte   4,  16      ; V1R = Triangle
bip         jsr clearsid
            php
            pha
            txa
            pha
            tya
            pha
            lda #$00
            tax
            tay
bipcmd      ldx bipson,y        ; On programme le SID pour le son.
            iny
            lda bipson,y
            iny
            cpy #$ff
            beq bipout
            sta sid,x
            jmp bipcmd
bipout      pla
            tay
            pla
            tax
            pla
            plp
            rts
;-----------------------------------------------------------------------------
; En mode direct.
;-----------------------------------------------------------------------------
bip2        jsr clearsid
            php
            pha
            lda #15
            sta sid+24
            lda #30
            sta sid+1
            lda #5
            sta sid
            lda #(15*16+9)
            sta sid+6
            lda #(16+1)
            sta sid+4
            lda #16
            sta sid+4
            pla
            plp
            rts
