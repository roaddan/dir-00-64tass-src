;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
gotoxy          jmp     gotoxy_s
gotoxy_ra       .byte   0
gotoxy_rx       .byte   0
gotoxy_ry       .byte   0
gotoxy_pcl      .byte   0
gotoxy_pch      .byte   0
gotoxy_sf       .byte   0

gotoxy_zl       .byte   0
gotoxy_zh       .byte   0

gotoxy_lx       .byte   0
gotoxy_ly       .byte   0
gotoxy_s        sta     gotoxy_ra       
                php                     ; On sauvegarde tout les registres ...
                pla                     ; ... cc, a, x et y ...
                sta     gotoxy_sf       
                stx     gotoxy_rx
                sty     gotoxy_ry
                lda     ZEROPAGE
                sta     gotoxy_zl
                lda     ZEROPAGE+1
                sta     gotoxy_zh
                ;lda     gotoxy_ra       ; Si a contenait un param d'entrée alors! 
                pla                     ; On récupère le PC de la pile et ...
                sta     ZEROPAGE        ; (STACK PCL -> ZEROPAGE)
                sta     gotoxy_pcl
                pla                     ; ... on le place dans le ZEROPAGE.
                sta     ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1)
                sta     gotoxy_pch
; Là on commence ....                
                ldy     #1              ; On pointe y sur le 1ier byte.
                lda     (ZEROPAGE),y    ; On récupere X
                sta     gotoxy_lx       ; On le sauvegarde
                iny                     ; On saute au prochain
                lda     (ZEROPAGE),y          ; On récupère Y
                sta     gotoxy_ly       ; On le sauvegarde.
                tax
                ldx     gotoxy_ly
                ldy     gotoxy_lx
                clc                     ; Carry a 0 SET POS et a 1 GET POS
                jsr     PLOT
; Le travail est fini on se prépare a sortir
; On récupère l'adresse de retour originale
                lda     gotoxy_pcl     
                sta     ZEROPAGE
                lda     gotoxy_pch     
                sta     ZEROPAGE+1
; On l'ajuste en fonction du nombre de parametres
                clc                     ; on efface nos traces
                lda     #2              ; Il n’y a que deux parametres
                adc     ZEROPAGE        ; on ajuste l’adresse de retour du PC         
                tay                     ; on sauvegarde le lsb
                lda     #0              ; on ajoute le bit carry
                adc     ZEROPAGE+1      ; au msb du pc avant de le 
                pha                     ; replacer sur la pile puis (ZEROPAGE+1 -> STACK PCH)
                tya                     ; on recupere le lsb pour        
                pha                     ; faire de meme.            (ZEROPAGE -> STACK PCL)
; On efface nos traces
                lda     gotoxy_zl       ; Comme il ,'y a aucun paramêtres ...
                sta     ZEROPAGE        ; ... de de retour on redonne a tous les ... 
                lda     gotoxy_zh       ; ... registres leurs valeurs initiales.
                sta     ZEROPAGE+1
                ldx     gotoxy_rx 
                ldy     gotoxy_ry 
                lda     gotoxy_sf
                pha
                plp
                lda     gotoxy_ra      
                rts                     
