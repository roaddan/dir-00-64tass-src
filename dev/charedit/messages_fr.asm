
editor_msg     .byte vrose,1,5
               .null     "[editeur]"

blankmsg       .byte     mesgcol,0,5,146
               .null     "                                       "

prompt_msg     .byte     mesgcol,0,5,146
               .null     " utilisez les clefs de fonction :"

f1a_msg
edit_msg       .byte     mesgcol,0,5,146     ;18
               .null     " mode edit: chr$(   )",146
f2a_msg
copy_msg       .byte     mesgcol,0,5
               .null     " entez le character a copier:"
f3a_msg
save_msg       .byte     mesgcol,0,5,146
               .null     " sauver sur cassette or disque? (c/d): "
f4a_msg
load_msg       .byte     mesgcol,0,5,146
               .null     " charger d'une cassette ou disk? (c/d): "
f5a_msg
clear_msg      .byte     mesgcol,0,5
               .null     " effacer char: chr$(   )"
f6a_msg
fill_msg       .byte     mesgcol,0,5
               .null     " remplir char:  chr$(   )"
f7a_msg
work_msg       .byte     mesgcol,0,5
               .null     " recuperer les caracteres."

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
               .null     " defiler vers le haut:"
f6b_msg
scrolld_msg    .byte     mesgcol,0,5
               .null     " defiler vers le bas:"
f7b_msg
rvrs_msg       .byte     mesgcol,0,5
               .null     " reverse character:"

menua_msg      .byte     mesgcol,0,5
               .null     " vous etes dirige vers le menu 1."
menub_msg      .byte     mesgcol,0,5
               .null     " vous etes dirige vers le menu 2."

copychar_msg   .byte     vjaune,0,5
               .null     " entrez le caractera a copier (?).",157,157,157

fname_msg      .byte     vjaune,0,5
               .null     " nom du fichier (6 lettres): ",$a4,$a4,$a4,$a4,$a4,$a4,".chr",157,157,157,157,157,157,157,157,157,157


quit_msg       .byte     vblue1,21,24,18
               .text     "ctrl-x",146
               .null     "-quitter."     
menu_msg
exit_msg       .byte     vvert1,21,24,18
               .text     "ctrl-x",146
               .null     " au menu."     


      

whoami0        .byte     whoamicol,4,6,18
               .null     "                               ",146

whoami1        .byte     whoamicol,4,7,18
               .null     "       ",146," c h a r e d i t ",18,"       ",146
 
whoami2        .byte     whoamicol,4,8,18
               .null     "                               ",146

whoami3        .byte     whoamicol,4,9,18
               .null     "    inspire de john heilborn   ",146

whoami4        .byte     whoamicol,4,10,18
               .null     "      isbn: 0-942386-29-9      ",146

whoami5        .byte     whoamicol,4,11,18
               .null     "                               ",146

whoami6        .byte     whoamicol,4,12,18 
               .null     "      code assembleur par      ",146

whoami7        .byte     whoamicol,4,13,18
               .null     " daniel lafrance quebec/canada ",146

whoami8        .byte     whoamicol,4,14,18
               .null     "    version:",version,"    ",146

whoami9        .byte     whoamicol,4,15,18
               .null     "                               ",146

bye_msg        .byte     vcyan,6,16,20
               .null     "      bonjour et merci      ",146

any_msg        .byte     vvert1,5,24,18
               .null     " appuyez une cle pour basic ",146


;--------- first function key set ------------------               

titremenu1     .byte     menu1col1,fkeyleft,f1top-2       ;133
               .null     18," jeu de fonctions #1 ",146
titremenu2     .byte     menu2col1,fkeyleft,f1top-2       ;133
               .null     18," jeu de fonctions #2 ",146


f1abutton      .byte     menu1col1,fkeyleft,f1top       ;133
               .text     "editer carac..."
               .byte     18             ; position 15
               .null     $a9," f1 ",223,146
f2abutton      .byte     menu1col2,fkeyleft,f1top+1     ;138
               .text     "copy du car...."
               .byte     18   ; position 15
               .null     "  f2  ",146
f3abutton      .byte     menu1col1,fkeyleft,f1top+3     ;137
               .text     "savegarder sur." 
               .byte     18            ; position 15
               .null     $a9," f3 ",223,146
f4abutton      .byte     menu1col2,fkeyleft,f1top+4     ;134
               .text     "charger de....."
               .byte     18             ; position 15
               .null     "  f4  ",146
f5abutton      .byte     menu1col1,fkeyleft,f1top+6     ;135
               .text     "effacer........"
               .byte     18             ; position 15
               .null     $a9," f5 ",223,146
f6abutton      .byte     menu1col2,fkeyleft,f1top+7    ;139
               .text     "remplir........"
               .byte     18             ; position 15
               .null     "  f6  ",146
f7abutton      .byte     menu1col1,fkeyleft,f1top+9    ;136
               .text     "recuperer rom.."
               .byte     18             ; position 15
               .null     $a9," f7 ",223,146
f8abutton      .byte     menu1col2,fkeyleft,f1top+10
               .text     "afficher menu2."
               .byte     18             ; position 15
               .null     "  f8  ", 146
;-------- second function key set ------------------               
f1bbutton      .byte     menu2col1,fkeyleft,f1top
               .text     "basculer vert.." 
               .byte     18             ; position 15
               .null     $a9," f1 ",223,146
f2bbutton      .byte     menu2col2,fkeyleft,f1top+1
               .text     "basculer horz.."
               .byte     18             ; position 15
               .null     "  f2  ",146
f3bbutton      .byte     menu2col1,fkeyleft,f1top+3
               .text     "defil. droite.."
               .byte     18             ; position 15
               .null     $a9," f3 ",223,146
f4bbutton      .byte     menu2col2,fkeyleft,f1top+4
               .text     "defil. gauche.."
               .byte     18             ; position 15
               .null     "  f4  ",146
f5bbutton      .byte     menu2col1,fkeyleft,f1top+6
               .text     "defil. haut...."
               .byte     18             ; position 15
               .null     $a9," f5 ",223,146
f6bbutton      .byte     menu2col2,fkeyleft,f1top+7
               .text     "defil. bas....."
               .byte     18             ; position 15
               .null     "  f6  ",146
f7bbutton      .byte     menu2col1,fkeyleft,f1top+9
               .text     "inverser bits.."
               .byte     18             ; position 15
               .null     $a9," f7 ",223,146
f8bbutton      .byte     menu2col2,fkeyleft,f1top+10
               .text     "afficher menu1."
               .byte     18             ; position 15
               .null     "  f8  ", 146
 