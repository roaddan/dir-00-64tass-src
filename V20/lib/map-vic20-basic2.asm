;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; c64_bas2map.asm - Carthographie memoire et declaration de constantes pour les
; le Basic 2.0 du commodores 64 et 64c
;--------------------------------------------------------------------------------
; Scripteur...: daniel lafrance, j5w 1w5, canada.
; Version.....: 20191223.1
; Inspiration.: isbn 0-9692086-0-X
; Auteur......: Karl J.H. Hildon
;--------------------------------------------------------------------------------
; Segmentation principales de la mémoire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "c64_bas2map.s"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;--------------------------------------------------------------------------------
; Macro sur les elements importants (* = called by)
;--------------------------------------------------------------------------------
; Basic 2.0 entry point
;--------------------------------------------------------------------------------
;fname        = Addr  ; ##) Description. Register used->;INP;OUT;
b_opentxtspc  = $c3bb ;  1) Open space in BASIC text.   ;a-y;---; Array top $yyaa
b_chkavailmem = $c408 ;  2) Check available Memory. *1  ;a-y;---; Array top $yyaa
b_outofmem    = $c435 ;  3) ?Out of memory.             ;---;---;        
b_errormesg   = $c437 ;  4) Send BASIC error message.   ;a--;---; a = errno
b_warmstart   = $e467 ;  5) Basic warm start.           ;---;---;
b_chrget      = $c48a ;  6) Main CHRGET entry.          ;---;---; 
                      ;     Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                   ($77,$78),
                      ;                   $01ff=Basic inbuf-1
b_newline     = $c49c ;  7) Crunch tokens, insert line. ;-x-;---; x = buff len
b_clrready    = $c52a ;  8) Fix chaining CLR and READY. ;---;---;
b_fixchaining = $c533 ;  9) Fix chaining.               ;---;---;
b_kbgetline   = $c560 ; 10) Recieve line from keyboard.
                      ;     Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                    ($77,$78),
                      ;                    $01ff=Basic inbuf-1
b_crunchtkns  = $c579 ; 11) Crunch token. *7            ;-x-;---: x = buff len
b_findline    = $c613 ; 12) Find line in BASIC.         ;ax-;---; strBAS = $xxaa
b_new         = $c642 ; 13) Do NEW                      ;---;---;
b_resetclr    = $c659 ; 14) Reset BASIC and do CLR      ;---;---; 
b_clr         = $c65e ; 15) Do CLR                      ;---;---;
;Not in BASIC 2 $xxxx ; 16) Purge Stack of all return values
b_rstchrget   = $c68e ; 17) Rst CHRGET to BASIC start   ;---;a--; strBAS hi
b_continue    = $c857 ; 18) Do CONTINUE.                ;a-y;---; curline $yyaa
b_getint      = $c96b ; 19) Get int from BASIX text.    ;---;---;
                      ;     Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                    ($77,$78),
b_sndcr       = $cad3 ; 20) Send RETURN, LF in scr mode.;---;a--; a = LF
b_sndcrlf     = $cad7 ; 21) Send RETURN, LINEFEED.      ;---;a--; a = LF
b_outstr_ay   = $cb1e ; 22) Print string from $yyaa.    ;a-y;---; sptr = $yyaa
b_puts        = b_outstr_ay
b_outstrprep  = $cb24 ; 23) Print precomputated string. ;a--;---; a = strlen
                      ;     Prerequisit: str addr in $22,$23 ($1f,$20)
b_printqm     = $cb45 ; 24) Print '?'.                  ;---;---;                      
b_sendchar    = $cb47 ; 25) Send char in a to device.   ;a--;a--; a = char                      
b_frmnum      = $cd8a ; Evaluate numeric expression and/or check for data type mismatch
b_evalexpr    = $cd9e ; 26) Evaluate expression.                      
                      ; Prerequisit: Addr of expr in CHRGET ptr.             
                      ; Result: string  $0d = #$FF ($07);---;a-y; expaddr = $yyaa               
                      ;         numeric $0d = #$00 ($07);---;a--; a = result
b_chk4comma   = $cefd ; 27) Check for coma.             ;---;a--; a = char
b_chk4lpar    = $cefa ; 28) check for '('.              ;---;a--; a = char
b_chk4rpar    = $cef7 ; 29) check for ')'.              ;---;a--; a = char
b_syntaxerr   = $cf08 ; 30) send 'SYNTAX ERROR'.        ;---;---;
b_fndfloatvar = $b0e7 ; 31) find float var by name.     ;---;a-y; addr = $yyaa
                      ; Prerequisit : name in $45,$46 ($42,$43)
b_bumpvaraddr = $b185 ; 32) Bumb var addr by 2. *31     ;---;a-y; addr = $yyaa
                      ;     Prerequisit : name in $45,$46 ($42,$43).
b_float2int   = $b1bf ; 33) Float to int in Acc#1.      ;---;---;
b_fcerr       = $b248 ; Print ILLEGAL QUANTITY error message.
b_int2float   = $b391 ; 34) Int to float in Acc#1.      ;---;---;
b_getacc1lsb  = $b79e ; 35) Get Acc#1 LSB in x.         ;---;-x-; x = Acc#1 LSB
b_str2float   = $b7b5 ; 36) Evaluate str to float (VAL) ;---;---;
                      ;     Prerequisit : Straddr in CHRGET ptr.
                      ;     Result : Float in Acc#1.
b_strxy2float = $b7b9 ; 37) Eval. float from str in xy. ;---;-xy; strptr = $yyxx
                      ; Result : Float in Acc#1.
b_getpokeprms = $b7eb ; 38) Get 2 params for POKE, WAIT.;---;-x-; x = Param2
                      ;     Prerequisit : Straddr in CHRGET ptr.  
                      ;     Result : param2 in Acc#1.
b_getadr      = $b7f7 ; Convert Floating point number to an Unsighed TwoByte Integer.                      
b_memfloatadd = $b867 ; 39) Add from memory.            ;a-y;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1.
b_memfloatmul = $ba28 ; 40) Multiply from memory.       ;a-y;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1.
b_acc1mul10   = $bae2 ; 41) Multiply Acc#1 by 10.       ;---;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1.
b_memvar2acc1 = $bba2 ; 42) Unpack mem var to Acc#1.    ;a-y;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1
b_copyacc12xy = $bbd7 ; 43) Copy Acc#1 to mem location. ;-xy;---; ptr = $yyxx
b_acc2toacc1  = $bbfc ; 44) Move Acc#2 to Acc#1.        ;---;---;  
b_rndac1ac2   = $bc0c ; 45) Move rnd Acc#1 to Acc#2.    ;---;---;  
b_urndac1ac2  = $bc0f ; 46) Move unrnd Acc#1 to Acc#2.  ;---;---;  
b_rndac1      = $bc1b ; 47) Round Acc#1.                ;---;---;  
b_putint      = $bdcd ; 48) Print fix point value.      ;ax-;---; Value = $xxaa 
b_putfloat    = $bdd7 ; 49) Print Acc#1 float.          ;---;---;
b_num2str     = $bddd ; 50) Cnv num to str at $0100. *48;a-y;---; a=#$00, y=#$01
