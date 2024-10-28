;-------------------------------------------------------------------------------
           Version = "20241027-233303"
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
          jsr       bookinfo
          jsr       akey
          jsr       cls
          jsr       help
          jsr       akey
          jsr       exemp027
          #enable
          #uppercase
;          jsr       cls
;          #graycolor
;          #c64col
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

headerb   .byte     b_crlf
          .text               " *        exemple #3 & #4 (p027)      *"
          .byte     b_crlf
          .text               " *    programmed by Daniel Lafrance.  *"
          .byte     b_crlf
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "   E X A M P L E  S H O R T  C U T S  "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " exemp027: SYS %d ($%04X)",exemp027, exemp027)
          .byte     b_crlf
          .text     format(   " help....: SYS %d ($%04X)",help, help)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     b_crlf,b_eot
helptext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",exemp027)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",exemp027)
          .byte     b_crlf,b_black,b_eot

line      .text               " --------------------------------------"
          .byte     b_crlf,b_eot
;*=$4000

exemp027  .block
          pha
          txa
          pha
          #v20col
          jsr  cls
          jsr  insub
          jsr  b_facasc       ; Convertie FAC1 en ascii à $0100.
          ldy  #$ff           ; Cherche la fin de la chaine de caractère ($00)
fndend    iny                 ; De 
          lda  $0100,y        ; Lie le caractère.
          bne  fndend         ; Ce n'est pas un $00, on cherche encore.
          iny                 ; On ajuste le compte. 
          tya                 ; On met le compte dans acc.
          pha                 ; On le sauvegarde.
          lda  #$00           ; On place l'adresse de la chaine $0100
          sta  $22            ;  le $00 dans $22(lsb)
          lda  #$01           ;  et le $01      
          sta  $23            ;  dans $23(msb)
          pla                 ; On récupère le compte.
          jsr  cls
          jsr  b_strout       ; Affiche la chaine(z) dont l'adresse est
          pla                 ;  dans $22(lsb) et $23(msb)
          tax
          pla
          rts
          .bend
byte      .byte 0

insub  .block
          pha
          txa
          pha
          jsr  b_intcgt       ; Initialide chrget
          lda  #$00           ; On efface le basic input buffer 
          ldy  #$59           ;  situé à $200 long de 89 bytes ($59)
clear     sta  b_inpbuff,y    ;  en plaçant des $00 partout
          dey                 ;  et ce jusqu'au
          bne  clear          ;  dernier.
          lda  #<ptext
          sta  $22
          lda  #>ptext
          sta  $23
          lda  #ptextend-ptext
          jsr  b_strout       ; Affiche la chaine(z)
          jsr  b_prompt       ; Affiche un "?" et attend une entrée.
          stx  $7a            ; X et Y pointe sur $01ff au retour.
          sty  $7b
          jsr  b_chrget       ; Lecture du buffer.
          jsr  b_ascflt       ; Conversion la chaine ascii en 200 en float.
          pla                 ;  dans $22(lsb) et $23(msb)
          tax
          pla
          rts
ptext     .byte b_crlf, b_purple, b_space
          .text "Enter a number "
          .byte b_black,b_eot
ptextend
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
          .text               "Any key to continue!"
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
          .include "lib-cbm-pushpop.asm"
          .include "lib-cbm-mem.asm"
          .include "lib-cbm-hex.asm"
          .include "lib-cbm-keyb.asm"
