;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
putsxy          jmp putsxy_s
;----------------------------------
putsxy_ra       .byte   0
putsxy_rx       .byte   0
putsxy_ry       .byte   0
putsxy_lx       .byte   0
putsxy_ly       .byte   0
putsxy_zl       .byte   0
putsxy_zh       .byte   0
putsxy_ps       .byte   0
;----------------------------------
putsxy_s        sta     putsxy_ra       
                php                     ; On sauvegarde tout les registres ...
                pla                     ; ... cc, a, x et y ...
                sta     putsxy_ps       
                sty     putsxy_ry       
                stx     putsxy_rx       ; ... ainsi que les pointeurs du ZeroPage ...
                lda     ZEROPAGE              ; ZEROPAGE et ZEROPAGE+1.
                sta     putsxy_zl       ; ... pour les replacer à leurs ... 
                lda     ZEROPAGE+1             
                sta     putsxy_zh       ; ... état original à la fin.
                ;lda     putsxy_ra       ; Si a contenait un param d'entrée alors! 
; Là on commence ....                
                pla                     ; Recupere le PC de la pile pour l'utiliser    
                sta     ZEROPAGE        ; (STACK PCL -> ZEROPAGE) Zero Page
                pla                     ; comme pointeur sur le debut des parametres. 
                sta     ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1) Fero Page
                ldy     #1              ; Pointe Z sur premier caractere.
                lda     (ZEROPAGE),y    ; Récupère la colonne ...
                sta     putsxy_col      ; ... et la sauvegarde.
                iny                     ; prochain paramètre
                lda     (ZEROPAGE),y    ; Récupère la ligne ...
                sta     putsxy_lig      ; ... et la sauvegarde.
                jsr     gotoxy
putsxy_col      .byte   0                                        
putsxy_lig      .byte   0               ; Il y a certainement une raison pour ça, ...
                iny                     ; On pointe le caractère suivant
putsxy_l        lda     (ZEROPAGE),y    ; lecture des caracteres
                beq     putsxy_o        ; Au 0 on sort
                jsr     CHROUT          ; on fait la job
                iny                     ; param suivant
                bne     putsxy_l        ; La chaine se limite a 255 caracteres
putsxy_o        clc                     ; On efface nos traces
                tya                     ; On ajuste l'adresse de retour en fonction ...
                adc     ZEROPAGE        ; ...de la position de la fin de la chaine.         
                tay                     ; on sauvegarde le lsb
                lda     #0              ; on ajoute le bit carry
                adc     ZEROPAGE+1      ; au msb du pc avant de le 
                pha                     ; replacer sur la pile puis (ZEROPAGE+1 -> STACK PCH)
                tya                     ; on recupere le lsb pour        
                pha                     ; faire de meme.            (ZEROPAGE -> STACK PCL)
; On efface nos traces
                lda     putsxy_zl       ; Comme il ,'y a aucun paramêtres ...
                sta     ZEROPAGE        ; ... de de retour on redonne a tous les ... 
                lda     putsxy_zh       ; ... registres leurs valeurs initiales.
                sta     ZEROPAGE+1
                ldx     putsxy_rx 
                ldy     putsxy_ry 
                lda     putsxy_ps
                pha
                plp
                lda     putsxy_ra      
                rts                     
