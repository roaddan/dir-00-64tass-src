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
               jsr  cls
               ldx  #$0
               ldy  #$0
               jsr  gotoxy
               lda  #1
               jsr  setbkcol
               ldx  #<msg1        
               ldy  #>msg1       
               jsr  puts

               ldx  #$30      ;Adresse de destination 
               ldy  #$00      ; 
               jsr  chargen2ram
               lda  viccptr
               and  #241
               ora  #12
               lda  #29
               sta  viccptr

               ;jsr  makechar

               ;jmp  out
               ldy  #12
               ldx  #$0
               jsr  gotoxy
               lda  #$02
               jsr  setbkcol
               ldx  #<msg1        
               ldy  #>msg1       
               jsr  puts
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

makechar       .block
               jsr  push
               lda  #<char01 
               pha
               lda  #>char01
               pha
               lda  #<charram
               pha
               lda  #>charram
               pha
               lda  #$20
               pha
               lda  #$00
               pha
               jsr  showregs
               jsr  memmove
               pla
               pla
               pla
               pla
               pla
               pla
               jsr  pop
               rts
               .bend               
msg1a           .text " c64-Graphics & sounds programming book ",0
msg1b           .text " abcdefghijklmnopqrstuvwxyz0123456789&  ",0
msg1 .byte         1, 2, 3, 4, 5, 6, 7, 8, 9
     .byte     10,11,12,13,14,15,16,17,18,19
     .byte     20,21,22,23,24,25,26,27,28,29
     .byte     30,31,32,33,34,35,36,37,38,39
     .byte     40,41,42,43,44,45,46,47,48,49
     .byte     50,51,52,53,54,55,56,57,58,59
     .byte     60,61,62,63,0
char01         .byte     %11111111   
               .byte     %10000111   
               .byte     %10001111   
               .byte     %10011011   
               .byte     %11011011   
               .byte     %11110011   
               .byte     %10110011   
               .byte     %11111111   

               .byte     %11111111   
               .byte     %10000111   
               .byte     %10001111   
               .byte     %10011011   
               .byte     %11011011   
               .byte     %11110011   
               .byte     %10110011   
               .byte     %11111111   

               .byte     %11111111   
               .byte     %10000111   
               .byte     %10001111   
               .byte     %10011011   
               .byte     %11011011   
               .byte     %11110011   
               .byte     %10110011   
               .byte     %11111111   

               .byte     %11111111   
               .byte     %10000111   
               .byte     %10001111   
               .byte     %10011011   
               .byte     %11011011   
               .byte     %11110011   
               .byte     %10110011   
               .byte     %11111111   


