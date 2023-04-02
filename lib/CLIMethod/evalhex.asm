*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0


.include    "c64map.asm"

                ; On insere l'adresse de evalhex dans le vecteur 
                ; d'evaluation de ligne de commande de BASIC. 
main            ; c64map.asm pointe sur main.
install     	sta     install_ra       
                php                     ; On sauvegarde tout les registres ...
                pla                     ; ... cc, a, x et y ...
                sta     install_sf       
                ;stx     install_rx
                ;sty     install_ry
                ;lda     ZEROPAGE
                ;sta     install_zl
                ;lda     ZEROPAGE+1
                ;sta     install_zh
; Là on commence ....                
                lda     #<evalhex
                sta     IEVAL
                lda     #>evalhex
                sta     IEVAL+1
; On efface nos traces
                ;lda     install_zl  	; Comme il n'y a aucun paramêtres ...
                ;sta     ZEROPAGE        ; ... de de retour on redonne a tous les ... 
                ;lda     install_zh  	; ... registres leurs valeurs initiales.
                ;sta     ZEROPAGE+1
                ;ldx     install_rx 
                ;ldy     install_ry 
                lda     install_sf
                pha
                lda     install_ra      
                plp
                rts                     
install_ra  	.byte   0
;install_rx  	.byte   0
;install_ry  	.byte   0
;install_lx  	.byte   0
;install_ly  	.byte   0
;install_zl  	.byte   0
;install_zh  	.byte   0
install_sf  	.byte   0



evalhex     	sta     evalhex_ra       
                php                     ; On sauvegarde tout les registres ...
                pla                     ; ... cc, a, x et y ...
                sta     evalhex_sf       
                stx     evalhex_rx
;                sty     evalhex_ry
;                lda     ZEROPAGE
;                sta     evalhex_zl
;                lda     ZEROPAGE+1
 ;               sta     evalhex_zh
; Là on commence ....                
                lda     #0              ; Indique a BASIC qu'il s'agit d'une donnée ...
                sta     $0d             ; ... numérique dans le VALTYP 0=Num, FF=Chaine
                jsr     CHRGET          ; On cherche un '$'
                cmp     #"$"            ; PATSCII 36
                beq     evalhex_ishex
                jsr     CHRGOT          ; On en fait le caractere courant et ...
                jmp     $AE8D           ; ... on continu normalement.
evalhex_ishex   ldx     #$02            ; On traite deux octets
                ; Premier caractere de l'octet
evalhex_loop    jsr     CHRGET        
                cmp     #"@"            ; PETSCII 64         
                bcc     evalhex_skip1   ; C'est moins, on assume 0-9
                adc     #$08            ; C'est une lettre, On ajoute 9 (8+C) ...
                                        ;  ... pour que le low nib devienne a-f
evalhex_skip1   asl     a               ; on decale le quartet vers le haut               
                asl     a
                asl     a
                asl     a
                sta     evalhex_temp    ; Sauvegarde temporairement
                jsr     CHRGET        
                cmp     #"@"            ; PETSCII 64         
                bcc     evalhex_skip2   ; C'est moins, on assume 0-9
                adc     #$08            ; C'est une lettre, On ajoute 9 (8+C) ...
                                        ;  ... pour que le low nib devienne a-f
evalhex_skip2   and     #$0f            ; On efface le HighNib
                ora     evalhex_temp    ; On combine avec le High Nib en mémoire
                pha                     ; on place sur la pile
                dex                     ; on regarde si on est arrivé au denier
                bne     evalhex_loop    ; non, on cherche un autre octet
                pla                     ; on recupere le LN et le HN du nombre
                sta     $63             ; et on le place dans l'espace de
                pla                     ; conversion float de basic
                sta     $62             ; FAC1      
                ldx     #$90            ; exposant = 2^16
                sec                     ; le carry 
                jsr     $BC49           ; conversion en fp
                
; On efface nos traces
;                lda     evalhex_zl  	; Comme il n'y a aucun paramêtres ...
;                sta     ZEROPAGE        ; ... de de retour on redonne a tous les ... 
;                lda     evalhex_zh  	; ... registres leurs valeurs initiales.
;                sta     ZEROPAGE+1
;                ldy     evalhex_ry 
                ldx     evalhex_rx       
                lda     evalhex_sf
                pha
                lda     evalhex_ra      
                plp
                jmp     evalhex_out                     
evalhex_temp    .byte   0
evalhex_ra  	.byte   0
evalhex_rx  	.byte   0
;evalhex_ry  	.byte   0
;evalhex_lx  	.byte   0
;evalhex_ly  	.byte   0
;evalhex_zl  	.byte   0
;evalhex_zh  	.byte   0
evalhex_sf  	.byte   0
evalhex_out     jmp     CHRGET                

