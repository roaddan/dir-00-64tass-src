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
templatena  
    sta templatena_ra       ; Sauvegarde de l"accumulateir A, les seules 
    php                     ;   commandes sur le PS sont PLP et PHP, nous
    pla                     ;   devons passer par A pour le sauvegarder.
    sta templatena_sf       ; SF,
    stx templatena_rx       ; X,
    sty templatena_ry       ; Y, 
    lda ZEROPAGE            ; le contenu LSB 
    sta templatena_zl       ;   et 
    lda ZEROPAGE+1          ;   du MSB        
    sta templatena_zh       ;   du ZEROPAGE.
    lda CARCOL              ; On sauvegarde aussi le registre de 
    sta templatena_carcol   ;   couleur du caractère de BASIC.
;-------------------------------------------------------------------------------
; On récupère les paramètres d'entrée en récupérant l'adresse que JSR a mis sur 
; la pile. JSR place sur la pole 1 le MSB suivi du LSB. Comme la pile fonctionne
; sous le principe du LIFO STACK+1 contient LSB et STACK +2 contient MSB. 
;-------------------------------------------------------------------------------
    pla                     ; On récupère le lsb de l'adresse de retour placée    
    sta templatena_pcl      ;   sur la pile, on le copie dans la variable et
    sta ZEROPAGE            ;   dans le ZEROPAGE.
    pla                     ; On récupère le msb de l'adresse de retour placée 
    sta templatena_pch      ;   sur la pile, on le copie dans la variable et
    sta ZEROPAGE+1          ;   dans le ZEROPAGE.                
    ;lda templatena_ra       ; Si A contenait un paramèetre d'entrée on pourrait 
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
    sta templatena_car      ;   mémorise.
    iny                     ; Un octet plus loin 
    lda (ZEROPAGE),y        ; On récupère la couleur du caractère et on le 
    sta templatena_col      ;   mémorise.
    sty templatena_aptr     ; On memorise le pointeur de la fin des paramètres.  
;    tya                     ; On sauvegarde le pointeur de la fin des 
;    pha                     ; paramètres sur la pile.  
                            ; On flood la RAM couleur l'écran.
    lda #<COLORRAM          ; sur la RAM couleur
    sta ZEROPAGE            ; $00 dans ZEROPAGE
    lda #>COLORRAM          ; $D8 dans ZEROPAGE+1
    sta ZEROPAGE+1
    lda templatena_col      ; On charge la couleur dans A
    ; Il y a 2014 caractères sur l'écran. i.e. 4 x 256
    ldy #0                  ; On compte de 0 à 255
    ldx #4                  ; 4 fois.
templatena_l1       
    sta (ZEROPAGE),y        ; on place un caractère à la fois.
    iny                     ; et on passe au suivant.
    bne templatena_l1       ; Y n'est pas revenu à 0 on boucle.
    inc ZEROPAGE+1          ; on incrémente ZEROPAGE pour pointer 
    dex                     ; 1/4 de tour en moins
    bne templatena_l1       ; On a pas fait les 4 pages
                            ; On flood la RAM caractere l'écran.
    lda #<SCREENRAM         ; sur la RAM couleur
    sta ZEROPAGE            ; $00 dans ZEROPAGE
    lda #>SCREENRAM         ; $04 dans ZEROPAGE+1
    sta ZEROPAGE+1
                            ; Il y a 2014 caractères sur l'écran. i.e. 4 x 256
    ldy #0                  ;   On comptera donc  de 0 à 255
    ldx #4                  ;   4 fois.
templatena_l2       
    sta (ZEROPAGE),y        ; On place la couleur un octet à la fois
    iny                     ;   et on passe au suivant.
    bne templatena_l2       ; Y n'est pas revenu à 0, on boucle.
    inc ZEROPAGE+1          ; On passe à la page suivante en prenant soin 
    dex                     ;   de lex compter.
    bne templatena_l2       ; X n'est pas arrivé à 0 on boucle
                
    ldx #0                  ; On positionne le curseur dans le coin supp
    ldy #0                  ;   gauche de l'écran (0,0)
    jsr PLOT                ;   en appelant la fonction du kernal.
    ;pha                     ; Si A contenait un paramètre de retour.
templatena_out      
;-------------------------------------------------------------------------------
; Ici le travail est terminé, on recalcule l'adresse de retour pour le RTS ....                
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Comme nous avons utiliser la ZeroPage à d'autres fins, ...
; ... on doit récupérer l'adresse de retour originale.
;-------------------------------------------------------------------------------
    lda templatena_pcl      ;   et du PC.
    sta ZEROPAGE
    lda templatena_pch
    sta ZEROPAGE+1
    lda templatena_aptr     ; On récupère le pointeur de la fin des paramètres
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
    lda templatena_carcol   ; On redonne à BASIC sa couleur.
    sta CARCOL
    lda templatena_zl       ; et on récupère les registres que nous
    sta ZEROPAGE            ; avions sauvegarder au début.
    lda templatena_zh
    sta ZEROPAGE+1
    ldx templatena_rx
    ldy templatena_ry
    lda templatena_sf
    pha
    plp
    lda templatena_ra      
    ;pla                     ; Si A contenait un paramètre de retour.
    rts                     
;-------------------------------------------------------------------------------
; Dans la section suivante, une sauvegarde systématique de tous les registres 
; est. Ce n'est pas efficace mais eficient. je fait de replacer tous les 
; registres èa la fin de l'appel de notre fonction la rend totalement 
; transparente aux appels Basic.
;-------------------------------------------------------------------------------        
templatena_aptr     .byte   0   ; Ces lignes constitues un pseudo stack. 
templatena_ra       .byte   0   ; Ces lignes constitues un pseudo stack. 
templatena_rx       .byte   0   ; Même su cette méthode est couteuse en 
templatena_ry       .byte   0   ; Voici
templatena_sf       .byte   0   ; Le stack du 6502 étant limité à une 
templatena_zl       .byte   0   ; seule page de 256 octets et qu'il est
templatena_zh       .byte   0   ; largement utilisé par Basic, cette
templatena_carcol   .byte   0   ; me semble la plus simple a utiliser.
templatena_car      .byte   0   ; Si nous en avions besoin de plus de 
templatena_col      .byte   0   ; variables locales, nous lpourrions les 
templatena_pcl      .byte   0   ; créer ici. 
templatena_pch      .byte   0
;-------------------------------------------------------------------------------
