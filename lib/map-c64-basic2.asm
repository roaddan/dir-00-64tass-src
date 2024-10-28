;--------------------------------------------------------------------------------
; map-c64-basic2.asm - Carthographie memoire et declaration de constantes pour
; le Basic 2.0 du commodores 64 et 64c
;--------------------------------------------------------------------------------
; Scripteur...: daniel lafrance, G9B0S5, Canada.
; Version.....: 20230610-223618
; Inspiration.: isbn 0-9692086-0-X
; Auteur......: Karl J.H. Hildon
;--------------------------------------------------------------------------------
; Segmentation principales de la mémoire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass utilisez
; la syntaxes ...
;
;         .include "map-c64-basic2.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;--------------------------------------------------------------------------------
; Screen commands to run with basic print or call to $ffd2 in machine language.
;--------------------------------------------------------------------------------
; Colours
;--------------------------------------------------------------------------------
b_black        =    144  ;0,  ctrl-1
b_white        =    5    ;1,  ctrl-2
b_red          =    28   ;2,  ctrl-3
b_cyan         =    159  ;3,  ctrl-4
b_purple       =    156  ;4,  ctrl-5
b_green        =    30   ;5,  ctrl-6
b_blue         =    31   ;6,  ctrl-7
b_yellow       =    158  ;7,  ctrl-8
b_orange       =    129  ;8,  C=-1
b_brown        =    149  ;9,  C=-2
b_ltred        =    150  ;10, C=-3
b_gray3        =    155  ;11, C=-4
b_grey3        =    155  ;11, C=-4
b_gray2        =    152  ;12, C=-5
b_grey2        =    152  ;13, C=-5
b_ltgreen      =    153  ;13, C=-6
b_ltblue       =    154  ;14, C=-7
b_gray1        =    151  ;15, C=-8
b_grey1        =    151  ;15, C=-8
;--------------------------------------------------------------------------------
; Charactersets
;--------------------------------------------------------------------------------
b_rvs_on       =    18   ;    ctrl-9
b_rvs_off      =    146  ;    ctrl-0
b_lowercase    =    14
b_uppercase    =    142
;--------------------------------------------------------------------------------
; Cursor movement
;--------------------------------------------------------------------------------
b_crsr_up      =    145
b_crsr_down    =    17
b_crsr_left    =    157
b_crsr_right   =    29
b_home         =    19
b_clr_home     =    147
b_insert       =    20
b_shft_ret     =    141
b_delete       =    148
;--------------------------------------------------------------------------------
; Function keys
;--------------------------------------------------------------------------------
b_f1           =    133
b_f2           =    137
b_f3           =    134
b_f4           =    138
b_f5           =    135
b_f6           =    139
b_f7           =    136
b_f8           =    140
;--------------------------------------------------------------------------------
; Other function
;--------------------------------------------------------------------------------
b_dis_cmd      =    8
b_ena_cmd      =    9
;--------------------------------------------------------------------------------
; Box design available in all characterset
;--------------------------------------------------------------------------------
b_ul           =    172
b_ur           =    187
b_ll           =    188
b_lr           =    190
b_vl           =    182
b_vr           =    181
b_bo           =    184
b_to           =    185
;--------------------------------------------------------------------------------
; Others
;--------------------------------------------------------------------------------
b_eot          =    $00
b_inpbuff      =    $0200
b_crlf         =    $0d
b_space        =    $20
b_fac1         =    $61
b_fac2         =    $69
;--------------------------------------------------------------------------------
; Macro sur les elements importants (* = called by)
;--------------------------------------------------------------------------------
; Basic 2.0 entry point
;--------------------------------------------------------------------------------
;fname         = Addr  ; Description. Register used->;INP;OUT;
b_opentxtspc   = $a3bb ; Open space in BASIC text.   ;a-y;---; Array top $yyaa
b_chkavailmem  = $a408 ; Check available Memory. *1  ;a-y;---; Array top $yyaa
b_outofmem     = $a435 ; ?Out of memory.             ;---;---;        
b_errormesg    = $a437 ; Send BASIC error message.   ;a--;---; a = errno
b_warmstart    = $a474 ; Basic warm start.           ;---;---;
b_chrgetentry  = $a48a ; Main CHRGET entry.          ;---;---; 
                       ; Prerequizite : $7a=#$ff,$7b=#$01, 
                       ;                ($77,$78),
                       ;                $01ff=Basic inbuf-1
b_newline      = $a49c ; Crunch tokens, insert line. ;-x-;---; x = buff len
b_clrready     = $a52a ; Fix chaining CLR and READY. ;---;---;
b_fixchaining  = $a533 ; Fix chaining.               ;---;---;
b_kbgetline    = $a560 ; Recieve line from keyboard.
                       ; Prerequizite : $7a=#$ff,$7b=#$01, 
                       ;                ($77,$78),
                       ;                $01ff=Basic inbuf-1
b_crunchtkns   = $a579 ; Crunch token. *7            ;-x-;---: x = buff len
b_findline     = $a613 ; Find line in BASIC.         ;ax-;---; strBAS = $xxaa
b_new          = $a642 ; Do NEW                      ;---;---;
b_resetclr     = $a659 ; Reset BASIC and do CLR      ;---;---; 
b_clr          = $a65e ; Do CLR                      ;---;---;
;Not in BASIC  2 $xxxx ; Purge Stack of all return values
b_rstchrget    = $a68e ; Rst CHRGET to BASIC start   ;---;a--; strBAS hi
b_continue     = $a857 ; Do CONTINUE.                ;a-y;---; curline $yyaa
b_getint       = $a96b ; Get int from BASIX text.    ;---;---;
                       ; Prerequizite : $7a=#$ff,$7b=#$01, 
                       ;                ($77,$78),
b_sndcr        = $aad3 ; Send RETURN, LF in scr mode.;---;a--; a = LF
b_sndcrlf      = $aad7 ; Send RETURN, LINEFEED.      ;---;a--; a = LF
b_outstr_ay    = $ab1e ; Print string from $yyaa.    ;a-y;---; sptr = $yyaa
b_puts         = b_outstr_ay
b_outstrprep   = $ab24 ; Print precomputated string. ;a--;---; a = strlen
                       ; Prerequisit: str addr in $22,$23 ($1f,$20)
b_printqm      = $ab45 ; Print '?'.                  ;---;---;                      
b_sendchar     = $ab47 ; Send char in a to device.   ;a--;a--; a = char                      
b_intobuff     = $abf9 ; Input characters from std in anf write to buff. at $200.
b_frmnum       = $ad8a ; Evaluate numeric expression and/or check for data type mismatch
b_evalexpr     = $ad9e ; Evaluate expression.                      
                       ; Prerequisit: Addr of expr in CHRGET ptr.             
                       ; Result: string  $0d = #$FF ($07);---;a-y; expaddr = $yyaa               
                       ;         numeric $0d = #$00 ($07);---;a--; a = result
b_chk4comma    = $aefd ; Check for coma.             ;---;a--; a = char
b_chk4lpar     = $aefa ; check for '('.              ;---;a--; a = char
b_chk4rpar     = $aef7 ; check for ')'.              ;---;a--; a = char
b_syntaxerr    = $af08 ; send 'SYNTAX ERROR'.        ;---;---;
b_fort         = $afe6 ; FAC1 = FAC1 or FAC2.
b_fandt        = $afe9 ; FAC1 = FAC1 and FAC2.
b_fndfloatvar  = $b0e7 ; find float var by name.     ;---;a-y; addr = $yyaa
                       ; Prerequisit: name in $45,$46 ($42,$43)
b_bumpvaraddr  = $b185 ; Bumb var addr by 2. *31     ;---;a-y; addr = $yyaa
                       ;     Prerequisit : name in $45,$46 ($42,$43).
b_ftoint       = $b1aa ; FAC1 to word in $aayy       ;---;a-y; imt = $aayy
b_float2int    = $b1bf ; FAC1 to int in $64(lsb),$65(msb).
                       ; Only if FAC1 between -32768 and +32767.
b_num2int      = $b1d2 ; Converts float num expr to int in $64(lsb),$65(msb). 
b_fcerr        = $b248 ; Print ILLEGAL QUANTITY error message.
b_int2float    = $b391 ; Int to float in Acc#1.      ;---;---;
b_ytofac1      = $b3a2 ; Convert int(y) to FAC1.     ;--y;---;
b_getacc1lsb   = $b79e ; Get Acc#1 LSB in x.         ;---;-x-; x = Acc#1 LSB
b_fac1tox      = $b7a1 ; Conv FAC1 to byte in x.     ;---;-x-; x = byte
b_str2float    = $b7b5 ; Evaluate str to float (VAL) ;---;---;
                       ; Prerequisit: Straddr in CHRGET ptr.
                       ; Result: Float in Acc#1.
b_strxy2float  = $b7b9 ; Eval. float from str in xy. ;---;-xy; strptr = $yyxx
                       ; Result: Float in Acc#1.
b_evfint2x     = $b7e9 ; Conv FAC1 to byte in x.     ;---;-x-; x = byte  
b_getpokeprms  = $b7eb ; Get 2 params for POKE, WAIT.;---;-x-; x = Param2
                       ; Prerequisit: Straddr in CHRGET ptr.  
                       ; Result: param2 in Acc#1.
b_getadr       = $b7f7 ; Convert Floating point number to an Unsighed TwoByte Integer.
b_faddh        = $b849 ; FAC1 = FAC1 + 0.5 
b_fsub         = $b850 ; FAC1 = FVAR - FAC1.         ;a-y;---; ptr = $yyaa
b_fsubt        = $b853 ; FAC1 = FAC2 - FAC1.         ;---;---;                      
b_fadd         = $b867 ; FAC1 = FVAR + FAC1.         ;a-y;---; ptr = $yyaa                
b_memfloatadd  = $b867 ; Add from memory.            ;a-y;---; ptr = $yyaa
b_faddt        = $b86a ; FAC1 = FAC2 + FCA1 
b_f2addf1      = $b86a ; FAC1 = FAC2 + FCA1
b_fcomp2       = $b947 ; FAC1 = INV(FAC1) + 1
b_fmulv        = $ba28 ; FCA1 = FAC1 * FVAR.         ;a-y;---; ptr = $yyaa
b_memfloatmul  = $ba28 ; Multiply from memory.       ;a-y;---; ptr = $yyaa
b_fmult        = $ba2b ; FAC1 = FAC1 * FAC2
b_conupk       = $ba8c ; Copy FVAR to FAC2.          ;a-y;---; ptr = $yyaa
b_mul10        = $bae2 ; FAC1 = FAC1 * 10.
b_acc1mul10    = $bae2 ; Multiply Acc#1 by 10.       ;---;---; ptr = $yyaa
B_fdiv10       = $bafe ; FAC1 = FAC1 / 10.
b_fdiv         = $bb0f ;                      
b_vdivf        = $bb0f ; FAC1 = FVAR / FAC1.         ;a-y;---; ptr = $yyaa
b_fdivt        = $bb12 ; FAC1 = FAC2 / FAC1.
b_movfm        = $bba2 ; Copy FVAR to FAC1.          ;a-y;---; ptr = $yyaa
b_memvar2acc1  = $bba2 ; Unpack mem var to Acc#1.    ;a-y;---; ptr = $yyaa
b_cpfac1tow2   = $bbc7 ; Copy FAC1 to WORK#2 ($5c-$60)
b_cpfac1tow1   = $bbca ; Copy FAC1 to WORK#1 ($57-$5b)
b_cpfac1to49   = $bbd0 ; Copy FAC1 to FORPNT ($49-$4a)
b_fac1toaddr   = $bbd4 ; Copy FAC1 to memory.        ;-xy;---; ptr = $yyxx
b_cpfac1toxy   = $bbd7 ; Copy Acc#1 to mem location. ;-xy;---; ptr = $yyxx
b_movfa        = $bbfc ; 
b_acc2toacc1   = $bbfc ; Copy Acc#2 to Acc#1.        ;---;---; 
b_fac1sign     = $bc2b ; Check sign of FAC1
b_sgn          = $bc39 ; FAC1 = SIGN(FAC1)
b_atofac1      = $bc3c ; Convert int a to FAC1       ;a--;---; a = int 
b_int2fac1     = $bc44 ; $62(lsb),$63(msb) int to FAC1
b_abs          = $bc58 ; FAC1 = ABS(FAC1)
b_fcomp        = $bc5b ; FAC1 = FAC1 comp(FVAR).     ;a-y;---; ptr = $yyaa
b_movaf        = $bc0c ;
b_rndac1ac2    = $bc0c ; Move rnd Acc#1 to Acc#2.    ;---;---;  
b_urndac1ac2   = $bc0f ; Move unrnd Acc#1 to Acc#2.  ;---;---;  
b_round        = $bc1b ;
b_rndac1       = $bc1b ; Round Acc#1.                ;---;---; 
b_qint         = $bc9b ; Converts FAC1 to int in FAC1.
b_int          = $bccc ; FAC1 = INT(FAC1)
b_fin          = $bcf3 ; Conv. ascii dec num to FAC1,
b_addf1acc     = $bd7e ; Add Acc to FAC1 (a=0-9)     ;a--;---;
b_linptr       = $bdcd ; Print fix point value.      ;ax-;---; Value = $xxaa  
b_putint       = $bdcd ; Print fix point value.      ;ax-;---; Value = $xxaa 
b_putfloat     = $bdd7 ; Print Acc#1 float.          ;---;---;
b_fout         = $bddd ;
b_num2str      = $bddd ; Cnv num to str at $0100. *48;a-y;---; a=#$00, y=#$01
b_sqr          = $bf71 ; FAC1 = SQRT(FAC1).
b_fpwrt        = $bf7b ; FAC1 = FAC1 ^ FAC2. 
b_poly2        = $e059 ; Ploynomial evaluation
b_initcgt      = $e3bf ; Initialize all Basic zero page fixed value lication.   

;--------------------------------------------------------------------------------
; Equates pour le livre Tool Kit: basic
;--------------------------------------------------------------------------------
b_axout        = $bdcd ; Print fix point value.      ;ax-;---; Value = $xxaa 
b_intcgt       = $e3bf ; Initialize all Basic zero page fixed value lication.
b_ascflt       = $bcf3 ; Conv. ascii dec num to FAC1,
b_prompt       = $abf9 ; Input characters from std in anf write to buff. at $200.   
b_chrget       = $0073
b_chrgot       = $0079
b_facasc       = $bddd ; Cnv num to str at $0100. *48;a-y;---; a=#$00, y=#$01
b_vftf1        = $bba2 ; Copy FVAR to FAC1.          ;a-y;---; ptr = $yyaa
b_strout       = $ab24 ; Print precomputated string. ;a--;---; a = strlen
b_f1t57        = $bbca ; Copy FAC1 to WORK#1 ($57-$5b)
b_f1xfv        = $ba28 ; Multiply from memory.       ;a-y;---; ptr = $yyaa
b_f1tmem       = $bbd4 ; Copy FAC1 to memory.        ;-xy;---; ptr = $yyxx
b_f1x10        = $bae2 ; Multiply Acc#1 by 10.       ;---;---; ptr = $yyaa
b_f1d10        = $bafe ; FAC1 = FAC1 / 10.
b_sgnf1        = $bc2b ; Check sign of FAC1
b_f1tf2        = $bc0c ; Move rnd Acc#1 to Acc#2.    ;---;---;  
b_f1xf2        = $ba2b ; FAC1 = FAC1 * FAC2
b_fvdf1        = $bb0f ; FAC1 = FVAR / FAC1.         ;a-y;---; ptr = $yyaa
b_memtf2       = $ba8c ; Copy FVAR to FAC2.          ;a-y;---; ptr = $yyaa
b_f2df1        = $bb12 ; FAC1 = FAC2 / FAC1.
b_f1pfv        = $b867 ; FAC1 = FAC1 + FVAR.         ;a-y;---; ptr = $yyaa 
b_f2sf1        = $b853 ; FAC1 = FAC2 - FAC1.         ;---;---;  
b_fvsf1        = $b850 ; FAC1 = FVAR - FAC1.         ;a-y;---; ptr = $yyaa 
b_f1pacc       = $bd7e ; Add Acc to FAC1 (a=0-9)     ;a--;---;
b_f1pf2        = $b86a ; FAC1 = FAC2 + FCA1 
b_expon        = $bf7b ; FAC1 = FAC1 ^ FAC2.  
b_fpand        = $afe9 ; FAC1 = FAC1 and FAC2.
b_f1orf2       = $afe6 ; FAC1 = FAC1 or FAC2.
b_sqrtf1       = $bf71 ; FAC1 = SQRT(FAC1).
b_intf1        = $bccc ; FAC1 = INT(FAC1)
b_f1t5c        = $bbc7 ; Copy FAC1 to WORK#2 ($5c-$60)
b_f1cfv        = $bc5b ; FAC1 = FAC1 comp(FVAR).     ;a-y;---; ptr = $yyaa  
b_f1tx         = $b7a1 ; Conv FAC1 to byte in x.     ;---;-x-; x = byte
b_fltay        = $b1aa ; FAC1 to word in $aayy       ;---;a-y; imt = $aayy
b_ytfl1        = $b3a2 ; Convert int(y) to FAC1.     ;--y;---;
b_poly         = $e059 ; Ploynomial evaluation