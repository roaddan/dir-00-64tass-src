;---------------------------------------
; Table de mneumoniques
;---------------------------------------
mneumon 
	.text "brk,ora,---,---,---,ora"
	.text "asl,---,php,ora,asl,---"
	.text "---,ora,asl,---,bpl,ora"
	.text "---,---,---,ora,asl,---"
	.text "clc,ora,---,---,---,ora"
	.text "asl,---,jsr,and,---,---"
	.text "bit,and,rol,---,plp,and"
	.text "rol,---,bit,and,rol,---"
	.text "bmi,and,---,---,---,and"
	.text "rol,---,sec,and,---,---"
	.text "---,and,rol,---,rti,eor"
	.text "---,---,---,eor,lsr,---"
	.text "pha,eor,lsr,---,jmp,eor"
	.text "lsr,---,bvc,eor,---,---"
	.text "---,eor,lsr,---,cli,eor"
	.text "---,---,---,eor,lsr,---"
	.text "rts,adc,---,---,---,adc"
	.text "ror,---,pla,adc,ror,---"
	.text "jmp,adc,ror,---,bvs,adc"
	.text "---,---,---,adc,ror,---"
	.text "sei,adc,---,---,---,adc"
	.text "ror,---,---,sta,---,---"
	.text "sty,sta,stx,---,dey,---"
	.text "txa,---,sty,sta,stx,---"
	.text "bcc,sta,---,---,sty,sta"
	.text "stx,---,tya,sta,txs,---"
	.text "---,sta,---,---,ldy,lda"
	.text "ldx,---,ldy,lda,ldx,---"
	.text "tay,lda,tax,---,ldy,lda"
	.text "ldx,---,bcs,lda,---,---"
	.text "ldy,lda,ldx,---,clv,lda"
	.text "tsx,---,ldy,lda,ldx,---"
	.text "cpy,cmp,---,---,cpy,cmp"
	.text "dec,---,iny,cmp,dex,---"
	.text "cpy,cmp,dec,---,bne,cmp"
	.text "---,---,---,cmp,dec,---"
	.text "cld,cmp,---,---,---,cmp"
	.text "dec,---,cpx,sbc,---,---"
	.text "cpx,sbc,inc,---,inx,sbc"
	.text "nop,---,cpx,sbc,inc,---"
	.text "beq,sbc,---,---,---,sbc"
	.text "inc,---,sed,sbc,---,---"
	.text "---,sbc,inc,---"
;---------------------------------------
; Table des operandes hexadecimaux
;---------------------------------------
opcode 
     .byte $00,$01,$ff,$ff,$ff,$05
	.byte $06,$ff,$08,$09,$0a,$ff
	.byte $ff,$0d,$0e,$ff,$10,$11
	.byte $ff,$ff,$ff,$15,$16,$ff
	.byte $18,$19,$ff,$ff,$ff,$1d
	.byte $1e,$ff,$20,$21,$ff,$ff
	.byte $24,$25,$26,$ff,$28,$29
	.byte $2a,$ff,$2c,$2d,$2e,$ff
	.byte $30,$31,$ff,$ff,$ff,$35
	.byte $36,$ff,$38,$39,$ff,$ff
	.byte $ff,$3d,$3e,$ff,$40,$41
	.byte $ff,$ff,$ff,$45,$46,$ff
	.byte $48,$49,$4a,$ff,$4c,$4d
	.byte $4e,$ff,$50,$51,$ff,$ff
	.byte $ff,$55,$56,$ff,$58,$59
	.byte $ff,$ff,$ff,$5d,$5e,$ff
	.byte $60,$61,$ff,$ff,$ff,$65
	.byte $66,$ff,$68,$69,$6a,$ff
	.byte $6c,$6d,$6e,$ff,$70,$71
	.byte $ff,$ff,$ff,$75,$76,$ff
	.byte $78,$79,$ff,$ff,$ff,$7d
	.byte $7e,$ff,$ff,$81,$ff,$ff
	.byte $84,$85,$86,$ff,$88,$ff
	.byte $8a,$ff,$8c,$8d,$8e,$ff
	.byte $90,$91,$ff,$ff,$94,$95
	.byte $96,$ff,$98,$99,$9a,$ff
	.byte $ff,$9d,$ff,$ff,$a0,$a1
	.byte $a2,$ff,$a4,$a5,$a6,$ff
	.byte $a8,$a9,$aa,$ff,$ac,$ad
	.byte $ae,$ff,$b0,$b1,$ff,$ff
	.byte $b4,$b5,$b6,$ff,$b8,$b9
	.byte $ba,$ff,$bc,$bd,$be,$ff
	.byte $c0,$c1,$ff,$ff,$c4,$c5
	.byte $c6,$ff,$c8,$c9,$ca,$ff
	.byte $cc,$cd,$ce,$ff,$d0,$d1
	.byte $ff,$ff,$ff,$d5,$d6,$ff
	.byte $d8,$d9,$ff,$ff,$ff,$dd
	.byte $de,$ff,$e0,$e1,$ff,$ff
	.byte $e4,$e5,$e6,$ff,$e8,$e9
	.byte $ea,$ff,$ec,$ed,$ee,$ff
	.byte $f0,$f1,$ff,$ff,$ff,$f5
	.byte $f6,$ff,$f8,$f9,$ff,$ff
	.byte $ff,$fd,$fe,$ff
;---------------------------------------
; Table des modes d'adressage.
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
     .byte   0, 10,  0,  0,  0,  7
	.byte   7,  0,  0,  2,  0,  0
	.byte   0,  3,  3,  0,  4, 11
	.byte   0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5
	.byte   5,  0,  3, 10,  0,  0
	.byte   7,  7,  7,  0,  0,  2
	.byte   1,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8
	.byte   8,  0,  0,  6,  0,  0
	.byte   0,  5,  5,  0,  0, 10
	.byte   0,  0,  0,  7,  7,  0
	.byte   0,  2,  1,  0,  3,  3
	.byte   3,  0,  4, 11,  0,  0
	.byte   0,  8,  8,  0,  0,  6
	.byte   0,  0,  0,  5,  5,  0
	.byte   0, 10,  0,  0,  0,  7
	.byte   7,  0,  0,  2,  1,  0
	.byte  12,  3,  3,  0,  4, 11
	.byte   0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5
	.byte   5,  0,  0, 10,  0,  0
	.byte   7,  7,  7,  0,  0,  0
	.byte   0,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  8,  8
	.byte   9,  0,  0,  6,  0,  0
	.byte   0,  5,  0,  0,  2, 10
	.byte   2,  0,  7,  7,  7,  0
	.byte   0,  2,  0,  0,  3,  3
	.byte   3,  0,  4, 11,  0,  0
	.byte   8,  8,  9,  0,  0,  6
	.byte   0,  0,  5,  5,  6,  0
	.byte   2, 10,  0,  0,  7,  7
	.byte   7,  0,  0,  2,  0,  0
	.byte   3,  3,  3,  0,  4, 11
	.byte   0,  0,  0,  8,  8,  0
	.byte   0,  6,  0,  0,  0,  5
	.byte   5,  0,  2, 10,  0,  0
	.byte   7,  7,  7,  0,  0,  2
	.byte   0,  0,  3,  3,  3,  0
	.byte   4, 11,  0,  0,  0,  8
	.byte   8,  0,  0,  6,  0,  0
	.byte   0,  5,  5,  0
;---------------------------------------
; Table des nombrer d'octets
;---------------------------------------
opbytes 
     .byte   1,  2,  0,  0,  0,  2
	.byte   2,  0,  1,  1,  1,  0
	.byte   0,  3,  3,  0,  2,  2
	.byte   0,  0,  0,  2,  2,  0
	.byte   1,  3,  0,  0,  0,  3
	.byte   3,  0, 13,  2,  0,  0
	.byte   2,  2,  2,  0,  1,  2
	.byte   1,  0,  3,  3,  3,  0
	.byte   2,  2,  0,  0,  0,  2
	.byte   2,  0,  1,  3,  0,  0
	.byte   0,  3,  3,  0,  1,  2
	.byte   0,  0,  0,  2,  2,  0
	.byte   1,  2,  1,  0,  3,  3
	.byte   3,  0,  2,  2,  0,  0
	.byte   0,  2,  2,  0,  1,  3
	.byte   0,  0,  0,  3,  3,  0
	.byte   1,  2,  0,  0,  0,  2
	.byte   2,  0,  1,  2,  1,  0
	.byte   3,  3,  3,  0,  2,  2
	.byte   0,  0,  0,  2,  2,  0
	.byte   1,  3,  0,  0,  0,  3
	.byte   3,  0,  0,  2,  0,  0
	.byte   2,  2,  2,  0,  1,  0
	.byte   1,  0,  3,  3,  3,  0
	.byte   2,  2,  0,  0,  2,  2
	.byte   2,  0,  1,  3,  1,  0
	.byte   0,  3,  0,  0,  2,  2
	.byte   2,  0,  2,  2,  2,  0
	.byte   1,  2,  1,  0,  3,  3
	.byte   3,  0,  2,  2,  0,  0
	.byte   2,  2,  2,  0,  1,  3
	.byte   1,  0,  3,  3,  3,  0
	.byte   2,  2,  0,  0,  2,  2
	.byte   2,  0,  1,  2,  1,  0
	.byte   3,  3,  3,  0,  2,  2
	.byte   0,  0,  0,  2,  2,  0
	.byte   1,  3,  0,  0,  0,  3
	.byte   3,  0,  2,  2,  0,  0
	.byte   2,  2,  2,  0,  1,  2
	.byte   1,  0,  3,  3,  3,  0
	.byte   2,  2,  0,  0,  0,  2
	.byte   2,  0,  1,  3,  0,  0
	.byte   0,  3,  3,  0
;---------------------------------------
; Table des cycles
;---------------------------------------
opcycles 
     .byte   7,  6,  0,  0,  0,  3
	.byte   5,  0,  3,  5,  2,  0
	.byte   0,  4,  6,  0,  2,  5
	.byte   0,  0,  0,  4,  6,  0
	.byte   2,  4,  0,  0,  0,  4
	.byte   7,  0,  6,  6,  0,  0
	.byte   3,  3,  5,  0,  4,  2
	.byte   2,  0,  4,  4,  6,  0
	.byte   2,  5,  0,  0,  0,  4
	.byte   6,  0,  2,  4,  0,  0
	.byte   0,  4,  7,  0,  6,  6
	.byte   0,  0,  0,  3,  5,  0
	.byte   3,  2,  2,  0,  3,  4
	.byte   6,  0,  2,  5,  0,  0
	.byte   0,  4,  6,  0,  2,  4
	.byte   0,  0,  0,  4,  7,  0
	.byte   6,  6,  0,  0,  0,  3
	.byte   5,  0,  4,  2,  2,  0
	.byte   5,  4,  6,  0,  2,  5
	.byte   0,  0,  0,  4,  6,  0
	.byte   2,  4,  0,  0,  0,  4
	.byte   7,  0,  0,  6,  0,  0
	.byte   3,  3,  3,  0,  2,  0
	.byte   2,  0,  4,  4,  4,  0
	.byte   2,  6,  0,  0,  4,  4
	.byte   4,  0,  2,  5,  2,  0
	.byte   0,  5,  0,  0,  2,  6
	.byte   2,  0,  3,  3,  3,  0
	.byte   2,  2,  2,  0,  4,  4
	.byte   4,  0,  2,  5,  0,  0
	.byte   4,  4,  4,  0,  2,  4
	.byte   2,  0,  4,  4,  4,  0
	.byte   2,  6,  0,  0,  3,  3
	.byte   5,  0,  2,  2,  2,  0
	.byte   4,  4,  6,  0,  2,  5
	.byte   0,  0,  0,  4,  6,  0
	.byte   2,  4,  0,  0,  0,  4
	.byte   7,  0,  2,  6,  0,  0
	.byte   3,  3,  5,  0,  2,  2
	.byte   2,  0,  4,  4,  6,  0
	.byte   2,  5,  0,  0,  0,  4
	.byte   6,  0,  2,  4,  0,  0
	.byte   0,  4,  7,  0