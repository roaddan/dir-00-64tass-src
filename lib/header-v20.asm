;-----------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du
; BASIC 2.0 du Commodore Vic20 sans expantion de RAM.
;-----------------------------------------------------------
*= $1001
.word (+), 10       ;$1001 : Debut + 10 =$100b, $0010
.null $9e, "4109"   ;$1005 : "sys4109" = jsr $100d
+ .word 0           ;$100b : $0000
                    ;$100d : Adresse suivante    
