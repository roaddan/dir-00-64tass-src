uiictrlreg	=	$df1c
uiistatreg	=	$df1c
uiicomddta	=	$df1d
uiiidenreg	=	$df1d
uiirspdtaa	=	$df1e
uiistatdta	=	$df1e
uiiidle		=	$00
uiicmdbusy	=	$01
uiidatalast	=	$02
uiidatamore	=	$03

;Status register bits
;-------------------------------------------------------------------------------
;  Bit 7  ;  Bit 6  ; Bit 5 ; Bit 4 ;  Bit 3  ;   Bit 2  ;   Bit 1  ;   Bit 0  ;
;---------;---------;---------------;---------;----------;----------;-----------
; DATA_AV ; STAT_AV ;     STATE     ;  ERROR  ;  ABORT_P ; DATA_ACC ; CMD_BUSY ;
;-------------------------------------------------------------------------------

; ----------------------------
; Return Carry flag set if busy.
; ----------------------------
isuiibusy		.block
			pha	; Bit 0
			clc
			lda	uiistatreg
			and	#%00000001
			cmp	#%00000001
			bne  out
			sec
out			pla
			rts
			.bend
; ----------------------------
; Return Carry flag representing 
; condition.
; ----------------------------
isuiidtaacc	.block
			pha ; Bit 1
			clc
			lda	uiistatreg
			and	#%00000100
			cmp	#%00000100
			bne	out
			sec
out			pla
			rts
			.bend
; ----------------------------
; Return Carry flag representing 
; Uii abort condition.
; ----------------------------
isuiiabort	.block
			pha ; Bit 2
			clc
			lda	uiistatreg
			and	#%00000100
			cmp	#%00000100
			bne	out
			sec
out			pla
			rts
			.bend
; ----------------------------
; Return Carry flag representing 
; Uii abort condition.
; ----------------------------
isuiierror	.block
			pha ; Bit 3
			lda	uiistatreg
			and	#%00001000
			cmp	#%00001000
			bne	out
			sec
out			pla 
			rts
			.bend
; ----------------------------
; Returns status in A:
;    0 = Idle
;	1 = Command Busy
;    2 = Data Last
;    3 = Data More
; ----------------------------
getuiipstate	.block
			php	; Bita 5,4
			lda	uiistatreg
			lsr	
			lsr	
			lsr
			lsr
			and	#%00000011
			plp
			rts
			.bend
			
; ----------------------------
; Wait while Ultimate II +
; is busy.
; ----------------------------
uiiwait		.block
			php
			jsr	isuiibusy
			beq	uiiwait
			plp
			rts
			.bend
