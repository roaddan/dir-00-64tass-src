;-----------------------------------------------------------------------------
; Programme........: Assembleur sous Basic 2.
; IDE..............: Sublime text, Make, 64TASS + 1541 Ultimate II + C64.
; Système..........: Commodore 64 et 64c.
; Programmeur......: Daniel Lafrance.
; Date de création.: Octobre 25 2025.
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; inclusion de l'entête Basic
;-----------------------------------------------------------------------------
            .include    "header-c64.asm"

;-----------------------------------------------------------------------------
; Définition des constantes de couleurs.
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
;-----------------------------------------------------------------------------
; Entete de demarrage de programme sous Basic 2.0 sur le Commodore 64.
; 11 octets de long.
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; Le programme principal main.
;-----------------------------------------------------------------------------
main        .block
            jsr pushall
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
            #print titre
            #print startcmd
            ;-----------------------------------------------------------------
            ; L'appel du programme ci-dessoous.
            ;-----------------------------------------------------------------
            jsr sid_tada
            jsr ti_ronde
            jsr sid_guitar
            ;-----------------------------------------------------------------
            ; Prépare le retour à basic.
            ;-----------------------------------------------------------------
maindone    jsr popall
            rts
            .bend
;-----------------------------------------------------------------------------
; Inclusion des constantes et des librairies.
;-----------------------------------------------------------------------------
            .include    "lib-c64-timer.asm"
            .include    "lib-c64-sid.asm"
            .include    "lib-c64-vicii.asm"
            .include    "lib-c64-basic2.asm"
            .include    "lib-cbm-pushpop.asm"
            .include    "lib-cbm-hex.asm"
            .include    "lib-cbm-mem.asm"
            .include    "chaines_fr.asm"
            .include    "map-c64-basic2.asm"
            .include    "map-c64-kernal.asm"
            .include    "map-c64-sid-2.asm"
            .include    "map-c64-sid-notes-ntsc.asm"
            .include    "map-c64-vicii.asm"
            .include    "macros-64tass.asm"
;-----------------------------------------------------------------------------
; Fin du code.
;-----------------------------------------------------------------------------
