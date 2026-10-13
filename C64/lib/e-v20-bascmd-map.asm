;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: e-v20-bascmd-map.asm
; Dernière m.à j. : 
; Inspiration ....: 
;------------------------------------------------------------------------------
; e-v20-bascmd-map.asm - Carthographie memoire des commandes BASIC 2.0 du
; commodore Vic 20.
;------------------------------------------------------------------------------
; Segmentation principales de la mémoire $c000 - $dfff
;------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "e-v20-bascmd-map.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire 
; que votre programme.
;------------------------------------------------------------------------------
; A D R E S S E S   D E S  C O M M A N D E S   B A S I C  2
;------------------------------------------------------------------------------
bnew    =   $c642   ; Commande BASIC NEW.
bclr    =   $c642   ; Commande BASIC CLR.
blist   =   $c69c   ; Commande BASIC LIST.
bfor    =   $c742   ; Commande BASIC FOR.
brestore=   $c81d   ; Commande BASIC RESTORE.
bbstop  =   $c82f   ; Commande BASIC STOP.
bend    =   $c831   ; Commande BASIC END.
bcont   =   $c857   ; Commande BASIC CONT.
brun    =   $c871   ; Commande BASIC RUN.
bgosub  =   $c883   ; Commande BASIC GOSUB.
bgoto   =   $c8a0   ; Commande BASIC GOTO.
breturn =   $c8d2   ; Commande BASIC RETURN.
bskipst =   $c8f8   ; Commande BASIC DATA.
bif     =   $c928   ; Commande BASIC IF.
brem    =   $c93b   ; Commande BASIC REM.
bon     =   $c94b   ; Commande BASIC ON.
bcmd    =   $ca86   ; Commande BASIC CMD.
bprint  =   $caa0   ; Commande BASIC PRINT.
bprt7   =   $caf8   ; Commande BASIC TAB, SPC commands,
bget    =   $cb7b   ; Commande BASIC GET.
binputn =   $cba5   ; Commande BASIC INPUT#.
binput  =   $cbbf   ; Commande BASIC INPUT.
bread   =   $cc06   ; Commande BASIC READ.
bnext   =   $cd1e   ; Commande BASIC NEXT.
bnot    =   $ced4   ; Commande BASIC NOT.
borr    =   $cfe6   ; Commande BASIC OR.
bandd   =   $cfe9   ; Commande BASIC AND.
bdim    =   $d081   ; Commande BASIC DIM.
bfre    =   $d37d   ; Commande BASIC FRE.
mpos    =   $d39e   ; Commande BASIC POS.
bdef    =   $d3b3   ; Commande BASIC DEF.
bevalfn =   $d3f4   ; Commande BASIC FN.
bstr    =   $d465   ; Commande BASIC STR$.
baddstr =   $d63d   ; Commande BASIC "+", Concaténer des chaines de caractères.
bchr    =   $d6ec   ; Commande BASIC CHR$.
bleft   =   $d700   ; Commande BASIC LEFT$.
bright  =   $d72c   ; Commande BASIC RIGHT$.
bmid    =   $d737   ; Commande BASIC MID$.
blen    =   $d77c   ; Commande BASIC LEN.
basc    =   $d78b   ; Commande BASIC ASC.
bval    =   $d7ad   ; Commande BASIC VAL.
bpeek   =   $d80d   ; Commande BASIC PEEK.
bpoke   =   $d824   ; Commande BASIC POKE.
bwait   =   $d82d   ; Commande BASIC WAIT.
bsub    =   $d853   ; Commande BASIC "-". (Soustraction)
bplus   =   $d86a   ; Commande BASIC "+". (Addition)
blog    =   $d9ea   ; Commande BASIC LOG. (Logatithme)
btimes  =   $da28   ; Commande BASIC "*". (Multiplication)
bdivide =   $db12   ; Commande BASIC "/". (Division)
bsgn    =   $dc39   ; Commande BASIC SGN.
babs    =   $dc58   ; Commande BASIC ABS.
bint    =   $dccc   ; Commande BASIC INT.
bsqr    =   $df71   ; Commande BASIC SQR.
bexpont =   $df7b   ; Commande BASIC Puissance (touche flêche vers le haut).
bnegfac =   $dfb4   ; Commande BASIC - monadique.
bexp    =   $dfed   ; Commande BASIC EXP.
brnd    =   $e094   ; Commande BASIC RND.
bsystem =   $e127   ; Commande BASIC SYS.
bsave   =   $e153   ; Commande BASIC SAVE.
bbverif =   $e162   ; Commande BASIC VERIFY.
bbload  =   $e165   ; Commande BASIC LOAD.
bfopen  =   $e1bb   ; Commande BASIC OPEN.
bfclose =   $e1c4   ; Commande BASIC CLOSE.
bcos    =   $e261   ; Commande BASIC COS.
bsin    =   $e268   ; Commande BASIC SIN.
btan    =   $e2b1   ; Commande BASIC TAN.
batn    =   $e30b   ; Commande BASIC ATN.
