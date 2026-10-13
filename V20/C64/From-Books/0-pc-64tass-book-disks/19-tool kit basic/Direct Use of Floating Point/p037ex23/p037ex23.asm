;-------------------------------------------------------------------------------
           Version = "20241030-205806"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p037ex23  .block
          jsr  push           ; Sauvegarde le statut complet.
again     #v20col
          jsr  cls            ; On efface l'écran.
          #print ttext        ; Affiche le titre.
          #print ptextva      ; Affiche l'invite du premier nombre.
          jsr  insub          ; Lit le premier nombre.
          jsr  b_f1t57        ; Copie FAC1 vers $0057.
          #print ptext1b      ; Affiche l'invite du second nombre.
          jsr  insub          ; Lit le premier nombre.
          jsr  b_f1t5c        ; Copie FAC1 vers $005C.
          lda  #$57           
          ldy  #$00
          jsr  b_comp         ; Compare FAC1 avec FVAR de l'adresse $0057.
          tax                 ; Sauvegarde le résultat dans Acc.
          inx                 ; 
          bne  mless          ; Si mémoire <= FAC1 branche.
          lda  #$57           
          ldy  #$00
          clc
          bcc  mgreat         ; Si mémoire > FAC1 branche.
mless     lda  #$5c
          ldy  #$00
mgreat    jsr  b_fvtf1        ; Copie FVAR pointé paa A et Y vers FAC1.
          jsr  b_facasc       ; Conversion en ascii.
          #print restxt1      ; Affiche l'invite du résultat.
          jsr  outsub         ; Affiche la valeur finale.
          lda  #$0d           ; Affiche un CRLF.
          jsr  $ffd2
          #print query        ; Affiche l'invite de nouveau calcul.
          jsr  getkey         ; Attend une clef.
          and  #$7f           ; Met en minuscule.
          cmp  #'o'           ; Est-ce 'o'ui
          bne  out            ; Non, on sort.
          jmp again           ; On recommence.
out       jsr  aide           ; Affiche le menu d'aide.
          jsr  pop            ; Récupère le statut complet.
          rts
                    ;0123456789012345678901234567890123456789
query     .byte     b_ltblue,b_space,b_crlf
          .text     "   Un autre calcul (o/N)?"
          .byte     b_crlf,b_eot 
ttext     .byte     b_blue,b_space,b_rvs_on
          .text      " P.F. - FAC1 = PLUS GRAND FAV OU FAC1 "
          .byte     b_rvs_off,b_crlf,b_eot 
ptext1a   .byte     b_crlf, b_purple, b_space
          .text     " Entez la valeur de FAC1"
          .byte     b_black,b_eot
ptext2a   .byte     b_crlf, b_purple, b_space
          .text     " Entez la valeur de FAC2"
          .byte     b_black,b_eot
ptextva   .byte     b_crlf, b_purple, b_space
          .text     " Entez la valeur de FVAR"
          .byte     b_black,b_eot
ptext1b   .byte     b_crlf, b_purple, b_space
          .text     "      puis celle de FAC1"
          .byte     b_black,b_eot
ptext2b   .byte     b_crlf, b_purple, b_space
          .text     "      puis celle de FAC2"
          .byte     b_black,b_eot
ptextvb   .byte     b_crlf, b_purple, b_space
          .text     "      puis celle de FVAR"
          .byte     b_black,b_eot
restxt1   .byte     b_green,b_crlf
          .text    " Resultat dans FAC1="
          .byte     b_black,b_eot
restxt2   .byte     b_green,b_crlf
          .text    " Resultat dans FAC2="
          .byte     b_black,b_eot
restxtv   .byte     b_green,b_crlf
          .text    " Resultat dans FVAR="
          .byte     b_black,b_eot
          .bend

main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       bookinfo
          jsr       akey
          jsr       cls
          jsr       aide
          jsr       akey
          lda       #b_crlf
          jsr       $ffd2
          jsr       p037ex23
          #enable
;          #uppercase
;          #c64col
;          jsr       cls
;          jmp      b_warmstart
          rts
          .bend

            
bookinfo  .block
          jsr  push           ; Sauvegarde le statut complet.      
          #lowercase
          jsr       cls
          #print    line
          #print    headera
          #print    headerb
          #print    line
          jsr  pop            ; Récupère le statut complet.
          rts                      
          .bend  

aide      .block
          jsr  push           ; Sauvegarde le statut complet.      
          #lowercase
          jsr       cls
          #print    shortcuts
          #print    aidetext
          #print    line
          jsr  pop            ; Récupère le statut complet.
          rts
          .bend        

headera                       ;0123456789012345678901234567890123456789
          .text               " *       Vic-20 and Commodore 64      *"
          .byte     b_crlf
          .text               " *           Tool Kit: BASIC          *"
          .byte     b_crlf
          .text               " *          Book by Dan Heeb.         *"
          .byte     b_crlf
          .null               " *         ISBN: 0-942386-32-9        *"
headerb   .byte     $0d
          .text               " *    Direct Use of Floating Point    *"
          .byte     $0d
          .text               " *        page 37, exemple #23        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "       RACCOURCIS DE L'EXEMPLE        "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p037ex23: SYS %d ($%04x)",p037ex23, p037ex23)
          .byte     b_crlf
          .text     format(   " aide....: SYS %d ($%04x)",aide, aide)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04x)",cls, cls)
          .byte     b_crlf,b_eot
aidetext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p037ex23)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p037ex23)
          .byte     b_crlf,b_black,b_eot

line      .text               " --------------------------------------"
          .byte     b_crlf,b_eot


;-------------------------------------------------------------------------------
; Je mets les librairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
          .include "toolkitbasic.asm"
          .include "map-c64-kernal.asm"
          .include "map-c64-vicii.asm" 
          .include "map-c64-basic2.asm"
          .include "lib-c64-basic2.asm"
;          .include "lib-c64-showregs.asm"
          .include "lib-cbm-pushpop.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"

