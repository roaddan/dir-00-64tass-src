; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b lint t¢th
;
; ifgoto.asm - example assembly source file
;   demonstrates the use of .label, .if and .goto and .end directives
; ===================================================================

.goto countdown
.label a1
.goto dummy
.label a2
.end                    ; end of compile
.asc "this line will never be compiled!"

; ==============================
.label countdown
; puts the $0a, $09, ... $00 sequence in the target

count := $0b            ; start value of variable
                        ; loop will work like "for count := $0a downto 0 do"

.label loop1
count := count - 1      ; decrement variable
.byte count             ; put value of count in target file
.if count .goto loop1   ; jump back if count > 0
.goto a1

; ==============================
.label dummy
; puts a dummy sequence in the target

count := $10            ; start value of variable
_max = $15              ; maximum value (a local constant)
                        ; loop will work like "for count := 10 to 15 do"
temp := $d345           ; this value will be scrambled repeatedly in the loop

.label loop2
temp := (temp + 23) >> 1
.word temp - count      ; put a value in target file
count := count + 1      ; increment variable
.if count <= _max .goto loop2  ; jump back if count <= max
.goto a2
