;-----------------------------------------------------------
; Fichier..: l-v20-vic.asm
; Auteur...: Daniel Lafrance
; Version..: 0.1
; Revision.: 20261008-000000
;-----------------------------------------------------------
; Fonction pour la gestion graphique et musicale du VIC.
;-----------------------------------------------------------
vicforegnd  .block
            jsr   push
            and   #%00001111
            asl
            asl
            asl
            asl
            sta   tmp
            lda   vic15
            and   #$0f  
            ora   tmp
            sta   vic15
            jsr   pop
            rts
tmp         .byte 0
            .bend

vicbackgnd  .block
            jsr   push
            and   #%00000111
            sta   tmp
            lda   vic15
            and   #248
            ora   tmp
            sta   vic15     
            jsr   pop
            rts
tmp         .byte 0
            .bend

vicnormal   .block
            jsr   push
            lda   #27
            sta   vic15
            jsr   pop
            rts
            .bend