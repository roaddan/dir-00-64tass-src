;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: lib-cbm-stack.asm
; Type fichier....: Code
; Creation........: 20151208 
; Version.........: 0.1.0
; Révisions.......: 20261119 - Francisation des commentaires.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Sauvegarde sur la pile tous les registres ainsi que les pointeur Zéro-Page
; de l'utilisateur.
;------------------------------------------------------------------------------
pushall        .block               ; * Pile= pcl,pch
               php                  ; Place rp sur la pile.
                                    ; * Pile= flg,pcl,pch  
               sei                  ; Inhibe les interruptions.
               sta   ra             ; Sauve Acc. en mémoire.
               pla                  ; Prend rp de la pile.
                                    ; * Pile= pcl,pch
               sta   rp             ; Sauve rp en mémoire.
               pla                  ; Prend pcl de la pile.
                                    ; * Pile= pch
               sta   pc             ; Sauve pcl en mémoire.
               pla                  ; Prend pch de la pile.
                                    ; * Pile= -
               sta   pc+1           ; Sauve pch en mémoire.
               lda   zpage1         ; Prend zpage1 LSB
               pha                  ; Le place sur la pile.
                                    ; * Pile= zp1l
               lda   zpage1+1       ; Prend zpage1 MSB
               pha                  ; Le place sur la pile.
                                    ; * Pile= zp1h,zp1l
               lda   zpage2         ; Prend zpage2 LSB.
               pha                  ; Le place sur la pile.
                                    ; * Pile= zp2l,zp1h,zp1l
               lda   zpage2+1       ; Prend zpage2 MSB.
               pha                  ; Le place sur la pile.
                                    ; * Pile= zp2h,zp2l,zp1h,zp1l 
               lda   rp             ; Prend rp de la mémoire.
               pha                  ; Le place sur la pile.
                                    ; * Pile= flg,zp2h,zp2l,zp1h,zp1l
               lda   ra             ; Prend Acc. de la mémoire.
               pha                  ; Le place sur la pile.
                                    ; * Pile= Acc.,flg,zp2h,zp2l,zp1h,zp1l
               txa                  ; Transfère X dans Acc.
               pha                  ; Le place sur la pile.
                                    ; * Pile= X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               tya                  ; Transfère Y dans Acc.
               pha                  ; Le place sur la pile.
                                    ; * Pile= Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               lda   pc+1           ; Prend pch de la mémoire.
               pha                  ; Le replace sur la pile.
                                    ; * Pile= pch,Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               lda   pc             ; Prend pcl de la mémoire.
               pha                  ; Le replace sur la pile.
                                    ; * Pile= pcl,pch,Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               lda   rp             ; Prend rp de la mémoire.
               pha                  ; Le place sur la pile.
                                    ; * Pile= flg,pcl,pch,Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               lda   ra             ; Prend Acc. de la mémoire.
               plp                  ; Récupère rp de la pile.
                                    ; * Pile= pcl,pch,Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               cli                  ; Permet les interruptions.
               rts                  ; Sort avec l'adresse de retour sur la pile.
               .bend

;------------------------------------------------------------------------------
; Récupère de la pile tous les registres ainsi que les pointeur Zéro-Page
; de l'utilisateur.
;------------------------------------------------------------------------------
popall         .block               ; * Pile= pcl,pch,Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               sei                  ; Inhibe les interruptions.
               pla                  ; Prend pcl de la pile. 
                                    ; * Pile= pch,Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               sta   pc             ; Sauve pcl en mémoire.
               pla                  ; Prend pch de la pile. 
                                    ; * Pile= Y,X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               sta   pc+1           ; Sauve pch en mémoire.
               pla                  ; Prend Y de la pile. 
                                    ; * Pile= X,Acc.,flg,zp2h,zp2l,zp1h,zp1l
               tay                  ; Place dans Y.
               pla                  ; Prend X de la pile. 
                                    ; * Pile= Acc.,flg,zp2h,zp2l,zp1h,zp1l
               tax                  ; Place dans x.
               pla                  ; Prend Acc. de la pile. 
                                    ; * Pile= flg,zp2h,zp2l,zp1h,zp1l
               sta   ra             ; Sauve Acc. en mémoire.
               pla                  ; Prend flag de la pile. 
                                    ; * Pile= zp2h,zp2l,zp1h,zp1l
               sta   rp             ; Sauve rp en mémoire.
               pla                  ; Prend zp2H de la pile. 
                                    ; * Pile= zp2l,zp1h,zp1l 
               sta   zpage2+1       ; Place dans zpage2 MSB ($fe).
               pla                  ; Prend zp2l de la pile. 
                                    ; * Pile= zp1h,zp1l
               sta   zpage2         ; Place dans zpage2 lSB ($fd).
               pla                  ; Prend zp1h de la pile. 
                                    ; * Pile= zp1l
               sta   zpage1+1       ; Place dans zpage1 MSB ($fc).
               pla                  ; Prend zp1h de la pile.: 
                                    ; * Pile=
               sta   zpage1         ; Place dans zpage1 LSB ($fb).
               lda   pc+1           ; Prend pch de la mémoire.
               pha                  ; Le place sur la pile: 
                                    ; * Pile= pch
               lda   pc             ; Prend pcl de la mémoire.
               pha                  ; Le place sur la pile: 
                                    ; * Pile= pcl,pch
               lda   rp             ; Prend rp de la mémoire.
               pha                  ; Le place sur la pile: 
                                    ; * Pile= rp,pcl,pch
               lda   ra             ; Prend Acc. de la mémoire.        
               plp                  ; Prend rp de la pile: 
                                    ; * Pile= pcl,pch 
               cli                  ; Permet les interruptions.
               rts                  ; Sort avec l'adresse de retour sur la pile.
               .bend 

;------------------------------------------------------------------------------
; Sauvegarde sur la pile tous les registres.
;------------------------------------------------------------------------------
push           .block               ; * Pile= pcl,pch
               php                  ; Place rp sur la pile.
                                    ; * Pile= flg,pcl,pch  
               sei                  ; Inhibe les interruptions.
               sta   ra             ; Sauve Acc. en mémoire.
               pla                  ; Prend rp de la pile.
                                    ; * Pile= pcl,pch
               sta   rp             ; Sauve rp en mémoire.
               pla                  ; Prend pcl de la pile.
                                    ; * Pile= pch
               sta   pc             ; Sauve pcl en mémoire.
               pla                  ; Prend pch de la pile.
                                    ; * Pile= -
               sta   pc+1           ; Sauve pch en mémoire.
               lda   rp             ; Prend rp de la mémoire 
               pha                  ; Le place sur la pile: 
                                    ; * Pile= flg
               lda   ra             ; Prend Acc. de la mémoire.
               pha                  ; Le place sur la pile: 
                                    ; * Pile= Acc.,flg
               txa                  ; Transfère X dans Acc.
               pha                  ; Le place sur la pile.
                                    ; * Pile= X,Acc.,flg
               tya                  ; Transfère X dans Acc.
               pha                  ; Le place sur la pile.
                                    ; * Pile= Y,X,Acc.,flg
               lda   pc+1           ; Prend pch de la mémoire.
               pha                  ; Le place sur la pile.
                                    ; * Pile= pch,Y,X,Acc.,flg
               lda   pc             ; Prend pcl de la mémoire.
               pha                  ; Le place sur la pile.
                                    ; * Pile= pcl,pch,Y,X,Acc.,flg
               lda   rp             ; Prend rp de la mémoire
               pha                  ; Le place sur la pile.
                                    ; * Pile= flg,pcl,pch,Y,X,Acc.,flg
               lda   ra             ; Prend a de la mémoire.
               plp                  ; Prend rp de la pile.
                                    ; * Pile= pcl,pch,Y,X,Acc.,flg
               cli                  ; Permet les interruptions.
               rts                  ; Sort avec l'adresse de retour sur la pile.
               .bend

;------------------------------------------------------------------------------
; Récupère de la pile tous les registres.
;------------------------------------------------------------------------------
pop            .block               ; * Pile= pcl,pch,Y,X,Acc.,flg
               sei                  ; Inhibe les interruptions.
               pla                  ; Prend pcl de la pile. 
                                    ; * Pile= pch,Y,X,Acc.,flg
               sta  pc              ; Sauve pcl en mémoire.
               pla                  ; Prend pch de la pile.
                                    ; * Pile= Y,X,Acc.,flg
               sta  pc+1            ; Sauve pch en mémoire.
               pla                  ; Prend y de la pile.
                                    ; * Pile= X,Acc.,flg
               tay                  ; Transfère Y dans Acc..
               pla                  ; Prend x de la pile.
                                    ; * Pile= Acc.,flg
               tax                  ; Transfère X dans Acc..
               pla                  ; Prend Acc. de la pile.
                                    ; * Pile= flg
               sta  ra              ; Sauve Acc. en mémoire.
               pla                  ; Prend flag de la pile.
                                    ; * Pile= -
               sta  rp              ; Sauve rp en mémoire.
               lda  pc+1            ; Prend pch de la mémoire.
               pha                  ; Le place sur la pile.
                                    ; * Pile= pch
               lda  pc              ; Prend pcl de la mémoire.
               pha                  ; le place sur la pile.
                                    ; * Pile= pcl,pch
               lda  rp              ; Prend rp de la mémoire.
               pha                  ; le place sur la pile.
                                    ; * Pile= rp,pcl,pch
               lda  ra              ; Prend Acc. de la mémoire.        
               cli                  ; Permet les interruptions
               plp                  ; prend rp de la pile.
                                    ; * Pile= pcl,pch              
               rts                  ; Sort avec l'adresse de retour sur la pile.
               .bend       
