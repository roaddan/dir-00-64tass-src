;---------------------------------------------------------------------
; On change le vecteur d'interruption pour y placer le retour a 
; l'editeur TMPREU par la touche [restore].
;---------------------------------------------------------------------
; Le vecteur nmi du C64 est à l'adresse $0318
; Pour TMPstd le retour à l'application se fait à 32768 ($8000).
; Pour TMPreu le retour à l'application se fait à 00320 ($0140).
;---------------------------------------------------------------------
initnmi                  ; On assume TMPreu par défaut
initnmireu
         .block
jumpback = $0140
nmivect  = $0318
         php
         pha
         sei
         lda #<jumpback
         sta nmivect
         lda #>jumpback
         sta nmivect+1
         pla
         plp
         rts
         .bend
initnmistd
         .block
jumpback = $8000
nmivect  = $0318
         php
         pha
         sei
         lda #<jumpback
         sta nmivect
         lda #>jumpback
         sta nmivect+1
         pla
         plp
         rts
         .bend
