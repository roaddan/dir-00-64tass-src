;-----------------------------------------------------------------------------
; Projet...: 
; Fichier..: template.asm
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
               .include "h-header-c64.asm"
               .enc     "none"
couleur1       .byte 14
patern         .byte %00000000
main           .block
               php
               jsr   cls
               #tolower
               #outstr   texte_m
               jsr   screendis
               jsr   sub_g
               jsr   sub_c
               jsr   paintbkgnd
               jsr   maingraph
               jsr   drawman
mainloop       jsr   screenena
               jsr   getkey
               jsr   screendis

isit_splus     cmp   #$db
               bne   isit_smoins
               inc   patern
               jsr   sub_c
               jsr   paintbkgnd
               jmp   mainloop

isit_smoins    cmp   #$dd
               bne   isit_plus
               dec   patern
               jsr   sub_c
               jsr   paintbkgnd
               jmp   mainloop

isit_plus      cmp   #'+'
               bne   isit_moins
               inc   couleur1
               jsr   sub_c
               jsr   paintbkgnd
               jmp   mainloop

isit_moins     cmp   #'-'
               bne   isit_0
               dec   couleur1
               jsr   sub_c
               jsr   paintbkgnd
               jmp   mainloop

isit_0         cmp   #'0'
               bne   isit_1
               lda   #$0
               sta   patern
               jsr   paintbkgnd
               jmp   mainloop

isit_1         cmp   #'1'
               bne   isit_b
               lda   #$ff
               sta   patern
               jsr   paintbkgnd
               jmp   mainloop

isit_b         cmp   #'b'
               bne   isit_g
               inc   patern
               jsr   paintbkgnd
               jmp   mainloop

isit_g         cmp   #'g'
               bne   isit_t
               jsr   sub_g
               jmp   mainloop

isit_t         cmp   #'t'
               bne   isit_c
               jsr   sub_t
               jmp   mainloop

isit_c         cmp   #'c'
               bne   isit_x
               jsr   sub_c
               jmp   mainloop

isit_x         cmp   #'x'
               beq   out
               jsr   $ffd2
               pha
               jsr   $ffd2
               lda   #':'
               pla   
               jsr   putahexfmt
               pha
               lda   #13
               jsr   $ffd2
               pla   
               jmp   mainloop

out            jsr   sub_t
               plp
               rts
               .bend

sub_g          .block
               php
               pha
               #outstr   texte_g
               #poke 53265,59
               #poke 53272,29
               #poke 56576,198
               pla
               plp
               rts
               .bend

sub_t          .block
               php
               pha
               #outstr   texte_t
               #poke 53265,27
               #poke 53272,21
               #poke 56576,199
               #tolower
               jsr   screenena
               pla
               plp
               rts
               .bend

sub_c          .block
               php
               pha
               #outstr   texte_c
               #ldzp1ptr   17408
               #setloop    1000
               ldy   #$00
encore         lda   couleur1
               sta   (zpage1),y
               jsr   inczpage1
               jsr   loop
               bne   encore
               jsr   maingraph
               jsr   drawman
               pla
               plp
               rts
               .bend

maingraph      .block
               php
               pha
               #poke 18090,0
               #poke 18130,17
               #poke 18170,17
               #poke 18210,17
               pla
               plp
               rts
               .bend

paintbkgnd     .block
               php
               pha
               cli
               #ldzp1ptr 24575-48
               #setloop  (32576-24575)+48

encore         
               inc   patern
               lda   patern
               sta   (zpage1),y
               jsr   inczpage1
               jsr   loop
               bne   encore
               sei
               pla
               plp
               rts
               .bend


drawman        .block
               php
               pha
               #poke 17410,170
               #poke 17449,34
               #poke 17450,34
               #poke 17451,34
               #poke 17490,34
               #poke 17529,67
               #poke 17531,67

               #poke 17457,153
               #poke 17493,153
               #poke 17494,153
               #poke 17495,153
               #poke 17496,153
               #poke 17534,153
               #poke 17536,153
               pla
               plp
               rts
               .bend


texte_m        .text "Les touches g,t,c,ou x."
               .byte 13,0
texte_g        .text "La sous-routine g fonctionne."
               .byte 13,0
texte_t        .text "La sous-routine t fonctionne."
               .byte 13,0
texte_c        .text "La sous-routine c fonctionne."
               .byte 13,0



;-----------------------------------------------------------------------------
; Inclure mes propres librairies.
;-----------------------------------------------------------------------------
; Chargement des macros locales.
               .include "local-macros.asm"       ; Macros de ce programmes
;-----------------------------------------------------------------------------
; ... et du code spécifique au programmes.
;-----------------------------------------------------------------------------
               .include "local-code.asm"     ; Les routines de ce programme.
;-----------------------------------------------------------------------------
; Chargement des variables locales
;-----------------------------------------------------------------------------
               .include "local-variables.asm"       ; Variables de ce programme.
;-----------------------------------------------------------------------------
; Chargement des chaines de caractères locales.
;-----------------------------------------------------------------------------
               .include "local-francais.asm"     ; Les chaines en français.
;               .include "local-english.asm"     ; Les chaines en anglais.
;-----------------------------------------------------------------------------
; Chargement des constantes locales.
;-----------------------------------------------------------------------------
;               .include "local-const.asm"
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
