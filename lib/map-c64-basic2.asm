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
;fname        = Addr  ; Description. Register used->;INP;OUT;
b_opentxtspc  = $a3bb ; Open space in BASIC text.   ;a-y;---; Array top $yyaa
b_chkavailmem = $a408 ; Check available Memory. *1  ;a-y;---; Array top $yyaa
b_outofmem    = $a435 ; ?Out of memory.             ;---;---;        
b_errormesg   = $a437 ; Send BASIC error message.   ;a--;---; a = errno
b_warmstart   = $a474 ; Basic warm start.           ;---;---;
b_chrget      = $a48a ; Main CHRGET entry.          ;---;---; 
                      ; Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                ($77,$78),
                      ;                $01ff=Basic inbuf-1
b_newline     = $a49c ; Crunch tokens, insert line. ;-x-;---; x = buff len
b_clrready    = $a52a ; Fix chaining CLR and READY. ;---;---;
b_fixchaining = $a533 ; Fix chaining.               ;---;---;
b_kbgetline   = $a560 ; Recieve line from keyboard.
                      ; Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                ($77,$78),
                      ;                $01ff=Basic inbuf-1
b_crunchtkns  = $a579 ; Crunch token. *7            ;-x-;---: x = buff len
b_findline    = $a613 ; Find line in BASIC.         ;ax-;---; strBAS = $xxaa
b_new         = $a642 ; Do NEW                      ;---;---;
b_resetclr    = $a659 ; Reset BASIC and do CLR      ;---;---; 
b_clr         = $a65e ; Do CLR                      ;---;---;
;Not in BASIC 2 $xxxx ; Purge Stack of all return values
b_rstchrget   = $a68e ; Rst CHRGET to BASIC start   ;---;a--; strBAS hi
b_continue    = $a857 ; Do CONTINUE.                ;a-y;---; curline $yyaa
b_getint      = $a96b ; Get int from BASIX text.    ;---;---;
                      ; Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                ($77,$78),
b_sndcr       = $aad3 ; Send RETURN, LF in scr mode.;---;a--; a = LF
b_sndcrlf     = $aad7 ; Send RETURN, LINEFEED.      ;---;a--; a = LF
b_outstr_ay   = $ab1e ; Print string from $yyaa.    ;a-y;---; sptr = $yyaa
b_puts        = b_outstr_ay
b_outstrprep  = $ab24 ; Print precomputated string. ;a--;---; a = strlen
                      ; Prerequisit: str addr in $22,$23 ($1f,$20)
b_printqm     = $ab45 ; Print '?'.                  ;---;---;                      
b_sendchar    = $ab47 ; Send char in a to device.   ;a--;a--; a = char                      
b_frmnum      = $ad8a ; Evaluate numeric expression and/or check for data type mismatch
b_evalexpr    = $ad9e ; Evaluate expression.                      
                      ; Prerequisit: Addr of expr in CHRGET ptr.             
                      ; Result: string  $0d = #$FF ($07);---;a-y; expaddr = $yyaa               
                      ;         numeric $0d = #$00 ($07);---;a--; a = result
b_chk4comma   = $aefd ; Check for coma.             ;---;a--; a = char
b_chk4lpar    = $aefa ; check for '('.              ;---;a--; a = char
b_chk4rpar    = $aef7 ; check for ')'.              ;---;a--; a = char
b_syntaxerr   = $af08 ; send 'SYNTAX ERROR'.        ;---;---;
b_fndfloatvar = $b0e7 ; find float var by name.     ;---;a-y; addr = $yyaa
                      ; Prerequisit: name in $45,$46 ($42,$43)
b_bumpvaraddr = $b185 ; Bumb var addr by 2. *31     ;---;a-y; addr = $yyaa
                      ;     Prerequisit : name in $45,$46 ($42,$43).
b_float2int   = $b1bf ; Float to int in Acc#1.      ;---;---;
b_fcerr       = $b248 ; Print ILLEGAL QUANTITY error message.
b_int2float   = $b391 ; Int to float in Acc#1.      ;---;---;
b_getacc1lsb  = $b79e ; Get Acc#1 LSB in x.         ;---;-x-; x = Acc#1 LSB
b_str2float   = $b7b5 ; Evaluate str to float (VAL) ;---;---;
                      ; Prerequisit: Straddr in CHRGET ptr.
                      ; Result: Float in Acc#1.
b_strxy2float = $b7b9 ; Eval. float from str in xy. ;---;-xy; strptr = $yyxx
                      ; Result: Float in Acc#1.
b_getpokeprms = $b7eb ; Get 2 params for POKE, WAIT.;---;-x-; x = Param2
                      ; Prerequisit: Straddr in CHRGET ptr.  
                      ; Result: param2 in Acc#1.
b_getadr      = $b7f7 ; Convert Floating point number to an Unsighed TwoByte Integer.                      
b_memfloatadd = $b867 ; Add from memory.            ;a-y;---; ptr = $yyaa
                      ; Result: floar result in Acc#1.
b_memfloatmul = $ba28 ; Multiply from memory.       ;a-y;---; ptr = $yyaa
                      ; Result: floar result in Acc#1.
b_acc1mul10   = $bae2 ; Multiply Acc#1 by 10.       ;---;---; ptr = $yyaa
                      ; Result: floar result in Acc#1.
b_memvar2acc1 = $bba2 ; Unpack mem var to Acc#1.    ;a-y;---; ptr = $yyaa
                      ; Result: floar result in Acc#1
b_copyacc12xy = $bbd7 ; Copy Acc#1 to mem location. ;-xy;---; ptr = $yyxx
b_acc2toacc1  = $bbfc ; Move Acc#2 to Acc#1.        ;---;---;  
b_rndac1ac2   = $bc0c ; Move rnd Acc#1 to Acc#2.    ;---;---;  
b_urndac1ac2  = $bc0f ; Move unrnd Acc#1 to Acc#2.  ;---;---;  
b_rndac1      = $bc1b ; Round Acc#1.                ;---;---;  
b_putint      = $bdcd ; Print fix point value.      ;ax-;---; Value = $xxaa 
b_putfloat    = $bdd7 ; Print Acc#1 float.          ;---;---;
b_num2str     = $bddd ; Cnv num to str at $0100. *48;a-y;---; a=#$00, y=#$01
