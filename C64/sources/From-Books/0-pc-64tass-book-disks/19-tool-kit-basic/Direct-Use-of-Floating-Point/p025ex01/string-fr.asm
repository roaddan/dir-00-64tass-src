headera                       ;0123456789012345678901234567890123456789
          .text               " *       Vic-20 et Commodore 64       *"
          .byte     $0d
          .text               " *           Tool Kit: BASIC          *"
          .byte     $0d
          .text               " *         Livre par Dan Heeb.        *"
          .byte     $0d
          .null               " *         ISBN: 0-942386-32-9        *"

headerb   .byte     $0d
          .text               " *      Utilisation directe des       *"
          .byte     $0d
          .text               " *          points flottants.         *"
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
          .text     format(   " Aide....: SYS %d ($%04X)",help, help)
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
          .null               "Une clef pour continuer!"
kmsgend                      
