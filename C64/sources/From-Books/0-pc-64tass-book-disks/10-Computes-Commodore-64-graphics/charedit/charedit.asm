;-----------------------------------------------------------------------------
; Projet...: charedit
; Fichier..: charedit.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.2
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
            .include    "local-const.asm"
            .enc        "none"
main        .block
            jsr   pushreg           ; Sauvegarde les registres.
            jsr   scrmaninit        ; Initialise l'écran.
            #disable                ; Inhibe les changements de jeu de carac.
            jsr   drawcredits       ; Affiche l'écran des credits. 
            ;ldx   #$00              ; Attend environ 1 secondes.
waitmore    ;jsr   delay
            ;dex
            ;bpl   waitmore
            jsr   sid_tada          ; Joue le son de bienvenue.
            jsr   screendis         ; Désactive l'affichage vidéo.
            jsr   copycharset       ; Copie la matrice de caractères en ram.
            jsr   cls               ; Efface l'écran
            jsr   setscrptr         ; Sélectione les pointeurs d'écran
            jsr   setdfltchar       ; Choisi le caractère de départ.
            jsr   drawstatic        ; Affiche les elements statiques d'écran.
            jsr   drawbitmap        ; Affiche les informations du caractère.
            lda   #$00              ; Choisi le menu 
            sta   fkeyset           ; ... A au départ.
            jsr   drawfkeys         ; Affiche le menu.
            #affichemesg prompt_msg ; Affiche l'invite.
            jsr   kbflushbuff       ; Vide le tampon du clavier.
            jsr   screenena         ; Active l'affichage vidéo.
            ;-----------------------------------------------------------------
            ; Le coeur du programme se déroule dans cette routine.
            jsr   keyaction         ; 
            ;-----------------------------------------------------------------
            jsr   scrmaninit        ; Initialise l'écran.            
            jsr   drawcredits       ; Affiche l'écran des credits. 
            #printcxy bye_msg       ; Quel clef pour quitter ?
printbye    inc   any_msg           ; Change la couleur de bye_msg.
            #printcxy any_msg       ; l'affiche
            jsr   delay             ; Fais un delai.
            jsr   getin             ; Regarde si une clef est entrée.
            beq   printbye          ; pas de clef, on réaffiche.
            jsr   cls               ; Efface l'écran
endmain     jsr   popreg            ; Récupère les registres.
            jsr   kbflushbuff       ; Vide le tampon du clavier.
            ;jmp   k_warmstart       ; Basic soft start.
            jmp     cint
            ;rts
            .bend

;-----------------------------------------------------------------------------
; Inclure mes propres librairies.
;-----------------------------------------------------------------------------
; Chargement des variables locales
            .include    "local-vars.asm"
; Chargement des macros globales 
            .include    "m-c64-utils.asm"
; et locales.
            .include    "local-macros.asm"
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
; Chargement des librairies à la page $C000.
            *=$c000
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
; Chargement des constantes nécessaires aux librairies.
            .include    "e-c64-kernal.asm"
            .include    "e-c64-vicii.asm"
            .include    "e-c64-basic2.asm"
            .include    "e-c64-sid-ii.asm"
            .include    "e-c64-sid-notes-ntsc.asm"
;-----------------------------------------------------------------------------
