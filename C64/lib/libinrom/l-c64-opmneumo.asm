;---------------------------------------
; table de mneumoniques
;---------------------------------------
opmneumo 
	.text "brk,ora,---,---,---,ora,asl,---," ;$00-$07
	.text "php,ora,asl,---,---,ora,asl,---," ;$08-$0f
	.text "bpl,ora,---,---,---,ora,asl,---," ;$10-$17
	.text "clc,ora,---,---,---,ora,asl,---," ;$18-$1f
	.text "jsr,and,---,---,bit,and,rol,---," ;$20-$27
	.text "plp,and,rol,---,bit,and,rol,---," ;$28-$2f
	.text "bmi,and,---,---,---,and,rol,---," ;$30-$37
	.text "sec,and,---,---,---,and,rol,---," ;$38-$3f
	.text "rti,eor,---,---,---,eor,lsr,---," ;$40-$47
	.text "pha,eor,lsr,---,jmp,eor,lsr,---," ;$48-$4f
	.text "bvc,eor,---,---,---,eor,lsr,---," ;$50-$57
	.text "cli,eor,---,---,---,eor,lsr,---," ;$58-$5f
	.text "rts,adc,---,---,---,adc,ror,---," ;$60-$67
	.text "pla,adc,ror,---,jmp,adc,ror,---," ;$68-$6f
	.text "bvs,adc,---,---,---,adc,ror,---," ;$70-$77
	.text "sei,adc,---,---,---,adc,ror,---," ;$78-$7f
	.text "---,sta,---,---,sty,sta,stx,---," ;$80-$87
	.text "dey,---,txa,---,sty,sta,stx,---," ;$88-$8f
	.text "bcc,sta,---,---,sty,sta,stx,---," ;$90-$97
	.text "tya,sta,txs,---,---,sta,---,---," ;$98-$9f
	.text "ldy,lda,ldx,---,ldy,lda,ldx,---," ;$a0-$a7
	.text "tay,lda,tax,---,ldy,lda,ldx,---,"
	.text "bcs,lda,---,---,ldy,lda,ldx,---,"
	.text "clv,lda,tsx,---,ldy,lda,ldx,---,"
	.text "cpy,cmp,---,---,cpy,cmp,dec,---,"
	.text "iny,cmp,dex,---,cpy,cmp,dec,---,"
	.text "bne,cmp,---,---,---,cmp,dec,---,"
	.text "cld,cmp,---,---,---,cmp,dec,---,"
	.text "cpx,sbc,---,---,cpx,sbc,inc,---,"
	.text "inx,sbc,nop,---,cpx,sbc,inc,---,"
	.text "beq,sbc,---,---,---,sbc,inc,---,"
	.text "sed,sbc,---,---,---,sbc,inc,---,"
	.byte 0