*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;***************************************
; Inclusion des librairies
;***************************************
     .include  "c64_map_kernal.asm"
     .include  "c64_lib_pushpop.asm"
     .include  "c64_lib_mem.asm"
     .include  "c64_lib_hex.asm"
     .include  "c64_lib_mc.asm"
     .include  "c64_lib_showregs.asm"                
     ;.include  "c64_lib_joystick.asm"
     ;.include  "c64_lib_spriteman.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main           .block
               jsr  scrmaninit
               ; jsr  cls
               ldx  #0               
               lda  #vbleu
               
               lda  #1
               jsr  setbkcol
               lda  #1
               jsr  setcurcol
               ldy  #63
nextcar        tya
               ;lda  #1     
               jsr  putch
               dey     
               bpl  nextcar
forever        iny 
               tya
               and  #$0f
               ldx  #0
               jsr  setvicbkcol
               lda  bkcol
               jsr  showregs
               jmp  forever
over           rts
               .bend