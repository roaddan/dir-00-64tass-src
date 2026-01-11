;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
puts            jmp puts_s
puts_ra         .byte   0
puts_rx         .byte   0
puts_ry         .byte   0
puts_zl         .byte   0
puts_zh         .byte   0
puts_sf         .byte   0
puts_s          sta     puts_ra         ; On sauvegarde tout les registres ...
                php                     
                pla
                sta     puts_sf         ; ... a, cc, x et y ...
                stx     puts_rx       
                sty     puts_ry         ; ... ainsi que les pointeurs du ZeroPage ...
                lda     ZEROPAGE        ; ZEROPAGE et ZEROPAGE+1.
                sta     puts_zl         ; ... pour les replacer à leurs ... 
                lda     ZEROPAGE+1             
                sta     puts_zh         ; ... état original à la fin.
                ;lda     puts_ra         ; Si a contenait un param d'entrée alors! 
; Là on commence ....                
                pla                     ; recupere pc de la pile    
                sta     ZEROPAGE        ; et le place dans le (STACK PCL -> ZEROPAGE)
                pla                     ; dans le 
                sta     ZEROPAGE+1      ; ZEROPAGE                        (STACK PCH -> ZEROPAGE+1)
                ldy     #1              ; pointe Z sur le 1ier byte
puts_l          lda     (ZEROPAGE),y    ; lecture des caracteres
                beq     puts_lx         ; au dernier para on sort
                jsr     CHROUT          ; on fait la job
                iny                     ; param suivant
                bne     puts_l          ; on limite la chaine a 255 b
puts_lx         clc                     ; on efface nos traces
                tya                     ; on aditionne ou on est 
                adc     ZEROPAGE        ; on ajuste l’adresse de         
                tay                     ; on sauvegarde le lsb
                lda     #0              ; on ajoute le bit carry
                adc     ZEROPAGE+1      ; au msb du pc avant de le 
                pha                     ; replacer sur la pile puis (ZEROPAGE+1 -> STACK PCH)
                tya                     ; on recupere le lsb pour        
                pha                     ; faire de meme.            (ZEROPAGE -> STACK PCL)
; On efface nos traces
                lda     puts_zl         ; Comme il ,'y a aucun paramêtres ...
                sta     ZEROPAGE        ; ... de de retour on redonne a tous les ... 
                lda     puts_zh         ; ... registres leurs valeurs initiales.
                sta     ZEROPAGE+1
                ldx     puts_rx 
                ldy     puts_ry 
                lda     puts_sf
                pha
                plp
                lda     puts_ra      
                rts                     
