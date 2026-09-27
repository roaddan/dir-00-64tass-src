;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
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
fillchc         sta fillchc_ra          ; Sauvegarde de l"accumulateir A, les seules 
                php                     ;   commandes sur le PS sont PLP et PHP, nous
                pla                     ;   devons passer par A pour le sauvegarder.
                sta fillchc_sf          ; SF,
                stx fillchc_rx          ; X,
                sty fillchc_ry          ; Y, 
                lda ZEROPAGE            ; le contenu LSB 
                sta fillchc_zl          ;   et 
                lda ZEROPAGE+1          ;   du MSB        
                sta fillchc_zh          ;   du ZEROPAGE.
                lda CARCOL              ; On sauvegarde aussi le registre de 
                sta fillchc_carcol      ;   couleur du caractère de BASIC.
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
                pla                     ; On récupère le lsb de l'adresse de retour placée    
                sta fillchc_pcl         ;   sur la pile, on le copie dans la variable et
                sta ZEROPAGE            ;   dans le ZEROPAGE.
                pla                     ; On récupère le msb de l'adresse de retour placée 
                sta fillchc_pch         ;   sur la pile, on le copie dans la variable et
                sta ZEROPAGE+1          ;   dans le ZEROPAGE.                
                ;lda fillchc_ra          ; Si A contenait un paramèetre d'entrée on pourrait 
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
                sta fillchc_car         ;   mémorise.
                iny                     ; Un octet plus loin 
                lda (ZEROPAGE),y        ; On récupère la couleur du caractère et on le 
                sta fillchc_col         ;   mémorise.
                sty fillchc_aptr        ; On memorise l'offset du pointeur de la fin des paramètres.  
                ;tya                     ; On sauvegarde le pointeur de la fin des 
                ;pha                     ; paramètres sur la pile.  
                                        ; On flood la RAM couleur l'écran.
                lda #<COLORRAM          ; sur la RAM couleur
                sta ZEROPAGE            ; $00 dans ZEROPAGE
                lda #>COLORRAM          ; $D8 dans ZEROPAGE+1
                sta ZEROPAGE+1
                lda fillchc_col         ; On charge la couleur dans A
                ; Il y a 2014 caractères sur l'écran. i.e. 4 x 256
                ldy #0                  ; On compte de 0 à 255
                ldx #4                  ; 4 fois.
fillchc_l1      sta (ZEROPAGE),y        ; on place un caractère à la fois.
                iny                     ; et on passe au suivant.
                bne fillchc_l1          ; Y n'est pas revenu à 0 on boucle.
                inc ZEROPAGE+1          ; on incrémente ZEROPAGE pour pointer 
                dex                     ; 1/4 de tour en moins
                bne fillchc_l1          ; On a pas fait les 4 pages
                                        ; On flood la RAM caractere l'écran.
                lda #<SCREENRAM         ; sur la RAM couleur
                sta ZEROPAGE            ; $00 dans ZEROPAGE
                lda #>SCREENRAM         ; $04 dans ZEROPAGE+1
                sta ZEROPAGE+1
                                        ; Il y a 2014 caractères sur l'écran. i.e. 4 x 256
                ldy #0                  ;   On comptera donc  de 0 à 255
                ldx #4                  ;   4 fois.
fillchc_l2       
                sta (ZEROPAGE),y        ; On place la couleur un octet à la fois
                iny                     ;   et on passe au suivant.
                bne fillchc_l2          ; Y n'est pas revenu à 0, on boucle.
                inc ZEROPAGE+1          ; On passe à la page suivante en prenant soin 
                dex                     ;   de lex compter.
                bne fillchc_l2          ; X n'est pas arrivé à 0 on boucle
                
                ldx #0                  ; On positionne le curseur dans le coin supp
                ldy #0                  ;   gauche de l'écran (0,0)
                jsr PLOT                ;   en appelant la fonction du kernal.
                ;pha                     ; Si A contenait un paramètre de retour.
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Comme nous avons utiliser la ZeroPage à d'autres fins, ...
; ... on doit récupérer l'adresse de retour originale.
;-------------------------------------------------------------------------------
fillchc_out     lda fillchc_aptr        ; On récupère le pointeur de la fin des paramètres
                clc                     ; On ne veux pas ajouter le CARRY
                                        ; On aditionne la valeur contenue dans Y
                adc fillchc_pcl         ;
                tay                     ; le Carry est ajouté au MSB de l'adresse
                lda #0                  ; de retour et on la place sur la pile.
                adc fillchc_pch         ; D'abord le MSB.
                pha                     ; (ZEROPAGE+1 -> STACK PCH)
                tya                     ; Puis le LSB.
                pha                     ; (ZEROPAGE -> STACK PCL)
;-------------------------------------------------------------------------------
; On replace la couleur initiale dans le registre mémoire de Basic.
;-------------------------------------------------------------------------------
                lda fillchc_carcol      ; On redonne à BASIC sa couleur.
                sta CARCOL
                lda fillchc_zl          ; et on récupère les registres que nous
                sta ZEROPAGE            ; avions sauvegarder au début.
                lda fillchc_zh
                sta ZEROPAGE+1
                ldx fillchc_rx
                ldy fillchc_ry
                lda fillchc_sf
                pha
                plp
                lda fillchc_ra      
                ;pha                     ; Si A contenait un paramètre de retour.
                rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
fillchc_aptr    .byte   0   ; arg ptr   ;  
fillchc_ra      .byte   0   ; Reg A     ;   Ces lignes constitues un pseudo stack. 
fillchc_rx      .byte   0   ; Reg X     ;   Même su cette méthode est couteuse en 
fillchc_ry      .byte   0   ; Reg Y     ;
fillchc_sf      .byte   0   ; Flags     ;   Le stack du 6502 étant limité à une 
fillchc_zl      .byte   0   ; ZP_L      ;   seule page de 256 octets et qu'il est
fillchc_zh      .byte   0   ; ZP_H      ;   largement utilisé par Basic, cette
fillchc_pcl     .byte   0   ; PC L      ; 
fillchc_pch     .byte   0   ; PC H      ;
; Des variables spécifiques au programme
fillchc_carcol  .byte   0   ; Cme semble la plus simple a utiliser.
fillchc_car     .byte   0   ; Si nous en avions besoin de plus de 
fillchc_col     .byte   0   ; variables locales, nous lpourrions les 
;-------------------------------------------------------------------------------
