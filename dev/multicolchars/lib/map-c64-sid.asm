;-------------------------------------------------------------------------
; = = = = = = = = = = = = = = S I D   M A P = = = = = = = = = = = = = = = 
; VERSION : 20230402-082548
;-------------------------------------------------------------------------
; V O I C E   1  $d400-$d406 
;-------------------------------------------------------------------------
sidv1flow   =   $d400 ; 54272 - Voice 1 Low freq register low byte.
sidv1fhigh  =   $d401 ; 54273 - Voice 1 High freq register high byte.
sidv1pwlow 	=   $d402 ; 54274 - Voice 1 Pulse waveform width register low byte.
sidv1pwhigh =   $d403 ; 54275 - Voice 1 Pulse waveform width register high byte.
sidv1control=   $d404 ; 54276 - Voice 1 Voice control register.
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
sidv1atkdec =	$d405 ; 54277 - 0-3: Voice 1 Decay duration, 4-7: Attack duration.
sidv1stnrel =   $d406 ; 54278 - 0-3: Voice 1 Rel. duration, 4-7: Sustain duration.
;-------------------------------------------------------------------------
; V O I C E   2  $d407-$d413
;-------------------------------------------------------------------------
sidv2flow   =   $d407 ; 54279 - Voice 2 Low freq register low byte.
sidv2fhigh  =   $d408 ; 54280 - Voice 2 High freq register high byte.
sidv2pwlow 	=   $d409 ; 54281 - Voice 2 Pulse waveform width register low byte.
sidv2pwhigh	=   $d40a ; 54282 - Voice 2 Pulse waveform width register high byte.
sidv2control=   $d40b ; 54283 - Voice 2 Voice control register.
sidv2atkdec =   $d40c ; 54284 - Voice 2 0-3: Decay duration, 4-7: Attack duration.
sidv2stnrel =   $d40d ; 54285 - Voice 2 0-3: Rel. duration, 4-7: Sustain duration.
;-------------------------------------------------------------------------
; V O I C E   3  $d40e-$d414
;-------------------------------------------------------------------------
sidv3flow   =   $d40e ; 54286 - Voice 3 Low freq register low byte.
sidv3fhigh  =   $d40f ; 54287 - Voice 3 High freq register high byte.
sidv3pwlow 	=   $d410 ; 54288 - Voice 3 Pulse waveform width register low byte.
sidv3pwhigh =   $d411 ; 54289 - Voice 3 Pulse waveform width register high byte.
sidv3control=   $d412 ; 54290 - Voice 3 Poice control register.
sidv3atkdec =   $d413 ; 54291 - Voice 3 0-3: Decay duration, 4-7: Attack duration.
sidv3stnrel =   $d414 ; 54292 - Voice 3 0-3: Rel. duration, 4-7: Sustain duration.
;-------------------------------------------------------------------------
; F I L T E R   C O N T R O L  $D415-$D418
;-------------------------------------------------------------------------
sidcutlo    =   $d415 ; 54293 - Bits 0-2 = low portion of filter cutoff frequency.
                      ;         Bits 5-7 Unused.
sidcuthi    =   $d416 ; 54294 - Filter cutoff frequency (high byte).
sidreson    =   $d417 ; 54295 - Filter resonnance control register.
                      ;         Bit 0: Filter voice 1 output? 1=yes.
                      ;         Bit 1: Filter voice 2 output? 1=yes.
                      ;         Bit 2: Filter voice 3 output? 1=yes.
                      ;         Bit 3: Filter output from external input? 1=yes.
                      ;         Bits 4-7: Select filter resonnance 0-15.
sidsigvol  =    $d418 ; 54296 - Volume and Filter selectv register.
                      ;         Bits 0-3: Select output volume (0-15).
                      ;         Bit 4: Select low-pass filter, 1=low-pas on.
                      ;         Bit 5: Select band-pass filter, 1=band-pas on.
                      ;         Bit 6: Select high-pass filter, 1=high-pas on.
                      ;         Bit 7: Disconnect output of voice 3, 1=voice 3 off.
sidpotx    =    $d419 ; 54297 - Read game paddle 1 (or 3) X position.
sidpoty    =    $d41a ; 54298 - Read game paddle 1 (or 3) Y position.
sidrandom  =    $d41b ; 54299 - Read oscillator/Random number generator.
sidenv3    =    $d41c ; 54300 - Envelope Generator 3 output.
