;-----------------------------------------------------------------------------
; Projet...: charedit
; Fichier..: charedit.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.1
; Révision.: 20261021-193200
;-----------------------------------------------------------------------------
; Historique des révisions:
; --------------------------
; 2026-10-16 - Ajout et francisation des commentaires.
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
version  = "20261021-193200" 
;-----------------------------------------------------------------------------
            .include    "e-header-c64.asm"
            .include    "localcons.asm"
            .enc        "none"
main        .block
            jsr   pushreg
            jsr   scrmaninit
            #disable
            jsr   drawcredits
            ldx   #$03             ; Attend environ 5 secondes.
waitmore    jsr   delay
            dex
            bne   waitmore
            jsr   sid_tada
            #printcxy menu_msg
            jsr   screendis
            jsr   copycharset
            jsr   cls
            jsr   setscrptr
            jsr   setdfltchar
            jsr   drawstatic
            jsr   drawbitmap
            lda   #$00
            sta   fkeyset
            jsr   drawfkeys
            lda   #$00
            #affichemesg prompt_msg
            jsr   kbflushbuff
            jsr   screenena 
            ;-----------------------------------------------------------------
            ; Le coeur du programme se déroule dans cette routine
            jsr   keyaction         
            ;-----------------------------------------------------------------
            jsr   cls
            jsr   drawcredits
            #printcxy any_msg
printbye    inc   bye_msg
            #printcxy bye_msg
            jsr   delay
            jsr   getin
            beq   printbye
            jsr   cls       
endmain     jsr   popreg
            jmp   k_warmstart 
            .bend

;-----------------------------------------------------------------------------
; Including my self written libraries.
;-----------------------------------------------------------------------------
; chargement des variables locales
            .include    "localvars.asm"
; Chargement des macros globales 
            .include    "m-c64-utils.asm"
; et locales.
            .include    "localmacro.asm"
;-----------------------------------------------------------------------------
; Chargement du code spécifique au programmes et ...
            .include    "routines.asm"
; ... de ses chaines de caractères, ..
            .include    "strings_fr.asm"
;            .include    "strings_en.asm"
;-----------------------------------------------------------------------------
; Chargement en RAM des variables des librairies à la suite du programme.
            .include    "e-c64-vars.asm"
;-----------------------------------------------------------------------------
*=$c000
; Chargement des librairies à la page $C000.
            .include    "l-c64-timer.asm"
            .include    "l-c64-sid.asm"
            .include    "l-c64-vicii.asm"
            .include    "l-c64-basic2.asm" 
            .include    "l-cbm-push.asm"
            .include    "l-cbm-mem.asm"
            .include    "l-cbm-hex.asm"
            .include    "l-cbm-keyb.asm"
            .include    "l-cbm-disk.asm"
            .include    "l-c64-std-showregs.asm"
;-----------------------------------------------------------------------------
; Chargement des constantes nécessaires aux librairies et au programmes.
            .include    "e-c64-kernal.asm"
            .include    "e-c64-vicii.asm"
            .include    "e-c64-basic2.asm"
            .include    "e-c64-sid-ii.asm"
            .include    "e-c64-sid-notes-ntsc.asm"
;-----------------------------------------------------------------------------


