
headera                       ;0123456789012345678901234567890123456789
          .text               " *       Vic-20 and Commodore 64      *"
          .byte     b_crlf
          .text               " *           Tool Kit: BASIC          *"
          .byte     b_crlf
          .text               " *         Livre par Dan Heeb.        *"
          .byte     b_crlf
          .null               " *         ISBN: 0-942386-32-9        *"
headerb   .byte     $0d
          .text               " *      Utilisation directe des       *"
          .byte     $0d
          .text               " *          point flottants.          *"
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
          .text     format(   " Aide....: SYS %d ($%04X)",help, help)
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
 
kmsg      .byte b_crlf,b_green,b_crsr_up,b_crsr_right
          .text               "Une clef pour continuer!"
          .byte b_black,b_eot
kmsgend 
ttext     .byte     b_blue,b_space,b_rvs_on
          .text     "    P.F. - AFFICHAGE CHAINE A F.P.   "
          .byte     b_rvs_off,b_crlf,b_crlf,b_eot 
