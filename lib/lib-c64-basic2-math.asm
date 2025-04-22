;------------------------------------------------------------------------------
;
;------------------------------------------------------------------------------
b_math_template
			.block
			jsr	push
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Reference....: Vic-20 and Commodore 64 Tool Kit: Basic by Dan Heeb.
; ISBN.........: 0-942386-32-9 
; Book section : Direct Use of Floarting Point
;------------------------------------------------------------------------------
; Common memory locations.
b_bufflenght	.byte	$00
b_num1		.word	$1000,$1000,$1001
b_num2		.word	$0000,$0000,$0000
b_multresult	.word 	$0000,$0000,$0000
b_testnum		.null	"6.28e-23 "
;------------------------------------------------------------------------------
; Example 1: Convert Accum and X-reg ($AAXX) to decimal ascii string.
; Input: A=MSB, X=LSB
; You can load a and x using macro 
;            loadaxmem for Memory content or ... 
;            loadaximm for immediate mode.     
;------------------------------------------------------------------------------
b_praxstr		.block
			jsr	push
			jsr	b_axout
			jsr	pop
			rts
			.bend

; Macros to initialize AAXX.
; ==========================
loadaxmem      .macro axadd
               php
               ldx  \axadd		; Load lsb od address in X.
               lda  \axadd+1		; Load msb od address in A.
               plp
               .endm

loadaximm      .macro aximm
               php
               lda  #>\aximm
               ldx  #<\aximm
               plp
               .endm

;------------------------------------------------------------------------------
; Example 2.1: Prompt for a number from input device and save it as ascii in 
; 			the Basic line editor input buffer.
; Mods.......: Does not pring the resulting ascii value.			  
;			Instead saves the lenght of the ascii string in b_bufflenght.
; Output.....: Variable b_bufflenght contains the lenght of the string.
;------------------------------------------------------------------------------
b_getascnum	.block
			jsr	push
			jsr	b_intcgt		; Initialyse charget
			jsr	b_clearbuff	; Clear basic input buffer
			jsr	b_prompt		; Prompt for ? and fill buffer by reading...
							; ... input device.
			stx	$7a			; X and Y points to $01ff on return.
			sty	$7b
			jsr	b_chrget		
			jsr	b_ascflt		; Convert ASCII string at 0200 to FAC1 FP.
			jsr	b_facasc		; Converts FAC1 to ASCII string at 100.
			jsr	b_getbufflen	; Calculate lenght of buff and store in var. 
			jsr	pop
			rts
			.bend			

;------------------------------------------------------------------------------
; Example 2.2: Common subroutine to clear the basic command buffer.
;------------------------------------------------------------------------------
b_clearbuff	.block
			jsr	push
			lda	#$00
			ldy	#$59
clear		sta	$0200,y		; Clear Basic input buffer
			dey				
			bne	clear		; 60 bytes.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 2.3: Prints the number saved it as ascii in the Basic line editor 
;			input buffer.
; Mods.......: Gets the lenght of the ascii string from b_bufflenght.
;------------------------------------------------------------------------------
b_printbuff	.block
			jsr	push
			lda	#$00			; Set $22 to point to string at 100
			sta	$22
			lda	#$01
			sta	$23
			lda	b_bufflenght
			jsr	b_strout
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 3 .: Input a number from the editor and convert as floating point in
; FAC1.
; Output ....: FAC1 contains FP value.
;------------------------------------------------------------------------------
b_insub		.block
			jsr	push
			jsr	b_intcgt	; Initialize CHRGET.
			jsr	b_clearbuff
			jsr	b_prompt
			stx	$7a
			sty	$7b
			jsr	b_chrget
			jsr	b_ascflt	; Convert ascii string to floating point in FAC1.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 4 .: Read a floating point number from memory.
; Output.....: Variable b_bufflenght contains the lenght of the string.
;------------------------------------------------------------------------------
b_readmemfloat	.block
			jsr	push
			jsr	b_intcgt	; Initialize CHRGET.
			ldx	#<(b_testnum-1)  ;#$83		; Set pointer to fvar as location for var minus 1
			ldy	#>(b_testnum-1)  ; #$c5
			stx	$7a
			sty	$7b
			jsr	b_chrget
			jsr	b_ascflt	  ; Convert ascii string to floating point in FAC1.
;			ldx	#<(b_num1)  ;
;			ldy	#>(b_num1)  ;
;			jsr	b_f1tmem
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	b_getbufflen
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 5 .: Storing floating point multiplication into memory.
;------------------------------------------------------------------------------
b_mul2fptomem	.block
			jsr	push
			jsr	b_insub		; Input first number.
			jsr	b_f1t57		; Copy FAC1 to $0057.
			jsr	b_insub		; Input second number.
			lda	#$57			
			ldy	#$00			; Point to 1st number.
			jsr	b_f1xfv		; FAC1 = FAC1 X FVAR.
			ldx	#<b_multresult	; Set pointer to area to copy result to.
			ldy	#>b_multresult
			jsr	b_f1tmem		; Copy FAC1 to memory.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 6 .: Multiply 2 numbers got from input device.
; Output.....: Variable b_bufflenght contains the lenght of the string.
;------------------------------------------------------------------------------
b_mul2fptoasc	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057.
			jsr	b_insub	;	 Get second number.
			lda	#$57
			ldy	#$00			; Set pointer to FVAR.
			jsr	b_f1xfv		; FAC1 = FAC1 x FVAR.
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 6.2: Common subroutine to calculate basic command buffer lenght.
; Output.....: Variable b_bufflenght contains the lenght of the string.
;------------------------------------------------------------------------------
b_getbufflen	.block
			jsr	push
			ldy	#$ff
nxtchar		iny				; Determine lenght of string by ...
			lda	$0100,y		; ... searching for $00 EOS byte.
			bne	nxtchar		
			iny	
			sty	b_bufflenght	; Store buffer lenght in common variable.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 6.3: Common subroutine print the basic command buffer to the output
;			device.
;------------------------------------------------------------------------------
b_outsub		.block
			jsr	push
			jsr	b_getbufflen	; Calculate lenght of buff and store in var. 
			jsr	b_printbuff	; Print buffer content on output device.
			jsr	b_clearbuff
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 7  : Multiply FAC1 by 10.
;------------------------------------------------------------------------------
b_fac1x10		.block
			jsr	push
			jsr	b_insub
			jsr	b_f1x10	; FAC1 = FAC1 X 10
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 8 (9)  : Divide FAC1 by 10.
;------------------------------------------------------------------------------
b_fac1d10		.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_sgnf1
			pha
			jsr	b_f1d10		; FAC1 = FAC1 / 10
			pla
			tax
			inx
			bne	notneg
			lda	#$80		; On force le bit de signe ...
			sta	$66		; de FAC1 a 1 (neg)
notneg		jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 10 : FAC1 square.
;------------------------------------------------------------------------------
b_fac1square	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1tf2		; Copy FAC1 to FAC2.
			lda	$61			; get exponent of FAC1
			jsr	b_f1xf2		; FAC1 = FAC1 X FAC2
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 11 : FVAR divided by FAC1
;------------------------------------------------------------------------------
b_fvardfac1	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_fvdf1		; FAC1 = FVAR / FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 12 : FAC2 divided by FAC1.
;------------------------------------------------------------------------------
b_fac2dfac1	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_memtf2		; copy memory to FAC2
			lda	$61			; get exponent of FAC1
			jsr	b_f2df1		; FAC1 = FAC2 / FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 13 : Add FVAR to FAC1.
;------------------------------------------------------------------------------
b_fac1pfvar	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_f1pfv		; FAC1 = FAC1 + FVAR
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 14 : Substract FAC1 from FAC1.
;------------------------------------------------------------------------------
b_fac2sfac1	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_memtf2		; copy memory to FAC2
			jsr	b_f2sf1		; FAC1 = FAC2 + FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 15 : Substract FAC1 from FVAR.
;------------------------------------------------------------------------------
b_fvarsfac1	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_fvsf1		; FAC1 = FVAR + FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 16 : Add acc to FAC1.
;------------------------------------------------------------------------------
b_accpfac1	.block
			jsr	push
			pha
			jsr	b_insub		; Get first number.
			pla
			jsr	b_f1pacc
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 17 : Add FAC2 to FAC1.
;------------------------------------------------------------------------------
b_fac2pfac1	.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_memtf2		; copy memory to FAC2
			lda	$61			; get exponent of FAC1
			jsr	b_f1pf2
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	pop
			rts
			.bend

;------------------------------------------------------------------------------
; Example 18 : Add FAC1 to the power of FAC2.
;------------------------------------------------------------------------------
b_fac1powfac2
			.block
			jsr	push
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_memtf2		; copy memory to FAC2
			lda	$61			; get exponent of FAC1
			jsr	b_expon
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.

			jsr	pop
			rts
			.bend

