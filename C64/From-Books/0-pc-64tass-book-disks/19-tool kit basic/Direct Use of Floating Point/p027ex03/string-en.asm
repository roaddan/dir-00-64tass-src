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
          .text               " *         page 27, exAmple #3        *"
          .byte     $0d
          .text               " *    Programmer Daniel Lafrance.     *"
          .byte     $0d
          .text     format(   " *      Version: %s.     * ",Version)
          .byte     b_black,b_eot

shortcuts .byte     b_blue,b_space,b_rvs_on
          .text               "           EXAMPLE SHORTCUTS          "
          .byte     b_rvs_off,b_crlf,b_crlf
          .text     format(   " p027ex03: SYS %d ($%04X)",p027ex03, p027ex03)
          .byte     b_crlf
          .text     format(   " help....: SYS %d ($%04X)",help, help)
          .byte     b_crlf
          .text     format(   " cls.....: SYS %d ($%04X)",cls, cls)
          .byte     b_crlf,b_eot
helptext  .byte     b_crlf,b_space,b_red
          .text     format(   " ex.: SYS %d",p027ex03)
;          .byte     b_crlf
;          .text     format(   "      for i=0to100:SYS%05d:next",p027ex03)
          .byte     b_crlf,b_black,b_eot

line      .text                 " --------------------------------------"
          .byte     b_crlf,b_eot


ttext     .byte     b_blue,b_space,b_rvs_on
          .text                 "     F.P. NUMBER INPUT MANAGEMENT     "
          .byte     b_rvs_off,b_crlf,b_eot 
ptext     .byte b_crlf, b_purple, b_space
          .text "Enter a number "
          .byte b_black,b_eot
ptextend
kmsg      .byte b_crlf,b_green,b_crsr_up,b_crsr_right
          .text               "A key to continue!"
          .byte b_black,b_eot
kmsgend                      
