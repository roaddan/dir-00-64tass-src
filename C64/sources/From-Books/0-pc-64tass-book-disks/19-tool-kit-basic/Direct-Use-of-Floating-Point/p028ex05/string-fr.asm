headera                       ;0123456789012345678901234567890123456789
          .text               " *       Vic-20 et Commodore 64.      *"
          .byte     b_crlf
          .text               " *           Tool Kit: BASIC          *"
          .byte     b_crlf
          .text               " *         Livre par Dan Heeb.        *"
          .byte     b_crlf
          .null               " *         ISBN: 0-942386-32-9        *"
headerb   .byte     $0d
          .text               " *      Utilisation directe des       *"
          .byte     $0d
          .text               " *          points flottants.         *"
          .byte     $0d
          .text               " *    Programmeur Daniel Lafrance.    *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "        RACCOURCIS DES EXEMPLES       "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p028ex05: SYS %d ($%04X)",p028ex05, p028ex05)
          .byte     b_crlf
          .text     format(   " Aide....: SYS %d ($%04X)",help, help)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     b_crlf,b_eot
helptext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p028ex05)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p028ex05)
          .byte     b_crlf,b_black,b_eot

line      .text               " --------------------------------------"
          .byte     b_crlf,b_eot

ptext     .byte     b_crlf, b_purple, b_space
          .text     "Entez un nombre "
          .byte     b_black,b_eot
ptextend
kmsg      .byte     b_crlf,b_green,b_crsr_up,b_crsr_right
          .text     "Une clef pour continuer!"
          .byte     b_black,b_eot
kmsgend                      
