;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
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