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
        .text "adres"
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
        .text " [F1] A propos   "
        .byte kjaune,182,kblanc
        .text " [F2] aller $0000 "
        .byte kjaune,221,kblanc
        .byte eot       
menu2   .byte 1,20
        .byte kjaune,221,kblanc
        .text " [F3] +128 octets"
        .byte kjaune,182,kblanc
        .text " [F4] -128 octets "
        .byte kjaune,221,kblanc
        .byte eot       
menu3   .byte 1,21
        .byte kjaune,221,kblanc
        .text " [F5] +512 octets"
        .byte kjaune,182,kblanc
        .text " [F6] -512 octets "
        .byte kjaune,221,kblanc
        .byte eot       
menu4   .byte 1,22
        .byte kjaune,221,kblanc
        .text " [F7] +4K octets "
        .byte kjaune,182,kblanc
        .text " [F8] -4K octets  "
        .byte kjaune,221,kblanc
        .byte eot       
menu5   .byte 1,23
        .byte kjaune,221,kblanc
        .text "  [G] Aller a ?  "
        .byte kjaune,182,kblanc
        .text "  ["
        .byte 95
        .text "] Quitter     "
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
        .null "[Adresse]"
boxat1  .byte boxax+2,boxay+1
        .null "Entrez une adresse en"
boxat2  .byte boxax+2,boxay+2
        .null "hexadecimal : $"
;---------------------------------------
boxhx   = 1
boxhy   = 0
boxhw   = 38
boxhh   = 25
boxhc   = srose
boxh    .byte boxhx,boxhy
        .byte boxhw,boxhh
        .byte sgris2
        .null "[A propos]"
boxht1  .byte boxhx+1,boxhy+2
        .text "[F1]"
        .text " = Affiche cette page."
        .byte eot
boxht2  .byte boxhx+1,boxhy+3
        .text "[F2]"
        .text " = Ramene l'afficheur a"
        .text " $0000."
        .byte eot
boxht3  .byte boxhx+1,boxhy+4
        .text "[F3]/[F4]"
        .text " = +/- 128 octets"
        .byte eot
boxht4  .byte boxhx+1,boxhy+5
        .text "[F4]/[F5]"
        .text " = +/- 512 octets"
        .byte eot
boxht5  .byte boxhx+1,boxhy+6
        .text "[F6]/[F7]"
        .text " = +/- 4096 octets"
        .byte eot
boxht6  .byte boxhx+1,boxhy+7
        .text "[G] Permet d'entrer une "
        .text "adresse "
        .byte eot
boxht7  .byte boxhx+4,boxhy+8
        .text " a afficher. L'adresse"
        .text " choisie"
        .byte eot
boxht8  .byte boxhx+4,boxhy+9
        .text " sera tronquee a $xxx0 "
        .text "ou $xxx8"

        .byte eot
boxht9  .byte boxhx+4,boxhy+10
        .text " de facon a ce que"
        .text " l'adresse"
        .byte eot
boxht10 .byte boxhx+4,boxhy+11
        .text " soit sur les 2 premi"
        .text "eres lignes."
        .byte eot
boxht11 .byte boxhx+1,boxhy+12
        .text "["
        .byte 95
        .text "] = retour a "
        .text "Basic."
        .byte eot




boxht0  .byte boxhx+1,boxhy+13
        .text "=================="
        .text "=================="
        .byte eot
boxhta  .byte boxhx+1,boxhy+14
        .text " Ce programme cons"
        .text "titue la premiere"
        .byte eot
boxhtb  .byte boxhx+1,boxhy+15
        .text " section d'un proj"
        .text "et qui a pour but "
        .byte eot
boxhtc  .byte boxhx+1,boxhy+16
        .text " la creation d'un "
        .text "moniteur assem-"
        .byte eot
boxhtd  .byte boxhx+1,boxhy+17
        .text " bleur pour le com"
        .text "modore 64."
        .byte eot
boxhte  .byte boxhx+1,boxhy+19
        .text " La prochaine eta"
        .text "pe sera de creer"
        .byte eot
boxhtf  .byte boxhx+1,boxhy+20
        .text " un outil de"
        .text " desassemblage aussi"
        .byte eot
boxhtg  .byte boxhx+1,boxhy+21
        .text " pour le com"
        .text "modore 64 (6510/6502)."
        .byte eot
boxhth  .byte boxhx+15,boxhy+23
        .text "Une clef pour sortir."
        .byte eot
boxhti  .byte boxhx+2,boxhy+24
        .byte 18
        .text " Daniel Lafrance"
        .text " - decembre 2025. "
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