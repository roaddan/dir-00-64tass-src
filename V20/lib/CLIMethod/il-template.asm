;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Programme : template.asm
; Auteur... : Daniel Lafrance
; Version ..: 1.20191225
;-------------------------------------------------------------------------------
; Description: Dans ce groupe de fonctions, j'utilise la méthode de pasage de 
; paramètres dite "INLINE" qui conciste à placer les paramêtres d'entrées d'une 
; fonction immédiatement à la suite du code de son appel. 
; Cette méthode me permet de récupérer les paramêtres en utilisant l'adresse de  
; retour de la fonction comme pointeur sur les paramêtres. 
; La fonction ajuste ensuite l'adresse de retour de façon à survoler ceux-ci.
; Le grand avantage de cette méthode est de la rendre en grande partie indépe- 
; dente de l'usage de la pile du système et de l'influence du basic.  
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. le fait de replacer tous les 
; registres à la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------
template    	
; Au debut on sauvegarde tous les registres dans les zone mémoire reservé a la
; fin de la routine. 
sta     template_ra       
                php                     ; On sauvegarde tout les registres ...
                pla                     ; ... cc, a, x et y ...
                sta     template_sf       
                stx     template_rx
                sty     template_ry
                lda     ZP
                sta     template_zl
                lda     ZP+1
                sta     template_zh
; Si a contenait un param d'entrée alors on pourrais le recuperer comme suit. 
; la meme chose pourrait ette faite pour tous les registres.
                ;lda     template_ra  	 
; Là on commence ....                
                lda     #0     
                tax
                lda     #$20
template_l   	sta     $0400,x
                sta     $0500,x
                sta     $0600,x
                sta     $0700,x
                dex
                bne     template_l
                ldx     #0
                ldy     #0
                jsr     PLOT
; On efface nos traces
                lda     template_zl  	; Comme il ,'y a aucun paramêtres ...
                sta     ZP              ; ... de de retour on redonne a tous les ... 
                lda     template_zh  	; ... registres leurs valeurs initiales.
                sta     ZP+1
                ldx     template_rx 
                ldy     template_ry 
                lda     template_sf
                pha
                plp
                lda     template_ra      
                rts                        
template_ra  	.byte   0
template_rx  	.byte   0
template_ry  	.byte   0
template_lx  	.byte   0
template_ly  	.byte   0
template_zl  	.byte   0
template_zh  	.byte   0
template_sf  	.byte   0