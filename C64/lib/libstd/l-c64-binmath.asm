;-----------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-Basic2.asm
; Type fichier....: Code
; Creation........: 20151208 
; Version.........: 0.0.1
; Révision........: 20261119 - Francisation des commentaires.
; Variables dans..: v-c64-vars.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Ajout la valeur de l'accumulateur à une case mémoire 16 bits.
;------------------------------------------------------------------------------
bmaddacc       .block
               php                  ; Sauvegarde minimaliste 
               pha                  ; ... des registres.
               lda   #$00           ; On place 0 dans 
               sta   bmovfl         ; ... la variable de débordement.
               pla                  ; On récupère Acc
               pha                  ; Pour pouvoir sortir sans altération.
               clc                  ; Report à 0.
               adc   bmnum0         ; Ajoute Acc à LSB du nombre 16 bit. 
               sta   bmnum0         ; ... et l'enregistre.
               bcc   norep          ; Si carry est vide, pas de report à faire.
               inc   bmnum0+1       ; On fait le report.
norep          bcc   norep2         ; Si carry est vide, pas de débordement. 
               inc   bmovfl         ; On augmente l'octet de débordement de 1.     
norep          pla                  ; Récupération minimaliste
               plp                  ; ... des registres.
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Fonction test pour la sous-routine bmaddacc 
;------------------------------------------------------------------------------
bmtester       .block
               jsr   push           ; Sauvegarde tous les registres.
               lda   #1             ; Pour tester on ajoute 1
               jsr   bmaddacc       ; ... au nombre 16 bit en mémoire.
               ldx   bmnum0         ; On charge l'adresse ou se trouve 
               lda   bmnum0+1       ; ... le résultat dans $AAXX
               ldy   bmovfl         ; On charge le registre ovfl dans Y.
               jsr   showregs       ; On affiche le contenue des registres.
               jsr   pop            ; Récupère tous les registres.
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; addtoword: Aditionne la valeur de Acc. d'une valeur 16 bit en mémoire.
; adresse   = $YYXX Y=MSB, X=LSB
; valeur    = A
;------------------------------------------------------------------------------
addtoword      .block 
               jsr   pushall        ; Sauvegarde tous les registres et zps.
               sty   zpage1+1       ; Place le MSB de l'adresse dans $fc
               stx   zpage1         ; ... et son LSB dans $fb
               ldy   #$00           ; Index à 0 pour le mode indirect.
               clc                  ; ACD avec carry à 0.
               adc   (zpage1),y      ; Ajoute Acc. au LSB de la valeur pointée.
               bcc   noreport       ; Si C=0 pas de report à faire.
               iny
               inc   (zpage1),y   ; Ajoute 1 au MSB de la valeur pointée.
noreport       jsr   popall         ; Récupère tous les registres et zps.
               rts                  ; Môman, c'est fini.
               .bend 

;------------------------------------------------------------------------------
; subtoword: soustrait la valeur de Acc. d'une valeur 16 bit en mémoire.
; adresse   = $YYXX Y=MSB, X=LSB
; valeur    = A
;------------------------------------------------------------------------------
subtoword      .block
               jsr   pushall        ; Sauvegarde tous les registres et zps.
               sty   zpage1+1       ; Place le MSB de l'adresse dans $fc. 
               sty   zpage1         ; Place le LSB de l'adresse dans $fb.
               ldy   #$00           ; Index à 0 pour le mode indirect.
               sta   zpage2         ; Puisque sbc fait Acc-memoire on doit
               lda   (zpage1),Y     ; ... inverser les opérandes. 
               sec                  ; Prépare au cas d'emprunt.
               sbc   zpage2         ; On fait la soustraction.
               sta   (zpage1),y     ; On sauvegarde le LSB du résultat.
               bcs   pasemprunt     ; Pas d'emprunt on saute.
               iny                  ; Pointe le MSB.
               dec   (zpage1),y     ; Fait l'emprunt si nécessaire.
pasemprunt     jsr   popall         ; Récupère tous les registres et zps.
               rts                  ; Môman, c'est fini.
               .bend
    
addtwoword     .block
               jsr   push
               sty   adddo+1     ; LSB
               sty   adddo2+1    ; LSB
               sty   addrep+1    ; LSB
               stx   adddo+2     ; MSB
               stx   adddo2+2    ; MSB
               stx   addrep+2    ; MSB
               pha             ; Sauve  
               clc
               lda   #$01
               adc   addrep+1    ; LSB+1
               sta   addrep+1
               bcc   addsamepage 
               inc   addrep+2    ; MSB+1
addsamepage    ;brk
               pla
               clc
adddo          adc $ffff
adddo2         sta $ffff
               bcc addnorep
addrep         inc $ffff
addnorep       jsr pop
               rts                  ; Môman, c'est fini.
               .bend

