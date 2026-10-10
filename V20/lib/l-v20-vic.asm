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

vicauxcol   .block
            php
            asl
            asl
            asl
            asl
            sta   tmp
            lda   vic14
            and   #$0f
            ora   tmp
            sta   vic14
            plp
            rts
tmp         .byte 0
            .bend


vicmcmode   .block
            php
            pha
            lda   vic15
            ora   #%00001000
            sta   vic15
            pla
            plp
            rts
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

;-----------------------------------------------------------------------------
; a=couleur X=col, Y-lin
setcolram   .block
            jsr   pushall
            and   #$07
;            pha               ; color on the stack
            jsr   getcoladdr
            ldy   scroffset+1 ;MSB
            sty   zpage1+1
            ldx   scroffset   ;LSB
            stx   zpage1
            ldy   #$00
;            pla               ; color from the stack
            sta   ($fb),y
            jsr   popall
            rts
            .bend
settxtram   .block
            jsr   pushall
;            pha               ; color on the stack
            jsr   gettxtaddr
            ldy   scroffset+1 ;MSB
            sty   zpage1+1
            ldx   scroffset   ;LSB
            stx   zpage1
            ldy   #$00
;            pla               ; color from the stack
            sta   ($fb),y
            ; start testing .......
;            ldy   scroffset+1 ;MSB
;            ldx   scroffset   ;LSB
;            #outcar     $0d
;            #outcar     '$'
;            jsr   putyxhex
            ; end testing .......
            jsr   popall
            rts
            .bend            
scroffset   .word $00


getcoladdr  .block
            jsr   push
            lda   #>scrcol    ;MSB
            sta   scroffset+1
            lda   #<scrcol    ;LSB
            sta   scroffset
            jmp   calcaddr
            .bend

gettxtaddr  .block
            jsr   push
            lda   #>scrtxt    ;MSB
            sta   scroffset+1
            lda   #<scrtxt    ;LSB
            sta   scroffset
            jmp   calcaddr
            .bend


calcaddr    .block
addline     clc
            cpy   #0
            beq   addcolnm
            dey
            adc   #21
            sta   scroffset
            bcc   addline
            inc   scroffset+1
            jmp   addline   
addcolnm    txa   
            clc
            adc   scroffset
            bcc   norep
            inc   scroffset+1
norep       sta   scroffset
            ldy   scroffset+1 ;MSB
            ldx   scroffset   ;LSB
            jsr   pop
            rts
            .bend

vicnormal   .block
            jsr   push
            lda   #27
            sta   vic15
            jsr   pop
            rts
            .bend