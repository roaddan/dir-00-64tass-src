sidbase =   $d400
; Voice 1
frelo1  =   $d400 ; 54272 - Voice 1 frequency control (low byte).
frehi1  =   $d401 ; 54273 - Voice 1 frequency control (high byte).
pwlo1   =   $d402 ; 54274 - Voice 1 pulse waveform width (low byte).
pwhi1   =   $d403 ; 54275 - Voice 1 pulse waveform width (high byte).
vcreg1  =   $d404 ; 54276 - Voice 1 control register.
atdcy1  =   $d405 ; 54277 - Voive 1 attack/decay register.
surel1  =   $d406 ; 54278 - Voice 1 Sustain/Release control register.
; Voice 2
frelo2  =   $d407 ; 54279 - Voice 2 frequency control (low byte).
frehi2  =   $d408 ; 54280 - Voice 2 frequency control (high byte).
pwlo2   =   $d409 ; 54281 - Voice 2 pulse waveform width (low byte).
pwhi2   =   $d40a ; 54282 - Voice 2 pulse waveform width (high byte).
vcreg2  =   $d40b ; 54283 - Voice 2 control register.
atdcy2  =   $d40c ; 54284 - Voive 2 attack/decay register.
surel2  =   $d40d ; 54285 - Voice 2 Sustain/Release control register.
; Voice 3
frelo3  =   $d40e ; 54286 - Voice 2 frequency control (low byte).
frehi3  =   $d40f ; 54287 - Voice 2 frequency control (high byte).
pwlo3   =   $d410 ; 54288 - Voice 2 pulse waveform width (low byte).
pwhi3   =   $d411 ; 54289 - Voice 2 pulse waveform width (high byte).
vcreg3  =   $d412 ; 54290 - Voice 2 control register.
atdcy3  =   $d413 ; 54291 - Voive 2 attack/decay register.
surel3  =   $d414 ; 54292 - Voice 2 Sustain/Release control register.

cutlo   =   $d415 ; 54293 - Bits 0-2 = low portion of filter cutoff frequency.
                  ;         Bits 5-7 Unused
cuthi   =   $d416 ; 54294 - Filter cutoff frequency (high byte).
reson   =   $d417 ; 54295 - Filter resonnance control register.
                  ;         Bit 0: Filter voice 1 output? 1=yes.
                  ;         Bit 1: Filter voice 2 output? 1=yes.
                  ;         Bit 2: Filter voice 3 output? 1=yes.
                  ;         Bit 3: Filter output from external input? 1=yes.
                  ;         Bits 4-7: Select filter resonnance 0-15.
sigvol  =   $d418 ; 54296 - Volume and Filter selectv register
                  ;         Bits 0-3: Select output volume (0-15)
                  ;         Bit 4: Select low-pass filter, 1=low-pas on.
                  ;         Bit 5: Select band-pass filter, 1=band-pas on.
                  ;         Bit 6: Select high-pass filter, 1=high-pas on.
                  ;         Bit 7: Disconnect output of voice 3, 1=voice 3 off.
potx    =   $d419 ; 54297 - Read game paddle 1 (or 3) X position.
poty    =   $d41a ; 54298 - Read game paddle 1 (or 3) Y position.
random  =   $d41b ; 54299 - Read oscillator/Random number generator.
env3    =   $d41c ; 54300 - Envelope Generator 3 output.

                  
