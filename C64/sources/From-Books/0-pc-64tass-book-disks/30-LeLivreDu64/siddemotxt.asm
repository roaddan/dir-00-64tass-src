;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc "screen"
        .include    "l-c64-bashead.asm"
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
;-------------------------------------------------------------------------------
; Include library files
;-------------------------------------------------------------------------------
        .include    "e-c64-kernal.asm"
        .include    "e-c64-vars.asm"
        .include    "l-c64-push.asm"
        .include    "l-c64-hex.asm"
        .include    "l-c64-string.asm"
;        .include    "l-c64-sd.asm"
;                .include        "l-c64-mc.asm"
                .include        "l-c64-showregs.asm"                
;                .include        "l-c64-joystick.asm"
;                .include        "l-c64-spriteman.asm"
;                .include        "l-c64-chargen.asm"
                .include        "l-c64-mem.asm"
