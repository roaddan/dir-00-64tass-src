;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Disk error
; Book Page.: 55
;---------;---------;---------;---------;---------;---------;---------;---------
; Description : Display last disk error
;---------;---------;---------;---------;---------;---------;---------;---------
;*= $801
;.word (+), 10
;.null $9e, "2061"
;+ .word 0
;                .include "c64_map.asm"
;main            jsr   diskerror  
;                rts  
;*=$012c
                                ;kfunctions     |axy, Input        
                                ;               |AXY, Outuut
diskerror      .block
               jsr  push
               lda  driveno      ; Select device 8
               sta  $ba       ;
               jsr  talk      ; $ffb4 |a  , iec-cmd dev parle
               lda  #$6f
               sta  $b9       ; 
               jsr  tksa      ; $ff96 |a  , talk adresse sec.
nextchar       jsr  acptr     ; $ffa5 |a  , rx serie.
               jsr  chrout    ; $ffd2 |a  , sort un car.
               cmp  #$0d      ; Is it CR ?
               bne  nextchar  ; No, get next char
               jsr  untlk     ;$ffab      , iec-cmc stop talk
               jsr  pop
               rts
                .bend