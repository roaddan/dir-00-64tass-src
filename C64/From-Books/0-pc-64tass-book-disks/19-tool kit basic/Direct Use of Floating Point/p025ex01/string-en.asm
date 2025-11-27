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
          .text               " *         page 25, example #1        *"
          .byte     $0d 
          .text               " *     Programmer Daniel Lafrance     *"
          .byte     $0d
          .null     format(   " *      Version: %s.     * ",Version)


shortcuts .text               "           EXAMPLE SHORTCUTS           "
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

kmsg      .byte $0d
          .null               "A key to continue!"
kmsgend                      
