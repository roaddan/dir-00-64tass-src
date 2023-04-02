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
; -dente de l'usage de la pile du système et de l'influence du basic.  
;-------------------------------------------------------------------------------
putchc          sta     putchc_ra       ; ... A, ...
                php                     ; les seules commandes sur le PS sont
                pla                     ; PLP et PHP, nous passons par A.
                sta     putchc_sf       ; ... SF, ... x et y ...
                stx     putchc_rx       ; ... X, ...
                sty     putchc_ry       ; ... Y, ... 
                lda     ZEROPAGE        ; ... le contenu LSB et du ... 
                sta     putchc_zl       ; ... SEROPAGE et ... 
                lda     ZEROPAGE+1      ; ... et celui ...        
                sta     putchc_zh       ; ... du MSB.
                lda     CARCOL          ; On sauvegarde localement le registre   
                sta     putchc_carcol    ; ... de couleur du caractère de BASIC
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
                pla                     ; Sauvegarde l'adresse de retour placée    
                sta     ZEROPAGE        ; (STACK PCL -> ZEROPAGE)
                pla                     ; sur la pile par le JSR. 
                sta     ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1)                
                ;lda     putchx_ra       ; Si a contenait un param d'entrée alors! 
;-------------------------------------------------------------------------------
; Là on commence lr vray travail de la fonction ...                
;-------------------------------------------------------------------------------
                ldy     #1              ; pointe Z sur le 1ier byte
                lda     (ZEROPAGE),y    ; 
                sta     putchc_car      ; Lecture du caractèere à afficher
                iny
                lda     (ZEROPAGE),y    ; Lecture de la couleur à afficher.
                sta     CARCOL
                jsr     putch
putchc_car       .byte   0
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
putchc_out      clc                     ; On ne veux pas ajouter le CARRY
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
                lda     putchc_carcol   ; On redonne à BASIC sa couleur.
                sta     CARCOL
                lda     putchc_zl       ; et on récupère les registres que nous                
                sta     ZEROPAGE        ; avions sauvegarder au début.
                lda     putchc_zh      
                sta     ZEROPAGE+1
                ldx     putchc_rx 
                ldy     putchc_ry 
                lda     putchc_sf
                pha
                plp
                lda     putchc_ra      
                rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
putchc_ra      .byte   0                ; Ces lignes constitues un pseudo stack. 
putchc_rx      .byte   0                ; Même su cette méthode est couteuse en 
putchc_ry      .byte   0                ; Voici
putchc_sf      .byte   0                ; Le stack du 6502 étant limité à une 
putchc_zl      .byte   0                ; seule page de 256 octets et qu'il est
putchc_zh      .byte   0                ; largement utilisé par Basic, cette
putchc_carcol  .byte   0                ; me semble la plus simple a utiliser.
                                        ; Si nous en avions besoin de plus de 
                                        ; nous pourrions, nous lpourrions les 
                                        ; créer ici. 
;-------------------------------------------------------------------------------
