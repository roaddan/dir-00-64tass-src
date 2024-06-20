.pc = $801
:basicupstart(49666)
; depart à $c202
			lda	#$00	; 110 - 2
			ldy	#$c0	; 120 - 2
			jsr	$ab1e	; 130 - 3
			lda	#$4c	; 140 - 2
			sta	$7c		; 150 - 2
			lda	#$18	; 160 - 2
			sta	$7d		; 170 - 2
			lda	#$c2	; 180 - 2
			sta	$7e		; 190 - 2
			jmp	($0302)	; 200 - 3
wos			cmp	#$40	; 210 - 2
			bne	rb09	; 220 - 2 branche a $44 (+68) bytes
			lda	$9d		; 230 - 2
			beq	rb40	; 240 - 2 branche a $28 (+40) bytes
			lda	$0200	; 250 - 3
			cmp	#$40	; 260 - 2
			bne	rb28	; 270 - 2 branche a $1c (+28) bytes
			jsr	$c272	; 280 - 3 appel à basic
rbf6		ldy #$00	; 290 - 2
			lda	($7a),y	; 300 - 2
			cmp	#$20	; 310 - 2
			beq	$09		; 320 - 2
			inc	$7a		; 330 - 2
			bne	rbf6	; 340 - 2 branche a $f6 (-10) bytes
			inc $7b		; 350 - 2
			sec			; 360 - 1
			bcs rbf6	; 370 - 2 branche a $f1 (-15) bytes	
			jsr $a474	; 380 - 3 appel à basic	
			lda #$00	; 390 - 2	
			sec			; 400 - 1	
			bcs	rb09	; 410 - 2 branche a $1d (+29) bytes
rb28		lda	#$40	; 420 - 2
			sec			; 430 - 1
			bcs	rb09	; 440 - 2 branche a $18	(+24) bytes
rb40		jsr	$c272	; 450 - 3 appel à basic
			ldy	#$00	; 460 - 2
rb14		lda	($7a),y	; 470 - 2
			cmp	#$00	; 480 - 2
			beq	rb09	; 490 - 2 branche à $0d (+13) bytes
			cmp	#$3a	; 500 - 2
			beq	rb09	; 510 - 2 branche à $09 ( +9) bytes 
			inc $7a		; 520 - 2 
			bne rb14	; 530 - 2 branche à $f2 (-14) bytes
			inc	$7b		; 540 - 2
			sec			; 550 - 1
			bcs	rb14	; 560 - 2 branche à $ed	(-20) bytes	
rb09		cmp #$3a	; 570 - 2
			bcs	rb0a	; 580 - 2 branche à $0a (+10) bytes
			cmp	#$20	; 590 - 2
			beq	rb07	; 600 - 2 branche à $07 ( +7) bytes
			sec			; 610 - 1
			sbc #$30	; 620 - 2
			sec			; 630 - 1
			sbc	#$d0	; 640 - 2
rb0a		rts			; 650 - 1
rb07		jmp $0073	; 660 - 3
			lda	#$00	; 670 - 2
			