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
mcpy        sta mcpy_ra       ; Sauvegarde de l"accumulateir A, les seules 
            php               ;   commandes sur le PS sont PLP et PHP, nous
            pla               ;   devons passer par A pour le sauvegarder.
            sta mcpy_sf       ; SF,
            stx mcpy_rx       ; X,
            sty mcpy_ry       ; Y, 
            lda ZEROPAGE      ; le contenu LSB 
            sta mcpy_zl       ;   et 
            lda ZEROPAGE+1    ;   du MSB        
            sta mcpy_zh       ;   du ZEROPAGE.
            lda CARCOL        ; On sauvegarde aussi le registre de 
            sta mcpy_carcol   ;   couleur du caractère de BASIC.
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
            pla               ; On récupère le lsb de l'adresse de retour placée    
            sta mcpy_pcl      ;   sur la pile, on le copie dans la variable et
            sta ZEROPAGE      ;   dans le ZEROPAGE.
            pla               ; On récupère le msb de l'adresse de retour placée 
            sta mcpy_pch      ;   sur la pile, on le copie dans la variable et
            sta ZEROPAGE+1    ;   dans le ZEROPAGE.                
            ;lda mcpy_ra       ; Si A contenait un paramèetre d'entrée on pourrait 
                              ; le récupérer de notre variable. 
;-------------------------------------------------------------------------------
; Ici commence le vrai travail de la fonction ...                
;-------------------------------------------------------------------------------
; Dans notre exemple, l'écran sera remplie par le caractère spécifié par le 
;   premier paramètre et coloré dans la couleurs spécifiée dans le second 
;   paramèetre      
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
            ldy #1            ; On récupère le premier paramètre, qui est 1 octet
            lda (ZEROPAGE),y  ;   plus loin que l'adresse de retour et on le 
            sta mcpy_src      ;   mémorise.
            iny               ; Un octet plus loin 
            lda (ZEROPAGE),y  ; On récupère la couleur du caractère et on le 
            sta mcpy_src+1      
            iny               ; On récupère le premier paramètre, qui est 1 octet
            lda (ZEROPAGE),y  ;   plus loin que l'adresse de retour et on le 
            sta mcpy_dst      ;   mémorise.
            iny               ; Un octet plus loin 
            lda (ZEROPAGE),y  ; On récupère la couleur du caractère et on le 
            sta mcpy_dst+1      
            iny               ; On récupère le premier paramètre, qui est 1 octet
            lda (ZEROPAGE),y  ;   plus loin que l'adresse de retour et on le 
            sta mcpy_lsn      ;   mémorise.
            iny               ; Un octet plus loin 
            lda (ZEROPAGE),y  ; On récupère la couleur du caractère et on le 
            sta mcpy_len+1      
            iny               ;   mémorise.
            sty mcpy_aptr     ; On memorise le pointeur de la fin des paramètres.  
mcpy        lda #<mcpy_src
            sta mcpy_zp1
            lda #>mcpy_src
            sta from+1
            lda #<mcpy_dst
            sta mcpy_zp2
            lda #>mcpy_dst
            sta mcpy_zp2+1
            ldx #>len
            beq mcpy_rem
            ldy #$ff
mcpynext    lda (mcpy_zp1),y        
            sta (mcpy_zp2),y
            dey
            cpy #$ff
            bne mcpy_next
mcpynxblk   inc mcpy_zp1+1
            inc mcpy_zp2+1
            dex
            bmi mcpy_end
            bne mcpy_next
mcpy_rem    ldy #<mcpy_len
            beq mcpy_end
            dey
            bne mcpy_next
mcpy_end    rts        
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Comme nous avons utiliser la ZeroPage à d'autres fins, ...
; ... on doit récupérer l'adresse de retour originale.
;-------------------------------------------------------------------------------
            lda mcpy_pcl            ;   et du PC.
            sta ZEROPAGE
            lda mcpy_pch
            sta ZEROPAGE+1
            lda mcpy_aptr           ; On récupère le pointeur de la fin des paramètres
            clc                     ; On ne veux pas ajouter le CARRY
            tya                     ; On aditionne la valeur contenue dans Y
            adc ZEROPAGE            ; en l'aditionnant a ZP en s'assurant
            tay                     ; le Carry est ajouté au MSB de l'adresse
            lda #0                  ; de retour et on la place sur la pile.
            adc ZEROPAGE+1          ; D'abord le MSB.
            pha                     ; (ZEROPAGE+1 -> STACK PCH)
            tya                     ; Puis le LSB.
            pha                     ; (ZEROPAGE -> STACK PCL)
;-------------------------------------------------------------------------------
; On replace la couleur initiale dans le registre mémoire de Basic.
;-------------------------------------------------------------------------------
            lda mcpy_carcol         ; On redonne à BASIC sa couleur.
            sta CARCOL
            lda mcpy_zl             ; et on récupère les registres que nous
            sta ZEROPAGE            ; avions sauvegarder au début.
            lda mcpy_zh
            sta ZEROPAGE+1
            ldx mcpy_rx
            ldy mcpy_ry
            lda mcpy_sf
            pha
            plp
            lda mcpy_ra      
            ;pla                    ; Si A contenait un paramètre de retour.
            rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
mcpy_aptr   .byte $0   ; Ces lignes constitues un pseudo stack. 
mcpy_ra     .byte $0   ; Ces lignes constitues un pseudo stack. 
mcpy_rx     .byte $0   ; Même su cette méthode est couteuse en 
mcpy_ry     .byte $0   ; Voici
mcpy_sf     .byte $0   ; Le stack du 6502 étant limité à une 
mcpy_zl     .byte $0   ; seule page de 256 octets et qu'il est
mcpy_zh     .byte $0   ; largement utilisé par Basic, cette
mcpy_carcol .byte $0   ; me semble la plus simple a utiliser.
mcpy_car    .byte $0   ; Si nous en avions besoin de plus de 
mcpy_col    .byte $0   ; variables locales, nous lpourrions les 
mcpy_pcl    .byte $0   ; créer ici. 
mcpy_pch    .byte $0
mcpy_src    .byte $0
mcpy_dst    .word $0
mcpy_len    .word $0
mcpyzp1 = ZEROPAGE  ; from
mcpyzp2 = ZONEPAGE  ; to
;-------------------------------------------------------------------------------
        
