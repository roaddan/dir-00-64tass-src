;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du
; BASIC 2.0 DU Commodore Vic20 avec expantion de RAM.
;-----------------------------------------------------------
*= $1201
.word (+), 10       ;$1201 : Debut + 10 =$120b, $0010
.null $9e, "4621"   ;$1205 : "sys4621" = jsr #120d
+ .word 0           ;$120b : $0000    
                    ;$120d : Adresse suivante
