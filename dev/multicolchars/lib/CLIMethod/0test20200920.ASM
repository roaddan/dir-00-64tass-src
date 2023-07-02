*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

.include        "stdio.asm"
carcol          .byte   0
count           .byte   19

main            lda     #CBLEU
                sta     FRAMECOL
                lda     #CJAUNE
                sta     BACKGRND
                jsr     clears
                jsr     putchncxy
                .byte   163,40,CBLEU,0,1
                jsr     test_putchnxy
                jsr     putscxy
                .text   CBLANC,13,0,"bonjour daniel!",0
                jsr     putchnxy
                .text   32,40,0,23
                ;jsr     test_outword
                jsr     putscxy
                .text   CJAUNE,0,22,"load",34,"tst.prg",34,",8",0
                jsr     putscxy
                .text   CROUGE,0,23,"run",0
utime           jsr     clock
                jsr     gotoxy
                .byte   0,20
                ;jmp     utime
                rts

test_putch      jsr     gotoxy
                .byte   10,10
                jsr     putch
                .byte   'a'
                rts

test_putchnxy   ;jsr     fillchc
                ;.byte   102,CVERT
                ;jsr     putchncxy
                ;.byte   164,40,CGRISMOYEN,0,1
                ;jsr     putchncxy
                ;.byte   181,40,CBRUN,0,2
                jsr     putchncxy
                .byte   163,40,CROUGE,0,1
                rts
                
test_outbyte    jsr     outbyte
myword          .word   $5a
                rts

clock           jsr     RDTIM
                sty     heures
                stx     minutes
                sta     secondes
                jsr     gotoxy
                .byte   32,0
                jsr     outbyte
heures          .byte   0                  
                jsr     putch
                .byte   ":"  
                jsr     outbyte
minutes         .byte   0               
                jsr     putch
                .byte   ":"             
                jsr     outbyte
secondes        .byte   0               
                rts


test_outword    jsr     gotoxy
                .byte   0,10
                jsr     putch
                .byte   "$"
                jsr     outword
tst_word        .word   $0000
                inc     tst_word
                bne     test_outword   
                inc     tst_word+1
                bne     test_outword        
                rts                
                

test_floods     jsr     fillchc
char            .byte   34
col             .byte   0
                ;inc     char
                ;inc     col
                ;bne     test_floods
                rts

test_gotoxy     jsr     gotoxy                
                .byte   0,2
                rts

test_puts       jsr     puts
                .text   "load",34,"tst.prg",34,",8",0
                rts

test_putsxy     jsr     putscxy
                .text   CMAUVE,13,0,"bonjour daniel!",0
                jsr     putchnxy
                .text   32,40,0,24
                jsr     putscxy
                .text   CVERT,0,24,"load",34,"tst.prg",34,",8",0
                jsr     gotoxy
                .byte   0,22
                rts

