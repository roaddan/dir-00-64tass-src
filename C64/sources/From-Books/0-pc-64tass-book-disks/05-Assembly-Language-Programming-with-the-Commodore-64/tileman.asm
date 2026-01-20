;----------------------------------------------------------------------
; Fonction .: tileman
; Auteur ...: Daniel Lafrance
; Date .....: 2022-07-20
; Révision .: 0.0.1
; ---------------------------------------------------------------------
; Description:
; 
; ---------------------------------------------------------------------
; Démarrage par Basic 2.0 
            *=          $801
            .word (+),  10
            .null $9e,  "2061"
            + .word     0
            .enc    "screen"    ; Chaines encodé en code écran $01="A"
; ---------------------------------------------------------------------
; Saute au programme principal.
            jmp     main
; ---------------------------------------------------------------------
; Définitions de constantes locales.
; ---------------------------------------------------------------------
temp    =   $02
hours   =   $dc0b
minuts  =   $dc0a
secnds  =   $dc09
tenths  =   $dc08
; ---------------------------------------------------------------------
; Variables Globales.
; ---------------------------------------------------------------------

main        .block
            jsr push
modetest    jsr modemcgraf
            jsr getbyt
            jsr modestdcar
            jsr pop
            rts
            .bend

modemcgraf  .block
            jsr push
            lda #$3b
            sta vic11
            lda #$18
            sta vic16
            lda #$14
            sta vic18
            jsr pop
            rts
            .bend

modestdcar  .block
            jsr push
            lda #$1b
            sta vic11
            lda #$08
            sta vic16
            lda #$14
            sta vic18
            jsr pop
            rts
            .bend

;----------------------------------------------------------------------
; Utilise utilise les macros suivantes:   
;----------------------------------------------------------------------
.include    "c64_map_kernal.asm"    ; inclus un instruction "jmp main".
.include    "c64_map_basic2.asm" 
.include    "c64_map_vicii.asm" 
;----------------------------------------------------------------------
; Utilise utilise les librairies suivantes:   
;----------------------------------------------------------------------
.include    "c64_lib_pushpop.asm"
;----------------------------------------------------------------------
;*=$c000
;-----------------------------------------------------------
