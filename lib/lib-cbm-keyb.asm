waitstop        .block
                jsr     push
wait            jsr     k_stop
                bne     wait
                jsr     pop
                rts
                .bend

anykey          .block
                php
                pha
nokey           lda 203
                cmp #64
                beq nokey
                jsr releasekey
                pla
                plp
                rts
                .bend

releasekey      .block
                php
                pha 
keypressed      lda 203
                cmp #64
                bne keypressed
                pla
                plp
                rts
                .bend


getkey          .block
again           jsr     chrin
                bne     again
                rts
                .bend

waitkey         .block
                jsr     push
                sta     thekey                
nope            jsr     getin
                jsr     chrout
                cmp     thekey
                bne     nope
                jsr     chrout
                jsr     pop
                rts
thekey          .byte   0
                .bend

waitspace       .block
                jsr     push
wait            lda     #$7f  ;%01111111 
                sta     $dc00 
                lda     $dc01 
                and     #$10  ;mask %00010000 
                bne     wait
                jsr     pop
                .bend

waitsstop       .block
                jsr     push
wait            jsr     k_stop  ;%01111111 
                bne     wait
                jsr     pop
                .bend

waitreturn      .block
                jsr     push
                lda     thecount
                sta     scrnram
                lda     #$02     
                sta     colorram
nope            jsr     getin
                jsr     chrout
                cmp     #$0d
                bne     nope
                inc     thecount
                jsr     pop
                rts
thecount        .byte   $01
                .bend