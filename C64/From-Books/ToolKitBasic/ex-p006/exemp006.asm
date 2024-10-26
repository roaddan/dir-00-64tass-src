;-------------------------------------------------------------------------------
           Version = "20241026-125836"
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
          jsr       help
          jsr       anykey
          jsr       exemp006
          #enable
          #uppercase
          jsr       cls
          #graycolor
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
          .text               " *           exemp006 (pxx)           *"
          .byte     $0d
          .text               " *    programmed by Daniel Lafrance.  *"
          .byte     $0d
          .null     format(   " *      Version: %s.     *",Version)

shortcuts .byte     $0d
          .text               " -------- S H O R T - C U T S ---------"
          .byte     $0d
          .text     format(   " exemp006: SYS%05d ($%04X)",main, main)
          .byte     $0d
          .text     format(   " help: SYS%05d ($%04X)",help, help)
          .byte     $0d
          .text     format(   " cls: SYS%05d ($%04X)",cls, cls)
          .byte     $0d,0
helptext  .byte     $0d
          .text     format(   " First run: SYS%05d ($%04X)",exemp006, exemp006)
          .byte     $0d, $0d
          .text     format(   " ex.: SYS%05d",exemp006)
          .byte     $0d
          .text     format(   "      for i=0to100:SYS%05d:next",exemp006)
          .byte     $0d,0
line      .text               " --------------------------------------"
          .byte     $0d,0
          .bend
;*=$4000

exemp006       .block
          pha
          lda vicbordcol
          sta byte
          lda #$10
          sta vicbordcol
          jsr anykey
          lda byte
          sta vicbordcol
          pla
          rts
          .bend
byte           .byte 0
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
