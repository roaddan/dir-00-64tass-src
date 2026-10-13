.pc = $801
:basicupstart(49666)
; depart à $c202
            jmp initwos
msg0        .byte 147,13,"  ** c64 extended super basic v1.0 ** ",13,0
initwos		lda	#<msg0	;  110 - 2 charge lsb du message initial
			ldy	#>msg0	;  120 - 2 charge msb du message initial 
			jsr	$ab1e	;  130 - 3 affiche le message initial (basic)
			lda	#$4c	;  140 - 2 on remplace le code ascii de ":"
			sta	$7c		;  150 - 2 ... par celui de "@"
			lda	#<wos	;  160 - 2 on remplace l’adresse de notre
			sta	$7d		;  170 - 2 ... fonction à la place de 
			lda	#>wos	;  180 - 2 ... celle du basic du c64
			sta	$7e		;  190 - 2 ... pour s’insérer.
			jmp	($0302)	;  200 - 3 fonction basic warm-start
; début de notre fonction
wos			cmp	#$40	;  210 - 2
			bne	l570	;  220 - 2 branche a $44 (+68) bytes
			lda	$9d		;  230 - 2
			beq	l450	;  240 - 2 branche a $28 (+40) bytes
			lda	$0200	;  250 - 3
			cmp	#$40	;  260 - 2
			bne	l420	;  270 - 2 branche a $1c (+28) bytes
			jsr	l670	;  280 - 3 appel à basic
l290		ldy #$00	;  290 - 2
			lda	($7a),y	;  300 - 2
			cmp	#$20	;  310 - 2
			beq	l380	;  320 - 2
			inc	$7a		;  330 - 2
			bne	l290	;  340 - 2 branche a $f6 (-10) bytes
			inc $7b		;  350 - 2
			sec			;  360 - 1
			bcs l290	;  370 - 2 branche a $f1 (-15) bytes	
l380		jsr $a474	;  380 - 3 appel à basic	
			lda #$00	;  390 - 2	
			sec			;  400 - 1	
			bcs	l570	;  410 - 2 branche a $1d (+29) bytes
l420		lda	#$40	;  420 - 2
			sec			;  430 - 1
			bcs	l570	;  440 - 2 branche a $18	(+24) bytes
l450		jsr	l670	;  450 - 3 appel à basic
			ldy	#$00	;  460 - 2
l470		lda	($7a),y	;  470 - 2
			cmp	#$00	;  480 - 2
			beq	l570	;  490 - 2 branche à $0d (+13) bytes
			cmp	#$3a	;  500 - 2
			beq	l570	;  510 - 2 branche à $09 ( +9) bytes 
			inc $7a		;  520 - 2 
			bne l470	;  530 - 2 branche à $f2 (-14) bytes
			inc	$7b		;  540 - 2
			sec			;  550 - 1
			bcs	l470	;  560 - 2 branche à $ed	(-20) bytes	
l570		cmp #$3a	;  570 - 2
			bcs	l650	;  580 - 2 branche à $0a (+10) bytes
			cmp	#$20	;  590 - 2
			beq	l660	;  600 - 2 branche à $07 ( +7) bytes
			sec			;  610 - 1
			sbc #$30	;  620 - 2
			sec			;  630 - 1
			sbc	#$d0	;  640 - 2
l650		rts			;  650 - 1
l660		jmp $0073	;  660 - 3
l670		lda	#$00	;  670 - 2
			sta $7f     ;  680 - 2
			lda #$c1    ;  690 - 2
			sta $80     ;  700 - 2
			inc $7a     ;  710 - 2
			bne l740    ;  720 - 2 branche à $02 (+02) bytes
			inc $7b     ;  730 - 2
l740        ldy #$00    ;  740 - 2
            ldx #$00    ;  750 - 2
l760        lda ($7f),y ;  760 - 2
            beq l1010   ;  770 - 2 brabche à $24 (+36) bytes
            cmp ($7a),y ;  780 - 2
            bne l820    ;  790 - 2 branche à $02 (+02) bytes
            iny         ;  800 - 1
            sec         ;  810 - 1
l820        bcs l760    ;  820 - 2 branche à $f4 (-12) bytes
l830        lda ($7f),y ;  830 - 2
            beq l880    ;  840 - 2 branche à $04 (+04) bytes
            iny         ;  850 - 1
            sec         ;  860 - 1
            bcs l820    ;  870 - 2 branche à $f8 (-06) bytes
l880        iny         ;  880 - 1
            tya         ;  890 - 1
            clc         ;  900 - 1
            adc $7f     ;  910 - 2
            sta $7f     ;  920 - 2
            lda #$00    ;  930 - 2
            adc $80     ;  940 - 2
            sta $80     ;  950 - 2
            ldy #$00    ;  960 - 2
            inx         ;  970 - 1
            iny         ;  980 - 1
            sec         ;  990 - 1
            bcs l760    ; 1000 - 2 branche à $d8 (-40) bytes
l1010       lda $c050,x ; 1010 - 3
            sta $80     ; 1020 - 2
            inx         ; 1030 - 1
            lda $c050,x ; 1040 - 3
            sta $81     ; 1050 - 2
            jmp ($0080) ; 1060 - 3
illegal     ldx #$0b    ; 1070 - 2
            jmp ($300)  ; 1080 - 3
; setup command table
cmdtbl      .byte   "cls",0,"low",0,"up",0
cls         lda #$93
            jmp $ffd2
low         lda #$0e
            jmp $ffd2
up          lda #$8d
            jmp $ffd2


            
            
            