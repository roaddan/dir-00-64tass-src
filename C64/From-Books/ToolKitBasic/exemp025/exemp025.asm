;-------------------------------------------------------------------------------
           Version = "20241026-221343"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none
main      .block
          jsr       scrmaninit
          #disable
          #v20col
          jsr       help
          jsr       exemp025
          jsr       anykey
          #enable
          #uppercase
          jsr       cls
;          #graycolor
          #c64col
;          jmp      b_warmstart
          .bend
            
help           .block      
          #lowercase
          jsr       cls
          #print    line
          #print    headera
          #print    headerb
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
          .text               " *           exemp025 (pxx)           *"
          .byte     $0d
          .text               " *    programmed by Daniel Lafrance.  *"
          .byte     $0d
          .null     format(   " *      Version: %s.     *",Version)

shortcuts .byte     $0d
          .text               " -------- S H O R T - C U T S ---------"
          .byte     $0d,$0d
          .text     format(   " exemp025: SYS %d ($%04X)",exemp025, exemp025)
          .byte     $0d
          .text     format(   " help....: SYS %d ($%04X)",help, help)
          .byte     $0d
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     $0d,0
helptext  .byte     $0d
          .text     format(   " ex.: SYS%d",exemp025)
;          .byte     $0d
;          .text     format(   "      for i=0to100:SYS%05d:next",exemp025)
          .byte     $0d,0
line      .text               " --------------------------------------"
          .byte     $0d,0
          .bend
;*=$4000

exemp025  .block
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
byte      .byte 0
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
