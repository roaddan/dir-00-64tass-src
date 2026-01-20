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
msg   .byte $0d,$0d,29,29,29,29,29,29  
      .text "one moment! loading "
fname .null "romc000"
