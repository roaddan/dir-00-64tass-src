;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
clears          pha
                jsr     fillscr
                .byte   $20,0,0,0
                jsr     gotoxy
                .byte   0,0
                pla
                rts     
