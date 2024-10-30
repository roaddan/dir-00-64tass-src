;-------------------------------------------------------------------------------
           Version = "20241028-220934"
;-------------------------------------------------------------------------------           .include    "header-c64.asm"
          .include    "header-c64.asm"
          .include    "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
          .enc      none

p027ex04  .block
          jsr  push
          #v20col
          #print ttext 
          jsr  b_intcgt       ; Initialide chrget
          ldx  #<(floatnum-1)
          ldy  #>(floatnum-1)
          stx  $7a
          sty  $7b
          jsr  b_chrget
          jsr  b_ascflt
          jsr  b_facasc
          ldy  #$ff
sbufx     iny
          lda  $0100,y
          bne  sbufx
          iny
          tya
          pha
          lda  #$00
          sta  $22
          lda  #$01
          sta  $23
          pla
          jsr  b_strout
          lda  #b_crlf
          jsr  $ffd2
          jsr  pop
          rts
floatnum  .null     "25.35e3"
ttext     .byte     b_blue,b_space,b_rvs_on
          .text     "    P.F. - AFFICHAGE STRING A F.P.   "
          .byte     b_rvs_off,b_crlf,b_crlf,b_eot 
          .bend

main      .block
          jsr  scrmaninit
          #disable
          #v20col
          jsr  bookinfo
          jsr  akey
          jsr  cls
          jsr  help
          jsr  akey
          jsr  cls
          lda  #b_crlf
          jsr  $ffd2
          jsr  p027ex04
          #enable
;          #uppercase
;          #c64col
;          jsr       cls
;          jmp      b_warmstart
          rts
          .bend
            
bookinfo  .block      
          #lowercase
          jsr       cls
          #print    line
          #print    headera
          #print    headerb
          #print    line
          rts                      
          .bend  

help      .block      
          #lowercase
          jsr       cls
          #print    shortcuts
          #print    helptext
          #print    line
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
          .text               " *         page 27, exemple #4        *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "        RACCOURCIS DES EXEMPLES       "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p027ex04: SYS %d ($%04X)",p027ex04, p027ex04)
          .byte     b_crlf
          .text     format(   " help....: SYS %d ($%04X)",help, help)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     b_crlf,b_eot
helptext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p027ex04)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p027ex04)
          .byte     b_crlf,b_black,b_eot

line      .text               " --------------------------------------"
          .byte     b_crlf,b_eot

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

