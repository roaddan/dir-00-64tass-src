*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;***************************************
; Inclusion des librairies
;***************************************
     .include  "map-c64-kernal.asm"
     .include  "lib-cbm-pushpop.asm"
     .include  "lib-cbm-mem.asm"
     .include  "lib-cbm-hex.asm"
     .include  "lib-c64-text-mc.asm"
     .include  "lib-c64-showregs.asm"         
     ;.include  "lib-c64-joystick.asm"
     ;.include  "lib-c64-spriteman.asm"
;---------------------------------------
;
;---------------------------------------
        jsr  scrmaninit
        ;jsr  cls
        ldx  #0        
        lda  #vbleu
        lda  #1
        jsr  setbkcol
        lda  #1
        jsr  setcurcol
        ldy  #63
nextcar tya
        ;lda  #1     
        jsr  putch
        dey     
        bpl  nextcar
forever iny 
        tya
        and  #$0f
        ldx  #0
        jsr  setvicbkcol
        lda  bkcol
        jsr  showregs
        jmp  forever
over    rts
        .bend