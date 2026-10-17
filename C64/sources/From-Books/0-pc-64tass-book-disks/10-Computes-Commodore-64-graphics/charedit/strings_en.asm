editor_msg     .byte vrose,1,5
               .null     "[editor]"

blankmsg       .byte     mesgcol,0,5,146
               .null     "                                       "

prompt_msg     .byte     mesgcol,0,5,146
               .null     " enter f-key command :"

wait_msg       .byte     mesgcol,0,5,146
               .null     " one moment please ... "
f1a_msg
edit_msg       .byte     mesgcol,0,5,146     ;18
               .text     " edit mode: chr$(   )"
               .byte     146.0
f2a_msg
copy_msg       .byte     mesgcol,0,5
               .null     " enter character to copy:"
f3a_msg
save_msg       .byte     mesgcol,0,5,146
               .null     " save on witch device? (1/8/9): "
f4a_msg
load_msg       .byte     mesgcol,0,5,146
               .null     " load from witch device? (1/8/9): "
f5a_msg
clear_msg      .byte     mesgcol,0,5
               .null     " clear char: chr$(   )"
f6a_msg
fill_msg       .byte     mesgcol,0,5
               .null     " fill char:  chr$(   )"
f7a_msg
work_msg       .byte     mesgcol,0,5
               .null     " restoring all characters."
f1b_msg
invr_msg       .byte     mesgcol,0,5
               .null     " flipping vertically:"
f2b_msg
flip_msg       .byte     mesgcol,0,5
               .null     " flipping horizontally:"
f3b_msg
scrollr_msg    .byte     mesgcol,0,5
               .null     " scrolling right:"
f4b_msg
scrolll_msg    .byte     mesgcol,0,5
               .null     " scrolling left:"
f5b_msg
scrollu_msg    .byte     mesgcol,0,5
               .null     " scrolling up:"
f6b_msg
scrolld_msg    .byte     mesgcol,0,5
               .null     " scrolling down:"
f7b_msg
rvrs_msg       .byte     mesgcol,0,5
               .null     " reverse character:"

menua_msg      .byte     mesgcol,0,5
               .null     " you are being moved to menu 1."
               
menub_msg      .byte     mesgcol,0,5
               .null     " you are being moved to menu 2."

copychar_msg   .byte     vjaune,0,5
               .text     " enter character to copy from (?).",
               .byte     157,157,157
               .byte     0

fname_msg      .byte     vjaune,0,5
               .text     " enter a 6 letter filename : "
               .byte     $a4,$a4,$a4,$a4,$a4,$a4
               .text     ".chr"
               .byte     157,157,157,157,157,157,157,157,157,157
               .byte     0

quit_msg       .byte     vmauve,21,24,18
               .text     "ctrl-x"
               .byte     146
               .null     " to quit."     

redraw_msg     .byte     vrose,20,22,18
               .text     "ctrl-r"
               .byte     146
               .null     " to redraw."     
menu_msg
exit_msg       .byte     vvert1,21,24,18
               .text     "ctrl-x"
               .byte     146
               .null     " to menu."     

whoami0        .byte     whoamicol,4,6,18
               .text     "                               "
               .byte     146
               .byte     0

whoami1        .byte     whoamicol,4,7,18
               .text     "          "
               .byte     146," charedit "
               .byte     18,"           "
               .byte     146
               .byte     0
 
whoami2        .byte     whoamicol,4,8,18
               .text     "                               "
               .byte     146
               .byte     0

whoami3        .byte     whoamicol,4,9,18
               .text     "   from isbn : 0-942386-29-9   "
               .byte     146
               .byte     0

whoami4        .byte     whoamicol,4,10,18
               .text     "        by john heilborn       "
               .byte     146
               .byte     0

whoami5        .byte     whoamicol,4,11,18
               .text     "                               "
               .byte     146
               .byte     0

whoami6        .byte     whoamicol,4,12,18
               .text     " coded in assembly language by "
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
               .text     " thanks and have a good day "
               .byte     146
               .byte     0

any_msg        .byte     vvert1,5,24,18
               .null         "  use the [anykey] to basic  "
               .byte     146
               .byte     0

;--------- first function key set ------------------               

titremenu1     .byte     menu1col1,fkeyleft,f1top-2
               .byte     18,"   function set #1   "
               .byte     146
               .byte     0

titremenu2     .byte     menu2col1,fkeyleft,f1top-2       ;133
               .byte     18,"   function set #2   "
               .byte     146
               .byte     0

f1abutton      .byte     menu1col1,fkeyleft,f1top       ;133
               .text     "edit character."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f1 "
               .byte     223,146
               .byte     0

f2abutton      .byte     menu1col2,fkeyleft,f1top+1     ;138
               .text     "copy from......"
               .byte     18   ; position 15
               .text     "  f2  "
               .byte     146
               .byte     0

f3abutton      .byte     menu1col1,fkeyleft,f1top+3     ;137
               .text     "save to........" 
               .byte     18            ; position 15
               .byte     $a9
               .text     " f3 "
               .byte     223,146
               .byte     0

f4abutton      .byte     menu1col2,fkeyleft,f1top+4     ;134
               .text     "load from......"
               .byte     18             ; position 15
               .text     "  f4  "
               .byte     146
               .byte     0

f5abutton      .byte     menu1col1,fkeyleft,f1top+6     ;135
               .text     "clear.........."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f5 "
               .byte     223,146
               .byte     0

f6abutton      .byte     menu1col2,fkeyleft,f1top+7    ;139
               .text     "fill..........."
               .byte     18             ; position 15
               .text     "  f6  "
               .byte     146
               .byte     0

f7abutton      .byte     menu1col1,fkeyleft,f1top+9    ;136
               .text     "restore all...."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f7 "
               .byte     223,146
               .byte     0

f8abutton      .byte     menu1col2,fkeyleft,f1top+10
               .text     "go to menu #2.."
               .byte     18             ; position 15
               .text     "  f8  "
               .byte     146
               .byte     0

;-------- second function key set ------------------               
f1bbutton      .byte     menu2col1,fkeyleft,f1top
               .text     "vertical flip.." 
               .byte     18             ; position 15
               .byte     $a9
               .text     " f1 "
               .byte     223,146
               .byte     0

f2bbutton      .byte     menu2col2,fkeyleft,f1top+1
               .text     "horzontal flip."
               .byte     18             ; position 15
               .text     "  f2  "
               .byte     146
               .byte     0

f3bbutton      .byte     menu2col1,fkeyleft,f1top+3
               .text     "scroll to right"
               .byte     18             ; position 15
               .byte     $a9
               .text     " f3 "
               .byte     223,146
               .byte     0

f4bbutton      .byte     menu2col2,fkeyleft,f1top+4
               .text     "scroll to left."
               .byte     18             ; position 15
               .text     "  f4  "
               .byte     146
               .byte     0

f5bbutton      .byte     menu2col1,fkeyleft,f1top+6
               .text     "scroll up......"
               .byte     18             ; position 15
               .byte     $a9
               .text     " f5 "
               .byte     223,146
               .byte     0

f6bbutton      .byte     menu2col2,fkeyleft,f1top+7
               .text     "scroll down...."
               .byte     18             ; position 15
               .text     "  f6  "
               .byte     146
               .byte     0

f7bbutton      .byte     menu2col1,fkeyleft,f1top+9
               .text     "reverse bits..."
               .byte     18             ; position 15
               .byte     $a9
               .text     " f7 "
               .byte     223,146
               .byte     0

f8bbutton      .byte     menu2col2,fkeyleft,f1top+10
               .text     "go to menu #1.."
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