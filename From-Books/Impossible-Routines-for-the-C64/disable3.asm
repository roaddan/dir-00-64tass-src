;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Disable 1
; Book Page.: 33
;---------;---------;---------;---------;---------;---------;---------;---------
; Make run/stop rerun the current program
;---------;---------;---------;---------;---------;---------;---------;---------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
                .include "c64_map.asm"
main            jsr   disable3  
                rts  
*=$012c
                                ;kfunctions     |axy, Input        
                                ;               |AXY, Output
disable3        sei
                lda     #<sub_disable3  ;#$0d
                sta     $0328
                lda     #>sub_disable3  ;#$10
                sta     $0329
                cli
                rts
sub_disable3    jsr     $a65e           ;Clear screen
                jsr     $a68e           ;Back space
                jmp     $a7ae           ;Rerun program in memory
