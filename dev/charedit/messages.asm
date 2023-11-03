blankmsg       .byte     1,0,5,146
               .null     "                                      "
edit_msg       .byte     1,0,5,18
               .null     " entry mode: chr$(   )"
save_msg       .byte     1,0,5,146
               .null     " save on cassette or disk? (c/d):"
load_msg       .byte     1,0,5
               .null     " load on cassette or disk? (c/d):"
copy_msg       .byte     1,0,5
               .null     " enter character to copy:"
clear_msg      .byte     1,0,5
               .null     " clear char: chr$(   )"
fill_msg       .byte     1,0,5
               .null     " fill char:  chr$(   )"
work_msg       .byte     1,0,5
               .null     " enable work space"
rvrs_msg       .byte     1,0,5
               .null     " reverse character:"
invr_msg       .byte     1,0,5
               .null     " inverting character:"
flip_msg       .byte     1,0,5
               .null     " flipping character:"
scrollr_msg    .byte     1,0,5
               .null     " scrolling right:"
scrolll_msg    .byte     1,0,5
               .null     " scrolling left:"
scrollu_msg    .byte     1,0,5
               .null     " scrolling up:"
scrolld_msg    .byte     1,0,5
               .null     " scrolling down:"
save_fname_msg .byte     1,0,5
               .null     " save: file name ------.chr"
load_fname_msg .byte     1,0,5
               .null     " load: file name ------.chr"
fkeyleft=18
f1top=8
f1abutton     .byte     1,fkeyleft,f1top
               .text     "edit....... "
               .byte     18
               .text     "   f1   "
               .byte     146,0
f2abutton     .byte     1,fkeyleft,f1top+2
               .text     "save....... "
               .byte     18
               .text     "   f2   "
               .byte     146,0
f3abutton     .byte     1,fkeyleft,f1top+4
               .text     "load....... "
               .byte     18
               .text     "   f3   "
               .byte     146,0
f4abutton     .byte     1,fkeyleft,f1top+6
               .text     "copy....... "
               .byte     18
               .text     "   f4   "
               .byte     146,0
f5abutton     .byte     1,fkeyleft,f1top+8
               .text     "clear...... "
               .byte     18
               .text     "   f5   "
               .byte     146,0
f6abutton     .byte     1,fkeyleft,f1top+10
               .text     "fill....... "
               .byte     18
               .text     "   f6   "
               .byte     146,0
f7abutton     .byte     1,fkeyleft,f1top+12
               .text     "work....... "
               .byte     18
               .text     "   f7   "
               .byte     146,0
f8abutton     .byte     1,fkeyleft,f1top+14
               .text     "function... "
               .byte     18
               .text     "   f8   "
               .byte     146,0
