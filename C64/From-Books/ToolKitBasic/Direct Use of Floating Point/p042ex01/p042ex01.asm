;-------------------------------------------------------------------------------
           Version = "20241105-205257"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p042ex01  .block
start     =    $a000
end       =    $bfff

          jsr  push           ; Sauvegarde le statut complet.
again     #v20col
          jsr  cls            ; On efface l'écran.
          #print    ttext
          #print    ttext2
          lda  #<start
          sta  zpage1
          lda  #>start
          sta  zpage1+1
nextp     ldy  #$00
nextb     lda  (zpage1),y
          sta  (zpage1),y
          iny
          bne  nextb
          inc  $fc
          lda  $fb
          cmp  #$c0
          bmi  nextp
          lda  #130
          sta  47548
          lda  $01
          and  #$fe
          sta  $01
out       ;jsr  aide           ; Affiche le menu d'aide.
          jsr  pop            ; Récupère le statut complet.
          rts
                    ;0123456789012345678901234567890123456789
query     .byte     2,23,b_crlf,b_ltblue,b_space
          .text     " Un autre calcul (o/N)?"
          .byte     b_eot 
ttext     .byte     b_white,b_space,b_blue,b_rvs_on
          .text      " Copie le contenu du rom Basic en RAM "
          .byte     b_rvs_off,b_crlf,b_eot 
ttext2    .byte     b_white,b_space,b_blue,b_rvs_on
          .text      " La commande FOR saute de 2 par defaut"
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
          jsr       p042ex01
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
          .text               " *        page 42, exemple #01        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "       RACCOURCIS DE L'EXEMPLE        "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p042ex01: SYS %d ($%04x)",p042ex01, p042ex01)
          .byte     b_crlf
          .text     format(   " aide....: SYS %d ($%04x)",aide, aide)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04x)",cls, cls)
          .byte     b_crlf,b_eot
aidetext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p042ex01)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p042ex01)
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

