;---------------------------------------
; Nom fichier..: e-64map.asm 
; Type fichier.: (seq) equates pour T.M.P.
; Auteur.......: Daniel Lafrance
; Version......: 0.0.1 pour T.M.P. sept 6
; Revision.....: 20251120
;---------------------------------------
; Kernal
;--------------------------------------
chrget = $0073    ;
chrgot = $0079
zp1    = $fb
zp2    = $fd
fascii = $0100
kcol   = $0286
intcgt = $e3bf    ;initialise charget
;---------------------------------------
; VicII
;---------------------------------------
vic      = $d000 ;Debut du VICII
sprtmem  = $0340 ;832
sprtloc  = $07f8 ;2040
vidstart = $2000
vidend   = $3f3f
;--------------------------------------
; Basic
;--------------------------------------
prompt = $abf9    ;prompt ? fill buffer
strout = $ab24    ;Print string at $22
;---------------------------------------
; Codes ecran pour $ffd2 ou puts.
;---------------------------------------
discase  = 8
enacase  = 9
locase   = 14
upcase   = 142
crsdown  = 17
crsright = 29
crsup    = 145
crsleft  = 157
enarevs  = 18
disrevs  = 146
gohome   = 19
clrhome  = 147
delete   = 20
space    = 32
knoir    = 144
korange  = 129
kblanc   = 5
krouge   = 28
kvert    = 30
kbleu    = 31
kbrun    = 149
krose    = 150
kgris1   = 151
kgris2   = 152
kvertp   = 153
kbleup   = 154
kgris3   = 155
kmauve   = 156
kjaune   = 158
kcyan    = 159
;--------------------------------------
