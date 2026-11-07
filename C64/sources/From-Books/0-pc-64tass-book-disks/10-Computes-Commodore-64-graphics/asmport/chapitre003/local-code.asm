random8        .block
               php
nosame         jsr   $e0d3
               lda   #$ff
               eor   $8a
               eor   $8c
               eor   $8d
               eor   $8e
               ;eor   $8e
               ;eor   $8d
               ;eor   $8c
               ;bit   tmpb
               ;bmi   checkv
               ;eor   #$ff
               ;jmp   out
checkv         ;bvs   out
               ;and   #$7f
               ;cmp   tmpb
               ;beq   nosame
out            ;sta   tmpb
               plp
               rts

tmpb           .byte 0
               .bend

stat           .block
               php
               and   #$0f
cmp0           cmp   #$00
               bne   cmp1
               #incadr16 nbr0
               #printcxy nbr0str
               #printwordbin nbr0
               jmp   out
cmp1           cmp   #$01
               bne   cmp2
               #incadr16 nbr1
               #printcxy nbr1str
               #printwordbin nbr1
               jmp   out
cmp2           cmp   #$02
               bne   cmp3
               #incadr16 nbr2
               #printcxy nbr2str
               #printwordbin nbr2
               jmp   out
cmp3           cmp   #$03
               bne   cmp4
               #incadr16 nbr3
               #printcxy nbr3str
               #printwordbin nbr3
               jmp   out
cmp4           cmp   #$04
               bne   cmp5
               #incadr16 nbr4
               #printcxy nbr4str
               #printwordbin nbr4
               jmp   out
cmp5           cmp   #$05
               bne   cmp6
               #incadr16 nbr5
               #printcxy nbr5str
               #printwordbin nbr5
               jmp   out
cmp6           cmp   #$06
               bne   cmp7
               #incadr16 nbr6
               #printcxy nbr6str
               #printwordbin nbr6
               jmp   out
cmp7           cmp   #$07
               bne   cmp8
               #incadr16 nbr7
               #printcxy nbr7str
               #printwordbin nbr7
               jmp   out
cmp8           cmp   #$08
               bne   cmp9
               #incadr16 nbr8
               #printcxy nbr8str
               #printwordbin nbr8
               jmp   out
cmp9           cmp   #$09
               bne   cmpa
               #incadr16 nbr9
               #printcxy nbr9str
               #printwordbin nbr9
               jmp   out
cmpa           cmp   #$0a
               bne   cmpb
               #incadr16 nbra
               #printcxy nbrastr
               #printwordbin nbra
               jmp   out
cmpb           cmp   #$0b
               bne   cmpc
               #incadr16 nbrb
               #printcxy nbrbstr
               #printwordbin nbrb
               jmp   out
cmpc           cmp   #$0c
               bne   cmpd
               #incadr16 nbrc
               #printcxy nbrcstr
               #printwordbin nbrc
               jmp   out
cmpd           cmp   #$0d
               bne   cmpe
               #incadr16 nbrd
               #printcxy nbrdstr
               #printwordbin nbrd
               jmp   out
cmpe           cmp   #$0e
               bne   cmpf
               #incadr16 nbre
               #printcxy nbrestr
               #printwordbin nbre
               jmp   out
cmpf           cmp   #$0f
               bne   out
               #incadr16 nbrf
               #printcxy nbrfstr
               #printwordbin nbrf
out            plp
               rts
               .bend