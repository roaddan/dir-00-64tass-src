template     	sta     template_ra       
                php                     ; On sauvegarde tout les registres 
                pla                     ;   cc, a, x et y.
                sta     template_sf     ; Certaines de ces lignes peuvent être >
                stx     template_rx     ;   ommises au besoin pour raccourcir
                sty     template_ry     ;   et accélérer le programme.
                lda     ZP              
                sta     template_zl
                lda     ZP+1
                sta     template_zh
                ;lda     template_ra  	 ; Si a contenait un param d'entrée alors! 
; Là on commence ....                
                lda     #0              ; Dans cet exemple, le programme efface
                tax                     ;   l'écran en plaçant des espaces
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
                lda     template_zl     ; Comme il ,'y a aucun paramêtres de 
                sta     ZP              ;   retour on redonne a tous les  
                lda     template_zh     ;   registres leurs valeurs initiales.
                sta     ZP+1            ;
                ldx     template_rx     ;
                ldy     template_ry     ;
                lda     template_sf     ;
                pha
                plp
                lda     template_ra      
                rts                     
; Zone de mémorisation des registres
template_ra  	.byte   0
template_rx  	.byte   0
template_ry  	.byte   0
template_lx  	.byte   0
template_ly  	.byte   0
template_zl  	.byte   0
template_zh  	.byte   0
template_sf  	.byte   0
