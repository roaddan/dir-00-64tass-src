;-----------------------------------------------------------
; Entete de programme assembleur pour demarrage à partir du
; sur un COMMODORE C64.
;-----------------------------------------------------------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
