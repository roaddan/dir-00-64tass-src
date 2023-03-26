*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;--------------------------------------------
; question da sauter au dessus des variables.
;--------------------------------------------
		jsr	main
		rts
.include "system.asm"  ; include system declarations
.include "specialcar.asm" 	; les caractères spéciaux
b01		.byte 5,10,29,5,rose,0
s01 	.text 7,11,lcase,vertp,"mon premier code assembleur",0
s02 	.text 13,12,"sur commodore 64",0
s03 	.text 11,13,"par daniel lafrance",0
s09		.text 1,25,brun,"load",quote,"shownum.prg",quote,",9,1",0
s10		.text 1,23,rose,"[enter] pour recharger.",0
zp=$fd
;----------------------------------------------------------
; un programme pour tester le tout.
;----------------------------------------------------------
main		       jsr clear
			jsr drwrbox	; on dessine une boîte
			lda #<s01	; on place l'adresse de la chaine 
			sta zp		; dans le pointeur de page 0
			lda #>s01	
			sta zp+1	
			jsr putsxy	
			lda #<s02	; on place l'adresse de la chaine 
			sta zp		; dans le pointeur de page 0
			lda #>s02	
			sta zp+1	
			jsr putsxy	
			lda #<s03	; on place l'adresse de la chaine 
			sta zp		; dans le pointeur de page 0
			lda #>s03	
			sta zp+1	
			jsr putsxy	
			lda #<s09	; on place l'adresse de la chaine 
			sta zp		; dans le pointeur de page 0
			lda #>s09	
			sta zp+1	
			jsr putsxy	
			lda #<s10	; on place l'adresse de la chaine 
			sta zp		; dans le pointeur de page 0
			lda #>s10	
			sta zp+1	
			jsr putsxy	
			lda #gris1
			jsr chrout
			rts	
;----------------------------------------------------------
; imprimer une chaine via zero-page.
;----------------------------------------------------------
puts		jmp puts_beg
puts_cnt	.byte 0			
puts_beg	ldy #2			; la chaine commence par x,y
			sty puts_cnt
putsloop	lda (zp),y		; a=prochain caractere 
			beq puts_end	; a=0 on sort
			jsr	chrout		; on fait appel a basic	
			inc puts_cnt	
			ldy puts_cnt	
			bne putsloop	
			inc zp+1	
			bne putsloop	
			jmp puts_end	
puts_end	rts	

;----------------------------------------------------------
; afficher un byte en décimal 
;----------------------------------------------------------
drwrbox		jsr drwrbox_beg
x1			.byte 1
y1			.byte 1
wd			.byte 1
ht			.byte 1
co			.byte 1
drwrbox_beg	lda #<b01	; les parametres de boite -> zp 
			sta zp		;
			lda #>b01	;
			sta zp+1	;
			ldy	#0
			lda (zp),y	; on enregistre x1 ...
			sta	x1
			iny
			lda (zp),y	; ... y1
			sta	y1
			iny
			lda	(zp),y	; ... la largeur
			sta	wd
			iny
			lda (zp),y	; ... la hauteur
			sta ht
			iny
			lda (zp),y	; ... la couleur
			sta ht
			ldx	x1
			ldy	y1
			jsr gotoxy
			lda	#95
			; jsr chrout
			rts
;----------------------------------------------------------
; afficher un byte en décimal 
;----------------------------------------------------------
putsxy		ldy	#0
			lda	(zp),y	
			tax	
			iny	
			lda	(zp),y	
			tay
			jsr gotoxy	
			jsr puts	
putsxy_end	rts	
;----------------------------------------------------------
; afficher un byte en décimal 
;----------------------------------------------------------
digout		cmp	#9
			rts
;----------------------------------------------------------
; effacer l'écran avec les fonction de basic
;----------------------------------------------------------
clear			lda	#11		;
			sta	tour
			lda	#0
			sta	fond
			lda #cls
			jsr chrout
			rts		
            		lda #home		
			jsr chrout		
			rts		
;----------------------------------------------------------
; positionner le curseur en x,y
;----------------------------------------------------------
gotoxy		cpx #1		; 1 est la première colonne
			bcc	_gxyend
			cpy #1		; 1 est la première ligne
			bcc	_gxyend
			lda	#home		
			jsr chrout		
			lda	#crse	; code su curseur vers l'est	
_gxynxx 	dex			; 1 est la première colonne		
			beq _gxytoy	; x nombre de fois	
			jsr chrout	; on deplace le curseur 	
			jmp _gxynxx	
_gxytoy		lda	#crss	; code du curseur vers le sud	
_gxynxy		dey			; 1 est la première ligne
			beq	_gxyend
		 	jsr chrout  ; on descend le curseur				
			jmp _gxynxy				
_gxyend		rts				

