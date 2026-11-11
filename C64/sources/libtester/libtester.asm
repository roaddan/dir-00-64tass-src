;-----------------------------------------------------------------------------
; Projet...: libtest
; Fichier..: libtest.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1.2
; Révision.: 20261028-000000
;-----------------------------------------------------------------------------
; Historique des révisions:
; --------------------------
; 2026-10-16 - Ajout et francisation des commentaires.
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
version  = "20261028     " 
;-----------------------------------------------------------------------------
               .include "h-header-c64.asm"
               .enc     "none"
point1         .word $4321
point2         =     $0402
main           .block
               #tolower
               #setzpage1  24*40
               ;#drawbox  2,2,20,15,cblanc,chaine 
               lda   colram 
               ;jsr   sid_tada
               ; On met les registres à zero.   
               lda   #$00
               #deekxy  motvide
               ; On charge a et x à la valeur de mot.
               #deekax  mot
               ; On copie mot dans mot 2.
               #dokeax  mot2
               ; On vide AX
               #deekax  motvide
               ; On le recharge avec mot 2 A=$12 x=$34
               #deekax  mot2
               #showregs            ; = = = = = S H O W R E G S = = = = = = = =
               inc   mot
               #deekax  motvide
               #deekax  mot
               #showregs            ; = = = = = S H O W R E G S = = = = = = = =
               #deekay  motvide
               #deekxy  mot2
               #showregs            ; = = = = = S H O W R E G S = = = = = = = =
               #deekxy  motvide
               #deekyx  mot2
               #showregs            ; = = = = = S H O W R E G S = = = = = = = =
               rts
               .bend

mot            .word $1234           
motvide        .word $000
mot2           .word $000
chainecol      .byte 15
chainepos      .byte 10,10
chaine         .null "chaine test."
;-----------------------------------------------------------------------------
; Inclure mes propres librairies.
;-----------------------------------------------------------------------------
; Chargement des macros locales.
               .include "local-macros.asm"      ; Macros de ce programmes
;-----------------------------------------------------------------------------
; ... et du code spécifique au programmes.
;-----------------------------------------------------------------------------
               .include "local-code.asm"        ; Les routines de ce programme.
;-----------------------------------------------------------------------------
; Chargement des variables locales
;-----------------------------------------------------------------------------
               .include "local-variables.asm"  ; Variables de ce programme.
;-----------------------------------------------------------------------------
; Chargement des chaines de caractères locales.
;-----------------------------------------------------------------------------
               .include "local-francais.asm"    ; Les chaines en français.
;               .include "local-english.asm"     ; Les chaines en anglais.
;-----------------------------------------------------------------------------
; Chargement des constantes locales.
;-----------------------------------------------------------------------------
;               .include "local-constantes.asm"
;-----------------------------------------------------------------------------
; Inclure les macros globales.
;-----------------------------------------------------------------------------
; Chargement des macros globales 
               .include "m-c64-utils.asm"    ; Macros générales du C64
;-----------------------------------------------------------------------------
; Chargement en RAM des variables des librairies à la suite du programme.
;-----------------------------------------------------------------------------
               .include "v-c64-vars.asm"     ; Les variables générales du C64.
               .include "v-cbm-vars.asm"
               .include "v-c64-showregs.asm"
;-----------------------------------------------------------------------------
; Chargement des librairies à la page $C000.
;-----------------------------------------------------------------------------
               *=$c000                       ; Les librairies de code:
romstart       jmp   romstart
               .include "l-c64-timer.asm"    ; ... divers de delais,  
               .include "l-c64-sid.asm"      ; ... d'utilisation du SID,
               .include "l-c64-vicii.asm"    ; ... d'utilisation du VICII,
               .include "l-c64-basic2.asm"   ; ... de routine utilisant Basic.
               .include "l-cbm-stack.asm"    ; ... de gestion de la pile.
               .include "l-cbm-mem.asm"      ; ... de gestion mémoire,
               .include "l-cbm-keyb.asm"     ; ... d'utilisation du clavier, 
               .include "l-cbm-disk.asm"     ; ... d'utilisation des media. 
               .include "l-cbm-conv.asm"     ; ... de conversions diverses, 
               .include "l-c64-showregs.asm"
               .include "l-c64-drawbox.asm"
romend         jmp   romend
;-----------------------------------------------------------------------------
; Chargement des constantes nécessaires aux librairies.
                                                  ; Les constantes associées; 
               .include "e-c64-kernal.asm"        ; ... au noyeau (Kernal),
               .include "e-c64-vicii.asm"         ; ... au VICII,
               .include "e-c64-basic2.asm"        ; ... à la ROM Basic,
               .include "e-c64-sid-ii.asm"        ; ... au SID,
               .include "e-c64-sid-notes-ntsc.asm"; ... aux fréquences NTSC.
;-----------------------------------------------------------------------------
