;---------------------------------------
; fichier......: ramprobe.asm (seq)
; type fichier.: code pour T.M.P.
; auteur.......: Daniel Lafrance
; version......: 0.0.1
; revision.....: 20151220
;---------------------------------------
;---------------------------------------
ramprobe
        .block
        jsr pushregs
        jsr clrkbbuf
        #styxptr dumpadr
        #outcar 147
        jsr showmenu
        jmp runit
ava128  clc
        lda dumpadr
        adc #$80
        bcc nrep128
        inc dumpadr+1   
nrep128 sta dumpadr
        jmp runit
arr128  sec
        lda dumpadr
        sbc #$80
        bcs nemp128
        dec dumpadr+1   
nemp128 sta dumpadr
        jmp runit
ava256  inc dumpadr+1   
        jmp runit
arr256  dec dumpadr+1   
        jmp runit
ava512  inc dumpadr+1
        jmp runit
arr512  dec dumpadr+1
        jmp runit
arr1k   lda dumpadr+1
        sec
        sbc #$10
        sta dumpadr+1
        jmp runit
ava1k   lda dumpadr+1
        clc
        adc #$10
        sta dumpadr+1
        jmp runit
runit   #locate 1,1
        lda #16
        #ldyxptr dumpadr
        jsr memdump
morekey jsr getkey
        ;jsr showkey
chkf1   cmp #133   ; touche [F1]
        bne chkf2
        jsr aide 
        jmp runit
        jmp morekey; +128     
chkf2   cmp #137   ; touche [F2]
        bne chkf3 
        ldy #$00
        ldx #$00
        #styxptr dumpadr
        jmp runit
        jmp morekey;-128
chkf3   cmp #134   ; touche [F3]
        bne chkf4
        jmp ava128 ;+128
chkf4   cmp #138   ; touche [F4]
        bne chkf5
        jmp arr128 ;-128
chkf5   cmp #135   ; touche [F6]
        bne chkf6
        jmp ava512  ;+512 
chkf6   cmp #139   ; touche [F6]
        bne chkf7
        jmp arr512 ;-512
chkf7   cmp #136   ; touche [F7]
        bne chkf8
        jmp ava1k  ;+1024
chkf8   cmp #140   ; touche [F8]
        bne chk20
        jmp arr1k  ;-1024
chk20   cmp #$20   ; touche espace
        bne chkn
        jmp runit    
chkn    cmp #71    ; touche G
        bne chkq
        jsr getadr ; demande adresse
        jsr runit
chkq    cmp #$5f   ; touche [<-]
        beq quitter
        jmp morekey
quitter jsr popregs
        #outcar 147
        #locate 0,0
        rts
        .bend 
;---------------------------------------