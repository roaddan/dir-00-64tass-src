editor_msg     .byte vrose,1,5
               .null     "[editeur]"

blankmsg       .byte     mesgcol,0,5,146
               .null     "                                       "

prompt_msg     .byte     mesgcol,0,5,146
               .null     " utilisez les clefs de fonction:       "

wait_msg       .byte     mesgcol,0,5,146
               .null     " un instant s.v.p. ... "
f1a_msg
edit_msg       .byte     mesgcol,0,5,146     ;18
               .text     " mode edit: chr$(   )"
               .byte     146,0
f2a_msg
copy_msg       .byte     mesgcol,0,5
               .null     " entez le character a copier:"
f3a_msg
save_msg       .byte     mesgcol,0,5,146
               .null     " sauvegarder sur quel lecteur? (1/8/9): "
f4a_msg
load_msg       .byte     mesgcol,0,5,146
               .null     " charger de quel lecteur? (1,8,9): "
f5a_msg
clear_msg      .byte     mesgcol,0,5
               .null     " effacer char: chr$(   )"
f6a_msg
fill_msg       .byte     mesgcol,0,5
               .null     " remplir char:  chr$(   )"
f7a_msg
work_msg       .byte     mesgcol,0,5
               .null     " recuperer les caracteres du chargen."
f1b_msg
invr_msg       .byte     mesgcol,0,5
               .null     " basculer verticalement:"
f2b_msg
flip_msg       .byte     mesgcol,0,5
               .null     " basculer horizontalement:"
f3b_msg
scrollr_msg    .byte     mesgcol,0,5
               .null     " defiler vers la droite:"
f4b_msg
scrolll_msg    .byte     mesgcol,0,5
               .null     " defiler vers la gauche:"
f5b_msg
scrollu_msg    .byte     mesgcol,0,5
               .null     " defiler 1 bit vers le haut:"
f6b_msg
scrolld_msg    .byte     mesgcol,0,5
               .null     " defiler 1 bit vers le bas:"
f7b_msg
rvrs_msg       .byte     mesgcol,0,5
               .null     " inverser les bits:"

menua_msg      .byte     mesgcol,0,5
               .null     " vous etes dirige vers le menu 1."

menub_msg      .byte     mesgcol,0,5
               .null     " vous etes dirige vers le menu 2."

copychar_msg   .byte     vjaune,0,5
               .text     " entrez le caracter a copier (?)."
               .byte     157,157,157
               .byte 0

fname_msg      .byte     vjaune,0,5
               .text     " nom du fichier (6 lettres): "
               .byte     $a4,$a4,$a4,$a4,$a4,$a4
               .text     ".chr"
               .byte     157,157,157,157,157,157,157,157,157,157
               .byte     0

quit_msg       .byte     vmauve,18,24,18
               .text     "ctrl-x"
               .byte     146
               .null     " = quitter.   "     

redraw_msg     .byte     vrose,18,23,18
               .text     "ctrl-r"
               .byte     146
               .null     " = rafraichir."   

menu_msg
exit_msg       .byte     vvert1,18,24,18
               .text     "ctrl-x"
               .byte     146
               .null     " = au menu.   "     

whoami0        .byte     whoamicol,4,6,18
               .text     "                               "
               .byte     146
               .byte     0

whoami1        .byte     whoamicol,4,7,18
               .text     "       "
               .byte     146
               .text     " c h a r e d i t "
               .byte     18
               .text     "       "
               .byte     146
               .byte     0
 
whoami2        .byte     whoamicol,4,8,18
               .text     "                               "
               .byte     146
               .byte     0

whoami3        .byte     whoamicol,4,9,18
               .text     " tirez de isbn : 0-942386-29-9 "
               .byte     146
               .byte     0

whoami4        .byte     whoamicol,4,10,18
               .text     "       par john heilborn       "
               .byte     146
               .byte     0

whoami5        .byte     whoamicol,4,11,18
               .text     "                               "
               .byte     146
               .byte     0

whoami6        .byte     whoamicol,4,12,18 
               .text     "      code assembleur par      "
               .byte     146
               .byte     0

whoami7        .byte     whoamicol,4,13,18
               .text     " daniel lafrance quebec/canada "
               .byte     146
               .byte     0

whoami8        .byte     whoamicol,4,14,18
               .text     "    version:",version,"    "
               .byte     146
               .byte     0

whoami9        .byte     whoamicol,4,15,18
               .text     "                               "
               .byte     146
               .byte     0

bye_msg        .byte     vcyan,6,16,20
               .text     "      bonjour et merci      "
               .byte     146
               .byte     0

any_msg        .byte     vvert1,5,24,18
               .text     " appuyez une cle pour basic "
               .byte     146
               .byte     0

;--------- first function key set ------------------               

titremenu1     .byte     menu1col1,fkeyleft,f1top-2       ;133
               .byte     18
               .text     " jeu de fonctions #1 "
               .byte     146
               .byte     0

titremenu2     .byte     menu2col1,fkeyleft,f1top-2       ;133
               .byte     18
               .text     " jeu de fonctions #2 "
               .byte     146
               .byte     0

f1abutton      .byte     menu1col1,fkeyleft,f1top       ;133
               .text     "editer carac..."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f1 "
               .byte     223,146
               .byte     0

f2abutton      .byte     menu1col2,fkeyleft,f1top+1     ;138
               .text     "copier un carac"
               .byte     18   ; position 15
               .text     "  f2  "
               .byte     146
               .byte     0

f3abutton      .byte     menu1col1,fkeyleft,f1top+3     ;137
               .text     "savegarder sur." 
               .byte     18            ; position 15
               .byte     $a9
               .text     " f3 "
               .byte     223,146
               .byte     0

f4abutton      .byte     menu1col2,fkeyleft,f1top+4     ;134
               .text     "charger de....."
               .byte     18             ; position 15
               .text     "  f4  "
               .byte     146
               .byte     0

f5abutton      .byte     menu1col1,fkeyleft,f1top+6     ;135
               .text     "mettre tout a 0"
               .byte     18             ; position 15
               .byte     $a9
               .text     " f5 "
               .byte     223,146
               .byte     0

f6abutton      .byte     menu1col2,fkeyleft,f1top+7    ;139
               .text     "mettre tout a 1"
               .byte     18             ; position 15
               .text     "  f6  "
               .byte     146
               .byte     0

f7abutton      .byte     menu1col1,fkeyleft,f1top+9    ;136
               .text     "recuperer rom.."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f7 "
               .byte     223,146
               .byte     0

f8abutton      .byte     menu1col2,fkeyleft,f1top+10
               .text     "aller au menu2."
               .byte     18             ; position 15
               .text     "  f8  "
               .byte      146
               .byte     0

;-------- second function key set ------------------               
f1bbutton      .byte     menu2col1,fkeyleft,f1top
               .text     "basculer vert.." 
               .byte     18             ; position 15
               .byte     $a9
               .text     " f1 "
               .byte     223,146
               .byte     0

f2bbutton      .byte     menu2col2,fkeyleft,f1top+1
               .text     "basculer horz.."
               .byte     18             ; position 15
               .text     "  f2  "
               .byte     146
               .byte     0

f3bbutton      .byte     menu2col1,fkeyleft,f1top+3
               .text     "defiler droite."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f3 "
               .byte     223,146
               .byte     0

f4bbutton      .byte     menu2col2,fkeyleft,f1top+4
               .text     "defiler gauche."
               .byte     18             ; position 15
               .text     "  f4  "
               .byte     146
               .byte     0

f5bbutton      .byte     menu2col1,fkeyleft,f1top+6
               .text     "defiler haut..."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f5 "
               .byte     223,146
               .byte     0

f6bbutton      .byte     menu2col2,fkeyleft,f1top+7
               .text     "defiler bas...."
               .byte     18             ; position 15
               .text     "  f6  "
               .byte     146
               .byte     0

f7bbutton      .byte     menu2col1,fkeyleft,f1top+9
               .text     "inverser bits.."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f7 "
               .byte     223,146
               .byte     0

f8bbutton      .byte     menu2col2,fkeyleft,f1top+10
               .text     "aller au menu1."
               .byte     18             ; position 15
               .text     "  f8  "
               .byte     146
               .byte     0

; Variables locales
txt0           .null     "petscii :   "
txt1           .null     "key code:   "
txt2           .null     "bitmap..: "
txt3           .null     "offset..:   "
txt4           .null     "mapaddr.: "
txt5           .null     "cursval.: "
txt6           .null     "stack......:"