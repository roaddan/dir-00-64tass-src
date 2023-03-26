*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;-------------------------------------------------------------------------------
; Include library files
;-------------------------------------------------------------------------------
                .include        "c64_map_kernal.asm"
                .include        "c64_lib_pushpop.asm"
                .include        "c64_lib_hex.asm"
;                .include        "c64_lib_sd.asm"
                .include        "c64_lib_mc.asm"
                .include        "c64_lib_showregs.asm"                
;                .include        "c64_lib_joystick.asm"
;                .include        "c64_lib_spriteman.asm"
                .include        "c64_lib_chargen.asm"
                .include        "c64_lib_mem.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc screen
main           .block
               jsr  scrmaninit
;               lda  #1
;               jsr  setbkcol
               jsr  cls
               lda  #vbleu
               jsr  setborder
               lda  #0
               sta  compteur
nextblank      sta  blank+3
               ldx  #<blank        
               ldy  #>blank 
               jsr  putscxy
               dec  compteur
               lda  compteur
               bpl  nextblank
               ldx  #<msg1a        
               ldy  #>msg1a       
               jsr  putscxy

               ldx  #$30      ;Adresse de destination 
               ldy  #$00      ; 
               jsr  chargen2ram
               lda  viccptr
               and  #241
               ora  #12
               lda  #29
               sta  viccptr
               rts
               ;jsr  makechar

               ;jmp  out
               ;ldy  #12
               ;ldx  #$0
               ;jsr  gotoxy
               ;lda  #$02
               ;jsr  setbkcol
               ;ldx  #<msg1a        
               ;ldy  #>msg1a       
               ;jsr  putscbxy

ici            dec  vborder
waitscan       lda  vicreg11
               bpl  waitscan
               inc  vborder
               lda  $d022
               clc               
               adc  #$01
               and  #$0f
               sta  $d022
               jmp  ici
out            rts
               .bend
compteur       .byte 2
               .text 1,2,0,1,"0123456789012345678901234567890123456789"  
blank          .text 1,3,0,0,"                                        ",0             
msg1a          .text 1,3,0,0," C64/C64c - SID alternatives comparison ",0
