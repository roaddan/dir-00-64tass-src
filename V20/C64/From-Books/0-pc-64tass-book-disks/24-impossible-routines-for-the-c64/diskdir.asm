;*= $801
;.word (+), 10
;.null $9e, "2061"
;+ .word 0
;               .include "c64_map_kernal.asm"
;               .include "c64_map_basic2.asm"
;               .include "c64_lib_basic2.asm"
;               .include "c64_lib_hex.asm"
;               .include "c64_lib_pushpop.asm"
;               .include "diskerror.asm"
;main
diskdir        .block
               jsr  push
               lda  #$24      ; L012C - Filename is "$"
               sta  $fb       ; L012E - Zpage1 msb
               lda  #$fb      ; L0130 - Set current filename 
               sta  $bb       ; L0132 - Current filename msb.
               lda  #$00      ; L0134 - to Zpage 1
               sta  $bc       ; L0136 - Current filename lsb.
               lda  #$01      ; L0138 - set ...
               sta  $b7       ; L013A - ... length of current filename
               lda  driveno      ; L013C - set 8 as ... 
               sta  $ba       ; L013E - ... current serial sevice.
               lda  #$60      ; L0140 - set $60 to ...
               sta  $b9       ; L0142 - ... secondary address
               jsr  sfopen    ; L0144 - $f3d5 Serial file open.
               lda  $ba       ; L0147 - Command device $ba ($08) ...
               jsr  talk      ; L0149 - $ffb4 ... to talk.
               lda  $b9       ; L014C - Command sec. device ($60) ...
               jsr  tksa      ; L014E - $ff96 ... to talk.
               lda  #$00      ; L0151 - put $00 in ...
               sta  $90       ; L0153 - ... kernal status word.
                              ; Bit 0 : Time out (Write).
                              ; Bit 1 : Time out (Read).
                              ; Bit 6 : EOI (End of Identify).
                              ; Bit 7 : Device not present.
               ldy  #$03      ; L0155 - To read 3 bytes, put $03 in
loop1          sty  $fb       ; L0157 - Zpage 1 Msb
               jsr  acptr     ; L0159 - $ffa5 Recoit un byte du port serie.
               sta  $fc       ; L015C - Store byte in zpage 1 lsb
               ldy  $90       ; L015E - Load kernal status word.
               bne  exit      ; L0160 - If any error, EXIT.
               jsr  $ffa5     ; L0162 - jsr acptr
               ldy  $90       ; L0165 - Load byte counter,
               bne  exit      ; L0167
               ldy  $fb       ; L0169
               dey            ; L016b
               bne  loop1     ; L016C - If not last, loop
               ldx  $fc       ; L016E - Load the recieved byte in X.
               jsr  b_putint  ; L0170 - $bdcd print file size    
               lda  #$20      ; L0173 - Load space character and ...
               jsr  chrout    ; L0175 - $ffd2 ... print it.
loop3          jsr  acptr     ; L0178 - $ffa5 Recoit un byte du port serie.
               ldx  $90       ; L017B - Load kernal status word.
               bne  exit      ; L017D - If any error, EXIT.
               tax            ; L017F - tfr a in x
               beq  loop2     ; L0180 - Byte is 0 loop1
               jsr  chrout    ; L0182 - $ffd2 ... print it. 
               jmp  loop3     ; L0185 - get another byte
loop2          lda  #$0d      ; L0188  - Load CR in a
               jsr  chrout    ; L018A - $ffd2 ... print it.
               ldy  #$02      ; L018D - set Y to 2
               bne  loop1     ; L018f - Loop to next dir entry.
exit           jsr  sfclose   ; L0191 - $f642 ... close file.
               jsr  pop
               rts            ; L0194
               .bend