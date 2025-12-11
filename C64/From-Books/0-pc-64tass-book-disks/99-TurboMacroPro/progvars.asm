;---------------------------------------
; fichier......: progvars.asm (seq)
; type fichier.: code
; auteur.......: daniel lafrance
; version......: 0.0.1
; revision.....: 20151126
;---------------------------------------
row      .byte $00
col      .byte $00
lin      .byte $00
sbit     .byte $55
adrs     .word $00
counter  .byte $00
baseaddr .word $2000 ;8192
scrwidth .word $0140 ;320
;---------------------------------------
dmphead .byte $20,18,5
        .text "ADRES"
        .byte 159
        .text " 00 01 02 03"
        .text " 04 05 06 07 "
        .byte 153
        .text "petsciis"
        .byte 146,$0d,0
menu    .byte $0d
        .text ""
        .byte $0d
        .byte $0d
        .byte $0d
        .byte $0d
        .byte $00