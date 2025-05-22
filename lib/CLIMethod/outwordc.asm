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
; paramètres dit "INLINE" qui conciste à placer les paramètres d'entrées d'une 
; fonction immédiatement à la suite du code de son appel de son appel. 
; Cette méthode me permet de récupérer les paramètres en utilisant l'adresse de  
; retour de la fonction comme pointeur sur les paramètres. 
;
; Le grand avantage de cette méthode c'est de la rendre en grande partie indépe- 
; dente de l'usage de la pile du système et de l'influence du basic.  
;-------------------------------------------------------------------------------
outwordc        sta     outwordc_ra      ; ... A, ...
                php                     ; les seules commandes sur le PS sont
                pla                     ; PLP et PHP, nous passons par A.
                sta     outwordc_sf      ; ... SF, ... x et y ...
                stx     outwordc_rx      ; ... X, ...
                sty     outwordc_ry      ; ... Y, ... 
                lda     ZEROPAGE        ; ... le contenu LSB et du ... 
                sta     outwordc_zl      ; ... SEROPAGE et ... 
                lda     ZEROPAGE+1      ; ... et celui ...        
                sta     outwordc_zh      ; ... du MSB.
                lda     CARCOL          ; On sauvegarde localement le registre   
                sta     outwordc_carcol  ; ... de couleur du caractère de BASIC
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pile le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO, STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
                pla                     ; Sauvegarde l'adresse de retour placée    
                sta     ZEROPAGE        ; (STACK PCL -> ZEROPAGE)
                pla                     ; sur la pile par le JSR. 
                sta     ZEROPAGE+1      ; (STACK PCH -> ZEROPAGE+1)                
                ;lda     outwordc_ra      ; Si a contenait un param d'entrée alors! 
;-------------------------------------------------------------------------------
; Là on commence le vrai travail de la fonction ...                
;-------------------------------------------------------------------------------
             	ldy     #2              ; in index ZP à 0 
outwordc_l0     lda     (ZEROPAGE),y    ; on charge le msb 
                sta     outwordc_byte 
                jsr     outbytec
outwordc_byte   .byte   0                
                dey
                bne     outwordc_l0
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
outwordc_out     ;pha                     ; Si A contient un paramètre de retour.
                lda     #2              ; On compense pour les deux paramètres. 
                clc                     ; On ne veux pas ajouter le CARRY
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
                lda     outwordc_carcol  ; On redonne à BASIC sa couleur.
                sta     CARCOL
                lda     outwordc_zl      ; et on récupère les registres que nous                
                sta     ZEROPAGE        ; avions sauvegarder au début.
                lda     outwordc_zh      
                sta     ZEROPAGE+1
                ldx     outwordc_rx 
                ldy     outwordc_ry 
                lda     outwordc_sf
                pha
                plp
                lda     outwordc_ra      
                rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
outwordc_ra      .byte   0               ; Ces lignes constitues un pseudo stack. 
outwordc_rx      .byte   0               ; Même su cette méthode est couteuse en 
outwordc_ry      .byte   0               ; Voici
outwordc_sf      .byte   0               ; Le stack du 6502 étant limité à une 
outwordc_zl      .byte   0               ; seule page de 256 octets et qu'il est
outwordc_zh      .byte   0               ; largement utilisé par Basic, cette
outwordc_carcol  .byte   0               ; me semble la plus simple a utiliser.
outwordc_turbo   .byte   1               ; Si nous en avions besoin de plus de 
                                        ; nous pourrions, nous lpourrions les 
                                        ; créer ici. 
;-------------------------------------------------------------------------------               
