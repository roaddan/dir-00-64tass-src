; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b�lint t�th
;
; print.asm - example assembly source file
;   prints a null terminated string to screen whose address in a/y
; ===================================================================

;.include "system.asm"     ; include system declarations
                        ; (only the chrout routine is really used)

; print subroutine prints a 0 ended string whose address comes from a/y regs
print   jmp _pstart
_tmp    .byte 0
_pstart sta _zp
	sty _zp + 1
	ldy #0
	sty _tmp
_loop	lda (_zp),y
	beq _quit
	jsr chrout
	inc _tmp
	ldy _tmp
	bne _loop
	inc _zp + 1
	bne _loop
_quit   rts
_zp     =       $fd
