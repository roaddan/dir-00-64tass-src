;------------------------------
; Assembly Language Programming
;    with the commodore 64
;      Marvin L. De Jong
;------------------------------
; Example 3-8
; Clearing A, X and Y.
;------------------------------
*=$c000 ; 49152
start   ldy #$00    ; Y <- 0
        tya         ; A <- Y
        tax         ; X <- A
        rts
        
        