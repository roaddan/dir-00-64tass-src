;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: header-v20ex.asm
; Cernière m.à j. : 20250521-222823
; Inspiration ....: 
;--------------------------------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du BASIC 2.0 du 
; Commodore Vic20 avec expantion de RAM.
;--------------------------------------------------------------------------------
*= $1201
.word (+), 10       ;$1201 : Debut + 10 =$120b, $0010
.null $9e, "4621"   ;$1205 : "sys4621" = jsr #120d
+ .word 0           ;$120b : $0000    
                    ;$120d : Adresse suivante
