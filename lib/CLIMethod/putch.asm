;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Auteur. : Daniel Lafrance
; Version : 1.20191225
;-------------------------------------------------------------------------------
; Description: Dans ce groupe de fonctions, j'utilise la méthode de pasage de 
; paramèetres ditr "INLINE" qui conciste à placer les paramêtres d'entrées d'une 
; fonction immédiatement à la suite du code de son appel de son appel. 
; Cette méthode me permet de récupérer les paramêtres en utilisant l'adresse de  
; retour de la fonction comme pointeur sur les paramêtres. 
;
; Le grand avantage de cette méthode c'est de la rendre en grande partie indépe- 
; dente de l'usage de la pile du système et de l'influence du basic.  
;-------------------------------------------------------------------------------
putch           sta putch_ra        ; ... A, ...
                php                 ; les seules commandes sur le PS sont
                pla                 ; PLP et PHP, nous passons par A.
                sta putch_sf        ; ... SF, ... x et y ...
                stx putch_rx        ; ... X, ...
                sty putch_ry        ; ... Y, ... 
                lda ZEROPAGE        ; ... le contenu LSB et du ... 
                sta putch_zl        ; ... SEROPAGE et ... 
                lda ZEROPAGE+1      ; ... et celui ...        
                sta putch_zh        ; ... du MSB.
                lda CARCOL          ; On sauvegarde localement le registre   
                sta putch_carcol    ; ... de couleur du caractère de BASIC
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
                pla                 ; Sauvegarde l'adresse de retour placée    
                sta putch_pcl       ;   sur la pile, on le copie dans la variable et
                sta ZEROPAGE        ; (STACK PCL -> ZEROPAGE)
                pla                 ; sur la pile par le JSR. 
                sta putch_pch       ;   sur la pile, on le copie dans la variable et
                sta ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1)                
                ;lda putch_ra        ; Si a contenait un param d'entrée alors! 
                                    ; le récupérer de notre variable. 
;-------------------------------------------------------------------------------
; Là on commence le vrai travail de la fonction ...                
;-------------------------------------------------------------------------------
                ldy     #1              ; pointe Z sur le 1ier byte
                lda     (ZEROPAGE),y    ; lecture des caracteres
                jsr     CHROUT
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
                ;pha                     ; Si A contient un paramètre de retour.
putch_out       clc                     ; On ne veux pas ajouter le CARRY
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
                lda     putch_carcol    ; On redonne à BASIC sa couleur.
                sta     CARCOL
                lda     putch_zl        ; et on récupère les registres que nous                
                sta     ZEROPAGE        ; avions sauvegarder au début.
                lda     putch_zh      
                sta     ZEROPAGE+1
                ldx     putch_rx 
                ldy     putch_ry 
                lda     putch_sf
                pha
                plp
                lda     putch_ra      
                rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
putch_ra      .byte   0                 ; Ces lignes constitues un pseudo stack. 
putch_rx      .byte   0                 ; Même su cette méthode est couteuse en 
putch_ry      .byte   0                 ; Voici
putch_sf      .byte   0                 ; Le stack du 6502 étant limité à une 
putch_zl      .byte   0                 ; seule page de 256 octets et qu'il est
putch_zh      .byte   0                 ; largement utilisé par Basic, cette
putch_carcol  .byte   0                 ; me semble la plus simple a utiliser.
putch_pch     .byte   0                 ; Si nous en avions besoin de plus de 
putch_pcl     .byte   0                 ; nous pourrions, nous lpourrions les 
                                        ; créer ici. 
;-------------------------------------------------------------------------------
