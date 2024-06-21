putscxy          jmp putscxy_s
;----------------------------------
putscxy_ra       .byte   0
putscxy_rx       .byte   0
putscxy_ry       .byte   0
putscxy_zl       .byte   0
putscxy_zh       .byte   0
putscxy_ps       .byte   0

putscxy_lx       .byte   0
putscxy_col      .byte   0
;----------------------------------
putscxy_s       sta     putscxy_ra       
                php                     ; On sauvegarde tout les registres ...
                pla                     ; ... cc, a, x et y ...
                sta     putscxy_ps       
                sty     putscxy_ry       
                stx     putscxy_rx      ; ... ainsi que les pointeurs du ZeroPage ...
                lda     ZEROPAGE              ; ZEROPAGE et ZEROPAGE+1.
                sta     putscxy_zl      ; ... pour les replacer à leurs ... 
                lda     ZEROPAGE+1             
                sta     putscxy_zh      ; ... état original à la fin.
                ;lda     putscxy_ra      ; Si a contenait un param d'entrée alors! 
; Là on commence ....                
                pla                     ; Recupere le PC de la pile pour l'utiliser    
                sta     ZEROPAGE        ; (STACK PCL -> ZEROPAGE) Zero Page
                pla                     ; comme pointeur sur le debut des parametres. 
                sta     ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1) Fero Page
                lda     CARCOL
                sta     putscxy_col
                ldy     #1              ; Pointe Z sur premier caractere.
                lda     (ZEROPAGE),y    ; Récupère la couleur ...
                sta     CARCOL          ; ... et la sauvegarde.
                iny                     ; prochain paramètre
                lda     (ZEROPAGE),y    ; Récupère la colonne ...
                sta     putscxy_cln     ; ... et la sauvegarde.
                iny                     ; prochain paramètre
                lda     (ZEROPAGE),y    ; Récupère la ligne ...
                sta     putscxy_lin     ; ... et la sauvegarde.
                jsr     gotoxy
putscxy_cln     .byte   0                                        
putscxy_lin     .byte   0               ; Il y a certainement une raison pour ça, ...
                iny                     ; On pointe le caractère suivant
putscxy_l       lda     (ZEROPAGE),y    ; lecture des caracteres
                beq     putscxy_o       ; Au 0 on sort
                jsr     CHROUT          ; on fait la job
                iny                     ; param suivant
                bne     putscxy_l       ; La chaine se limite a 255 caracteres
putscxy_o       clc                     ; On efface nos traces
                tya                     ; On ajuste l'adresse de retour en fonction ...
                adc     ZEROPAGE        ; ...de la position de la fin de la chaine.         
                tay                     ; on sauvegarde le lsb
                lda     #0              ; on ajoute le bit carry
                adc     ZEROPAGE+1      ; au msb du pc avant de le 
                pha                     ; replacer sur la pile puis (ZEROPAGE+1 -> STACK PCH)
                tya                     ; on recupere le lsb pour        
                pha                     ; faire de meme.            (ZEROPAGE -> STACK PCL)
                lda     putscxy_col
                sta     CARCOL
; On efface nos traces
                lda     putscxy_zl       ; Comme il ,'y a aucun paramêtres ...
                sta     ZEROPAGE        ; ... de de retour on redonne a tous les ... 
                lda     putscxy_zh       ; ... registres leurs valeurs initiales.
                sta     ZEROPAGE+1
                ldx     putscxy_rx 
                ldy     putscxy_ry 
                lda     putscxy_ps
                pha
                plp
                lda     putscxy_ra      
                rts                     
