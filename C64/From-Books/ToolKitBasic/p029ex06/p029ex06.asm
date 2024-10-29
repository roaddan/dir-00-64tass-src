;-------------------------------------------------------------------------------
           Version = "20241028-172827"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p029ex06  .block
          jsr  push           ; Sauvegarde le statut complet.
          #v20col
          jsr  cls            ; On efface l'écran.
          #print ttext
          #print ptext1
          jsr  insub          ; Lit le premier nombre.
          jsr  b_f1t57        ; Le copie en RAM.
          #print ptext2
          jsr  insub          ; Lit le second nombre dans FAC1.
          lda  #$57           ; Multiply FAC1 avec
          ldy  #$00           ;  le nombre sauvegardé
          jsr  b_f1xfv        ;  en RAM.
          jsr  b_facasc       ; Converti le résultat en ascii à $0100.
          #print restxt
          jsr  outsub         ; Affiche la valeur finale.
          
          jsr  pop            ; Récupère le statut complet.
          rts
ttext     .byte     b_blue,b_space,b_rvs_on
          .text     "    MULTIPLICATION - POINT FLOTTANT   "
          .byte     b_rvs_off,b_crlf,$00   
ptext1    .byte     b_crlf, b_purple, b_space
          .text     "Entez un premier nombre"
          .byte     b_black,b_eot
ptext2    .byte     b_crlf, b_purple, b_space
          .text     "Entez un second nombre "
          .byte     b_black,b_eot
restxt    .byte     b_green,b_crlf
          .text    " Voici le resultat......:"
          .byte     b_black,$00
          .bend

outsub    .block
          jsr  push           ; Sauvegarde le statut complet.
          ldy  #$ff           ; On détermine 
nxtchr    iny                 ;  le nombre de caractères
          lda  $0100,y        ;  qu'il y a dans la chaine à afficher.
          bne  nxtchr
          iny                 ; On ajoute 1 au nombre trouvé pour compenser
          tya                 ;  l'adresse a y=0.
          pha                 ; Sauvegarde ce nombre.
          lda  #$00           ; On prépare le pointeur $22-$23
          sta  $22            ;  en le peuplant avec 
          lda  #$01           ;  l'adresse ou se trouve la chaine
          sta  $23            ;  à afficher.
          pla                 ; On ramène le nombre de caractères.
          jsr  b_strout       ; On affiche.
          jsr  pop            ; Récupère le statut complet.
          rts
          .bend

insub     .block
          jsr  push           ; Sauvegarde le statut complet.
          jsr  kbflushbuff
          jsr  b_intcgt       ; Initialide chrget
          lda  #$00           ; On efface le basic input buffer 
          ldy  #$59           ;  situé à $200 long de 89 bytes ($59)
clear     sta  b_inpbuff,y    ;  en plaçant des $00 partout
          dey                 ;  et ce jusqu'au
          bne  clear          ;  dernier.
          jsr  b_prompt       ; Affiche un "?" et attend une entrée.
          stx  $7a            ; X et Y pointe sur $01ff au retour.
          sty  $7b
          jsr  b_chrget       ; Lecture du buffer.
          jsr  b_ascflt       ; Conversion la chaine ascii en 200 en float.
                              ;  dans $22(lsb) et $23(msb)
          jsr  pop            ; Récupère le statut complet.
          rts

          .bend

akey      .block
          lda  #<kmsg
          sta  $22
          lda  #>kmsg
          sta  $23
          lda  #kmsgend-kmsg
          jsr  b_strout
          jsr  anykey
          rts
kmsg      .byte b_crlf,b_green,b_crsr_up,b_crsr_right
          .text               "Une clef pour continuer!"
          .byte b_black,b_eot
kmsgend                      
          .bend

main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       bookinfo
          jsr       akey
          jsr       cls
          jsr       help
          jsr       akey
          lda       #b_crlf
          jsr       $ffd2
          jsr       p029ex06
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

help      .block
          jsr  push           ; Sauvegarde le statut complet.      
          #lowercase
          jsr       cls
          #print    shortcuts
          #print    helptext
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
          .text               " *         page 28, exemple #5        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "        RACCOURCIS DES EXEMPLES       "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p029ex06: SYS %d ($%04X)",p029ex06, p029ex06)
          .byte     b_crlf
          .text     format(   " help....: SYS %d ($%04X)",help, help)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     b_crlf,b_eot
helptext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p029ex06)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p029ex06)
          .byte     b_crlf,b_black,b_eot

line      .text               " --------------------------------------"
          .byte     b_crlf,b_eot


;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
          .include "map-c64-kernal.asm"
          .include "map-c64-vicii.asm" 
          .include "map-c64-basic2.asm"
          .include "lib-c64-basic2.asm"
          .include "lib-c64-showregs.asm"
          .include "lib-cbm-pushpop.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"

