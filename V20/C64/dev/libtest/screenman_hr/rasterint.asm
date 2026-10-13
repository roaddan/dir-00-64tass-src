
;---------------------------------------------------------------------          
;          
;---------------------------------------------------------------------                    
myint
rastlino  =    215
          .block
          php
          pha
          ;inc  scrnram0
          ;inc  scrncol0
          lda  #vbleu0
          sta  $d021     
scanit    lda  vicscan
          cmp  #rastlino+40
          bne  scanit
goblack   lda  #vnoir
          sta  $d021     
          pla          
          plp
          ;jmp  (jumpback)
          jmp $ea31
          .bend
jumpback  .word $00
setmyint
          .block
intvect   =    $0314
          php
          pha
          lda  intvect
          sta  jumpback
          lda  intvect+1
          sta  jumpback+1
          sei  
          lda  #%01111111     ; switch off interrupt signals from CIA-1
          sta  $dc0d
          and  $d011          ; clear most significant bit of VIC's raster register
          sta  $d011
          lda  $dc0d          ; acknowledge pending interrupts from CIA-1
          lda  $dd0d          ; acknowledge pending interrupts from CIA-2
          lda  #rastlino      ; set rasterline where interrupt shall occur
          sta  $d012
          lda  #<myint        ; set interrupt vectors, pointing to interrupt service routine below
          sta  intvect
          lda  #>myint
          sta  intvect+1
          lda  #%00000001     ; enable raster interrupt signals from VIC
          sta  $d01a
          cli
          pla
          plp
          rts
         .bend
