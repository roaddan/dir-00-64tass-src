headtcol        =   b_jaune
normtcol        =   b_jaune    

nextline        .byte   0
line            .null           "                                "
texta           .byte           b_rvs_off
                .text           " SL-BUG 64 Version 4.00 "
                .byte           b_rvs_on,0
textb           .null           "     Version Commodore 64     "
textc           .null           "  Idee Originale sur MC-6809  "
textd           .null           "  Par Serge Leblanc mai 1994  "
texte           .null           " Port C64 par Daniel Lafrance "
textf           .null           "       (c) Octobre 2025       "
textg           .null   format( "   Version: %-17s ",Version)
texth           .byte           b_rvs_off
                .text           " RACCOURCIS "
                .byte           b_rvs_on,0
texti           .null   format( " Execution.: SYS%5d ($%4X) ",slbug64,slbug64)
textj           .null   format( " Aide......: SYS%5d ($%4X) ",help,help)
textk           .null   format( " CLS.......: SYS%5d ($%4X) ",cls,cls)
textl           .null           "Une clef pour continuer!" 
titre           .null   "[Fenetre]"
tline   .byte   176,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,174,0
mline   .byte   171,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,179,0
bline   .byte   173,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,189,0
eline   .byte   221,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,221,0
