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
dmphead .byte 18,5
        .text "adres"
        .byte 159
        .text " 00 01 02 03"
        .text " 04 05 06 07 "
        .byte 153
        .text "petsciis"
        .byte 146,0
dmphead2 .byte 18,5
        .text "     "
        .byte 159
        .text " 08 09 0A 0B"
        .text " 0C 0D 0E 0F "
        .byte 153
        .text "        "
        .byte 146,0
menu0   .byte 1,18
        .byte kjaune,176
        .byte 192,192,192
        .byte 192,192,192,192,192,192
        .byte 192,192,192,192,192,192
        .byte 18
        .text " MENU "
        .byte 146
        .byte 192,192,192,192,192,192
        .byte 192,192,192,192,192,192
        .byte 192,192,192
        .byte 174
        .byte 0
menu1   .byte 1,19
        .byte kjaune,221,kblanc
        .text " [F1] +128 octets"
        .byte kjaune,182,kblanc
        .text " [F2] -128 octets "
        .byte kjaune,221,kblanc
        .byte 0        
menu2   .byte 1,20
        .byte kjaune,221,kblanc
        .text " [F3] +256 octets"
        .byte kjaune,182,kblanc
        .text " [F4] -256 octets "
        .byte kjaune,221,kblanc
        .byte 0        
menu3   .byte 1,21
        .byte kjaune,221,kblanc
        .text " [F5] +512 octets"
        .byte kjaune,182,kblanc
        .text " [F6] -512 octets "
        .byte kjaune,221,kblanc
        .byte 0        
menu4   .byte 1,22
        .byte kjaune,221,kblanc
        .text " [F7]+4096 octets"
        .byte kjaune,182,kblanc
        .text " [F8]-4096 octets "
        .byte kjaune,221,kblanc
        .byte 0        
menu5   .byte 1,23
        .byte kjaune,221,kblanc
        .text " [N] entrer adre."
        .byte kjaune,182,kblanc
        .text " [Q] Quitter      "
        .byte kjaune,221,kblanc
        .byte 0        
menu6   .byte 1,24
        .byte kjaune,173
        .byte 192,192,192,192,192,192
        .byte 192,192,192,192,192,192
        .byte 192
        .byte 18
        .text " DLBUG-64 "
        .byte 146,192
        .byte 192,192,192,192,192,192
        .byte 192,192,192,192,192,192
        .byte 189,kblanc
        .byte 0

;---------------------------------------
