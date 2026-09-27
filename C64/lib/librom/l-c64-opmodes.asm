;---------------------------------------
; table des modes d'adressage.
;---------------------------------------
; mode d'adressage
; 0 = implicite ;0;
; 1 = accumulateur ;1;
; 2 = immediat ;2;
; 3 = absolue ;3;
; 4 = relatif ;4;
; 5 = absolue,x ;5;
; 6 = absolue,y ;6;
; 7 = zero page ;7;
; 8 = zero page,x ;8;
; 9 = zero page,y ;9;
; 10 = (zero page,x) ;10;
; 11 = (zeropage),y ;11;
; 12 = (absolue ind) ;12;
;---------------------------------------
opmodes 
	.byte   0, 10,  0,  0,  0,  7,  7,  0
	.byte   0,  2,  0,  0,  0,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5,  5,  0
	.byte   3, 10,  0,  0,  7,  7,  7,  0
	.byte   0,  2,  1,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5,  5,  0
	.byte   0, 10,  0,  0,  0,  7,  7,  0
	.byte   0,  2,  1,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5,  5,  0
	.byte   0, 10,  0,  0,  0,  7,  7,  0
	.byte   0,  2,  1,  0, 12,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5,  5,  0
	.byte   0, 10,  0,  0,  7,  7,  7,  0
	.byte   0,  0,  0,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  8,  8,  9,  0
	.byte   0,  6,  0,  0,  0,  5,  0,  0
	.byte   2, 10,  2,  0,  7,  7,  7,  0
	.byte   0,  2,  0,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  8,  8,  9,  0
	.byte   0,  6,  0,  0,  5,  5,  6,  0
	.byte   2, 10,  0,  0,  7,  7,  7,  0
	.byte   0,  2,  0,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5,  5,  0
	.byte   2, 10,  0,  0,  7,  7,  7,  0
	.byte   0,  2,  0,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8,  8,  0
opmoddesc
opmod0	.null "imp."
opmod1	.null "acc."
opmod2	.null "imm."
opmod3	.null "abs."
opmod4	.null "rel."
opmod5	.null "abs.,indx"
opmod6	.null "abs.,indy"
opmod7	.null "zpage indirect"
opmod8	.null "zpage,indx"
opmod9	.null "zpage,indy"
opmod10	.null "(zpage,indx)"
opmod11	.null "(zpage),indy"
opmod12	.null "(abs. ind)"
opmodvec 
	.word opmod0,opmod1,opmod2,opmod3
	.word opmod4,opmod5,opmod6,opmod7
	.word opmod8,opmod9,opmod10,opmod11
	.word opmod12

