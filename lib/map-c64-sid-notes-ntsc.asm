; ----------------------------------------------------------------------------
; SID note frequency calculated for a NTSC system with a 1022727 Hz Chrystal.
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
do0   = $010C ;   16,35Hz NTSC (hex): hi: $01, lo: $0C ; (dec): lo: 12, Hi:  1
dod0  = $011C ;   17,33Hz NTSC (hex): hi: $01, lo: $1C ; (dec): lo: 28, Hi:  1
re0   = $012D ;   18,35Hz NTSC (hex): hi: $01, lo: $2D ; (dec): lo: 45, Hi:  1
red0  = $013F ;   19,45Hz NTSC (hex): hi: $01, lo: $3F ; (dec): lo: 63, Hi:  1
mi0   = $0152 ;   20,60Hz NTSC (hex): hi: $01, lo: $52 ; (dec): lo: 82, Hi:  1
fa0   = $0166 ;   21,83Hz NTSC (hex): hi: $01, lo: $66 ; (dec): lo:102, Hi:  1
fad0  = $017B ;   23,13Hz NTSC (hex): hi: $01, lo: $7B ; (dec): lo:123, Hi:  1
sol0  = $0192 ;   24,50Hz NTSC (hex): hi: $01, lo: $92 ; (dec): lo:146, Hi:  1
sold0 = $01AA ;   25,96Hz NTSC (hex): hi: $01, lo: $AA ; (dec): lo:170, Hi:  1
la0   = $01C3 ;   27,50Hz NTSC (hex): hi: $01, lo: $C3 ; (dec): lo:195, Hi:  1
lad0  = $01DE ;   29,14Hz NTSC (hex): hi: $01, lo: $DE ; (dec): lo:222, Hi:  1
si0   = $01FA ;   30,87Hz NTSC (hex): hi: $01, lo: $FA ; (dec): lo:250, Hi:  1
; ----------------------------------------------------------------------------
; Octave 1
; ----------------------------------------------------------------------------
do1   = $0219 ;   32,71Hz NTSC (hex): hi: $02, lo: $19 ; (dec): lo: 25, Hi:  2
dod1  = $0238 ;   34,65Hz NTSC (hex): hi: $02, lo: $38 ; (dec): lo: 56, Hi:  2
re1   = $025A ;   36,71Hz NTSC (hex): hi: $02, lo: $5A ; (dec): lo: 90, Hi:  2
red1  = $027E ;   38,89Hz NTSC (hex): hi: $02, lo: $7E ; (dec): lo:126, Hi:  2
mi1   = $02A4 ;   41,21Hz NTSC (hex): hi: $02, lo: $A4 ; (dec): lo:164, Hi:  2
fa1   = $02CC ;   43,66Hz NTSC (hex): hi: $02, lo: $CC ; (dec): lo:204, Hi:  2
fad1  = $02F7 ;   46,25Hz NTSC (hex): hi: $02, lo: $F7 ; (dec): lo:247, Hi:  2
sol1  = $0324 ;   49,00Hz NTSC (hex): hi: $03, lo: $24 ; (dec): lo: 36, Hi:  3
sold1 = $0354 ;   51,91Hz NTSC (hex): hi: $03, lo: $54 ; (dec): lo: 84, Hi:  3
la1   = $0386 ;   55,00Hz NTSC (hex): hi: $03, lo: $86 ; (dec): lo:134, Hi:  3
lad1  = $03BC ;   58,28Hz NTSC (hex): hi: $03, lo: $BC ; (dec): lo:188, Hi:  3
si1   = $03F5 ;   61,74Hz NTSC (hex): hi: $03, lo: $F5 ; (dec): lo:245, Hi:  3
; ----------------------------------------------------------------------------
; Octave 2
; ----------------------------------------------------------------------------
do2   = $0431 ;   65,41Hz NTSC (hex): hi: $04, lo: $31 ; (dec): lo: 49, Hi:  4
dod2  = $0471 ;   69,30Hz NTSC (hex): hi: $04, lo: $71 ; (dec): lo:113, Hi:  4
re2   = $04B4 ;   73,41Hz NTSC (hex): hi: $04, lo: $B4 ; (dec): lo:180, Hi:  4
red2  = $04FC ;   77,79Hz NTSC (hex): hi: $04, lo: $FC ; (dec): lo:252, Hi:  4
mi2   = $0548 ;   82,41Hz NTSC (hex): hi: $05, lo: $48 ; (dec): lo: 72, Hi:  5
fa2   = $0598 ;   87,31Hz NTSC (hex): hi: $05, lo: $98 ; (dec): lo:152, Hi:  5
fad2  = $05ED ;   92,50Hz NTSC (hex): hi: $05, lo: $ED ; (dec): lo:237, Hi:  5
sol2  = $0648 ;   98,00Hz NTSC (hex): hi: $06, lo: $48 ; (dec): lo: 72, Hi:  6
sold2 = $06A7 ;  103,83Hz NTSC (hex): hi: $06, lo: $A7 ; (dec): lo:167, Hi:  6
la2   = $070C ;  110,00Hz NTSC (hex): hi: $07, lo: $0C ; (dec): lo: 12, Hi:  7
lad2  = $0778 ;  116,55Hz NTSC (hex): hi: $07, lo: $78 ; (dec): lo:120, Hi:  7
si2   = $07EA ;  123,48Hz NTSC (hex): hi: $07, lo: $EA ; (dec): lo:234, Hi:  7
; ----------------------------------------------------------------------------
; Octave 3
; ----------------------------------------------------------------------------
do3   = $0862 ;  130,83Hz NTSC (hex): hi: $08, lo: $62 ; (dec): lo: 98, Hi:  8
dod3  = $08E2 ;  138,60Hz NTSC (hex): hi: $08, lo: $E2 ; (dec): lo:226, Hi:  8
re3   = $0969 ;  146,83Hz NTSC (hex): hi: $09, lo: $69 ; (dec): lo:105, Hi:  9
red3  = $09F8 ;  155,58Hz NTSC (hex): hi: $09, lo: $F8 ; (dec): lo:248, Hi:  9
mi3   = $0A90 ;  164,83Hz NTSC (hex): hi: $0A, lo: $90 ; (dec): lo:144, Hi: 10
fa3   = $0B31 ;  174,63Hz NTSC (hex): hi: $0B, lo: $31 ; (dec): lo: 49, Hi: 11
fad3  = $0BDB ;  185,00Hz NTSC (hex): hi: $0B, lo: $DB ; (dec): lo:219, Hi: 11
sol3  = $0C8F ;  196,00Hz NTSC (hex): hi: $0C, lo: $8F ; (dec): lo:143, Hi: 12
sold3 = $0D4E ;  207,65Hz NTSC (hex): hi: $0D, lo: $4E ; (dec): lo: 78, Hi: 13
la3   = $0E19 ;  220,00Hz NTSC (hex): hi: $0E, lo: $19 ; (dec): lo: 25, Hi: 14
lad3  = $0EF0 ;  233,10Hz NTSC (hex): hi: $0E, lo: $F0 ; (dec): lo:240, Hi: 14
si3   = $0FD3 ;  246,95Hz NTSC (hex): hi: $0F, lo: $D3 ; (dec): lo:211, Hi: 15
; ----------------------------------------------------------------------------
; Octave 4
; ----------------------------------------------------------------------------
do4   = $10C4 ;  261,65Hz NTSC (hex): hi: $10, lo: $C4 ; (dec): lo:196, Hi: 16
dod4  = $11C3 ;  277,20Hz NTSC (hex): hi: $11, lo: $C3 ; (dec): lo:195, Hi: 17
re4   = $12D1 ;  293,65Hz NTSC (hex): hi: $12, lo: $D1 ; (dec): lo:209, Hi: 18
red4  = $13F0 ;  311,15Hz NTSC (hex): hi: $13, lo: $F0 ; (dec): lo:240, Hi: 19
mi4   = $1520 ;  329,65Hz NTSC (hex): hi: $15, lo: $20 ; (dec): lo: 32, Hi: 21
fa4   = $1661 ;  349,25Hz NTSC (hex): hi: $16, lo: $61 ; (dec): lo: 97, Hi: 22
fad4  = $17B6 ;  370,00Hz NTSC (hex): hi: $17, lo: $B6 ; (dec): lo:182, Hi: 23
sol4  = $191F ;  392,00Hz NTSC (hex): hi: $19, lo: $1F ; (dec): lo: 31, Hi: 25
sold4 = $1A9D ;  415,30Hz NTSC (hex): hi: $1A, lo: $9D ; (dec): lo:157, Hi: 26
la4   = $1C32 ;  440,00Hz NTSC (hex): hi: $1C, lo: $32 ; (dec): lo: 50, Hi: 28
lad4  = $1DE0 ;  466,20Hz NTSC (hex): hi: $1D, lo: $E0 ; (dec): lo:224, Hi: 29
si4   = $1FA6 ;  493,90Hz NTSC (hex): hi: $1F, lo: $A6 ; (dec): lo:166, Hi: 31
; ----------------------------------------------------------------------------
; Octave 5
; ----------------------------------------------------------------------------
do5   = $2188 ;  523,30Hz NTSC (hex): hi: $21, lo: $88 ; (dec): lo:136, Hi: 33
dod5  = $2387 ;  554,40Hz NTSC (hex): hi: $23, lo: $87 ; (dec): lo:135, Hi: 35
re5   = $25A2 ;  587,30Hz NTSC (hex): hi: $25, lo: $A2 ; (dec): lo:162, Hi: 37
red5  = $27E0 ;  622,30Hz NTSC (hex): hi: $27, lo: $E0 ; (dec): lo:224, Hi: 39
mi5   = $2A3F ;  659,30Hz NTSC (hex): hi: $2A, lo: $3F ; (dec): lo: 63, Hi: 42
fa5   = $2CC2 ;  698,50Hz NTSC (hex): hi: $2C, lo: $C2 ; (dec): lo:194, Hi: 44
fad5  = $2F6B ;  740,00Hz NTSC (hex): hi: $2F, lo: $6B ; (dec): lo:107, Hi: 47
sol5  = $323D ;  784,00Hz NTSC (hex): hi: $32, lo: $3D ; (dec): lo: 61, Hi: 50
sold5 = $3539 ;  830,60Hz NTSC (hex): hi: $35, lo: $39 ; (dec): lo: 57, Hi: 53
la5   = $3864 ;  880,00Hz NTSC (hex): hi: $38, lo: $64 ; (dec): lo:100, Hi: 56
lad5  = $3BBF ;  932,40Hz NTSC (hex): hi: $3B, lo: $BF ; (dec): lo:191, Hi: 59
si5   = $3F4C ;  987,80Hz NTSC (hex): hi: $3F, lo: $4C ; (dec): lo: 76, Hi: 63
; ----------------------------------------------------------------------------
; Octave 6
; ----------------------------------------------------------------------------
do6   = $4311 ; 1046,60Hz NTSC (hex): hi: $43, lo: $11 ; (dec): lo: 17, Hi: 67
dod6  = $470D ; 1108,80Hz NTSC (hex): hi: $47, lo: $0D ; (dec): lo: 13, Hi: 71
re6   = $4B45 ; 1174,60Hz NTSC (hex): hi: $4B, lo: $45 ; (dec): lo: 69, Hi: 75
red6  = $4FC1 ; 1244,60Hz NTSC (hex): hi: $4F, lo: $C1 ; (dec): lo:193, Hi: 79
mi6   = $547F ; 1318,60Hz NTSC (hex): hi: $54, lo: $7F ; (dec): lo:127, Hi: 84
fa6   = $5985 ; 1397,00Hz NTSC (hex): hi: $59, lo: $85 ; (dec): lo:133, Hi: 89
fad6  = $5ED7 ; 1480,00Hz NTSC (hex): hi: $5E, lo: $D7 ; (dec): lo:215, Hi: 94
sol6  = $647A ; 1568,00Hz NTSC (hex): hi: $64, lo: $7A ; (dec): lo:122, Hi:100
sold6 = $6A73 ; 1661,20Hz NTSC (hex): hi: $6A, lo: $73 ; (dec): lo:115, Hi:106
la6   = $70C8 ; 1760,00Hz NTSC (hex): hi: $70, lo: $C8 ; (dec): lo:200, Hi:112
lad6  = $777F ; 1864,80Hz NTSC (hex): hi: $77, lo: $7F ; (dec): lo:127, Hi:119
si6   = $7E99 ; 1975,60Hz NTSC (hex): hi: $7E, lo: $99 ; (dec): lo:153, Hi:126
; ----------------------------------------------------------------------------
; Octave 7
; ----------------------------------------------------------------------------
do7   = $8622 ; 2093,20Hz NTSC (hex): hi: $86, lo: $22 ; (dec): lo: 34, Hi:134
dod7  = $8E1A ; 2217,60Hz NTSC (hex): hi: $8E, lo: $1A ; (dec): lo: 26, Hi:142
re7   = $9689 ; 2349,20Hz NTSC (hex): hi: $96, lo: $89 ; (dec): lo:137, Hi:150
red7  = $9F82 ; 2489,20Hz NTSC (hex): hi: $9F, lo: $82 ; (dec): lo:130, Hi:159
mi7   = $A8FE ; 2637,20Hz NTSC (hex): hi: $A8, lo: $FE ; (dec): lo:254, Hi:168
fa7   = $B30A ; 2794,00Hz NTSC (hex): hi: $B3, lo: $0A ; (dec): lo: 10, Hi:179
fad7  = $BDAD ; 2960,00Hz NTSC (hex): hi: $BD, lo: $AD ; (dec): lo:173, Hi:189
sol7  = $C8F4 ; 3136,00Hz NTSC (hex): hi: $C8, lo: $F4 ; (dec): lo:244, Hi:200
sold7 = $D4E6 ; 3322,40Hz NTSC (hex): hi: $D4, lo: $E6 ; (dec): lo:230, Hi:212
la7   = $E18F ; 3520,00Hz NTSC (hex): hi: $E1, lo: $8F ; (dec): lo:143, Hi:225
lad7  = $EEFE ; 3729,60Hz NTSC (hex): hi: $EE, lo: $FE ; (dec): lo:254, Hi:238
si7   = $FD31 ; 3951,20Hz NTSC (hex): hi: $FD, lo: $31 ; (dec): lo: 49, Hi:253