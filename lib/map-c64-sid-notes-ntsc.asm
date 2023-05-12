; ----------------------------------------------------------------------------
; SID note frequency calculated for a NTSC system with a 1022727 Hz Chrystal.
; ----------------------------------------------------------------------------
silence     = $0000 ; Silence (no frequency)
; ----------------------------------------------------------------------------
; Octave 0
; ----------------------------------------------------------------------------
la0     = $00E1 ; NTSC (hex): high: $00, low: $E1 ; (dec): low:225, High:  0
lad0    = $00EE ; NTSC (hex): high: $00, low: $EE ; (dec): low:238, High:  0
si0     = $00FD ; NTSC (hex): high: $00, low: $FD ; (dec): low:253, High:  0
; ----------------------------------------------------------------------------
; Octave 1
; ----------------------------------------------------------------------------
do1     = $010C ; NTSC (hex): high: $01, low: $0C ; (dec): low: 12, High:  1
dod1    = $011C ; NTSC (hex): high: $01, low: $1C ; (dec): low: 28, High:  1
re1     = $012D ; NTSC (hex): high: $01, low: $2D ; (dec): low: 45, High:  1
red1    = $013F ; NTSC (hex): high: $01, low: $3F ; (dec): low: 63, High:  1
mi1     = $0151 ; NTSC (hex): high: $01, low: $51 ; (dec): low: 81, High:  1
fa1     = $0166 ; NTSC (hex): high: $01, low: $66 ; (dec): low:102, High:  1
fad1    = $017B ; NTSC (hex): high: $01, low: $7B ; (dec): low:123, High:  1
sol1    = $0191 ; NTSC (hex): high: $01, low: $91 ; (dec): low:145, High:  1
sold1   = $01A9 ; NTSC (hex): high: $01, low: $A9 ; (dec): low:169, High:  1
la1     = $01C3 ; NTSC (hex): high: $01, low: $C3 ; (dec): low:195, High:  1
lad1    = $01DD ; NTSC (hex): high: $01, low: $DD ; (dec): low:221, High:  1
si1     = $01FA ; NTSC (hex): high: $01, low: $FA ; (dec): low:250, High:  1
; ----------------------------------------------------------------------------
; Octave 2
; ----------------------------------------------------------------------------
do2     = $0218 ; NTSC (hex): high: $02, low: $18 ; (dec): low: 24, High:  2
dod2    = $0238 ; NTSC (hex): high: $02, low: $38 ; (dec): low: 56, High:  2
re2     = $025A ; NTSC (hex): high: $02, low: $5A ; (dec): low: 90, High:  2
red2    = $027E ; NTSC (hex): high: $02, low: $7E ; (dec): low:126, High:  2
mi2     = $02A3 ; NTSC (hex): high: $02, low: $A3 ; (dec): low:163, High:  2
fa2     = $02CC ; NTSC (hex): high: $02, low: $CC ; (dec): low:204, High:  2
fad2    = $02F6 ; NTSC (hex): high: $02, low: $F6 ; (dec): low:246, High:  2
sol2    = $0323 ; NTSC (hex): high: $03, low: $23 ; (dec): low: 35, High:  3
sold2   = $0353 ; NTSC (hex): high: $03, low: $53 ; (dec): low: 83, High:  3
la2     = $0386 ; NTSC (hex): high: $03, low: $86 ; (dec): low:134, High:  3
lad2    = $03BB ; NTSC (hex): high: $03, low: $BB ; (dec): low:187, High:  3
si2     = $03F4 ; NTSC (hex): high: $03, low: $F4 ; (dec): low:244, High:  3
; ----------------------------------------------------------------------------
; Octave 3
; ----------------------------------------------------------------------------
do3     = $0431 ; NTSC (hex): high: $04, low: $31 ; (dec): low: 49, High:  4
dod3    = $0470 ; NTSC (hex): high: $04, low: $70 ; (dec): low:112, High:  4
re3     = $04B4 ; NTSC (hex): high: $04, low: $B4 ; (dec): low:180, High:  4
red3    = $04FC ; NTSC (hex): high: $04, low: $FC ; (dec): low:252, High:  4
mi3     = $0547 ; NTSC (hex): high: $05, low: $47 ; (dec): low: 71, High:  5
fa3     = $0598 ; NTSC (hex): high: $05, low: $98 ; (dec): low:152, High:  5
fad3    = $05ED ; NTSC (hex): high: $05, low: $ED ; (dec): low:237, High:  5
sol3    = $0647 ; NTSC (hex): high: $06, low: $47 ; (dec): low: 71, High:  6
sold3   = $06A7 ; NTSC (hex): high: $06, low: $A7 ; (dec): low:167, High:  6
la3     = $070C ; NTSC (hex): high: $07, low: $0C ; (dec): low: 12, High:  7
lad3    = $0777 ; NTSC (hex): high: $07, low: $77 ; (dec): low:119, High:  7
si3     = $07E9 ; NTSC (hex): high: $07, low: $E9 ; (dec): low:233, High:  7
; ----------------------------------------------------------------------------
; Octave 4
; ----------------------------------------------------------------------------
do4     = $0862 ; NTSC (hex): high: $08, low: $62 ; (dec): low: 98, High:  8
dod4    = $08E1 ; NTSC (hex): high: $08, low: $E1 ; (dec): low:225, High:  8
re4     = $0968 ; NTSC (hex): high: $09, low: $68 ; (dec): low:104, High:  9
red4    = $09F8 ; NTSC (hex): high: $09, low: $F8 ; (dec): low:248, High:  9
mi4     = $0A8F ; NTSC (hex): high: $0A, low: $8F ; (dec): low:143, High: 10
fa4     = $0B30 ; NTSC (hex): high: $0B, low: $30 ; (dec): low: 48, High: 11
fad4    = $0BDA ; NTSC (hex): high: $0B, low: $DA ; (dec): low:218, High: 11
sol4    = $0C8F ; NTSC (hex): high: $0C, low: $8F ; (dec): low:143, High: 12
sold4   = $0D4E ; NTSC (hex): high: $0D, low: $4E ; (dec): low: 78, High: 13
la4     = $0E18 ; NTSC (hex): high: $0E, low: $18 ; (dec): low: 24, High: 14
lad4    = $0EEF ; NTSC (hex): high: $0E, low: $EF ; (dec): low:239, High: 14
si4     = $0FD3 ; NTSC (hex): high: $0F, low: $D3 ; (dec): low:211, High: 15
; ----------------------------------------------------------------------------
; Octave 5
; ----------------------------------------------------------------------------
do5     = $10C4 ; NTSC (hex): high: $10, low: $C4 ; (dec): low:196, High: 16
dod5    = $11C3 ; NTSC (hex): high: $11, low: $C3 ; (dec): low:195, High: 17
re5     = $12D1 ; NTSC (hex): high: $12, low: $D1 ; (dec): low:209, High: 18
red5    = $13F0 ; NTSC (hex): high: $13, low: $F0 ; (dec): low:240, High: 19
mi5     = $151F ; NTSC (hex): high: $15, low: $1F ; (dec): low: 31, High: 21
fa5     = $1661 ; NTSC (hex): high: $16, low: $61 ; (dec): low: 97, High: 22
fad5    = $17B5 ; NTSC (hex): high: $17, low: $B5 ; (dec): low:181, High: 23
sol5    = $191E ; NTSC (hex): high: $19, low: $1E ; (dec): low: 30, High: 25
sold5   = $1A9C ; NTSC (hex): high: $1A, low: $9C ; (dec): low:156, High: 26
la5     = $1C31 ; NTSC (hex): high: $1C, low: $31 ; (dec): low: 49, High: 28
lad5    = $1DDF ; NTSC (hex): high: $1D, low: $DF ; (dec): low:223, High: 29
si5     = $1FA6 ; NTSC (hex): high: $1F, low: $A6 ; (dec): low:166, High: 31
; ----------------------------------------------------------------------------
; Octave 6
; ----------------------------------------------------------------------------
do6     = $2188 ; NTSC (hex): high: $21, low: $88 ; (dec): low:136, High: 33
dod6    = $2386 ; NTSC (hex): high: $23, low: $86 ; (dec): low:134, High: 35
re6     = $25A2 ; NTSC (hex): high: $25, low: $A2 ; (dec): low:162, High: 37
red6    = $27E0 ; NTSC (hex): high: $27, low: $E0 ; (dec): low:224, High: 39
mi6     = $2A3F ; NTSC (hex): high: $2A, low: $3F ; (dec): low: 63, High: 42
fa6     = $2CC2 ; NTSC (hex): high: $2C, low: $C2 ; (dec): low:194, High: 44
fad6    = $2F6B ; NTSC (hex): high: $2F, low: $6B ; (dec): low:107, High: 47
sol6    = $323D ; NTSC (hex): high: $32, low: $3D ; (dec): low: 61, High: 50
sold6   = $3539 ; NTSC (hex): high: $35, low: $39 ; (dec): low: 57, High: 53
la6     = $3863 ; NTSC (hex): high: $38, low: $63 ; (dec): low: 99, High: 56
lad6    = $3BBF ; NTSC (hex): high: $3B, low: $BF ; (dec): low:191, High: 59
si6     = $3F4C ; NTSC (hex): high: $3F, low: $4C ; (dec): low: 76, High: 63
; ----------------------------------------------------------------------------
; Octave 7
; ----------------------------------------------------------------------------
do7     = $4310 ; NTSC (hex): high: $43, low: $10 ; (dec): low: 16, High: 67
dod7    = $470D ; NTSC (hex): high: $47, low: $0D ; (dec): low: 13, High: 71
re7     = $4B44 ; NTSC (hex): high: $4B, low: $44 ; (dec): low: 68, High: 75
red7    = $4FC0 ; NTSC (hex): high: $4F, low: $C0 ; (dec): low:192, High: 79
mi7     = $547E ; NTSC (hex): high: $54, low: $7E ; (dec): low:126, High: 84
fa7     = $5984 ; NTSC (hex): high: $59, low: $84 ; (dec): low:132, High: 89
fad7    = $5ED6 ; NTSC (hex): high: $5E, low: $D6 ; (dec): low:214, High: 94
sol7    = $647A ; NTSC (hex): high: $64, low: $7A ; (dec): low:122, High:100
sold7   = $6A72 ; NTSC (hex): high: $6A, low: $72 ; (dec): low:114, High:106
la7     = $70C7 ; NTSC (hex): high: $70, low: $C7 ; (dec): low:199, High:112
lad7    = $777E ; NTSC (hex): high: $77, low: $7E ; (dec): low:126, High:119
si7     = $7E98 ; NTSC (hex): high: $7E, low: $98 ; (dec): low:152, High:126
; ----------------------------------------------------------------------------
; Octave 8
; ----------------------------------------------------------------------------
do8     = $8621 ; NTSC (hex): high: $86, low: $21 ; (dec): low: 33, High:134
dod8    = $8E1A ; NTSC (hex): high: $8E, low: $1A ; (dec): low: 26, High:142
re8     = $9689 ; NTSC (hex): high: $96, low: $89 ; (dec): low:137, High:150
red8    = $9F81 ; NTSC (hex): high: $9F, low: $81 ; (dec): low:129, High:159
mi8     = $A8FD ; NTSC (hex): high: $A8, low: $FD ; (dec): low:253, High:168
fa8     = $B309 ; NTSC (hex): high: $B3, low: $09 ; (dec): low:  9, High:179
fad8    = $BDAD ; NTSC (hex): high: $BD, low: $AD ; (dec): low:173, High:189
sol8    = $C8F4 ; NTSC (hex): high: $C8, low: $F4 ; (dec): low:244, High:200
sold8   = $D4E5 ; NTSC (hex): high: $D4, low: $E5 ; (dec): low:229, High:212
la8     = $E18F ; NTSC (hex): high: $E1, low: $8F ; (dec): low:143, High:225
lad8    = $EEFD ; NTSC (hex): high: $EE, low: $FD ; (dec): low:253, High:238
si8     = $FD31 ; NTSC (hex): high: $FD, low: $31 ; (dec): low: 49, High:253