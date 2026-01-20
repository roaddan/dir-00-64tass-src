;---------------------------------------
; TABLE DE MNEUMONIQUES
;---------------------------------------
MNEUMON 
     .TEXT "BRK,ORA,---,---,---,ORA,"
     .TEXT "ASL,---,PHP,ORA,ASL,---,"
     .TEXT "---,ORA,ASL,---,BPL,ORA,"
     .TEXT "---,---,---,ORA,ASL,---,"
     .TEXT "CLC,ORA,---,---,---,ORA,"
     .TEXT "ASL,---,JSR,AND,---,---,"
     .TEXT "BIT,AND,ROL,---,PLP,AND,"
     .TEXT "ROL,---,BIT,AND,ROL,---,"
     .TEXT "BMI,AND,---,---,---,AND,"
     .TEXT "ROL,---,SEC,AND,---,---,"
     .TEXT "---,AND,ROL,---,RTI,EOR,"
     .TEXT "---,---,---,EOR,LSR,---,"
     .TEXT "PHA,EOR,LSR,---,JMP,EOR,"
     .TEXT "LSR,---,BVC,EOR,---,---,"
     .TEXT "---,EOR,LSR,---,CLI,EOR,"
     .TEXT "---,---,---,EOR,LSR,---,"
     .TEXT "RTS,ADC,---,---,---,ADC,"
     .TEXT "ROR,---,PLA,ADC,ROR,---,"
     .TEXT "JMP,ADC,ROR,---,BVS,ADC,"
     .TEXT "---,---,---,ADC,ROR,---,"
     .TEXT "SEI,ADC,---,---,---,ADC,"
     .TEXT "ROR,---,---,STA,---,---,"
     .TEXT "STY,STA,STX,---,DEY,---,"
     .TEXT "TXA,---,STY,STA,STX,---,"
     .TEXT "BCC,STA,---,---,STY,STA,"
     .TEXT "STX,---,TYA,STA,TXS,---,"
     .TEXT "---,STA,---,---,LDY,LDA,"
     .TEXT "LDX,---,LDY,LDA,LDX,---,"
     .TEXT "TAY,LDA,TAX,---,LDY,LDA,"
     .TEXT "LDX,---,BCS,LDA,---,---,"
     .TEXT "LDY,LDA,LDX,---,CLV,LDA,"
     .TEXT "TSX,---,LDY,LDA,LDX,---,"
     .TEXT "CPY,CMP,---,---,CPY,CMP,"
     .TEXT "DEC,---,INY,CMP,DEX,---,"
     .TEXT "CPY,CMP,DEC,---,BNE,CMP,"
     .TEXT "---,---,---,CMP,DEC,---,"
     .TEXT "CLD,CMP,---,---,---,CMP,"
     .TEXT "DEC,---,CPX,SBC,---,---,"
     .TEXT "CPX,SBC,INC,---,INX,SBC,"
     .TEXT "NOP,---,CPX,SBC,INC,---,"
     .TEXT "BEQ,SBC,---,---,---,SBC,"
     .TEXT "INC,---,SED,SBC,---,---,"
     .TEXT "---,SBC,INC,---,"
;---------------------------------------
; TABLE DES OPERANDES HEXADECIMAUX
;---------------------------------------
OPCODE 
     .BYTE $00,$01,$FF,$FF,$FF,$05
     .BYTE $06,$FF,$08,$09,$0A,$FF
     .BYTE $FF,$0D,$0E,$FF,$10,$11
     .BYTE $FF,$FF,$FF,$15,$16,$FF
     .BYTE $18,$19,$FF,$FF,$FF,$1D
     .BYTE $1E,$FF,$20,$21,$FF,$FF
     .BYTE $24,$25,$26,$FF,$28,$29
     .BYTE $2A,$FF,$2C,$2D,$2E,$FF
     .BYTE $30,$31,$FF,$FF,$FF,$35
     .BYTE $36,$FF,$38,$39,$FF,$FF
     .BYTE $FF,$3D,$3E,$FF,$40,$41
     .BYTE $FF,$FF,$FF,$45,$46,$FF
     .BYTE $48,$49,$4A,$FF,$4C,$4D
     .BYTE $4E,$FF,$50,$51,$FF,$FF
     .BYTE $FF,$55,$56,$FF,$58,$59
     .BYTE $FF,$FF,$FF,$5D,$5E,$FF
     .BYTE $60,$61,$FF,$FF,$FF,$65
     .BYTE $66,$FF,$68,$69,$6A,$FF
     .BYTE $6C,$6D,$6E,$FF,$70,$71
     .BYTE $FF,$FF,$FF,$75,$76,$FF
     .BYTE $78,$79,$FF,$FF,$FF,$7D
     .BYTE $7E,$FF,$FF,$81,$FF,$FF
     .BYTE $84,$85,$86,$FF,$88,$FF
     .BYTE $8A,$FF,$8C,$8D,$8E,$FF
     .BYTE $90,$91,$FF,$FF,$94,$95
     .BYTE $96,$FF,$98,$99,$9A,$FF
     .BYTE $FF,$9D,$FF,$FF,$A0,$A1
     .BYTE $A2,$FF,$A4,$A5,$A6,$FF
     .BYTE $A8,$A9,$AA,$FF,$AC,$AD
     .BYTE $AE,$FF,$B0,$B1,$FF,$FF
     .BYTE $B4,$B5,$B6,$FF,$B8,$B9
     .BYTE $BA,$FF,$BC,$BD,$BE,$FF
     .BYTE $C0,$C1,$FF,$FF,$C4,$C5
     .BYTE $C6,$FF,$C8,$C9,$CA,$FF
     .BYTE $CC,$CD,$CE,$FF,$D0,$D1
     .BYTE $FF,$FF,$FF,$D5,$D6,$FF
     .BYTE $D8,$D9,$FF,$FF,$FF,$DD
     .BYTE $DE,$FF,$E0,$E1,$FF,$FF
     .BYTE $E4,$E5,$E6,$FF,$E8,$E9
     .BYTE $EA,$FF,$EC,$ED,$EE,$FF
     .BYTE $F0,$F1,$FF,$FF,$FF,$F5
     .BYTE $F6,$FF,$F8,$F9,$FF,$FF
     .BYTE $FF,$FD,$FE,$FF
;---------------------------------------
; TABLE DES MODES D'ADRESSAGE.
;---------------------------------------
; MODE D'ADRESSAGE
; 0 = IMPLICITE ;0;
; 1 = ACCUMULATEUR ;1;
; 2 = IMMEDIAT ;2;
; 3 = ABSOLUE ;3;
; 4 = RELATIF ;4;
; 5 = ABSOLUE,X ;5;
; 6 = ABSOLUE,Y ;6;
; 7 = ZERO PAGE ;7;
; 8 = ZERO PAGE,X ;8;
; 9 = ZERO PAGE,Y ;9;
; 10 = (ZERO PAGE,X) ;10;
; 11 = (ZEROPAGE),Y ;11;
; 12 = (ABSOLUE IND) ;12;
;---------------------------------------
OPMODES 
     .BYTE   0, 10,  0,  0,  0,  7
     .BYTE   7,  0,  0,  2,  0,  0
     .BYTE   0,  3,  3,  0,  4, 11
     .BYTE   0,  0,  0,  8,  8,  0
     .BYTE   0,  6,  0,  0,  0,  5
     .BYTE   5,  0,  3, 10,  0,  0
     .BYTE   7,  7,  7,  0,  0,  2
     .BYTE   1,  0,  3,  3,  3,  0
     .BYTE   4, 11,  0,  0,  0,  8
     .BYTE   8,  0,  0,  6,  0,  0
     .BYTE   0,  5,  5,  0,  0, 10
     .BYTE   0,  0,  0,  7,  7,  0
     .BYTE   0,  2,  1,  0,  3,  3
     .BYTE   3,  0,  4, 11,  0,  0
     .BYTE   0,  8,  8,  0,  0,  6
     .BYTE   0,  0,  0,  5,  5,  0
     .BYTE   0, 10,  0,  0,  0,  7
     .BYTE   7,  0,  0,  2,  1,  0
     .BYTE  12,  3,  3,  0,  4, 11
     .BYTE   0,  0,  0,  8,  8,  0
     .BYTE   0,  6,  0,  0,  0,  5
     .BYTE   5,  0,  0, 10,  0,  0
     .BYTE   7,  7,  7,  0,  0,  0
     .BYTE   0,  0,  3,  3,  3,  0
     .BYTE   4, 11,  0,  0,  8,  8
     .BYTE   9,  0,  0,  6,  0,  0
     .BYTE   0,  5,  0,  0,  2, 10
     .BYTE   2,  0,  7,  7,  7,  0
     .BYTE   0,  2,  0,  0,  3,  3
     .BYTE   3,  0,  4, 11,  0,  0
     .BYTE   8,  8,  9,  0,  0,  6
     .BYTE   0,  0,  5,  5,  6,  0
     .BYTE   2, 10,  0,  0,  7,  7
     .BYTE   7,  0,  0,  2,  0,  0
     .BYTE   3,  3,  3,  0,  4, 11
     .BYTE   0,  0,  0,  8,  8,  0
     .BYTE   0,  6,  0,  0,  0,  5
     .BYTE   5,  0,  2, 10,  0,  0
     .BYTE   7,  7,  7,  0,  0,  2
     .BYTE   0,  0,  3,  3,  3,  0
     .BYTE   4, 11,  0,  0,  0,  8
     .BYTE   8,  0,  0,  6,  0,  0
     .BYTE   0,  5,  5,  0
;---------------------------------------
; TABLE DES NOMBRER D'OCTETS
;---------------------------------------
OPBYTES 
     .BYTE   1,  2,  0,  0,  0,  2
     .BYTE   2,  0,  1,  1,  1,  0
     .BYTE   0,  3,  3,  0,  2,  2
     .BYTE   0,  0,  0,  2,  2,  0
     .BYTE   1,  3,  0,  0,  0,  3
     .BYTE   3,  0, 13,  2,  0,  0
     .BYTE   2,  2,  2,  0,  1,  2
     .BYTE   1,  0,  3,  3,  3,  0
     .BYTE   2,  2,  0,  0,  0,  2
     .BYTE   2,  0,  1,  3,  0,  0
     .BYTE   0,  3,  3,  0,  1,  2
     .BYTE   0,  0,  0,  2,  2,  0
     .BYTE   1,  2,  1,  0,  3,  3
     .BYTE   3,  0,  2,  2,  0,  0
     .BYTE   0,  2,  2,  0,  1,  3
     .BYTE   0,  0,  0,  3,  3,  0
     .BYTE   1,  2,  0,  0,  0,  2
     .BYTE   2,  0,  1,  2,  1,  0
     .BYTE   3,  3,  3,  0,  2,  2
     .BYTE   0,  0,  0,  2,  2,  0
     .BYTE   1,  3,  0,  0,  0,  3
     .BYTE   3,  0,  0,  2,  0,  0
     .BYTE   2,  2,  2,  0,  1,  0
     .BYTE   1,  0,  3,  3,  3,  0
     .BYTE   2,  2,  0,  0,  2,  2
     .BYTE   2,  0,  1,  3,  1,  0
     .BYTE   0,  3,  0,  0,  2,  2
     .BYTE   2,  0,  2,  2,  2,  0
     .BYTE   1,  2,  1,  0,  3,  3
     .BYTE   3,  0,  2,  2,  0,  0
     .BYTE   2,  2,  2,  0,  1,  3
     .BYTE   1,  0,  3,  3,  3,  0
     .BYTE   2,  2,  0,  0,  2,  2
     .BYTE   2,  0,  1,  2,  1,  0
     .BYTE   3,  3,  3,  0,  2,  2
     .BYTE   0,  0,  0,  2,  2,  0
     .BYTE   1,  3,  0,  0,  0,  3
     .BYTE   3,  0,  2,  2,  0,  0
     .BYTE   2,  2,  2,  0,  1,  2
     .BYTE   1,  0,  3,  3,  3,  0
     .BYTE   2,  2,  0,  0,  0,  2
     .BYTE   2,  0,  1,  3,  0,  0
     .BYTE   0,  3,  3,  0
;---------------------------------------
; TABLE DES CYCLES
;---------------------------------------
OPCYCLES 
     .BYTE   7,  6,  0,  0,  0,  3
     .BYTE   5,  0,  3,  5,  2,  0
     .BYTE   0,  4,  6,  0,  2,  5
     .BYTE   0,  0,  0,  4,  6,  0
     .BYTE   2,  4,  0,  0,  0,  4
     .BYTE   7,  0,  6,  6,  0,  0
     .BYTE   3,  3,  5,  0,  4,  2
     .BYTE   2,  0,  4,  4,  6,  0
     .BYTE   2,  5,  0,  0,  0,  4
     .BYTE   6,  0,  2,  4,  0,  0
     .BYTE   0,  4,  7,  0,  6,  6
     .BYTE   0,  0,  0,  3,  5,  0
     .BYTE   3,  2,  2,  0,  3,  4
     .BYTE   6,  0,  2,  5,  0,  0
     .BYTE   0,  4,  6,  0,  2,  4
     .BYTE   0,  0,  0,  4,  7,  0
     .BYTE   6,  6,  0,  0,  0,  3
     .BYTE   5,  0,  4,  2,  2,  0
     .BYTE   5,  4,  6,  0,  2,  5
     .BYTE   0,  0,  0,  4,  6,  0
     .BYTE   2,  4,  0,  0,  0,  4
     .BYTE   7,  0,  0,  6,  0,  0
     .BYTE   3,  3,  3,  0,  2,  0
     .BYTE   2,  0,  4,  4,  4,  0
     .BYTE   2,  6,  0,  0,  4,  4
     .BYTE   4,  0,  2,  5,  2,  0
     .BYTE   0,  5,  0,  0,  2,  6
     .BYTE   2,  0,  3,  3,  3,  0
     .BYTE   2,  2,  2,  0,  4,  4
     .BYTE   4,  0,  2,  5,  0,  0
     .BYTE   4,  4,  4,  0,  2,  4
     .BYTE   2,  0,  4,  4,  4,  0
     .BYTE   2,  6,  0,  0,  3,  3
     .BYTE   5,  0,  2,  2,  2,  0
     .BYTE   4,  4,  6,  0,  2,  5
     .BYTE   0,  0,  0,  4,  6,  0
     .BYTE   2,  4,  0,  0,  0,  4
     .BYTE   7,  0,  2,  6,  0,  0
     .BYTE   3,  3,  5,  0,  2,  2
     .BYTE   2,  0,  4,  4,  6,  0
     .BYTE   2,  5,  0,  0,  0,  4
     .BYTE   6,  0,  2,  4,  0,  0
     .BYTE   0,  4,  7,  0