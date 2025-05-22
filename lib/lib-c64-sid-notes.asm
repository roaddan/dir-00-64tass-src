;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
;Note           high, low
lad1    .word $00F8 ; NTSC (hex): high: $00, low: $F8 ; (dec): low:248, High:0
si1     .word $0106 ; NTSC (hex): high: $01, low: $06 ; (dec): low:6, High:1
do1     .word $0116 ; NTSC (hex): high: $01, low: $16 ; (dec): low:22, High:1
dod1    .word $0127 ; NTSC (hex): high: $01, low: $27 ; (dec): low:39, High:1
re1     .word $0138 ; NTSC (hex): high: $01, low: $38 ; (dec): low:56, High:1
red1    .word $014B ; NTSC (hex): high: $01, low: $4B ; (dec): low:75, High:1
mi1     .word $015E ; NTSC (hex): high: $01, low: $5E ; (dec): low:94, High:1
fa1     .word $0173 ; NTSC (hex): high: $01, low: $73 ; (dec): low:115, High:1
fad1    .word $0189 ; NTSC (hex): high: $01, low: $89 ; (dec): low:137, High:1
sol1    .word $01A1 ; NTSC (hex): high: $01, low: $A1 ; (dec): low:161, High:1
sold1   .word $01B9 ; NTSC (hex): high: $01, low: $B9 ; (dec): low:185, High:1
la2     .word $01D4 ; NTSC (hex): high: $01, low: $D4 ; (dec): low:212, High:1
lad2    .word $01F0 ; NTSC (hex): high: $01, low: $F0 ; (dec): low:240, High:1
si2     .word $020D ; NTSC (hex): high: $02, low: $0D ; (dec): low:13, High:2
do2     .word $022C ; NTSC (hex): high: $02, low: $2C ; (dec): low:44, High:2
dod2    .word $024E ; NTSC (hex): high: $02, low: $4E ; (dec): low:78, High:2
re2     .word $0271 ; NTSC (hex): high: $02, low: $71 ; (dec): low:113, High:2
red2    .word $0296 ; NTSC (hex): high: $02, low: $96 ; (dec): low:150, High:2
mi2     .word $02BD ; NTSC (hex): high: $02, low: $BD ; (dec): low:189, High:2
fa2     .word $02E7 ; NTSC (hex): high: $02, low: $E7 ; (dec): low:231, High:2
fad2    .word $0313 ; NTSC (hex): high: $03, low: $13 ; (dec): low:19, High:3
sol2    .word $0342 ; NTSC (hex): high: $03, low: $42 ; (dec): low:66, High:3
sold2   .word $0373 ; NTSC (hex): high: $03, low: $73 ; (dec): low:115, High:3
la3     .word $03A8 ; NTSC (hex): high: $03, low: $A8 ; (dec): low:168, High:3
lad3    .word $03E0 ; NTSC (hex): high: $03, low: $E0 ; (dec): low:224, High:3
si3     .word $041B ; NTSC (hex): high: $04, low: $1B ; (dec): low:27, High:4
do3     .word $0459 ; NTSC (hex): high: $04, low: $59 ; (dec): low:89, High:4
dod3    .word $049C ; NTSC (hex): high: $04, low: $9C ; (dec): low:156, High:4
re3     .word $04E2 ; NTSC (hex): high: $04, low: $E2 ; (dec): low:226, High:4
red3    .word $052C ; NTSC (hex): high: $05, low: $2C ; (dec): low:44, High:5
mi3     .word $057B ; NTSC (hex): high: $05, low: $7B ; (dec): low:123, High:5
fa3     .word $05CE ; NTSC (hex): high: $05, low: $CE ; (dec): low:206, High:5
fad3    .word $0627 ; NTSC (hex): high: $06, low: $27 ; (dec): low:39, High:6
sol3    .word $0684 ; NTSC (hex): high: $06, low: $84 ; (dec): low:132, High:6
sold3   .word $06E7 ; NTSC (hex): high: $06, low: $E7 ; (dec): low:231, High:6
la4     .word $0751 ; NTSC (hex): high: $07, low: $51 ; (dec): low:81, High:7
lad4    .word $07C0 ; NTSC (hex): high: $07, low: $C0 ; (dec): low:192, High:7
si4     .word $0836 ; NTSC (hex): high: $08, low: $36 ; (dec): low:54, High:8
do4     .word $08B3 ; NTSC (hex): high: $08, low: $B3 ; (dec): low:179, High:8
dod4    .word $0938 ; NTSC (hex): high: $09, low: $38 ; (dec): low:56, High:9
re4     .word $09C4 ; NTSC (hex): high: $09, low: $C4 ; (dec): low:196, High:9
red4    .word $0A59 ; NTSC (hex): high: $0A, low: $59 ; (dec): low:89, High:10
mi4     .word $0AF6 ; NTSC (hex): high: $0A, low: $F6 ; (dec): low:246, High:10
fa4     .word $0B9D ; NTSC (hex): high: $0B, low: $9D ; (dec): low:157, High:11
fad4    .word $0C4E ; NTSC (hex): high: $0C, low: $4E ; (dec): low:78, High:12
sol4    .word $0D09 ; NTSC (hex): high: $0D, low: $09 ; (dec): low:9, High:13
sold4   .word $0DCF ; NTSC (hex): high: $0D, low: $CF ; (dec): low:207, High:13
la5     .word $0EA2 ; NTSC (hex): high: $0E, low: $A2 ; (dec): low:162, High:14
lad5    .word $0F81 ; NTSC (hex): high: $0F, low: $81 ; (dec): low:129, High:15
si5     .word $106D ; NTSC (hex): high: $10, low: $6D ; (dec): low:109, High:16
do5     .word $1167 ; NTSC (hex): high: $11, low: $67 ; (dec): low:103, High:17
dod5    .word $1270 ; NTSC (hex): high: $12, low: $70 ; (dec): low:112, High:18
re5     .word $1388 ; NTSC (hex): high: $13, low: $88 ; (dec): low:136, High:19
red5    .word $14B2 ; NTSC (hex): high: $14, low: $B2 ; (dec): low:178, High:20
mi5     .word $15ED ; NTSC (hex): high: $15, low: $ED ; (dec): low:237, High:21
fa5     .word $173B ; NTSC (hex): high: $17, low: $3B ; (dec): low:59, High:23
fad5    .word $189C ; NTSC (hex): high: $18, low: $9C ; (dec): low:156, High:24
sol5    .word $1A13 ; NTSC (hex): high: $1A, low: $13 ; (dec): low:19, High:26
sold5   .word $1B9F ; NTSC (hex): high: $1B, low: $9F ; (dec): low:159, High:27
la6     .word $1D44 ; NTSC (hex): high: $1D, low: $44 ; (dec): low:68, High:29
lad6    .word $1F02 ; NTSC (hex): high: $1F, low: $02 ; (dec): low:2, High:31
si6     .word $20DA ; NTSC (hex): high: $20, low: $DA ; (dec): low:218, High:32
do6     .word $22CE ; NTSC (hex): high: $22, low: $CE ; (dec): low:206, High:34
dod6    .word $24E0 ; NTSC (hex): high: $24, low: $E0 ; (dec): low:224, High:36
re6     .word $2710 ; NTSC (hex): high: $27, low: $10 ; (dec): low:16, High:39
red6    .word $2964 ; NTSC (hex): high: $29, low: $64 ; (dec): low:100, High:41
mi6     .word $2BDA ; NTSC (hex): high: $2B, low: $DA ; (dec): low:218, High:43
fa6     .word $2E76 ; NTSC (hex): high: $2E, low: $76 ; (dec): low:118, High:46
fad6    .word $3139 ; NTSC (hex): high: $31, low: $39 ; (dec): low:57, High:49
sol6    .word $3426 ; NTSC (hex): high: $34, low: $26 ; (dec): low:38, High:52
sold6   .word $373F ; NTSC (hex): high: $37, low: $3F ; (dec): low:63, High:55
la7     .word $3A89 ; NTSC (hex): high: $3A, low: $89 ; (dec): low:137, High:58
lad7    .word $3E05 ; NTSC (hex): high: $3E, low: $05 ; (dec): low:5, High:62
si7     .word $41B4 ; NTSC (hex): high: $41, low: $B4 ; (dec): low:180, High:65
do7     .word $459D ; NTSC (hex): high: $45, low: $9D ; (dec): low:157, High:69
dod7    .word $49C1 ; NTSC (hex): high: $49, low: $C1 ; (dec): low:193, High:73
re7     .word $4E21 ; NTSC (hex): high: $4E, low: $21 ; (dec): low:33, High:78
red7    .word $52C9 ; NTSC (hex): high: $52, low: $C9 ; (dec): low:201, High:82
mi7     .word $57B5 ; NTSC (hex): high: $57, low: $B5 ; (dec): low:181, High:87
fa7     .word $5CEC ; NTSC (hex): high: $5C, low: $EC ; (dec): low:236, High:92
fad7    .word $6272 ; NTSC (hex): high: $62, low: $72 ; (dec): low:114, High:98
sol7    .word $684C ; NTSC (hex): high: $68, low: $4C ; (dec): low:76, High:104
sold7   .word $6E7F ; NTSC (hex): high: $6E, low: $7F ; (dec): low:127, High:110
la8     .word $7512 ; NTSC (hex): high: $75, low: $12 ; (dec): low:18, High:117
lad8    .word $7C0A ; NTSC (hex): high: $7C, low: $0A ; (dec): low:10, High:124
si8     .word $8369 ; NTSC (hex): high: $83, low: $69 ; (dec): low:105, High:131
do8     .word $8B3B ; NTSC (hex): high: $8B, low: $3B ; (dec): low:59, High:139
dod8    .word $9382 ; NTSC (hex): high: $93, low: $82 ; (dec): low:130, High:147
re8     .word $9C43 ; NTSC (hex): high: $9C, low: $43 ; (dec): low:67, High:156
red8    .word $A593 ; NTSC (hex): high: $A5, low: $93 ; (dec): low:147, High:165
mi8     .word $AF6B ; NTSC (hex): high: $AF, low: $6B ; (dec): low:107, High:175
fa8     .word $B9D9 ; NTSC (hex): high: $B9, low: $D9 ; (dec): low:217, High:185
fad8    .word $C4E4 ; NTSC (hex): high: $C4, low: $E4 ; (dec): low:228, High:196
sol8    .word $D099 ; NTSC (hex): high: $D0, low: $99 ; (dec): low:153, High:208
sold8   .word $DCFF ; NTSC (hex): high: $DC, low: $FF ; (dec): low:255, High:220
la9     .word $EA24 ; NTSC (hex): high: $EA, low: $24 ; (dec): low:36, High:234
lad9    .word $F815 ; NTSC (hex): high: $F8, low: $15 ; (dec): low:21, High:248
si9     .word $06D2 ; NTSC (hex): high: $06, low: $D2 ; (dec): low:210, High:262
do9     .word $1677 ; NTSC (hex): high: $16, low: $77 ; (dec): low:119, High:278
dod9    .word $2704 ; NTSC (hex): high: $27, low: $04 ; (dec): low:4, High:295
re9     .word $3886 ; NTSC (hex): high: $38, low: $86 ; (dec): low:134, High:312
red9    .word $4B26 ; NTSC (hex): high: $4B, low: $26 ; (dec): low:38, High:331
mi9     .word $5ED6 ; NTSC (hex): high: $5E, low: $D6 ; (dec): low:214, High:350
fa9     .word $73B2 ; NTSC (hex): high: $73, low: $B2 ; (dec): low:178, High:371
fad9    .word $89C8 ; NTSC (hex): high: $89, low: $C8 ; (dec): low:200, High:393
sol9    .word $A132 ; NTSC (hex): high: $A1, low: $32 ; (dec): low:50, High:417
sold9   .word $B9FE ; NTSC (hex): high: $B9, low: $FE ; (dec): low:254, High:441
FreqTableNtscLo:
                    ;  C   C#  D   D#  E   F   F#  G   G#  A   A#  B
                .byte $0c,$1c,$2d,$3f,$52,$66,$7b,$92,$aa,$c3,$de,$fa  ; 1
                .byte $18,$38,$5a,$7e,$a4,$cc,$f7,$24,$54,$86,$bc,$f5  ; 2
                .byte $31,$71,$b5,$fc,$48,$98,$ee,$48,$a9,$0d,$79,$ea  ; 3
                .byte $62,$e2,$6a,$f8,$90,$30,$dc,$90,$52,$1a,$f2,$d4  ; 4
                .byte $c4,$c4,$d4,$f0,$20,$60,$b8,$20,$a4,$34,$e4,$a8  ; 5
                .byte $88,$88,$a8,$e0,$40,$c0,$70,$40,$48,$68,$c8,$50  ; 6
                .byte $10,$10,$50,$c0,$80,$80,$e0,$80,$90,$d0,$90,$a0  ; 7
                .byte $20,$20,$a0,$80,$00,$00,$c0,$00,$20,$a0,$20,$40  ; 8
     
FreqTableNtscHi:
		          ;  C   C#  D   D#  E   F   F#  G   G#  A   A#  B
                .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01  ; 1
                .byte $02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03  ; 2
                .byte $04,$04,$04,$04,$05,$05,$05,$06,$06,$07,$07,$07  ; 3
                .byte $08,$08,$09,$09,$0a,$0b,$0b,$0c,$0d,$0e,$0e,$0f  ; 4
                .byte $10,$11,$12,$13,$15,$16,$17,$19,$1a,$1c,$1d,$1f  ; 5
                .byte $21,$23,$25,$27,$2a,$2c,$2f,$32,$35,$38,$3b,$3f  ; 6
                .byte $43,$47,$4b,$4f,$54,$59,$5e,$64,$6a,$70,$77,$7e  ; 7
                .byte $86,$8e,$96,$9f,$a9,$b3,$bd,$c9,$d5,$e1,$ef,$fd  ; 8