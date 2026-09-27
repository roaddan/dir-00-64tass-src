;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: header.asm
; Cernière m.à j. : 20250521
; Inspiration ....: 
;--------------------------------------------------------------------------------
;-----------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du
; Basic 2 sur un COMMODORE C64.
;-----------------------------------------------------------
;*= $801
;.word (+), 10
;.null $9e, "2061"
;+ .word 0
;-----------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du
; Basic 2 sur un Vic20 sans expantion de RAM.
;-----------------------------------------------------------
;*= $1001
;.word (+), 10       ;$1001 : Debut + 10 =$100b, $0010
;.null $9e, "4109"   ;$1005 : "sys4109" = jsr $100d
;+ .word 0           ;$100b : $0000
                     ;$100d : Adresse suivante    
;-----------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du
; BASIC 2 sur un Vic20 avec expantion de RAM.
;-----------------------------------------------------------
*= $1201
.word (+), 10       ;$1201 : Debut + 10 =$120b, $0010
.null $9e, "4621"   ;$1205 : "sys4621" = jsr #120d
+ .word 0           ;$120b : $0000    
                    ;$120d : Adresse suivante    
;-----------------------------------------------------------
