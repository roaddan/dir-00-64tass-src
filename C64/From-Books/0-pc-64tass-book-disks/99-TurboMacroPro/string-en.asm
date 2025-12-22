;---------------------------------------
; fichier......: stringfr.asm (seq)
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
        .text "addre"
        .byte 159
        .text " 00 01 02 03"
        .text " 04 05 06 07 "
        .byte 153
        .text "petsciis"
        .byte 146,eot
dmphead2 .byte 18,5
        .text "     "
        .byte 159
        .text " 08 09 0A 0B"
        .text " 0C 0D 0E 0F "
        .byte 153
        .text "        "
        .byte 146,eot
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
        .byte eot
menu1   .byte 1,19
        .byte kjaune,221,kblanc
        .text " [F1] About      "
        .byte kjaune,182,kblanc
        .text " [F2] Goto $0000  "
        .byte kjaune,221,kblanc
        .byte eot       
menu2   .byte 1,20
        .byte kjaune,221,kblanc
        .text " [F3] +128 bytes "
        .byte kjaune,182,kblanc
        .text " [F4] -128 bytes  "
        .byte kjaune,221,kblanc
        .byte eot       
menu3   .byte 1,21
        .byte kjaune,221,kblanc
        .text " [F5] +512 bytes "
        .byte kjaune,182,kblanc 
        .text " [F6] -512 bytes  "
        .byte kjaune,221,kblanc
        .byte eot       
menu4   .byte 1,22
        .byte kjaune,221,kblanc
        .text " [F7] +4K bytes  "
        .byte kjaune,182,kblanc
        .text " [F8] -4K bytes   "
        .byte kjaune,221,kblanc
        .byte eot       
menu5   .byte 1,23
        .byte kjaune,221,kblanc
        .text " [G] goto addr ? "
        .byte kjaune,182,kblanc
        .text " ["
        .byte 95
        .text "]  Quit        "
        .byte kjaune,221,kblanc
        .byte eot       
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
        .byte eot
;---------------------------------------
boxax   = 7
boxay   = 7
boxaw   = 26
boxah   = 4
boxac   = svertp
boxa    .byte boxax,boxay
        .byte boxaw,boxah
        .byte boxac
        .null "[Address]"
boxat1  .byte boxax+2,boxay+1
        .null "Enter an hexadecimal "
boxat2  .byte boxax+2,boxay+2
        .null "adresse : $"
;---------------------------------------
boxhx   = 1
boxhy   = 0
boxhw   = 38
boxhh   = 25
boxhc   = srose
boxh    .byte boxhx,boxhy
        .byte boxhw,boxhh
        .byte sgris2
        .null "[About]"
boxht1  .byte boxhx+1,boxhy+2
        .text "[F1]"
        .text " = Show this page."
        .byte eot
boxht2  .byte boxhx+1,boxhy+3
        .text "[F2]"
        .text " = Bring's back to"
        .text " $0000."
        .byte eot
boxht3  .byte boxhx+1,boxhy+4
        .text "[F3]/[F4]"
        .text " = +/- 128 bytes."
        .byte eot
boxht4  .byte boxhx+1,boxhy+5
        .text "[F4]/[F5]"
        .text " = +/- 512 bytes."
        .byte eot
boxht5  .byte boxhx+1,boxhy+6
        .text "[F6]/[F7]"
        .text " = +/- 4096 bytes."
        .byte eot
boxht6  .byte boxhx+1,boxhy+7
        .text "[G] Show a delected "
        .byte eot
boxht7  .byte boxhx+4,boxhy+8
        .text " address. The chosen"
        .text " address will"
        .byte eot
boxht8  .byte boxhx+4,boxhy+9
        .text " be rounded to $xxx0 "
        .text "or $xxx8"

        .byte eot
boxht9  .byte boxhx+4,boxhy+10
        .text " to be shown on the"
        .text " first two "
        .byte eot
boxht10 .byte boxhx+4,boxhy+11
        .text " lines of the "
        .text "interface."
        .byte eot
boxht11 .byte boxhx+1,boxhy+12
        .text "["
        .byte 95
        .text "] = Back to "
        .text "Basic."
        .byte eot




boxht0  .byte boxhx+1,boxhy+13
        .text "=================="
        .text "=================="
        .byte eot
boxhta  .byte boxhx+1,boxhy+14
        .text "This program cons"
        .text "titus the first "
        .byte eot
boxhtb  .byte boxhx+1,boxhy+15
        .text " section of a proj"
        .text "et whoms goal is "
        .byte eot
boxhtc  .byte boxhx+1,boxhy+16
        .text " the creation of a "
        .text "assembly language"
        .byte eot
boxhtd  .byte boxhx+1,boxhy+17
        .text " monitor for the com"
        .text "modore 64."
        .byte eot
boxhte  .byte boxhx+1,boxhy+19
        .text " The next step is"
        .text "to create a"
        .byte eot
boxhtf  .byte boxhx+1,boxhy+20
        .text " dissassembling"
        .text " tool also for the"
        .byte eot
boxhtg  .byte boxhx+1,boxhy+21
        .text " commodore 64"
        .text " (6510/6502)."
        .byte eot
boxhth  .byte boxhx+20,boxhy+23
        .text "Any key to exit."
        .byte eot
boxhti  .byte boxhx+2,boxhy+24
        .byte 18
        .text " Daniel Lafrance"
        .text " - december 2025. "
        .byte 146, eot

;---------------------------------------
printboxt  .macro  ptr,col
        ldx \ptr
        ldy \ptr+1
        jsr gotoxy
        lda \col    ;verification
        #ldyximm \ptr+2
        jsr putscyx
           .endm     