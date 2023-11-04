mesgcol = vjaune

blankmsg       .byte     vjaune,0,5,146
               .null     "                                      "
edit_msg       .byte     vjaune,0,5,18
               .null     " entry mode: chr$(   )",146
save_msg       .byte     vjaune,0,5,146
               .null     " save on cassette or disk? (c/d):"
load_msg       .byte     vjaune,0,5
               .null     " load on cassette or disk? (c/d):"
copy_msg       .byte     vjaune,0,5
               .null     " enter character to copy:"
clear_msg      .byte     vjaune,0,5
               .null     " clear char: chr$(   )"
fill_msg       .byte     vjaune,0,5
               .null     " fill char:  chr$(   )"
work_msg       .byte     vjaune,0,5
               .null     " enable work space"
rvrs_msg       .byte     vjaune,0,5
               .null     " reverse character:"
invr_msg       .byte     vjaune,0,5
               .null     " inverting character:"
flip_msg       .byte     vjaune,0,5
               .null     " flipping character:"
scrollr_msg    .byte     vjaune,0,5
               .null     " scrolling right:"
scrolll_msg    .byte     vjaune,0,5
               .null     " scrolling left:"
scrollu_msg    .byte     vjaune,0,5
               .null     " scrolling up:"
scrolld_msg    .byte     vjaune,0,5
               .null     " scrolling down:"
save_fname_msg .byte     vjaune,0,5
               .null     " save: file name ------.chr"
load_fname_msg .byte     vjaune,0,5
               .null     " load: file name ------.chr"
fkeyleft=18
f1top=8
;--------- first function key set ------------------               
menu1col = 1
menu2col = 3
f1abutton      .byte     menu1col,fkeyleft,f1top       ;133
               .text     "edit....... "
               .byte     18             ; position 15
               .text     "   f1   "
               .byte     146,0
f2abutton      .byte     menu1col,fkeyleft,f1top+2     ;137
               .text     "save....... " 
               .byte     18            ; position 15
               .text     "   f2   "
               .byte     146,0
f3abutton      .byte     menu1col,fkeyleft,f1top+4     ;134
               .text     "load....... "
               .byte     18             ; position 15
               .text     "   f3   "
               .byte     146,0
f4abutton      .byte     menu1col,fkeyleft,f1top+6     ;138
               .text     "copy....... "
               .byte     18             ; position 15
               .text     "   f4   "
               .byte     146,0
f5abutton      .byte     menu1col,fkeyleft,f1top+8     ;135
               .text     "clear...... "
               .byte     18             ; position 15
               .text     "   f5   "
               .byte     146,0     
f6abutton      .byte     menu1col,fkeyleft,f1top+10    ;139
               .text     "fill....... "
               .byte     18             ; position 15
               .text     "   f6   "
               .byte     146,0
f7abutton      .byte     menu1col,fkeyleft,f1top+12    ;136
               .text     "work....... "
               .byte     18             ; position 15
               .text     "   f7   "
               .byte     146,0
f8abutton      .byte     menu1col,fkeyleft,f1top+14    ;140
               .text     "function... "
               .byte     18             ; position 15
               .text     "   f8   "
               .byte     146,0
;-------- second function key set ------------------               
f1bbutton      .byte     menu2col,fkeyleft,f1top
               .text     "reverse.... "
               .byte     18             ; position 15
               .text     "   f1   "
               .byte     146,0
f2bbutton      .byte     menu2col,fkeyleft,f1top+2
               .text     "invert..... " 
               .byte     18             ; position 15
               .text     "   f2   "
               .byte     146,0
f3bbutton      .byte     menu2col,fkeyleft,f1top+4
               .text     "flip....... "
               .byte     18             ; position 15
               .text     "   f3   "
               .byte     146,0
f4bbutton      .byte     menu2col,fkeyleft,f1top+6
               .text     "scroll r... "
               .byte     18             ; position 15
               .text     "   f4   "
               .byte     146,0
f5bbutton      .byte     menu2col,fkeyleft,f1top+8
               .text     "scroll l... "
               .byte     18             ; position 15
               .text     "   f5   "
               .byte     146,0
f6bbutton      .byte     menu2col,fkeyleft,f1top+10
               .text     "scroll u... "
               .byte     18             ; position 15
               .text     "   f6   "
               .byte     146,0
f7bbutton      .byte     menu2col,fkeyleft,f1top+12
               .text     "scroll d... "
               .byte     18             ; position 15
               .text     "   f7   "
               .byte     146,0
f8bbutton      .byte     menu2col,fkeyleft,f1top+14
               .text     "function... "
               .byte     18             ; position 15
               .text     "   f8   "
               .byte     146,0
