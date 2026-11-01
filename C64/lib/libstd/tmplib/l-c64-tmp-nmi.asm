;-------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: l-c64-tmp-nmi.asm
; Cernière m.à j. : 20250521
; Inspiration ....: 
;-------------------------------------------------------------------------------
; On change le vecteur d'interruption pour y placer le retour a 
; l'editeur TMPREU ou TMPstd par la touche [restore].
;-------------------------------------------------------------------------------
; Le vecteur nmi du C64 est à l'adresse $0318
; Pour TMPstd le retour à l'application se fait à 32768 ($8000).
; Pour TMPreu le retour à l'application se fait à 00320 ($0140).
;-------------------------------------------------------------------------------
initnmi                             ; On assume TMPreu par défaut.
;-------------------------------------------------------------------------------
; Place l'adresse d'appel de TMPREU ($0140) dans le vecteur NMI pour pouvoir 
; l'appeler par la séquence de touche [RUN/STOP]+[RESTORE]
;-------------------------------------------------------------------------------
initnmireu     .block
jumpback       =     $0140          ; L'adresse du vecteur TMP en REU.
nmivect        =     $0318          ; L'adresse du vecteur BRK.
               php                  ; Sauvegarde les status.           
               pha                  ; Sauvegarde Acc.
               sei                  ; Bloque les interruptions.
               lda   #<jumpback     ; Enregistre le vecteur de l'instruction ... 
               sta   nmivect        ; ... BRK et des touches ...
               lda   #>jumpback     ; ... [RUN/STOP] - [RESTORE] dans un ...
               sta   nmivect+1      ; ... vecteur personnel.
               pla                  ; On récupère l'Acc et ...
               plp                  ; ... le registre de status.
               rts
               .bend
               
;-------------------------------------------------------------------------------
; Place l'adresse d'appel de TMP ($8000) dans le vecteur NMI pour pouvoir 
; l'appeler par la séquence de touche [RUN/STOP]+[RESTORE]
;-------------------------------------------------------------------------------
initnmistd     .block
jumpbackstd    =     $8000          ; L'adresse du vecteur TMP standard.
nmivect        =     $0318          ; L'adresse du vecteur BRK.
               php                  ; Sauvegarde les status.           
               pha                  ; Sauvegarde Acc.
               sei                  ; Bloque les interruptions.
               lda   #<jumpbackstd  ; Enregistre le vecteur de l'instruction ... 
               sta   nmivect        ; ... BRK et des touches ...
               lda   #>jumpbackstd  ; ... [RUN/STOP] - [RESTORE] dans un ...
               sta   nmivect+1      ; ... vecteur personnel.
               pla                  ; On récupère l'Acc et ...
               plp                  ; ... le registre de status.
               rts
               .bend
