*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;--------------------------------------------
; question da sauter au dessus des variables.
;--------------------------------------------
            jsr	main
            rts
.include    "system.asm"  ; include system declarations
.include    "c64utils.asm"
b01         .byte 7,9,27,8,mauve
b02         .byte 9,9,23,8,rose
b03         .byte 8,8,25,10,rouge
s01         .text 11,9,ucase,mauve,revon,"gestion de terminal",revoff,0
s02         .text 13,11,bleup,"commodore 64 ",bleu,"c",rouge,"=",0
s03         .text 11,13,cyan, "par daniel lafrance",revoff,0
s04         .text 12,14,blanc, "version: 20191211",revoff,0
s09         .text 1,25,blanc,"load",quote,"basm.prg",quote,",8,1",0
s10         .text 9,16,mauve,revon,"[enter] pour recharger.",revoff,0
s11         .text 1,23,blanc,"",0
                
test        .word $abcd
zp=$fd

;----------------------------------------------------------
; un programme pour tester le tout.
;----------------------------------------------------------
main        pha
            jsr     clear
            ;lda    #255
            ;ldy    #2
            ;jsr    div8bit                        
            ;jsr    byte2hex
            lda     #<b01       ; les parametres de boite -> zp 
            sta     zp          ;
		lda     #>b01	;
		sta     zp+1	;
		jsr     drwrbox	; on dessine une boîte
                jmp onebox

		lda     #<b02	; les parametres de boite -> zp 
		sta     zp		;
		lda     #>b02	;
		sta     zp+1	;
		jsr     drwrbox	; on dessine une boîte
		lda     #<b03	; les parametres de boite -> zp 
		sta     zp		;
		lda     #>b03	;
		sta     zp+1	;
		jsr     drwrbox	; on dessine une boîte
			
onebox	lda     #<s01	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s01	
		sta     zp+1	
		jsr     putsxy	
		lda     #<s02	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s02	
		sta     zp+1	
		jsr     putsxy	
		lda     #<s03	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s03	
		sta     zp+1	
		jsr     putsxy	
		lda     #<s04	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s04	
		sta     zp+1	
		jsr     putsxy	
		lda     #<s10	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s10	
		sta     zp+1	
		jsr     putsxy	
		lda     #<s09	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s09	
		sta     zp+1	
		jsr     putsxy	
		lda     #<s11	; on place l'adresse de la chaine 
		sta     zp		; dans le pointeur de page 0
		lda     #>s11	
		sta     zp+1	
		jsr     putsxy	
		lda     #gris1
		jsr     chrout
		pla
		rts	
;----------------------------------------------------------
; division 8 bits de a par y dans a :  a/y=a
;----------------------------------------------------------
div8bit		jmp	div8beg
div8denom	.byte 0	
div8beg		ldx	#0
		    sty div8denom
 		    cmp div8denom
		    bcc	div8end
div8loop	inx
		    sec
		    sbc	div8denom
		    cmp #0
		    beq	div8end
		    jmp div8loop
div8end		txa
		    rts
			
