;-------------------------------------------------------------------------------
; Auteur. : Daniel Lafrance
; Version : 0.1.0.20191225
;-------------------------------------------------------------------------------
; Description: Dans ce groupe de fonctions, j'utilise la méthode de pasage de 
; paramèetres dite "INLINE" qui conciste à placer les paramêtres d'entrées d'une 
; fonction immédiatement à la suite du code de son appel. 
; Cette méthode me permet de récupérer les paramêtres en utilisant l'adresse de  
; retour de la fonction comme pointeur sur les paramêtres. 
;
; Le grand avantage de cette méthode c'est de la rendre en grande partie indépe- 
; dente de l'usage de la pile du système et de l'influence du basic.  
;-------------------------------------------------------------------------------
fillscr         sta fillscr_ra          ; Sauvegarde de l'accumulateir A, les seules 
                php                     ;   commandes sur le PS sont PLP et PHP, nous
                pla                     ;   devons passer par A pour le sauvegarder.
                sta fillscr_sf          ; SF,
                stx fillscr_rx          ; X,
                sty fillscr_ry          ; Y, 
                lda ZEROPAGE            ; le contenu LSB 
                sta fillscr_zl          ;   et 
                lda ZEROPAGE+1          ;   du MSB        
                sta fillscr_zh          ;   du ZEROPAGE.
                lda CARCOL              ; On sauvegarde aussi le registre de 
                sta fillscr_bascol      ;   couleur du caractère de BASIC.
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
                pla                     ; On récupère le lsb de l'adresse de retour placée    
                sta fillscr_pcl         ;   sur la pile, on le copie dans la variable et
                sta ZEROPAGE            ;   dans le ZEROPAGE.
                pla                     ; On récupère le msb de l'adresse de retour placée 
                sta fillscr_pch         ;   sur la pile, on le copie dans la variable et
                sta ZEROPAGE+1          ;   dans le ZEROPAGE.                
                ;lda fillscr_ra          ; Si A contenait un paramèetre d'entrée on pourrait 
                                        ; le récupérer de notre variable. 
;-------------------------------------------------------------------------------
; Ici commence le vrai travail de la fonction ...                
;-------------------------------------------------------------------------------
; Dans notre exemple, l'écran sera remplie par le caractère spécifié par le 
;   premier paramètre et coloré dans la couleurs spécifiée dans le second 
;   paramèetre      
;-------------------------------------------------------------------------------
                ldy #1                  ; On récupère le premier paramètre, qui est 1 octet
                lda (ZEROPAGE),y        ;   plus loin que l'adresse de retour et on le 
                sta fillscr_car         ;   mémorise.
                iny                     ; Un octet plus loin 
                lda (ZEROPAGE),y        ; On récupère la couleur du caractère et on le 
                sta fillscr_col
                iny
                lda (ZEROPAGE),y
                sta BGROUND             
                iny                     ; Un octet plus loin 
                lda (ZEROPAGE),y        ; On récupère la couleur de la bordure et on le 
                sta VBORDER
                sty fillscr_aptr        ; On memorise l'offset du pointeur de la fin des
                lda #0
                tax
fillscrloop     lda fillscr_car
                sta SCRRAM0,x
                sta SCRRAM1,x
                sta SCRRAM2,x
                sta SCRRAM3,x
                lda fillscr_col
                sta COLRAM0,x
                sta COLRAM1,x
                sta COLRAM2,x
                sta COLRAM3,x
                dex
                bne fillscrloop                
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Comme nous avons utiliser la ZeroPage à d'autres fins, ...
; ... on doit récupérer l'adresse de retour originale.
;-------------------------------------------------------------------------------
fillscr_out     lda fillscr_aptr        ; On récupère le pointeur de la fin des paramètres
                clc                     ; On ne veux pas ajouter le CARRY
                                        ; On aditionne la valeur contenue dans Y
                adc fillscr_pcl         ;
                tay                     ; le Carry est ajouté au MSB de l'adresse
                lda #0                  ; de retour et on la place sur la pile.
                adc fillscr_pch         ; D'abord le MSB.
                pha                     ; (ZEROPAGE+1 -> STACK PCH)
                tya                     ; Puis le LSB.
                pha                     ; (ZEROPAGE -> STACK PCL)
;-------------------------------------------------------------------------------
; On replace la couleur initiale dans le registre mémoire de Basic.
;-------------------------------------------------------------------------------
                lda fillscr_bascol      ; On redonne à BASIC sa couleur.
                sta CARCOL
                lda fillscr_zl          ; et on récupère les registres que nous
                sta ZEROPAGE            ; avions sauvegarder au début.
                lda fillscr_zh
                sta ZEROPAGE+1
                ldx fillscr_rx
                ldy fillscr_ry
                lda fillscr_sf
                pha
                plp
                lda fillscr_ra      
                ;pha                     ; Si A contenait un paramètre de retour.
                rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
fillscr_aptr    .byte   0   ; arg ptr   ;  
fillscr_ra      .byte   0   ; Reg A     ;   Ces lignes constitues un pseudo stack. 
fillscr_rx      .byte   0   ; Reg X     ;   Même su cette méthode est couteuse en 
fillscr_ry      .byte   0   ; Reg Y     ;
fillscr_sf      .byte   0   ; Flags     ;   Le stack du 6502 étant limité à une 
fillscr_zl      .byte   0   ; ZP_L      ;   seule page de 256 octets et qu'il est
fillscr_zh      .byte   0   ; ZP_H      ;   largement utilisé par Basic, cette
fillscr_pcl     .byte   0   ; PC L      ; 
fillscr_pch     .byte   0   ; PC H      ;
; Des variables spécifiques au programme
fillscr_bascol  .byte   0   ; Cme semble la plus simple a utiliser.
fillscr_car     .byte   0   ; Si nous en avions besoin de plus de 
fillscr_col     .byte   0   ; variables locales, nous lpourrions le
fillscr_brd     .byte   0   ; la couleur de la bordure
;-------------------------------------------------------------------------------
