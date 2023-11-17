
editor_msg     .byte vrose,1,5
               .null     "[editor]"

blankmsg       .byte     mesgcol,0,5,146
               .null     "                                       "

prompt_msg     .byte     mesgcol,0,5,146
               .null     " enter f-key command :"

f1a_msg
edit_msg       .byte     mesgcol,0,5,146     ;18
               .null     " edit mode: chr$(   )",146
f2a_msg
copy_msg       .byte     mesgcol,0,5
               .null     " enter character to copy:"
f3a_msg
save_msg       .byte     mesgcol,0,5,146
               .null     " save on cassette or disk? (c/d): "
f4a_msg
load_msg       .byte     mesgcol,0,5,146
               .null     " load from cassette or disk? (c/d): "
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
               .null     " you are now in menu a."
menub_msg      .byte     mesgcol,0,5
               .null     " you are now in menu b."

copychar_msg   .byte     vjaune,0,5
               .null     " enter character to copy from (?).",157,157,157

fname_msg      .byte     vjaune,0,5
               .null     " enter a 6 letter filename : ",$a4,$a4,$a4,$a4,$a4,$a4,".chr",157,157,157,157,157,157,157,157,157,157


quit_msg       .byte     vblue1,21,24,18
               .text     "ctrl-x",146
               .null     " to quit."     
menu_msg
exit_msg       .byte     vvert1,21,24,18
               .text     "ctrl-x",146
               .null     " to menu."     


      

whoami0        .byte     whoamicol,4,6,18
               .null     "                               ",146

whoami1        .byte     whoamicol,4,7,18
               .null     "          ",146," charedit ",18,"           ",146
 
whoami2        .byte     whoamicol,4,8,18
               .null     "                               ",146

whoami3        .byte     whoamicol,4,9,18
               .null     "  inspired from john heilborn  ",146

whoami4        .byte     whoamicol,4,10,18
               .null     "      isbn: 0-942386-29-9      ",146

whoami5        .byte     whoamicol,4,11,18
               .null     "                               ",146

whoami6        .byte     whoamicol,4,12,18
               .null     " coded in assembly language by ",146

whoami7        .byte     whoamicol,4,13,18
               .null     "     daniel lafrance 2023      ",146

whoami8        .byte     whoamicol,4,14,18
               .null     "    version:",version,"    ",146

whoami9        .byte     whoamicol,4,15,18
               .null     "                               ",146

bye_msg        .byte     vcyan,6,16,20
               .null     " thanks and have a good day ",146

any_msg        .byte     vvert1,5,24,18
               .null         "  use the [anykey] to basic  ",146

fkeyleft=18
f1top=8
;--------- first function key set ------------------               




f1abutton      .byte     menu1col1,fkeyleft,f1top       ;133
               .text     "edit char....."
               .byte     18             ; position 15
               .null     $a9," f1 ",223,146
f2abutton      .byte     menu1col2,fkeyleft,f1top+1     ;138
               .text     "copy from....."
               .byte     18   ; position 15
               .null     "  f2  ",146
f3abutton      .byte     menu1col1,fkeyleft,f1top+3     ;137
               .text     "save to......." 
               .byte     18            ; position 15
               .null     $a9," f3 ",223,146
f4abutton      .byte     menu1col2,fkeyleft,f1top+4     ;134
               .text     "load from....."
               .byte     18             ; position 15
               .null     "  f4  ",146
f5abutton      .byte     menu1col1,fkeyleft,f1top+6     ;135
               .text     "clear........."
               .byte     18             ; position 15
               .null     $a9," f5 ",223,146
f6abutton      .byte     menu1col2,fkeyleft,f1top+7    ;139
               .text     "fill.........."
               .byte     18             ; position 15
               .null     "  f6  ",146
f7abutton      .byte     menu1col1,fkeyleft,f1top+9    ;136
               .text     "restore all..."
               .byte     18             ; position 15
               .null     $a9," f7 ",223,146
f8abutton      .byte     menu1col2,fkeyleft,f1top+10
               .text     "function      "
               .byte     18             ; position 15
               .null     "  f8  ", 146
;-------- second function key set ------------------               
f1bbutton      .byte     menu2col1,fkeyleft,f1top
               .text     "flip vert....." 
               .byte     18             ; position 15
               .null     $a9," f1 ",223,146
f2bbutton      .byte     menu2col2,fkeyleft,f1top+1
               .text     "flip horz....."
               .byte     18             ; position 15
               .null     "  f2  ",146
f3bbutton      .byte     menu2col1,fkeyleft,f1top+3
               .text     "scroll right.."
               .byte     18             ; position 15
               .null     $a9," f3 ",223,146
f4bbutton      .byte     menu2col2,fkeyleft,f1top+4
               .text     "scroll left..."
               .byte     18             ; position 15
               .null     "  f4  ",146
f5bbutton      .byte     menu2col1,fkeyleft,f1top+6
               .text     "scroll up....."
               .byte     18             ; position 15
               .null     $a9," f5 ",223,146
f6bbutton      .byte     menu2col2,fkeyleft,f1top+7
               .text     "scroll down..."
               .byte     18             ; position 15
               .null     "  f6  ",146
f7bbutton      .byte     menu2col1,fkeyleft,f1top+9
               .text     "reverse bits.."
               .byte     18             ; position 15
               .null     $a9," f7 ",223,146
f8bbutton      .byte     menu2col2,fkeyleft,f1top+10
               .text     "function      "
               .byte     18             ; position 15
               .null     "  f8  ", 146
 