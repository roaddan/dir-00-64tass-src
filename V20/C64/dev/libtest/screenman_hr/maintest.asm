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
          .include "hr_utils.asm"
          .include "showregs.asm"          
          .include "joystick.asm"
main      
          .block
          ;jsr initnmi        ; À utiliser avec TMPreu
          ;jsr  setmyint
          jsr  hr_scrmaninit
          jsr  initjoy
          lda  #$80
          sta  hr_curcol
          lda  #0
          sta  hr_bakcol
          lda  #vbleu
          sta  hr_brdcol
          jsr  hr_cls
goagain   ldx  #<bstring1 
          ldy  #>bstring1
          jsr  hr_putscxy
          ldx  #<bstring2 
          ldy  #>bstring2
          jsr  hr_putscxy
          ldx  #<bstring3 
          ldy  #>bstring3
          jsr  hr_putscxy
          ;rts
          ldx  #$00
          ldy  #$0f
          jsr  hr_gotoxy
          lda  #vjaune
          jsr  hr_setcurcol
          ldx  #$00
          jsr  hr_setbkcol
          lda  #$00
nextcar   jsr  hr_putch
          clc
          adc  #$01
          cmp  #64
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
bstring1  .byte vcyan,hr_bkcol3,0,0        
                ;          111111111122222222223333333333
                ;0123456789012345678901234567890123456789    
          .text "      Visualisation des ports jeux      "
          .byte 0
bstring2  .byte vcyan,hr_bkcol3,0,1
          .text "     Programme assembleur pour 6502     "
          .byte 0
bstring3  .byte vgris1,hr_bkcol3,0,2
          .text "       par Daniel Lafrance (2021)       "
          .byte 0
          .bend
          
          