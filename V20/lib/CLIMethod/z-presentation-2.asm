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

main            jsr     fillchc
                .byte   'a',1
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
                
test_outbyte    jsr     putchncxy
byteloc         .byte   '$',1,1,0, 0
                jsr     outbyte
myword          .byte   $00
                inc     myword
                bne     test_outbyte
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
char            .byte   0
col             .byte   15
                inc     char
                bne     test_floods
                dec     col
                bpl     test_floods
                rts

test_gotoxy     jsr     gotoxy                
                .byte   0,2
                rts

test_puts       jsr     puts
                .text   "load",34,"tst.prg",34,",8,1",0
                rts

test_putsxy     jsr     putscxy
                .text   CMAUVE,13,0,"bonjour daniel!",0
                jsr     putchnxy
                .text   32,40,0,24
                jsr     putscxy
                .text   CVERT,0,24,"load",34,"file",34,",8,1",0
                jsr     gotoxy
                .byte   0,22
                rts

