;---------------------------------------------------------------------
; Rempli la page mémoire Y avec le code de A
;---------------------------------------------------------------------
blkfill        .block
bf0            jsr  push
               jsr  savezp1
               sty  zpage1+1
               ;jsr  showregs
               ldy  #$00
               sty  zpage1
bf1            sta  (zpage1),y
               iny
               bne  bf1
               jsr  restzp1
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
; Rempli les pages de Y à Y+X avec le code de A
;---------------------------------------------------------------------
memfill        .block
               jsr  push
mf1            jsr  blkfill
;               jsr  showregs
               iny
               dex
               bne  mf1
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
;    
;---------------------------------------------------------------------
memmove        .block
               jsr  push
               tsx            ; On se crée un pointeur ...
               txa
               clc
               adc  #11            
               tay            
               ldx  #$06
nextbyte       lda  $0100,y
               sta  words,y
               iny
               dex
               bne  nextbyte
               lda  s
               sta  source+1
               lda  s+1
               sta  source+2
               lda  d
               sta  destin+1
               lda  d+1
               sta  destin+2
destin         lda  $ffff
source         sta  $ffff
               inc  destin+1
               bne  src
               inc  destin+2
src            inc  source+1
               bne  cnt
               inc  source+2
cnt            lda  compte
               bne  decit
               lda  compte+1
               beq  fini
               dec  compte+1
decit          dec  compte
               ;jsr  showregs 
               jmp  destin             
fini           jsr  pop
               rts
words
s         .word     $0000
d         .word     $0000
compte    .word     $0000
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
decword        .block
               jsr  push
               stx  zpage2
               sty  zpage2+1

               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
inczp1         .block
               php
               pha
               inc  zpage1
               lda  zpage1
               bne  nopage
               inc  zpage1+1
nopage         pla
               plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
deczp1          .block
                php
                pha
                dec  zpage1
                bne  nopage
                dec  zpage1+1     
nopage          pla
                plp         
                rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
inczp2         .block
               php
               pha
               inc  zpage2
               lda  zpage2
               bne  nopage
               inc  zpage2+1
nopage         pla        
               plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
deczp2         .block
               php
               dec  zpage2
               bne  nopage
               dec  zpage2+1
nopage         plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
savezp1        .block
               php
               pha
               lda  zpage1
               sta  zp1
               lda  zpage1+1
               sta  zp1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
restzp1        .block
               php
               pha
               lda zp1
               sta zpage1
               lda zp1+1
               sta zpage1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
savezp2
         .block
         php
         pha
         lda zpage2
         sta zp2
         lda zpage2+1
         sta zp2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
restzp2
                .block
                php
                pha
                lda  zp2
                sta  zpage2
                lda  zp2+1
                sta  zpage2+1
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Calcule 16bits de :
;              addr2 = addr1 + x + (y * ymult)  
;---------------------------------------------------------------------
xy2addr    .block
                php
                pha
                txa
                pha
                tya
                pha
                lda     addr1+1
                sta     addr2+1
                lda     addr1     
                sta     addr2
                cpy     #$00
                beq     addx
moreline        clc
                adc     ymult
                bcc     norepy
                inc     addr2+1     
norepy          sta     addr2
                dey
                bne     moreline
addx            txa
                clc
                adc     addr2
                bcc     thatsit
                inc     addr2+1
thatsit         sta     addr2
                pla
                tay
                pla
                tax
                pla
                plp
                rts
                .bend

;*******************************************************************************
; Faire une fonction de boucle qui reçois un compte et l'adresse d'une routine 
; en paramètre.
;*******************************************************************************

;-------------------------------------------------------------------------------
; Une forme de for-next sur 16 bits.
; Placez le nombre nombre dans loopcount à l'aide de la macro setloop avant 
; d'appeler la fonction. 
; La loop fonction retournera le flag z a 1 si le décompte est terminé.
;-------------------------------------------------------------------------------
loop           .block
               dec  loopcount
               bne  norep
               dec  loopcount+1 
norep          lda  loopcount
               cmp  #$00
               bne  out
               eor  loopcount+1
               cmp  #$ff
out            rts
               .bend



;-------------------------------------------------------------------------------
; Variables globales
;-------------------------------------------------------------------------------
ymult          .byte     40                
addr1          .word     $0000    
addr2          .word     $0000
bytecnt        .word     $0000       
zp1            .word   $0000
zp2            .word   $0000
loopcount      .word     $0000


