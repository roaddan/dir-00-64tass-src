;---------------------------------------
; TABLE DE MNEUMONIQUES
;---------------------------------------
MNEUMON 
"
	.TEXT "BRK,ORA,---,---,---,ORA,ASL,---"
	.TEXT "PHP,ORA,ASL,---,---,ORA,ASL,---"
	.TEXT "BPL,ORA,---,---,---,ORA,ASL,---"
	.TEXT "CLC,ORA,---,---,---,ORA,ASL,---"
	.TEXT "JSR,AND,---,---,BIT,AND,ROL,---"
	.TEXT "PLP,AND,ROL,---,BIT,AND,ROL,---"
	.TEXT "BMI,AND,---,---,---,AND,ROL,---"
	.TEXT "SEC,AND,---,---,---,AND,ROL,---"
	.TEXT "RTI,EOR,---,---,---,EOR,LSR,---"
	.TEXT "PHA,EOR,LSR,---,JMP,EOR,LSR,---"
	.TEXT "BVC,EOR,---,---,---,EOR,LSR,---"
	.TEXT "CLI,EOR,---,---,---,EOR,LSR,---"
	.TEXT "RTS,ADC,---,---,---,ADC,ROR,---"
	.TEXT "PLA,ADC,ROR,---,JMP,ADC,ROR,---"
	.TEXT "BVS,ADC,---,---,---,ADC,ROR,---"
	.TEXT "SEI,ADC,---,---,---,ADC,ROR,---"
	.TEXT "---,STA,---,---,STY,STA,STX,---"
	.TEXT "DEY,---,TXA,---,STY,STA,STX,---"
	.TEXT "BCC,STA,---,---,STY,STA,STX,---"
	.TEXT "TYA,STA,TXS,---,---,STA,---,---"
	.TEXT "LDY,LDA,LDX,---,LDY,LDA,LDX,---"
	.TEXT "TAY,LDA,TAX,---,LDY,LDA,LDX,---"
	.TEXT "BCS,LDA,---,---,LDY,LDA,LDX,---"
	.TEXT "CLV,LDA,TSX,---,LDY,LDA,LDX,---"
	.TEXT "CPY,CMP,---,---,CPY,CMP,DEC,---"
	.TEXT "INY,CMP,DEX,---,CPY,CMP,DEC,---"
	.TEXT "BNE,CMP,---,---,---,CMP,DEC,---"
	.TEXT "CLD,CMP,---,---,---,CMP,DEC,---"
	.TEXT "CPX,SBC,---,---,CPX,SBC,INC,---"
	.TEXT "INX,SBC,NOP,---,CPX,SBC,INC,---"
	.TEXT "BEQ,SBC,---,---,---,SBC,INC,---"
	.TEXT "SED,SBC,---,---,---,SBC,INC,---
;---------------------------------------
; TABLE DES OPERANDES HEXADECIMAUX
;---------------------------------------
OPCODE 

,$00,$01,$FF,$FF,$FF,$05,$06,$FF
	.BYTE $08,$09,$0A,$FF,$FF,$0D,$0E,$FF
	.BYTE $10,$11,$FF,$FF,$FF,$15,$16,$FF
	.BYTE $18,$19,$FF,$FF,$FF,$1D,$1E,$FF
	.BYTE $20,$21,$FF,$FF,$24,$25,$26,$FF
	.BYTE $28,$29,$2A,$FF,$2C,$2D,$2E,$FF
	.BYTE $30,$31,$FF,$FF,$FF,$35,$36,$FF
	.BYTE $38,$39,$FF,$FF,$FF,$3D,$3E,$FF
	.BYTE $40,$41,$FF,$FF,$FF,$45,$46,$FF
	.BYTE $48,$49,$4A,$FF,$4C,$4D,$4E,$FF
	.BYTE $50,$51,$FF,$FF,$FF,$55,$56,$FF
	.BYTE $58,$59,$FF,$FF,$FF,$5D,$5E,$FF
	.BYTE $60,$61,$FF,$FF,$FF,$65,$66,$FF
	.BYTE $68,$69,$6A,$FF,$6C,$6D,$6E,$FF
	.BYTE $70,$71,$FF,$FF,$FF,$75,$76,$FF
	.BYTE $78,$79,$FF,$FF,$FF,$7D,$7E,$FF
	.BYTE $FF,$81,$FF,$FF,$84,$85,$86,$FF
	.BYTE $88,$FF,$8A,$FF,$8C,$8D,$8E,$FF
	.BYTE $90,$91,$FF,$FF,$94,$95,$96,$FF
	.BYTE $98,$99,$9A,$FF,$FF,$9D,$FF,$FF
	.BYTE $A0,$A1,$A2,$FF,$A4,$A5,$A6,$FF
	.BYTE $A8,$A9,$AA,$FF,$AC,$AD,$AE,$FF
	.BYTE $B0,$B1,$FF,$FF,$B4,$B5,$B6,$FF
	.BYTE $B8,$B9,$BA,$FF,$BC,$BD,$BE,$FF
	.BYTE $C0,$C1,$FF,$FF,$C4,$C5,$C6,$FF
	.BYTE $C8,$C9,$CA,$FF,$CC,$CD,$CE,$FF
	.BYTE $D0,$D1,$FF,$FF,$FF,$D5,$D6,$FF
	.BYTE $D8,$D9,$FF,$FF,$FF,$DD,$DE,$FF
	.BYTE $E0,$E1,$FF,$FF,$E4,$E5,$E6,$FF
	.BYTE $E8,$E9,$EA,$FF,$EC,$ED,$EE,$FF
	.BYTE $F0,$F1,$FF,$FF,$FF,$F5,$F6,$FF
	.BYTE $F8,$F9,$FF,$FF,$FF,$FD,$FE,$FF