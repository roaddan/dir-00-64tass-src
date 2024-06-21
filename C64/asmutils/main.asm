; C64ASM  - Commodore 64 (6510) Assembler Package for PC
; Copyright (c) 1996 by B�lint T�th
;
; HELLOW.ASM - example assembly source file
;   Prints "Hello World!" message using KERNAL routine
; ===================================================================

*= $801
.word (+), 10
.null $9e, "16500"
+ .word 0

; main program: simply calls "print"

hellow	lda #<_text
	ldy #>_text
	jsr print       ; the print routine itself is in an include file
	rts

; the text to be printed:
_text   .TEXT "Hello World!" ; This will be all upcase in PET-ASCII!
        .BYTE 0

.INCLUDE PRINT.ASM      ; include the print routine
