;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Disable 2
; Book Page.: 34
;---------;---------;---------;---------;---------;---------;---------;---------
; Make run/stop reset the C64
;---------;---------;---------;---------;---------;---------;---------;---------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
                .include "c64_map.asm"
main            jsr   disable2  
                rts  
*=$012c
disable2        sei
                lda     #<sub_disable2
                sta     $0328
                lda     #>sub_disable2
                sta     $0329
                cli
                rts
sub_disable2    jsr     $fce2           ;main reset
