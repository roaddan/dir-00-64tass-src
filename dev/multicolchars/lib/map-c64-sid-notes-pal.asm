; ----------------------------------------------------------------------------
; SID note frequency calculated for a PAL system with a 985248 Hz Christal.
; ----------------------------------------------------------------------------
; Values are limited to the humain audible frequencies (20hx to 20000hz) and 
; to the maximum frequency register value of the sid II ($ffff : 65535)
;
; doN=C, dodN=C#, reN=D, redN=D#, miN=E ,faN=F, 
; fadN=F#, solN=G, soldN=G#, laN=A ,ladN=A#, siN=B
; 
; Where N is the octave number from 0 to 7
; ----------------------------------------------------------------------------
silence     = $0000 ; Silence (no frequency)
; ----------------------------------------------------------------------------
; Octave 0
; ----------------------------------------------------------------------------
do0   = $0116 ;   16,35Hz PAL (hex): hi: $01, lo: $16 ; (dec): lo: 22, Hi:  1
dod0  = $0127 ;   17,33Hz PAL (hex): hi: $01, lo: $27 ; (dec): lo: 39, Hi:  1
re0   = $0139 ;   18,35Hz PAL (hex): hi: $01, lo: $39 ; (dec): lo: 57, Hi:  1
red0  = $014B ;   19,45Hz PAL (hex): hi: $01, lo: $4B ; (dec): lo: 75, Hi:  1
mi0   = $015F ;   20,60Hz PAL (hex): hi: $01, lo: $5F ; (dec): lo: 95, Hi:  1
fa0   = $0174 ;   21,83Hz PAL (hex): hi: $01, lo: $74 ; (dec): lo:116, Hi:  1
fad0  = $018A ;   23,13Hz PAL (hex): hi: $01, lo: $8A ; (dec): lo:138, Hi:  1
sol0  = $01A1 ;   24,50Hz PAL (hex): hi: $01, lo: $A1 ; (dec): lo:161, Hi:  1
sold0 = $01BA ;   25,96Hz PAL (hex): hi: $01, lo: $BA ; (dec): lo:186, Hi:  1
la0   = $01D4 ;   27,50Hz PAL (hex): hi: $01, lo: $D4 ; (dec): lo:212, Hi:  1
lad0  = $01F0 ;   29,14Hz PAL (hex): hi: $01, lo: $F0 ; (dec): lo:240, Hi:  1
si0   = $020E ;   30,87Hz PAL (hex): hi: $02, lo: $0E ; (dec): lo: 14, Hi:  2
; ----------------------------------------------------------------------------
; Octave 1
; ----------------------------------------------------------------------------
do1   = $022D ;   32,71Hz PAL (hex): hi: $02, lo: $2D ; (dec): lo: 45, Hi:  2
dod1  = $024E ;   34,65Hz PAL (hex): hi: $02, lo: $4E ; (dec): lo: 78, Hi:  2
re1   = $0271 ;   36,71Hz PAL (hex): hi: $02, lo: $71 ; (dec): lo:113, Hi:  2
red1  = $0296 ;   38,89Hz PAL (hex): hi: $02, lo: $96 ; (dec): lo:150, Hi:  2
mi1   = $02BE ;   41,21Hz PAL (hex): hi: $02, lo: $BE ; (dec): lo:190, Hi:  2
fa1   = $02E7 ;   43,66Hz PAL (hex): hi: $02, lo: $E7 ; (dec): lo:231, Hi:  2
fad1  = $0314 ;   46,25Hz PAL (hex): hi: $03, lo: $14 ; (dec): lo: 20, Hi:  3
sol1  = $0342 ;   49,00Hz PAL (hex): hi: $03, lo: $42 ; (dec): lo: 66, Hi:  3
sold1 = $0374 ;   51,91Hz PAL (hex): hi: $03, lo: $74 ; (dec): lo:116, Hi:  3
la1   = $03A9 ;   55,00Hz PAL (hex): hi: $03, lo: $A9 ; (dec): lo:169, Hi:  3
lad1  = $03E0 ;   58,28Hz PAL (hex): hi: $03, lo: $E0 ; (dec): lo:224, Hi:  3
si1   = $041B ;   61,74Hz PAL (hex): hi: $04, lo: $1B ; (dec): lo: 27, Hi:  4
; ----------------------------------------------------------------------------
; Octave 2
; ----------------------------------------------------------------------------
do2   = $045A ;   65,41Hz PAL (hex): hi: $04, lo: $5A ; (dec): lo: 90, Hi:  4
dod2  = $049C ;   69,30Hz PAL (hex): hi: $04, lo: $9C ; (dec): lo:156, Hi:  4
re2   = $04E2 ;   73,41Hz PAL (hex): hi: $04, lo: $E2 ; (dec): lo:226, Hi:  4
red2  = $052D ;   77,79Hz PAL (hex): hi: $05, lo: $2D ; (dec): lo: 45, Hi:  5
mi2   = $057B ;   82,41Hz PAL (hex): hi: $05, lo: $7B ; (dec): lo:123, Hi:  5
fa2   = $05CF ;   87,31Hz PAL (hex): hi: $05, lo: $CF ; (dec): lo:207, Hi:  5
fad2  = $0627 ;   92,50Hz PAL (hex): hi: $06, lo: $27 ; (dec): lo: 39, Hi:  6
sol2  = $0685 ;   98,00Hz PAL (hex): hi: $06, lo: $85 ; (dec): lo:133, Hi:  6
sold2 = $06E8 ;  103,83Hz PAL (hex): hi: $06, lo: $E8 ; (dec): lo:232, Hi:  6
la2   = $0751 ;  110,00Hz PAL (hex): hi: $07, lo: $51 ; (dec): lo: 81, Hi:  7
lad2  = $07C1 ;  116,55Hz PAL (hex): hi: $07, lo: $C1 ; (dec): lo:193, Hi:  7
si2   = $0837 ;  123,48Hz PAL (hex): hi: $08, lo: $37 ; (dec): lo: 55, Hi:  8
; ----------------------------------------------------------------------------
; Octave 3
; ----------------------------------------------------------------------------
do3   = $08B4 ;  130,83Hz PAL (hex): hi: $08, lo: $B4 ; (dec): lo:180, Hi:  8
dod3  = $0938 ;  138,60Hz PAL (hex): hi: $09, lo: $38 ; (dec): lo: 56, Hi:  9
re3   = $09C4 ;  146,83Hz PAL (hex): hi: $09, lo: $C4 ; (dec): lo:196, Hi:  9
red3  = $0A59 ;  155,58Hz PAL (hex): hi: $0A, lo: $59 ; (dec): lo: 89, Hi: 10
mi3   = $0AF7 ;  164,83Hz PAL (hex): hi: $0A, lo: $F7 ; (dec): lo:247, Hi: 10
fa3   = $0B9E ;  174,63Hz PAL (hex): hi: $0B, lo: $9E ; (dec): lo:158, Hi: 11
fad3  = $0C4E ;  185,00Hz PAL (hex): hi: $0C, lo: $4E ; (dec): lo: 78, Hi: 12
sol3  = $0D0A ;  196,00Hz PAL (hex): hi: $0D, lo: $0A ; (dec): lo: 10, Hi: 13
sold3 = $0DD0 ;  207,65Hz PAL (hex): hi: $0D, lo: $D0 ; (dec): lo:208, Hi: 13
la3   = $0EA2 ;  220,00Hz PAL (hex): hi: $0E, lo: $A2 ; (dec): lo:162, Hi: 14
lad3  = $0F81 ;  233,10Hz PAL (hex): hi: $0F, lo: $81 ; (dec): lo:129, Hi: 15
si3   = $106D ;  246,95Hz PAL (hex): hi: $10, lo: $6D ; (dec): lo:109, Hi: 16
; ----------------------------------------------------------------------------
; Octave 4
; ----------------------------------------------------------------------------
do4   = $1167 ;  261,65Hz PAL (hex): hi: $11, lo: $67 ; (dec): lo:103, Hi: 17
dod4  = $1270 ;  277,20Hz PAL (hex): hi: $12, lo: $70 ; (dec): lo:112, Hi: 18
re4   = $1388 ;  293,65Hz PAL (hex): hi: $13, lo: $88 ; (dec): lo:136, Hi: 19
red4  = $14B2 ;  311,15Hz PAL (hex): hi: $14, lo: $B2 ; (dec): lo:178, Hi: 20
mi4   = $15ED ;  329,65Hz PAL (hex): hi: $15, lo: $ED ; (dec): lo:237, Hi: 21
fa4   = $173B ;  349,25Hz PAL (hex): hi: $17, lo: $3B ; (dec): lo: 59, Hi: 23
fad4  = $189D ;  370,00Hz PAL (hex): hi: $18, lo: $9D ; (dec): lo:157, Hi: 24
sol4  = $1A13 ;  392,00Hz PAL (hex): hi: $1A, lo: $13 ; (dec): lo: 19, Hi: 26
sold4 = $1BA0 ;  415,30Hz PAL (hex): hi: $1B, lo: $A0 ; (dec): lo:160, Hi: 27
la4   = $1D45 ;  440,00Hz PAL (hex): hi: $1D, lo: $45 ; (dec): lo: 69, Hi: 29
lad4  = $1F03 ;  466,20Hz PAL (hex): hi: $1F, lo: $03 ; (dec): lo:  3, Hi: 31
si4   = $20DA ;  493,90Hz PAL (hex): hi: $20, lo: $DA ; (dec): lo:218, Hi: 32
; ----------------------------------------------------------------------------
; Octave 5
; ----------------------------------------------------------------------------
do5   = $22CF ;  523,30Hz PAL (hex): hi: $22, lo: $CF ; (dec): lo:207, Hi: 34
dod5  = $24E1 ;  554,40Hz PAL (hex): hi: $24, lo: $E1 ; (dec): lo:225, Hi: 36
re5   = $2711 ;  587,30Hz PAL (hex): hi: $27, lo: $11 ; (dec): lo: 17, Hi: 39
red5  = $2965 ;  622,30Hz PAL (hex): hi: $29, lo: $65 ; (dec): lo:101, Hi: 41
mi5   = $2BDB ;  659,30Hz PAL (hex): hi: $2B, lo: $DB ; (dec): lo:219, Hi: 43
fa5   = $2E76 ;  698,50Hz PAL (hex): hi: $2E, lo: $76 ; (dec): lo:118, Hi: 46
fad5  = $3139 ;  740,00Hz PAL (hex): hi: $31, lo: $39 ; (dec): lo: 57, Hi: 49
sol5  = $3426 ;  784,00Hz PAL (hex): hi: $34, lo: $26 ; (dec): lo: 38, Hi: 52
sold5 = $3740 ;  830,60Hz PAL (hex): hi: $37, lo: $40 ; (dec): lo: 64, Hi: 55
la5   = $3A89 ;  880,00Hz PAL (hex): hi: $3A, lo: $89 ; (dec): lo:137, Hi: 58
lad5  = $3E05 ;  932,40Hz PAL (hex): hi: $3E, lo: $05 ; (dec): lo:  5, Hi: 62
si5   = $41B5 ;  987,80Hz PAL (hex): hi: $41, lo: $B5 ; (dec): lo:181, Hi: 65
; ----------------------------------------------------------------------------
; Octave 6
; ----------------------------------------------------------------------------
do6   = $459E ; 1046,60Hz PAL (hex): hi: $45, lo: $9E ; (dec): lo:158, Hi: 69
dod6  = $49C1 ; 1108,80Hz PAL (hex): hi: $49, lo: $C1 ; (dec): lo:193, Hi: 73
re6   = $4E22 ; 1174,60Hz PAL (hex): hi: $4E, lo: $22 ; (dec): lo: 34, Hi: 78
red6  = $52CA ; 1244,60Hz PAL (hex): hi: $52, lo: $CA ; (dec): lo:202, Hi: 82
mi6   = $57B6 ; 1318,60Hz PAL (hex): hi: $57, lo: $B6 ; (dec): lo:182, Hi: 87
fa6   = $5CED ; 1397,00Hz PAL (hex): hi: $5C, lo: $ED ; (dec): lo:237, Hi: 92
fad6  = $6272 ; 1480,00Hz PAL (hex): hi: $62, lo: $72 ; (dec): lo:114, Hi: 98
sol6  = $684D ; 1568,00Hz PAL (hex): hi: $68, lo: $4D ; (dec): lo: 77, Hi:104
sold6 = $6E80 ; 1661,20Hz PAL (hex): hi: $6E, lo: $80 ; (dec): lo:128, Hi:110
la6   = $7512 ; 1760,00Hz PAL (hex): hi: $75, lo: $12 ; (dec): lo: 18, Hi:117
lad6  = $7C0B ; 1864,80Hz PAL (hex): hi: $7C, lo: $0B ; (dec): lo: 11, Hi:124
si6   = $8369 ; 1975,60Hz PAL (hex): hi: $83, lo: $69 ; (dec): lo:105, Hi:131
; ----------------------------------------------------------------------------
; Octave 7
; ----------------------------------------------------------------------------
do7   = $8B3C ; 2093,20Hz PAL (hex): hi: $8B, lo: $3C ; (dec): lo: 60, Hi:139
dod7  = $9382 ; 2217,60Hz PAL (hex): hi: $93, lo: $82 ; (dec): lo:130, Hi:147
re7   = $9C43 ; 2349,20Hz PAL (hex): hi: $9C, lo: $43 ; (dec): lo: 67, Hi:156
red7  = $A593 ; 2489,20Hz PAL (hex): hi: $A5, lo: $93 ; (dec): lo:147, Hi:165
mi7   = $AF6B ; 2637,20Hz PAL (hex): hi: $AF, lo: $6B ; (dec): lo:107, Hi:175
fa7   = $B9D9 ; 2794,00Hz PAL (hex): hi: $B9, lo: $D9 ; (dec): lo:217, Hi:185
fad7  = $C4E4 ; 2960,00Hz PAL (hex): hi: $C4, lo: $E4 ; (dec): lo:228, Hi:196
sol7  = $D099 ; 3136,00Hz PAL (hex): hi: $D0, lo: $99 ; (dec): lo:153, Hi:208
sold7 = $DCFF ; 3322,40Hz PAL (hex): hi: $DC, lo: $FF ; (dec): lo:255, Hi:220
la7   = $EA24 ; 3520,00Hz PAL (hex): hi: $EA, lo: $24 ; (dec): lo: 36, Hi:234
lad7  = $F815 ; 3729,60Hz PAL (hex): hi: $F8, lo: $15 ; (dec): lo: 21, Hi:248

;FreqTablePalLo: ; 256 bytes
;     ;offset    0   1   2   3   4   5   6   7   8   9   a   b   c   e   d   f
;     ;          C   C#  D   D#  E   F   F#  G   G#  A   A#  B   C   D   E   F
;     .byte     $17,$27,$39,$4b,$5f,$74,$8a,$a1,$ba,$d4,$f0,$0e,$00,$00,$00,$00  ; 1
;     .byte     $2d,$4e,$71,$96,$be,$e8,$14,$43,$74,$a9,$e1,$1c,$00,$00,$00,$00  ; 2
;     .byte     $5a,$9c,$e2,$2d,$7c,$cf,$28,$85,$e8,$52,$c1,$37,$00,$00,$00,$00  ; 3
;     .byte     $b4,$39,$c5,$5a,$f7,$9e,$4f,$0a,$d1,$a3,$82,$6e,$00,$00,$00,$00  ; 4
;     .byte     $68,$71,$8a,$b3,$ee,$3c,$9e,$15,$a2,$46,$04,$dc,$00,$00,$00,$00  ; 5
;     .byte     $d0,$e2,$14,$67,$dd,$79,$3c,$29,$44,$8d,$08,$b8,$00,$00,$00,$00  ; 6
;     .byte     $a1,$c5,$28,$cd,$ba,$f1,$78,$53,$87,$1a,$10,$71,$00,$00,$00,$00  ; 7
;     .byte     $42,$89,$4f,$9b,$74,$e2,$f0,$a6,$0e,$33,$20,$ff,$00,$00,$00,$00  ; 8
;
;FreqTablePalHi: ; 256 bytes
;     ;          C   C#  D   D#  E   F   F#  G   G#  A   A#  B
;     .byte     $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$00,$00,$00,$00  ; 1
;     .byte     $02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$04,$00,$00,$00,$00  ; 2
;     .byte     $04,$04,$04,$05,$05,$05,$06,$06,$06,$07,$07,$08,$00,$00,$00,$00  ; 3
;     .byte     $08,$09,$09,$0a,$0a,$0b,$0c,$0d,$0d,$0e,$0f,$10,$00,$00,$00,$00  ; 4
;     .byte     $11,$12,$13,$14,$15,$17,$18,$1a,$1b,$1d,$1f,$20,$00,$00,$00,$00  ; 5
;     .byte     $22,$24,$27,$29,$2b,$2e,$31,$34,$37,$3a,$3e,$41,$00,$00,$00,$00  ; 6
;     .byte     $45,$49,$4e,$52,$57,$5c,$62,$68,$6e,$75,$7c,$83,$00,$00,$00,$00  ; 7
;     .byte     $8b,$93,$9c,$a5,$af,$b9,$c4,$d0,$dd,$ea,$f8,$ff,$00,$00,$00,$00  ; 8
