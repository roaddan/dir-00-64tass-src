;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: lib-c64-basic2-math.asm
; Cernière m.à j. : 20250521
; Inspiration ....: Vic-20 and Commodore 64 Tool Kit: Basic by Dan Heeb.
; ISBN ...........: 0-942386-32-9 
; Section du livre: Direct Use of Floarting Point (Pages 19 à 40)
;--------------------------------------------------------------------------------
b_math_template
			.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend
;--------------------------------------------------------------------------------
; N O T E : Dans les commentaire l'acronyme "P.F." signifie "Point Flottant".
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Variables publiques communes.
;--------------------------------------------------------------------------------
b_bufflenght	.byte	$00
b_num1		.word	$0000,$0000,$0000
b_num2		.word	$0000,$0000,$0000
b_num0
b_numresult	.word 	$0000,$0000,$0000
b_testnum		.null	"128"

;------------------------------------------------------------------------------
; Convertion de Accum et X-reg ($AAXX) en chaine décimal ascii.
; Entrée: A=MSB, X=LSB
; Pour charger les registres a and x utilisez les macros ... 
;            loadaxmem pour un contenu mémoire ou ... 
;            loadaximm pour le mode immédiat.    
;------------------------------------------------------------------------------
; Tirée de l'Exemple 1 de la page 25.
;------------------------------------------------------------------------------
b_praxstr		.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_axout
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; M a c r o s   p o u r   p e u p l e r   A A X X .
;------------------------------------------------------------------------------
loadaxmem      .macro axadd
               php
               ldx  \axadd		; Charge lsb de l'adresse dans X.
               lda  \axadd+1		; Charge msb de l'adresse dans A.
               plp
               .endm

loadaximm      .macro aximm
               php
               ldx  #<\aximm		; Charge dans X le LSB de la valeur imm.
               lda  #>\aximm 		; Charge dans A le MSB de la valeur imm.
               plp
               .endm
;------------------------------------------------------------------------------
; Récupère un nombre à partir du périphérique d'entrée et le sauvegarde en 
; ASCII dans le tampon d'éditeur de ligne de BASIC et sauvegarde la longueur de
; la chaîne dans la variable b_bufflenght.
; Entrée ....: STDIN
; Sortie ....: Tampon de ligne Basic et la variable b_bufflenght.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 2, page 26.
;------------------------------------------------------------------------------
b_getascnum	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_intcgt		; Initialise charget
			jsr	b_clearbuff	; Efface le tampon d'entrée de BASIC.
			jsr	b_prompt		; Affiche ? et peuple de tampon d'entrée de 
							; ... BASIC.
			stx	$7a			; X and Y pointent vers $01ff au retour.
			sty	$7b
			jsr	b_chrget		; Lit un jeton du périphérique d'entrée.
			jsr	b_ascflt		; Conv. ASCII de l'adresse 0200 vers FAC1.
			jsr	b_facasc		; Conv. FAC1 en chaîne ASCII à 100.
			jsr	b_getbufflen	; Calcule la longueur de la chaîne dans var. 
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend			

;------------------------------------------------------------------------------
; Sous-routine commune pour effacer le tampon de commande BASIC.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 2, page 26.
;------------------------------------------------------------------------------
b_clearbuff	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			lda	#$00			; Place des $00 à toutes adresses de 
			ldy	#$59			; ... $1a6 à $200 pour effacer le
clear		sta	$0200,y		; ... tampon d'entrée de BASIC.
			dey				; 
			bne	clear		; 60 octets.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Affiche le nombre P.F. sauvegardé en ascii dans le tampon d'édition de ligne
; BASIC.
; Entrée ...: Récupère la longueur de la chaîne de b_bufflenght.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 2, page 26.
;------------------------------------------------------------------------------
b_printbuff	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			lda	#$00			; Positionne le vecteur $0022 et 
			sta	$22			; ... $0023 pour quLil pointe vers
			lda	#$01			; l'adresse $0100.
			sta	$23
			lda	b_bufflenght	; Charge la longueur de la chaîne.
			jsr	b_strout		; Affiche la chaine
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Recoit un nombre de l'éditeur et le convertie en point flottant dans FAC1.
; Sortie ....: FAC1 contient le nombre en format PF..
;------------------------------------------------------------------------------
; Tirée de l'Exemple 3, page 27.
;------------------------------------------------------------------------------
b_insub		.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_intcgt		; Initialise CHRGET.
			jsr	b_clearbuff	; Efface le tampon d'entrée de BASIC.
			jsr	b_prompt		; Affiche ? et peuple de tampon d'entrée de 
							; ... BASIC. 
			stx	$7a
			sty	$7b
			jsr	b_chrget		; Lit un jeton du périphérique d'entrée.
			jsr	b_ascflt		; Conv. la chaîne ascii en PF dans FAC1.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Lecture d'un point flottant à ârtir de la mémoire.
; Sortie.....: La Variable b_bufflenght contient la longueur de la chaîne.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 4, page 27.
;------------------------------------------------------------------------------
b_readmemfloat	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_intcgt		; Initialisation de CHRGET.
			lda	$7a			; Sauvegarde des valeurs actuelles des cases
			sta	b_v7a		; ... mémoires $007a et $007b. 
			lda	$7b
			sta	b_v7b
			ldx	#<(b_testnum-1); Initialise le pointeur FVAR à l'adresse de
			stx	$7a			; ...
			ldy	#>(b_testnum-1); ...
			sty	$7b			; ... la variable -1.
			jsr	b_chrget		; Lit un jeton du périphérique d'entrée.
				jsr	pushreg		; Sauvegarde tous les registres.
			ldx	#<(b_num1)  	; Copie de FAC1 dans la variable ...
			ldy	#>(b_num1)  	; ... 
			jsr	b_f1tmem		; b_num1
			jsr	b_f1x10		; Multiplie FAC1 par 10.
			ldx	#<(b_num2)  	; Copie de FAC1 dans la variable ...
			ldy	#>(b_num2)  	; ... 
			jsr	b_f1tmem		; b_num2
			ldx	#<(b_num0)  	; Copie de FAC1 dans la variable ...
			ldy	#>(b_num0)  	; ... 
			jsr	b_f1tmem		; b_num0
			jsr	b_prhexbnum1	; Affiche b_num1 en hexadécimal.
				jsr	popreg		; Récupère tous les registres.
			jsr	b_ascflt	  	; Conv. chaîne ASCII vers P.F. dans FAC1.
			jsr	b_facasc		; Conv. P.F. FAC1 vers chaîne ascii à $0100.
			jsr	b_getbufflen
			lda	b_v7a		; Récupération des valeurs initiales des 
			sta	$7a			; ...
			lda	b_v7b		; ...
			sta	$7b			; ... cases mémoires $007a et $007b.
			jsr	b_clearbuff
			jsr	popreg		; Récupère tous les registres.
			rts
; Variables locale privées
b_v7a		.byte	$00
b_v7b		.byte	$00
			.bend

;------------------------------------------------------------------------------
; Multiplication de FAC1 et FAV et place le résultat en mémoire.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 5, page 28.
;------------------------------------------------------------------------------
b_mul2fptomem	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Récupère le premier nombre.
			jsr	b_f1t57		; Copie FAC1 dans $0057.
			jsr	b_insub		; Récupère le second nombre.
			lda	#$57			; Pointe vers le premier 
			ldy	#$00			; ... nombre.
			jsr	b_f1xfv		; Effectue la multiplication 
							; FAC1 = FAC1 X FVAR.
			ldx	#<b_numresult	; Initialise le pointeur ou le résultat doit
			ldy	#>b_numresult	; ... être copié.
			jsr	b_f1tmem		; Copie FAC1 en mémoire.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Multiplication de deux nombres reçus du périphérique d'entrée.
; Sortie.....: La variable b_bufflenght contiemnt la longueur de la chaîne.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 6, page 29.
;------------------------------------------------------------------------------
b_mul2fptoasc	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Récupère le premier nombre.
			jsr	b_f1t57		; Copie FAC1 dans $0057.
			jsr	b_insub		; Récupère le second nombre.
			lda	#$57			; Pointe vers le premier 
			ldy	#$00			; ... nombre.
			jsr	b_f1xfv		; Effectue la multiplication 
							; FAC1 = FAC1 X FVAR.
			jsr	b_facasc		; Conv. le P.F. FAC1 en chaîne de caractères 
							; ascii à la position $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Sous-routine commune pour calculer la longueur du tampon d'entrée de commande 
; de BASIC.
; Sortie.....: La variable b_bufflenght contiemnt la longueur de la chaîne.
;------------------------------------------------------------------------------
; Tirée de l'Exemple 6, page 29.
;------------------------------------------------------------------------------
b_getbufflen	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			ldy	#$ff
nxtchar		iny				; Determine lenght of string by ...
			lda	$0100,y		; ... searching for $00 EOS byte.
			bne	nxtchar		
			iny	
			sty	b_bufflenght	; Store buffer lenght in common variable.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 6.3: Common sous-routine print the basic command buffer to the output
;			device.
;------------------------------------------------------------------------------
b_outsub		.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_getbufflen	; Calculate lenght of buff and store in var. 
			jsr	b_printbuff	; Print buffer content on output device.
			jsr	b_clearbuff
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 7  : Multiply FAC1 by 10.
;------------------------------------------------------------------------------
b_fac1x10		.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub
			jsr	b_f1x10	; FAC1 = FAC1 X 10
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 8 (9)  : Divide FAC1 by 10.
;------------------------------------------------------------------------------
b_fac1d10		.block
			jsr	pushreg		; Sauvegarde tous les registres.
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
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 10 : FAC1 square.
;------------------------------------------------------------------------------
b_fac1square	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Get first number.
			jsr	b_f1tf2		; Copy FAC1 to FAC2.
			lda	$61			; get exponent of FAC1
			jsr	b_f1xf2		; FAC1 = FAC1 X FAC2
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 11 : FVAR divided by FAC1
;------------------------------------------------------------------------------
b_fvardfac1	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_fvdf1		; FAC1 = FVAR / FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 12 : FAC2 divided by FAC1.
;------------------------------------------------------------------------------
b_fac2dfac1	.block
			jsr	pushreg		; Sauvegarde tous les registres.
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
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 13 : Add FVAR to FAC1.
;------------------------------------------------------------------------------
b_fac1pfvar	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_f1pfv		; FAC1 = FAC1 + FVAR
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 14 : Substract FAC1 from FAC1.
;------------------------------------------------------------------------------
b_fac2sfac1	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_memtf2		; copy memory to FAC2
			jsr	b_f2sf1		; FAC1 = FAC2 + FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 15 : Substract FAC1 from FVAR.
;------------------------------------------------------------------------------
b_fvarsfac1	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			jsr	b_insub		; Get first number.
			jsr	b_f1t57		; Copy FAC1 to $0057			
			jsr	b_insub		; Get second number.
			lda	#$57
			ldy	#$00
			jsr	b_fvsf1		; FAC1 = FVAR + FAC1
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 16 : Add acc to FAC1.
;------------------------------------------------------------------------------
b_accpfac1	.block
			jsr	pushreg		; Sauvegarde tous les registres.
			pha
			jsr	b_insub		; Get first number.
			pla
			jsr	b_f1pacc
			jsr	b_facasc	; Convert FAC1 floating point to ascii string at 
						; $0100.
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 17 : Add FAC2 to FAC1.
;------------------------------------------------------------------------------
b_fac2pfac1	.block
			jsr	pushreg		; Sauvegarde tous les registres.
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
			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Example 18 : Add FAC1 to the power of FAC2.
;------------------------------------------------------------------------------
b_fac1powfac2
			.block
			jsr	pushreg		; Sauvegarde tous les registres.
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

			jsr	popreg		; Récupère tous les registres.
			rts
			.bend

;------------------------------------------------------------------------------
; Printing b_num1, b_num2 ans b_numresult in hex on screen.
;------------------------------------------------------------------------------
b_prhexbnum1	.block
			jsr	pushall		; debug
			#locate	0,5
			lda	#<b_num1
			sta	zpage1
			lda	#>b_num1
			sta	zpage1+1
			ldy	#$00
			ldx	#18
more			lda	(zpage1),y
			jsr	putahex
			iny
			cpy	#6
			bne	is12
			#locate	0,7
is12			cpy	#12
			bne	doit			
			#locate	0,9
doit			dex
			bne	more
			jsr	popall
			rts	
			.bend
