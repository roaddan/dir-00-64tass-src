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

