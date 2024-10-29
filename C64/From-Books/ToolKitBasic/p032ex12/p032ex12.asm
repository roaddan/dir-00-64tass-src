;-------------------------------------------------------------------------------
           Version = "20241029-122533"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p032ex12  .block
          jsr  push           ; Sauvegarde le statut complet.
again     #v20col
          jsr  cls            ; On efface l'écran.
          #print ttext
          #print ptext1
          jsr  insub          ; Lit le premier nombre.
          jsr  b_f1t57
          #print ptext2
          jsr  insub          ; Lit le premier nombre.
          lda  #$57
          ldy  #$00
          jsr  b_memtf2
          lda  $61
          jsr  b_f2df1
noneg     jsr  b_facasc       ; Converti le résultat en ascii à $0100.
          #print restxt
          jsr  outsub         ; Affiche la valeur finale.
          lda  #$0d
          jsr  $ffd2
          #print query
          jsr  getkey
          and  #$7f
          cmp  #'o'
          bne  out
          jmp again
out       jsr  aide
          jsr  pop            ; Récupère le statut complet.
          rts
query     .byte     b_ltblue,b_space,b_crlf
          .text     "   Un autre calcul (o/N)?"
          .byte     b_crlf,b_eot 
ttext     .byte     b_blue,b_space,b_rvs_on
          .text     "  POINT FLOTTANT - FAC1 = FAC2/FAC1  "
          .byte     b_rvs_off,b_crlf,b_eot 
ptext1    .byte     b_crlf, b_purple, b_space
          .text     " Entez la valeur de FAC2"
          .byte     b_black,b_eot
ptext2    .byte     b_crlf, b_purple, b_space
          .text     "      puis celle de FAC1"
          .byte     b_black,b_eot
restxt    .byte     b_green,b_crlf
          .text    " Voici le resultat......:"
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
          jsr       p032ex12
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
          .text               " *        page 32, exemple #12        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "       RACCOURCIS DE L'EXEMPLE        "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p032ex12: SYS %d ($%04X)",p032ex12, p032ex12)
          .byte     b_crlf
          .text     format(   " aide....: SYS %d ($%04X)",aide, aide)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     b_crlf,b_eot
aidetext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p032ex12)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p032ex12)
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
          .include "lib-c64-showregs.asm"
          .include "lib-cbm-pushpop.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"

