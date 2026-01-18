;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: e-v20float.asm
; Dernière m.à j. : 
; Inspiration ....: 
;------------------------------------------------------------------------------
; e-v20float.asm - Carthographie memoire des fonctions de calcul des nombres à
; virgules flottantes pour le BASIC 2.0 du commodore Vic 20.
;------------------------------------------------------------------------------
; Segmentation principales de la mémoire $c000 - $dfff
;------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "e-v20float.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire 
; que votre programme.
;------------------------------------------------------------------------------
; A D R E S S E S   D E S   E L E M E N T S   E T   F O N C T I O N S
;------------------------------------------------------------------------------
ffpor   =   $cfe6   ; f1=f1 or f2.
ffpand  =   $cfe9   ; f1=f1 and f2.
ff1wrday=   $d1aa   ; f1=word->$aayy                    
ff1swd64=   $d1bf   ; f1=sw(f1)->64
ff1wrd64=   $d1d2   ; f1=uw(f1)->64
fwrdayf1=   $d391   ; $aayy->f1
fiyytf1 =   $d3a2   ; f1=float(y)
ff1evalx=   $d79e   ; eval. expr. f1 to x.
ff1bytxx=   $d7a1   ; f1 to byte in x
ff1to20 =   $d7f7   ; f1 -> int($14,$15)
ff1p05  =   $d849   ; f1=f1+0,5.
ffvsf1  =   $d850   ; f1=fv-f1 ($yyaa)
ff2sf1  =   $d853   ; f1=f2-f1.
ffvpf1  =   $d867   ; f1=fv+f1 ($yyaa)
ff2pf1  =   $d86a   ; f1=f2+f1
fzerof1 =   $d8f7   ; f1=0.0
ff1com2 =   $d947   ; f1=two's compl f1
ff1xfv  =   $da28   ; f1=f1*fv ($yyaa)
ff1xf2  =   $da2b   ; f1=f1*f2
ff1maa  =   $da59   ; f1=f1*.A
ffvtf2  =   $da8c   ; fv $(yyaa) -> f2
ff1x10  =   $dae2   ; f1=f1*10
ff1d10  =   $dafe   ; f1=f1/10
ffvdf1  =   $db0f   ; f1=fv/f1 ($yyaa)
ff2df1  =   $db12   ; f1=f2/f1
ff1t5c  =   $dbc7   ; Copie f1 vers $5c-$60.
ff1t57  =   $dbca   ; copie f1 vers $57-$5b.
ff1t49  =   $dbd0   ; copie f1 vers $49-$4a.
ff1tyx  =   $dbd4   ; Copie f1 mem $yyxx.
ff2tf1  =   $dbfc   ; copie f2 to f1.
ff1tf2r =   $dc0c   ; Copie f1 to f2 avec arrondissement.
ff1tf2  =   $dc0f   ; Copie f1 to f2 sans arrondissement.
ff1rnd  =   $dc1b   ; f1=round(f1). 
fsngf1  =   $dc2b   ; Tester le signe de FAC1.
ff1sign =   $dc39   ; f1=sgn(f1).
fiaatf1 =   $dc3c   ; Conv. .A->F1.
fi62tf1 =   $dc44   ; Conv. mot 16 bits $62,$63 a f1.
ff1abs  =   $dc58   ; f1=abs(f1).
ffvcmp  =   $dc5b   ; f1=f1 comp fv ($yyaa)
ff1tudw =   $dc9b   ; f1-> 32 octets signé ($62-$65)
ff1int  =   $dccc   ; f1=int(f1).
fasctf1 =   $dcf3   ; f1=float(ascii)
ff1pac  =   $dd7e   ; f1=f1+ra val ra=0-9
fiaxtf1 =   $ddcd   ; f1=float($aaxx)+print
ff1tasc =   $dddd   ; f1 to ascii ($yyaa)
ff1sqr  =   $df71   ; f1=sqrt(f1).
ff1ef2  =   $df7b   ; f1=f1^f2
ff1nf1  =   $dfb4   ; f1=-f1.
ffac1cos=   $e261   ; f1=sin(f1+(pi/2)).. FAC1 copié en ram.
ff1cos  =   $e264   ; f1=sin(f1+(pi/2)).
fFAC1sin=   $e26b   ; f1=sin(f1). FAC1 copié en ram.
ff1sin  =   $e26b   ; f1=sin(f1)
fFAC1tan=   $e2b1   ; f1=sin(f1)/cos(f1). FAC1 copié en ram.
ff1tan  =   $e2b4   ; f1=sin(f1)/cos(f1)
ffac1atn=   $e30e   ; ff1=atn(f1). FAC1 copié en ram.
ff1atn  =   $e30e   ; ff1=atn(f1).
