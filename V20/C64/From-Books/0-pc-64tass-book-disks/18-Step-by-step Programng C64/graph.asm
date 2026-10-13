;---------------------------------------
; CRƒƒ LE  : 2021-12-04
;      PAR : DANIEL LAFRANCE
;---------------------------------------
*=$C000
;---------------------------------------
START                     ; $C000, IMP, 1
BRK                       ; $C001, IMP, 1
BRK                       ; $C002, IMP, 1
BRK                       ; $C003, IMP, 1
BRK                       ; $C004, IMP, 1
BRK                       ; $C005, IMP, 1
BRK                       ; $C006, IMP, 1
BRK                       ; $C007, IMP, 1
BRK                       ; $C008, IMP, 1
BRK                       ; $C009, IMP, 1
BRK                       ; $C00A, IMP, 1
BRK                       ; $C00B, IMP, 1
BRK                       ; $C00C, IMP, 1
BRK                       ; $C00D, IMP, 1
BRK                       ; $C00E, IMP, 1
BRK                       ; $C00F, IMP, 1
BRK                       ; $C010, IMP, 1
BRK                       ; $C011, IMP, 1
BRK                       ; $C012, IMP, 1
BRK                       ; $C013, IMP, 1
BRK                       ; $C014, IMP, 1
BRK                       ; $C015, IMP, 1
BRK                       ; $C016, IMP, 1
BRK                       ; $C017, IMP, 1
BRK                       ; $C018, IMP, 1
BRK                       ; $C019, IMP, 1
BRK                       ; $C01A, IMP, 1
BRK                       ; $C01B, IMP, 1
BRK                       ; $C01C, IMP, 1
BRK                       ; $C01D, IMP, 1
BRK                       ; $C01E, IMP, 1
BRK                       ; $C01F, IMP, 1
BRK                       ; $C020, IMP, 1
BRK                       ; $C021, IMP, 1
BRK                       ; $C022, IMP, 1
BRK                       ; $C023, IMP, 1
BRK                       ; $C024, IMP, 1
BRK                       ; $C025, IMP, 1
BRK                       ; $C026, IMP, 1
BRK                       ; $C027, IMP, 1
JSR $0079                 ; $C028, ABS, 3
JSR $AEFD                 ; $C02B, ABS, 3
JSR $AD8A                 ; $C02E, ABS, 3
JSR $B1BF                 ; $C031, ABS, 3
LDX $64                   ; $C034, ZP, 2
LDY $65                   ; $C036, ZP, 2
RTS                       ; $C038, IMP, 1
JSR $C028                 ; $C039, ABS, 3
STY $3F                   ; $C03C, ZP, 2
STY $14                   ; $C03E, ZP, 2
STX $40                   ; $C040, ZP, 2
STX $15                   ; $C042, ZP, 2
JSR $A613                 ; $C044, ABS, 3
LDA $5F                   ; $C047, ZP, 2
SEC                       ; $C049, IMP, 1
SBC #$01                  ; $C04A, IMM, 2
STA $41                   ; $C04C, ZP, 2
LDA $60                   ; $C04E, ZP, 2
SBC #$00                  ; $C050, IMM, 2
STA $42                   ; $C052, ZP, 2
RTS                       ; $C054, IMP, 1
LDA #$08                  ; $C055, IMM, 2
ORA $D018                 ; $C057, ABS, 3
STA $D018                 ; $C05A, ABS, 3
LDA #$20                  ; $C05D, IMM, 2
ORA $D011                 ; $C05F, ABS, 3
STA $D011                 ; $C062, ABS, 3
RTS                       ; $C065, IMP, 1
LDA #$F7                  ; $C066, IMM, 2
AND $D018                 ; $C068, ABS, 3
STA $D018                 ; $C06B, ABS, 3
LDA #$DF                  ; $C06E, IMM, 2
AND $D011                 ; $C070, ABS, 3
STA $D011                 ; $C073, ABS, 3
RTS                       ; $C076, IMP, 1
LDA #$08                  ; $C077, IMM, 2
LDY #$01                  ; $C079, IMM, 2
STA ($2B),Y               ; $C07B, (IND),Y, 2
JSR $A533                 ; $C07D, ABS, 3
LDA $22                   ; $C080, ZP, 2
STA $2D                   ; $C082, ZP, 2
STA $2F                   ; $C084, ZP, 2
STA $31                   ; $C086, ZP, 2
LDA $23                   ; $C088, ZP, 2
STA $2E                   ; $C08A, ZP, 2
STA $30                   ; $C08C, ZP, 2
STA $32                   ; $C08E, ZP, 2
RTS                       ; $C090, IMP, 1
JSR $0079                 ; $C091, ABS, 3
JSR $AEFD                 ; $C094, ABS, 3
LDA #$00                  ; $C097, IMM, 2
STA $0A                   ; $C099, ZP, 2
JSR $E102                 ; $C09B, ABS, 3
LDA $2D                   ; $C09E, ZP, 2
SBC #$02                  ; $C0A0, IMM, 2
STA $2B                   ; $C0A2, ZP, 2
LDA $2E                   ; $C0A4, ZP, 2
SBC #$00                  ; $C0A6, IMM, 2
STA $2C                   ; $C0A8, ZP, 2
LDA #$00                  ; $C0AA, IMM, 2
STA $B9                   ; $C0AC, ZP, 2
LDX $2B                   ; $C0AE, ZP, 2
LDY $2C                   ; $C0B0, ZP, 2
JSR $FFD5                 ; $C0B2, ABS, 3
BCS _LC0C5                ; $C0B5, REL, 2
STX $2D                   ; $C0B7, ZP, 2
STY $2E                   ; $C0B9, ZP, 2
JSR $A533                 ; $C0BB, ABS, 3
PLA                       ; $C0BE, IMP, 1
STA $2C                   ; $C0BF, ZP, 2
PLA                       ; $C0C1, IMP, 1
STA $2B                   ; $C0C2, ZP, 2
RTS                       ; $C0C4, IMP, 1
TAX                       ; $C0C5, IMP, 1
CMP #$04                  ; $C0C6, IMM, 2
BNE _LC0CF  _LC0CF        ; $C0C8, REL, 2
LDY $BA                   ; $C0CA, ZP, 2
DEY                       ; $C0CC, IMP, 1
BEQ _LC09D  _LC09D        ; $C0CD, REL, 2
PLA                       ; $C0CF, IMP, 1
STA $2C                   ; $C0D0, ZP, 2
PLA                       ; $C0D2, IMP, 1
STA $2B                   ; $C0D3, ZP, 2
CLC                       ; $C0D5, IMP, 1
JMP ($0300)               ; $C0D6, (IND), 3
CPX #$02                  ; $C0D9, IMM, 2
BCS _LC0E4  _LC0E4        ; $C0DB, REL, 2
CPX #$01                  ; $C0DD, IMM, 2
BCS _LC0E2  _LC0E2        ; $C0DF, REL, 2
RTS                       ; $C0E1, IMP, 1
CPY #$40                  ; $C0E2, IMM, 2
RTS                       ; $C0E4, IMP, 1
SEC                       ; $C0E5, IMP, 1
TXA         _LC0E6        ; $C0E6, IMP, 1
BNE _LC0EC  _LC0EC        ; $C0E7, REL, 2
TYA                       ; $C0E9, IMP, 1
CMP #$C8                  ; $C0EA, IMM, 2
RTS                       ; $C0EC, IMP, 1
ADC #$00                  ; $C0ED, IMM, 2
STA $2E                   ; $C0EF, ZP, 2
STA $30                   ; $C0F1, ZP, 2
STA $32                   ; $C0F3, ZP, 2
RTS                       ; $C0F5, IMP, 1
BRK                       ; $C0F6, IMP, 1
BRK                       ; $C0F7, IMP, 1
BRK                       ; $C0F8, IMP, 1
BRK                       ; $C0F9, IMP, 1
BRK                       ; $C0FA, IMP, 1
BRK                       ; $C0FB, IMP, 1
BRK                       ; $C0FC, IMP, 1
BRK                       ; $C0FD, IMP, 1
BRK                       ; $C0FE, IMP, 1
BRK                       ; $C0FF, IMP, 1
LDA $C008                 ; $C100, ABS, 3
PHA                       ; $C103, IMP, 1
AND #$07                  ; $C104, IMM, 2
STA $C001                 ; $C106, ABS, 3
PLA                       ; $C109, IMP, 1
AND #$F8                  ; $C10A, IMM, 2
STA $FD     _LC10C        ; $C10C, ZP, 2
LDA $C00C                 ; $C10E, ABS, 3
PHA                       ; $C111, IMP, 1
AND #$07                  ; $C112, IMM, 2
STA $C002                 ; $C114, ABS, 3
PLA                       ; $C117, IMP, 1
AND #$F8                  ; $C118, IMM, 2
PHA                       ; $C11A, IMP, 1
LSR                       ; $C11B, ACC, 1
LSR                       ; $C11C, ACC, 1
LSR                       ; $C11D, ACC, 1
STA $C003                 ; $C11E, ABS, 3
LSR                       ; $C121, ACC, 1
LSR                       ; $C122, ACC, 1
CLC                       ; $C123, IMP, 1
ADC $C003                 ; $C124, ABS, 3
STA $C003                 ; $C127, ABS, 3
PLA                       ; $C12A, IMP, 1
ASL                       ; $C12B, ACC, 1
ASL                       ; $C12C, ACC, 1
ASL                       ; $C12D, ACC, 1
ORA $C002                 ; $C12E, ABS, 3
CLC                       ; $C131, IMP, 1
ADC $FD                   ; $C132, ZP, 2
STA $FD                   ; $C134, ZP, 2
LDA $C003                 ; $C136, ABS, 3
ADC $C009                 ; $C139, ABS, 3
CLC                       ; $C13C, IMP, 1
ADC #$20                  ; $C13D, IMM, 2
STA $FE                   ; $C13F, ZP, 2
LDA #$80                  ; $C141, IMM, 2
LDX $C001                 ; $C143, ABS, 3
INX                       ; $C146, IMP, 1
DEX                       ; $C147, IMP, 1
BEQ _LC14E  _LC14E        ; $C148, REL, 2
LSR                       ; $C14A, ACC, 1
SEC                       ; $C14B, IMP, 1
BCS _LC147  _LC147        ; $C14C, REL, 2
STA $C000                 ; $C14E, ABS, 3
RTS                       ; $C151, IMP, 1
LDA $C01A                 ; $C152, ABS, 3
AND #$F8                  ; $C155, IMM, 2
STA $C01A                 ; $C157, ABS, 3
CLC                       ; $C15A, IMP, 1
ROR $C01B                 ; $C15B, ABS, 3
ROR $C01A                 ; $C15E, ABS, 3
ROR $C01B                 ; $C161, ABS, 3
ROR $C01A                 ; $C164, ABS, 3
ROR $C01B                 ; $C167, ABS, 3
ROR $C01A                 ; $C16A, ABS, 3
LDA #$00                  ; $C16D, IMM, 2
STA $FC                   ; $C16F, ZP, 2
LDA $C01C                 ; $C171, ABS, 3
LSR                       ; $C174, ACC, 1
LSR                       ; $C175, ACC, 1
LSR                       ; $C176, ACC, 1
STA $C004                 ; $C177, ABS, 3
ASL                       ; $C17A, ACC, 1
ASL                       ; $C17B, ACC, 1
CLC                       ; $C17C, IMP, 1
ADC $C004   _LC17D        ; $C17D, ABS, 3
ASL                       ; $C180, ACC, 1
ASL                       ; $C181, ACC, 1
ROL $FC                   ; $C182, ZP, 2
ASL                       ; $C184, ACC, 1
ROL $FC                   ; $C185, ZP, 2
CLC                       ; $C187, IMP, 1
ADC $C01A                 ; $C188, ABS, 3
STA $FB                   ; $C18B, ZP, 2
LDA #$04                  ; $C18D, IMM, 2
ADC $FC                   ; $C18F, ZP, 2
ADC $C01B                 ; $C191, ABS, 3
STA $FC                   ; $C194, ZP, 2
RTS                       ; $C196, IMP, 1
JSR $C028                 ; $C197, ABS, 3
STY $C005                 ; $C19A, ABS, 3
LDA #$20                  ; $C19D, IMM, 2
STA $FC                   ; $C19F, ZP, 2
LDA #$00                  ; $C1A1, IMM, 2
STA $FB                   ; $C1A3, ZP, 2
LDA $FC                   ; $C1A5, ZP, 2
CMP #$3F                  ; $C1A7, IMM, 2
BNE _LC1B1  _LC1B1        ; $C1A9, REL, 2
LDA $FB                   ; $C1AB, ZP, 2
CMP #$40                  ; $C1AD, IMM, 2
BEQ _LC1BE  _LC1BE        ; $C1AF, REL, 2
LDX #$00                  ; $C1B1, IMM, 2
TXA                       ; $C1B3, IMP, 1
STA ($FB,X)               ; $C1B4, (IND,X), 2
INC $FB                   ; $C1B6, ZP, 2
BNE _LC1A5  _LC1A5        ; $C1B8, REL, 2
INC $FC                   ; $C1BA, ZP, 2
BNE _LC1A5  _LC1A5        ; $C1BC, REL, 2
LDA #$04                  ; $C1BE, IMM, 2
STA $FC                   ; $C1C0, ZP, 2
LDA #$00                  ; $C1C2, IMM, 2
STA $FB                   ; $C1C4, ZP, 2
LDA $FC                   ; $C1C6, ZP, 2
CMP #$07                  ; $C1C8, IMM, 2
BNE _LC1D2  _LC1D2        ; $C1CA, REL, 2
LDA $FB                   ; $C1CC, ZP, 2
CMP #$E8                  ; $C1CE, IMM, 2
BEQ _LC1E1  _LC1E1        ; $C1D0, REL, 2
LDX #$00                  ; $C1D2, IMM, 2
LDA $C005                 ; $C1D4, ABS, 3
STA ($FB,X)               ; $C1D7, (IND,X), 2
INC $FB                   ; $C1D9, ZP, 2
BNE _LC1C6  _LC1C6        ; $C1DB, REL, 2
INC $FC                   ; $C1DD, ZP, 2
BNE _LC1C6  _LC1C6        ; $C1DF, REL, 2
RTS                       ; $C1E1, IMP, 1
JSR $C028                 ; $C1E2, ABS, 3
JSR $C0E0                 ; $C1E5, ABS, 3
BCC _LC1F1  _LC1F1        ; $C1E8, REL, 2
JSR $A906                 ; $C1EA, ABS, 3
JSR $A8FB                 ; $C1ED, ABS, 3
RTS                       ; $C1F0, IMP, 1
STX $C01B                 ; $C1F1, ABS, 3
STY $C01A                 ; $C1F4, ABS, 3
JSR $C028                 ; $C1F7, ABS, 3
JSR $C0EC   _LC1FA        ; $C1FA, ABS, 3
BCS _LC1EA  _LC1EA        ; $C1FD, REL, 2
STY $C01C                 ; $C1FF, ABS, 3
JSR $C028                 ; $C202, ABS, 3
STY $C005                 ; $C205, ABS, 3
JSR $C152                 ; $C208, ABS, 3
LDY #$00                  ; $C20B, IMM, 2
LDA $C005   _LC20D        ; $C20D, ABS, 3
STA ($FB),Y               ; $C210, (IND),Y, 2
RTS                       ; $C212, IMP, 1
BRK                       ; $C213, IMP, 1
BRK                       ; $C214, IMP, 1
BRK                       ; $C215, IMP, 1
BRK                       ; $C216, IMP, 1
BRK                       ; $C217, IMP, 1
BRK                       ; $C218, IMP, 1
BRK                       ; $C219, IMP, 1
BRK                       ; $C21A, IMP, 1
