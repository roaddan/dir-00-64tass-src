;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0

.include        "stdio.asm"
carcol          .byte   0
count           .byte   19

main            
    jsr flodder            
    rts
                
    jsr clears
    jsr test_putchnxy
    jsr putscxy
    .text   CJAUNE,13,0,"bonjour daniel!",0
    jsr putchnxy
    .text   32,40,0,23
    ;jsr     test_outword
main1           
    jsr clock
    jmp main1
    jsr putscxy
    .text   CVERT,0,21,"load",34,"tst01.prg",34,",8,1",0
    rts

flodder                
fagain          lda     colr1
                sta     FRAMECOL
                jsr     fillchc
car1            .byte   0                
colr1           .byte   15                
                inc     car1                
                bne     fagain
                dec     colr1
                bpl     fagain
                jsr     clears
                rts
                
utime           jsr     clock
                jsr     gotoxy
                .byte   0,21
                jmp     utime
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
                .byte   163,40,CGRISMOYEN,0,1
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

