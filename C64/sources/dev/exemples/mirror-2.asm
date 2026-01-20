; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b�lint t�th
;
; mirror.asm - example assembly source file
;   mirrors 8 bytes in their places (msb <--> lsb)
; ===================================================================

mirror lda #<_work
       ldy #>_work
       sta _zp
       sty _zp + 1
       ldy #_len
_loop  lda #7            ; number of bits - 1
       sta _tmp
       lda (_zp),y
_newbit asl a
       pha
       txa
       ror a
       tax
       pla
       dec _tmp
       bpl _newbit
       txa
       sta (_zp),y
       dey
       bpl _loop
       rts

_zp = $fd               ; zero page address for indirect indexed addressing
_tmp  .byte 0        ; temporary storage

; the 8 bytes to mirror:
_work  .byte $f0, $80, $55, $69, $60, 0, $12, $2f
_workend = *            ; it'll contain the address of the last byte ($2f)
_len = _workend - _work ; the number of bytes
