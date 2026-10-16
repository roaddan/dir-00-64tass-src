;-------------------------------------------------------------------------------
           Version = "20241030-2058ff"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p039ex28  .block
          jsr  push           ; Sauvegarde le statut complet.
again     #v20col
          jsr  cls            ; On efface l'écran.
          lda  #<serie        ; La série sera placée à l'adresse $c29a.
          sta  $fd            ; Un octet passé l'ordre.
          lda  #>serie
          sta  $fe
          lda  #$03           ; Demande trois valeurs.
          sta  $ff
          #print ttext        ; Affiche le titre.
          #print ttext2       ; Affiche le titre2.          
nexser    clc
          ldy  $ff
          lda  symboles,y
          sta  ptext+23
          #print ptext        ; Demande un nombre.
          jsr  insub
          ldx  $fd
          ldy  $fe
          jsr  b_f1tmem       ; Copie Fac1 à l'adresse pointée par x et y.
          clc
          lda  #$05           ; Déplace le pointeur de 5 octets.
          adc  $fd
          sta  $fd
          dec  $ff
          bne  nexser
          lda  #$02           ; Sélectionne l'ordre de la série.
          sta  order

          jsr  push
          ldy  $ff
          lda  symboles,y
          sta  ptext+23
          #print ptext        ; Demande un nombre.
          jsr  pull
          jsr  insub

          lda  #<order
          ldy  #>order
          jsr  b_poly
          jsr  b_facasc
          #print restext
          jsr  outsub

          #printxy query        ; Affiche l'invite de nouveau calcul.
          jsr  getkey         ; Attend une clef.
          and  #$7f           ; Met en minuscule.
          cmp  #'o'           ; Est-ce 'o'ui
          bne  out            ; Non, on sort.
          jmp again           ; On recommence.
out       jsr  aide           ; Affiche le menu d'aide.
          jsr  pop            ; Récupère le statut complet.
          rts
                    ;0123456789012345678901234567890123456789
query     .byte     2,23,b_crlf,b_ltblue,b_space
          .text     " Un autre calcul (o/N)?"
          .byte     b_eot 
ttext     .byte     b_white,b_space,b_blue,b_rvs_on
          .text      " Calcul un polynomial de 2ieme ordre. "
          .byte     b_rvs_off,b_crlf,b_eot 
ttext2    .byte     b_white,b_space,b_blue,b_rvs_on
          .text      "          f(x)=A(x)2+B(x)+C           "
          .byte     b_rvs_off,b_crlf,b_eot  
ptext     .byte     b_crlf, b_purple, b_space
          .text     " Entez la valeur de X"
          .byte     b_black,b_eot
restext   .byte     b_crlf, b_purple, b_space
          .text     " f(x)="
          .byte     b_black,b_eot

symboles  .text     "XCBA"
order     .byte     0
serie     .byte     0,0,0,0,0
          .byte     0,0,0,0,0
          .byte     0,0,0,0,0       
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
          jsr       p039ex28
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
          .text               " *        page 39, exemple #28        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "       RACCOURCIS DE L'EXEMPLE        "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p039ex28: SYS %d ($%04x)",p039ex28, p039ex28)
          .byte     b_crlf
          .text     format(   " aide....: SYS %d ($%04x)",aide, aide)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04x)",cls, cls)
          .byte     b_crlf,b_eot
aidetext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p039ex28)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p039ex28)
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

