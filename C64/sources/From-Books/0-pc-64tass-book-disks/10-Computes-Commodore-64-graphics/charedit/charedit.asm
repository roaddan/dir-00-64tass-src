;-----------------------------------------------------------------------------
; Projet...: charedit
; Fichier..: charedit.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.2
; Révision.: 20261028-000000
;-----------------------------------------------------------------------------
; Historique des révisions:
; --------------------------
; 2026-10-16 - Ajout et francisation des commentaires.
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
version  = "20261028       " 
;-----------------------------------------------------------------------------
               .include    "h-header-c64.asm"
               .enc        "none"
main           .block
               jsr   push           ; Sauvegarde les registres.
               jsr   scrmaninit     ; Initialise l'écran.
               jsr   cls
               lda   #$01
               ldx   #$02
               ldy   #$03
               sta   zpage1
               stx   zpage1+1
               stx   zpage2
               sty   zpage2+1
               #printregs
               jsr   pop
               brk
               jsr   push           ; Sauvegarde les registres.
               jsr   scrmaninit     ; Initialise l'écran.
               #disable             ; Inhibe les changements de jeu de carac.
               jsr   drawcredits    ; Affiche l'écran des credits. 
               ;ldx   #$00           ; Attend environ 1 secondes.
waitmore       ;jsr   delay
               ;dex
               ;bpl   waitmore
               jsr   sid_tada       ; Joue le son de bienvenue.
               ;jsr   screendis      ; Désactive l'affichage vidéo.
               jsr   copycharset    ; Copie la matrice de caractères en ram.
               jsr   cls            ; Efface l'écran
               jsr   setscrptr      ; Sélectione les pointeurs d'écran
               jsr   setdfltchar    ; Choisi le caractère de départ.
               jsr   drawstatic     ; Affiche les elements statiques d'écran.
               jsr   drawbitmap     ; Affiche les informations du caractère.
               lda   #$00           ; Choisi le menu 
               sta   fkeyset        ; ... A au départ.
               jsr   drawfkeys      ; Affiche le menu.
               #putmesg prompt_msg  ; Affiche l'invite.
               jsr   kbflushbuff    ; Vide le tampon du clavier.
               ;jsr   screenena      ; Active l'affichage vidéo.
               ;---------------------------------------------------------------
               ; Le coeur du programme se déroule dans cette routine.
               jsr   keyaction      ; 
               ;---------------------------------------------------------------
               jsr   scrmaninit     ; Initialise l'écran.            
               jsr   drawcredits    ; Affiche l'écran des credits. 
               #printcxy bye_msg    ; Quel clef pour quitter ?
printbye       inc   any_msg        ; Change la couleur de bye_msg.
               #printcxy any_msg    ; l'affiche
               jsr   delay          ; Fais un delai.
               jsr   getin          ; Regarde si une clef est entrée.
               beq   printbye       ; pas de clef, on réaffiche.
               jsr   cls            ; Efface l'écran
endmain        jsr   pop            ; Récupère les registres.
               ;jsr   kbflushbuff    ; Vide le tampon du clavier.
               rts
               .bend

;-----------------------------------------------------------------------------
; Inclure mes propres librairies.
;-----------------------------------------------------------------------------
; Chargement des macros globales 
            .include    "m-c64-utils.asm"    ; Macros générales du C64
; et locales.
            .include    "local-macros.asm"   ; Macros de ce programmes
;-----------------------------------------------------------------------------
; Chargement des variables locales
;-----------------------------------------------------------------------------
            *=$0a00
            .include    "v_c64_showregs.asm"
            .include    "local-vars.asm"     ; Variables de ce programme.
;-----------------------------------------------------------------------------
; Chargement des constantes et des chaines de caractères locales.
;-----------------------------------------------------------------------------
               .include    "local-const.asm"
               .include    "strings_fr.asm"     ; Les chaines en français.
;               .include    "strings_en.asm"     ; Les chaines en anglais.
;-----------------------------------------------------------------------------
; ... et du code spécifique au programmes.
;-----------------------------------------------------------------------------
            .include    "routines.asm"       ; Les routines de ce programme.
;-----------------------------------------------------------------------------
; Chargement en RAM des variables des librairies à la suite du programme.
;-----------------------------------------------------------------------------
            .include    "v-c64-vars.asm"     ; Les variables générales du C64.
            .include    "v-cbm-vars.asm"
;-----------------------------------------------------------------------------
; Chargement des librairies à la page $C000.
;-----------------------------------------------------------------------------
            *=$c000                          ; Les librairies de code:
            .include    "l-c64-timer.asm"    ; ... divers de delais,  
            .include    "l-c64-sid.asm"      ; ... d'utilisation du SID,
            .include    "l-c64-vicii.asm"    ; ... d'utilisation du VICII,
            .include    "l-c64-basic2.asm"   ; ... de routine utilisant Basic.
            .include    "l-cbm-stack.asm"    ; ... de gestion de la pile.
            .include    "l-cbm-mem.asm"      ; ... de gestion mémoire,
            .include    "l-cbm-keyb.asm"     ; ... d'utilisation du clavier, 
            .include    "l-cbm-disk.asm"     ; ... d'utilisation des media. 
            .include    "l-cbm-conv.asm"     ; ... de conversions diverses, 
            .include    "l-c64-showregs.asm"
;-----------------------------------------------------------------------------
; Chargement des constantes nécessaires aux librairies.
                                                  ; Les constantes associées; 
            .include    "e-c64-kernal.asm"        ; ... au noyeau (Kernal),
            .include    "e-c64-vicii.asm"         ; ... au VICII,
            .include    "e-c64-basic2.asm"        ; ... à la ROM Basic,
            .include    "e-c64-sid-ii.asm"        ; ... au SID,
            .include    "e-c64-sid-notes-ntsc.asm"; ... aux fréquences NTSC.
;-----------------------------------------------------------------------------
