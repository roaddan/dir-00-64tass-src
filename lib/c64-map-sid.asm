
sid      	=   $D400
;-------------------------------------------------------------------------
; V O I C E   1  $d400-$d406
;-------------------------------------------------------------------------
sid1flow    =   sid + $00 		; Low freq register low byte
sid1fhigh   =   sid + $01 		; High freq register high byte
sid1pwlow 	=   sid + $02 		; Pulse waveform width register low byte
sid1pwhigh 	=   sid + $03		; Pulse waveform width register high byte
sid1control	=   sid + $04 		; Voice control register
;-------------------------------------------------------------------------
; VOICE CONTROL REGISTER
;-------------------------------------------------------------------------
; 76543210
; |||||||+-0-> 1 = Start Atack/decay/sustain, 0 = Start release.
; ||||||+--1-> 1 = Sync oscillator with oscillator 3 fequency.
; |||||+---2-> 1 = Ring modulate oscillator 1 and 3.
; ||||+----3-> 1 = Disable oscillator 1.
; |||+-----4-> 1 = Select triangle waveform.
; ||+------5-> 1 = Select sawtooth waveform.
; |+-------6-> 1 = Select pulse waveform.
; +--------7-> 1 = Select random waveform.
;-------------------------------------------------------------------------
sid1atkdec 	=	sid + $05		; 0-3: Decay duration, 4-7: Attack duration.
sid1stnrel 	=   sid + $06 		; 0-3: Rel. duration, 4-7: Sustain duration.
;-------------------------------------------------------------------------
; V O I C E   2  $d407-$d413
;-------------------------------------------------------------------------
sid2flow    =   sid + $07 + $00 ; Low freq register low byte
sid2fhigh   =   sid + $07 + $01 ; High freq register high byte
sid2pwlow 	=   sid + $07 + $02 ; Pulse waveform width register low byte
sid2pwhigh	=   sid + $07 + $03	; Pulse waveform width register high byte
sid2control	=   sid + $07 + $04 ; Voice control register
sid2atkdec 	=   sid + $07 + $05	; 0-3: Decay duration, 4-7: Attack duration.
sid2stnrel 	=   sid + $07 + $06 ; 0-3: Rel. duration, 4-7: Sustain duration.
;-------------------------------------------------------------------------
; V O I C E   3  $d40e-$d414
;-------------------------------------------------------------------------
sid3flow    =   sid + $0e + $00 ; Low freq register low byte
sid3fhigh   =   sid + $0e + $01 ; High freq register high byte
sid3pwlow 	=   sid + $0e + $02 ; Pulse waveform width register low byte
sid3pwhigh  =   sid + $0e + $03	; Pulse waveform width register high byte
sid3control	=   sid + $0e + $04 ; Poice control register
sid3atkdec 	=   sid + $0e + $05	; 0-3: Decay duration, 4-7: Attack duration.
sid3stnrel 	=   sid + $0e + $06 ; 0-3: Rel. duration, 4-7: Sustain duration.
;-------------------------------------------------------------------------
; F I L T E R   C O N T R O L  $D415-$D418
;-------------------------------------------------------------------------
sidcutlo	=	SID + $15       ; 