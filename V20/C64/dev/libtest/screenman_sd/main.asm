          .enc      "screen"   
;---------------------------------------------------------------------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
          .include "c64map.asm"
          .include "butils.asm"
          .include "hexutils.asm"
;          .include "initnmi.asm"
;          .include "memutils.asm"
          .include "sd_utils.asm"
          .include "showregs.asm"          
          .include "joystick.asm"
main      
          .block
          ;jsr initnmi        ; À utiliser avec TMPreu
          ;jsr  setmyint
          jsr  sd_scrmaninit
          jsr  initjoy
          lda  #$80
          sta  sd_curcol
          lda  #0
          sta  sd_bakcol
          lda  #vbleu
          sta  sd_brdcol
          jsr  sd_cls
goagain   jsr  sd_setinverse
          ldx  #<bstring1 
          ldy  #>bstring1
          jsr  sd_putscxy
          ldx  #<bstring2 
          ldy  #>bstring2
          jsr  sd_putscxy
          ldx  #<bstring3 
          ldy  #>bstring3
          jsr  sd_putscxy
          jsr  sd_clrinverse
          ;rts
          ldx  #$00
          ldy  #$0f
          jsr  sd_gotoxy
          lda  #vjaune
          jsr  sd_setcurcol
          ldx  #$00
          jsr  sd_setbkcol
          lda  #$00
nextcar   jsr  sd_putch
          clc
          adc  #$01
          cmp  #00
          bne  nextcar
          ldx  #$00
looj2     lda  #$55
looper    jsr  scanjoy
          jsr  showjsvals
          ldx  j2pixx+1
          ldy  j2pixx
          lda  j2fire
          jsr  showregs
          jmp  looper
out       rts
          .enc "screen"
bstring1  .byte vcyan,sd_bkcol3,0,0        
                ;          111111111122222222223333333333
                ;0123456789012345678901234567890123456789    
          .text "      Visualisation des ports jeux      "
          .byte 0
bstring2  .byte vcyan,sd_bkcol3,0,1
          .text "     Programme assembleur pour 6502     "
          .byte 0
bstring3  .byte vcyan,sd_bkcol3,0,2
          .text "       par Daniel Lafrance (2021)       "
          .byte 0
          .bend
          
          