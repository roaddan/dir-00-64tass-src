;-------------------------------------------------------------------------------
           Version = "20241028-220934"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p025ex01  .block
          pha
          txa
          pha
          lda  #$05
          ldx  #$03
          jsr  b_putint
          pla
          tax
          pla
          rts
          .bend

akey      .block
          lda  #<kmsg
          sta  $22
          lda  #>kmsg
          sta  $23
          lda  #kmsgend-kmsg
          jsr  b_strout
          jsr  kbflushbuff
          jsr  anykey
          rts
kmsg      .byte $0d
          .null               "Une clef pour continuer!"
kmsgend                      
          .bend

main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       help
          jsr       p025ex01
          jsr       akey
          #enable
          #uppercase
;          #graycolor
;          jmp      b_warmstart
          jsr       cls
          rts
          .bend
            
help           .block      
          #lowercase
          jsr       cls
          #print    line
          #print    headera
          #print    headerb
          #print    line
          #print    shortcuts
          #print    helptext
          #print    line
          rts
                     
headera                       ;0123456789012345678901234567890123456789
          .text               " *       Vic-20 and Commodore 64      *"
          .byte     $0d
          .text               " *           Tool Kit: BASIC          *"
          .byte     $0d
          .text               " *          Book by Dan Heeb.         *"
          .byte     $0d
          .null               " *         ISBN: 0-942386-32-9        *"

headerb   .byte     $0d
          .text               " *    Direct Use of Floating Point    *"
          .byte     $0d
          .text               " *         page 25, exemple #1        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .null     format(   " *      Version: %s.     * ",Version)


shortcuts .text               "        RACCOURCIS DES EXEMPLES       "
          .byte     $0d,$0d
          .text     format(   " p025ex01: SYS %d ($%04X)",p025ex01, p025ex01)
          .byte     $0d
          .text     format(   " help....: SYS %d ($%04X)",help, help)
          .byte     $0d
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     $0d,0
helptext  .byte     $0d
          .text     format(   " ex.: SYS%d",p025ex01)
;          .byte     $0d
;          .text     format(   "      for i=0to100:SYS%05d:next",p025ex01)
          .byte     $0d,0
line      .text               " --------------------------------------"
          .byte     $0d,0
          .bend
;*=$4000

;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
;*=$c000        
          .include "map-c64-kernal.asm"
          .include "map-c64-vicii.asm" 
          .include "map-c64-basic2.asm"
          .include "lib-c64-basic2.asm"
          .include "lib-cbm-pushpop.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"
