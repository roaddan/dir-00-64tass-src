;-------------------------------------------------------------------------------
; Auteur. : Daniel Lafrance
; Version : 1.20191225
;-------------------------------------------------------------------------------
; Description: Dans ce groupe de fonctions, j'utilise la méthode de pasage de 
; paramètres dite "INLINE" qui conciste à placer les paramêtres d'entrées d'une 
; fonction immédiatement à la suite du code de son appel. 
; Cette méthode me permet de récupérer les paramêtres en utilisant l'adresse de  
; retour de la fonction comme pointeur sur les paramêtres. 
; La fonction ajuste ensuite l'adresse de retour de façon à survoler ceux-ci.
; Le grand avantage de cette méthode c'est de la rendre en grande partie indépe- 
; dente de l'usage de la pile du système et de l'influence du basic.  
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
outbyte         sta     outbyte_ra      ; ... A, ...
                php                     ; les seules commandes sur le PS sont
                pla                     ; PLP et PHP, nous passons par A.
                sta     outbyte_sf      ; ... SF, ...
                stx     outbyte_rx      ; ... X, ...
                sty     outbyte_ry      ; ... Y, ... 
                lda     ZEROPAGE        ; ... le contenu LSB et du ... 
                sta     outbyte_zl      ; ... SEROPAGE et ... 
                lda     ZEROPAGE+1      ; ... et celui ...        
                sta     outbyte_zh      ; ... du MSB.
                lda     CARCOL          ; On sauvegarde localement le registre   
                sta     outbyte_carcol  ; ... de couleur du caractère de BASIC
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
                pla                     ; Sauvegarde l'adresse de retour placée    
                sta     ZEROPAGE        ; (STACK PCL -> ZEROPAGE)
                pla                     ; sur la pile par le JSR. 
                sta     ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1)                
                ;lda     outbyte_ra    ; Si a contenait un param d'entrée alors! 
;-------------------------------------------------------------------------------
; Là on commence le vrai travail de la fonction ...                
;-------------------------------------------------------------------------------
             	ldy     #1              ; in index ZP à 0 
                lda     (ZEROPAGE),y    ; on charge le 
                pha
                lsr                     ; Le jeux d'instruction du 6502 n'a ...
                lsr                     ; pas d'instruction lsr avec paramètre ...
                lsr                     ; en immédiat pour le nombre de ...
                lsr                     ; position à décaler.
                jsr     nib2hex         ; On converti le MSN $X0. 
                jsr     CHROUT          ; On l'affiche.
                pla
                ;lda     (ZEROPAGE),y    ; on reprend la valeur.
                jsr     nib2hex         ; On converti le LSN $0X
                jsr     CHROUT          ; On l'affiche
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
outbyte_out     ;pha                     ; Si A contient un paramètre de retour.
                clc                     ; On ne veux pas ajouter le CARRY
                tya                     ; On aditionne la valeur contenue dans Y 
                adc     ZEROPAGE        ; en l'aditionnant a ZP en s'assurant         
                tay                     ; le Carry est ajouté au MSB de l'adresse
                lda     #0              ; de retour et on la place sur la pile.
                adc     ZEROPAGE+1      ; D'abord le MSB.
                pha                     ; (ZEROPAGE+1 -> STACK PCH) 
                tya                     ; Puis le LSB.        
                pha                     ; (ZEROPAGE -> STACK PCL)
;-------------------------------------------------------------------------------
; On replace la couleur initiale dans le registre mémoire de Basic.
;-------------------------------------------------------------------------------
                lda     outbyte_carcol  ; On redonne à BASIC sa couleur.
                sta     CARCOL
                lda     outbyte_zl      ; et on récupère les registres que nous                
                sta     ZEROPAGE        ; avions sauvegarder au début.
                lda     outbyte_zh      
                sta     ZEROPAGE+1
                ldx     outbyte_rx 
                ldy     outbyte_ry 
                lda     outbyte_sf
                pha
                plp
                lda     outbyte_ra      
                rts                     
;-------------------------------------------------------------------------------
outbyte_ra      .byte   0               ; Ces lignes constitues un pseudo stack. 
outbyte_rx      .byte   0               ; Même su cette méthode est couteuse en 
outbyte_ry      .byte   0               ; Voici
outbyte_sf      .byte   0               ; Le stack du 6502 étant limité à une 
outbyte_zl      .byte   0               ; seule page de 256 octets et qu'il est
outbyte_zh      .byte   0               ; largement utilisé par Basic, la méthode
outbyte_carcol  .byte   0               ; de parametre inline inline est utile.
outbyte_turbo   .byte   1               ; Si nous en avions besoin de plus de 
                                        ; nous pourrions les 
                                        ; créer ici. 
;-------------------------------------------------------------------------------               
