;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: Hard Copy
; Book Page.: 50
;---------;---------;---------;---------;---------;---------;---------;---------
; Make a hardcopy of program in memory
;---------;---------;---------;---------;---------;---------;---------;---------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
                .include "c64_map.asm"
main            jsr   hardcopy  
                rts  
                                ;kfunctions     |axy, Input        
*=0300                          ;               |AXY, Outout
hardcopy        .block
                lda     #$04
                sta     $ba     ; $04 -> FA -> Current device number.
                lda     #$7e
                sta     $b8     ; $7e -> LA -> Current logical file number.
                lda     #$00    ; 
                ldy     #$04
                sta     $71     ; $0400 -> FBUFPT -> File buffer pointer address
                sty     $72     ;        
                sta     $b7     ; $00 -> FNLEN -> Length of current filename.
                sta     $b9     ; $00 -> SA -> Secondary address
                jsr     kopen   ; kopen          |axy, ouvre fich-nom
                ldx     #$b8
                jsr     kchkout ; kchout        |--x, open canal out
                ldx     #$19
f014a           lda     #$0d
                jsr     kchrout ; ($f1ca) Output a character
                jsr     kstop   ; ($f6ed) Check the stop key
                beq     itisover
                ldy     #$00
f0156           lda     ($71),y
                sta     $67
                and     #$3f
                asl     $67
                bit     $67
                bpl     f0164
                ora     #$80
f0164           bvs     f0168
                ora     #$40
f0168           jsr     kchrout   ; ($f1ca) Output a character
                iny
                cpy     #$28
                bne     f0156
                tya
                clc
                adc     $71
                sta     $71
                bcc     f017a
                inc     $72
f017a           dex
                bne     f014a
                lda     #$0d
                jsr     kchrout   ; ($f1ca) Output a character                
itisover        jsr     kclrchn   ; ($f333) Clear Channel
                ldx     #$7e
                jmp     kclose   ; ($f291) Close all Logical files
                rts
                .bend