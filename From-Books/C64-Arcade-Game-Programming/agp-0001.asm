*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
                .include        "c64_map_kernal.asm"
                .include        "c64_lib_pushpop.asm"
                .include        "c64_lib_mem.asm"
                .include        "c64_lib_hex.asm"
;                .include        "c64_lib_sd.asm"
                .include        "c64_lib_mc.asm"
                .include        "c64_lib_showregs.asm"                
                .include        "c64_lib_joystick.asm"
                .include        "c64_lib_spriteman.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .enc "screen"
main           .block
               ;jsr  setvectors
               jsr  scrmaninit
               jsr  cls
               ldx  #$01
               ldy  #$0
               jsr  gotoxy
               lda  #1
               jsr  setbkcol
               ldx  #<msg1        
               ldy  #>msg1       
               jsr  puts
               ldy  #25
nextline       dey
               beq  go
               ldx  #$01
               jsr  gotoxy
               tya
               and  #$03
               jsr  setbkcol
               ldx  #<msg1        
               ldy  #>msg1       
               jsr  puts
               ;jmp  nextline
go             lda  #0
               ldx  #1
ici            dec  vborder
waitscan       lda  vicreg11
               bpl  waitscan
               inc  vborder
               clc
               inc  $d022
               lda  $d022
               and  #$0f
               sta  $d022
               jmp  ici
out            rts
msg1           .text "* c64 - arcade game programming book *",0   
               .bend