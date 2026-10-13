; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b lint t¢th
;
; rotatel.asm - example assembly source file
;   cyclically rotates 8 bytes left in by one bit their places
; ===================================================================

rotatel lda #<_work
       ldy #>_work
       sta _zp
       sty _zp + 1
       ldy #_len
_loop  lda (_zp),y
       rol a
       lda (_zp),y
       rol a
       sta (_zp),y
       dey
       bpl _loop
       rts

_zp = $fd               ; zero page address for indirect indexed addressing

; the 8 bytes to rotate:
_work   .byte $f0, $80, $55, $69, $60, 0, $12, $2f
_workend = *            ; it'll contain the address of the last byte ($2f)
_len = _workend - _work ; number of bytes
