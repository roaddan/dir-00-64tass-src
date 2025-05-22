;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
uiimacsndcmd   .macro pointer
               jsr  push
               ldx  #<\pointer
               ldy  #>\pointer
               jsr  uiifsndcmd
               jsr  pull
               .endm