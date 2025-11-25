*=$c000        
A0             .byte     0,0,0,0,0,0,0,0
               .byte     0,0,0,0,0,0,0,0           
               .byte     0,0,0,0,0,0,0,0           
               .byte     0,0,0,0,0,0,0,0           
               .byte     0,0,0,0,0,0,0,0           
c028           jsr  $0079
               jsr  $aefd
               jsr  $ad8a
               jsr  $b1bf
               ldx  $64
               ldy  $65
               rts
A3             jsr  c028               
               sty  $3f
               sty  $14
               stx  $40
               stx  $15
               jsr  $a613
               lda  $5f
               sec
               sbc  #$01
               sta  $41
               lda  $60
               sbc  #$00
               sta  $42
               rts
A1             lda  #$08               
               ora  $d018
               sta  $d018
               lda  #$20
               ora  $d011
               sta  $d011
               rts
A2             lda  #$f7               
               and  $d018
               sta  $d018
               lda  #$df
               and  $d011
               sta  $d011
               rts
A4             lda  #$08               
               ldy  #$01
               sta  ($2b),y
               jsr  $a533
               lda  $22
               sta  $2d
               sta  $2f
               sta  $31
               lda  $23
               sta  $2e
               sta  $30
               sta  $32
               rts
A5             jsr  $0079               
               jsr  $aefd
               lda  #$00
               sta  $0a
               jsr  $e1d4
               lda  $2b
c0a0           pha
               lda  $2c
               pha
c0a4           sec
               lda  $2d
               sbc  #$02
               sta  $2b
               lda  $2e
               sbc  #$00
               sta  $2c
               lda  #$00
               sta  $b9
               ldx  $2b
               ldy  $2c
               jsr  $ffd5
               bcs  c0cc
               stx  $2d
               sty  $2e
               jsr  $a533
               pla
               sta  $2c
               pla
               sta  $2b
               rts
c0cc           tax
               cmp  #$04
               bne  c0d6
               ldy  $ba
               dey
               beq  c0a4
c0d6           pla               
               sta  $2c               
               pla
               sta  $2b
               clc
               jmp  ($0300)
               cpx  #$02
               bcs  c0eb
               cpx  #$01
               bcs  c0e9
               rts
c0e9           cpy  #$40               
c0eb           rts
c0ec           sec    
               txa    
               bne  c0f3       
               tya
               cmp  #$c8
c0f3           rts    
c0f4           adc  #$00                    
               sta  $2e                    
               sta  $30
               sta  $32
               rts

*=$c100               
               lda  $c008               





               
*=$c7a0
H1             lda  $dc0e
               and  #$fe
               sta  $dc0e
               lda  $01
               and  #$fb
               sta  $01
               ldy  #$00
               sty  $fd
               sty  $fb
               lda  #$11 
               sta  $fe  ;$1100 Destination
               lda  #$d1
               sta  $fc  ;$d100 Source
               jsr  c7d7
               inc  $Fe
               lda  #$d0
               sta  $fc
               jsr  c7d7
               lda  $01
               ora  #$04
               sta  $01
               lda  $140e
               ora  #$01
               sta  $dc0e
               rts
c7d7           lda  ($fb),y    
               sta  ($fd),y
               iny
               bne  c7d7
               rts
h2             jsr  $c028               
               jsr  $c0e0                    
               bcc  c7ea
c7e7           jmp  $c1ea
c7ea           tya               
               and  #$f8
               sta  $c008
               stx  $c009
               jsr  $c028
               jsr  $c0ec
               bcs  c7e7
               tya
               and  #$f8
               sta  $c00c
               stx  $c00d
               jsr  $0079
               jsr  $aefd
               jsr  $ad9e
               jsr  $b6a3
               jsr  $c602
               lda  #$00
               sta  $c601
               sta  $fc
               jsr  $c100
c81d           lda  $fe
               cmp  #$40
               bcc  c82a
               lda  $fd
               cmp  #$40
               bcc  c82a
               rts
c82a           ldy  $c602               
               bne  c830
               rts
c830           dey                
               sty  $c602 
               ldy  $c601
               lda  ($22),y
               iny
               sty  $c601
               asl
               rol  $fc
               asl
               rol  $fc
               asl
               rol  $fc
               sta  $fb
               lda  $fc
               adc  #$10
               sta  $fc
               ldy  #$07
c850           lda  ($fb),y
               sta  ($fd),y
               dey
               bpl  c850
               clc
               lda  $fd
               adc  #$08
               sta  $fd
               lda  $fe
               adc  #$00
               sta  $fe
               lda  #$00
               sta  $fc
               jmp  c81d
               