;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance
; Nom du fichier .: e-v20-page0.asm
; Dernière m.à j. : 
; Inspiration ....: 
;------------------------------------------------------------------------------
; e-v20-page0.asm - Carthographie memoire et declaration de constantes 
; pour la page mémoire 0 du commodore Vic 20.
;------------------------------------------------------------------------------
; Segmentation principales de la mémoire
;------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "e-v20-page0.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire 
; que votre programme.
;------------------------------------------------------------------------------
; C O N S T A N T E S   S U R   L E S   E L E M E N T S   I M P O R T A N T S
;------------------------------------------------------------------------------
eot       = $00
kvar1     = $01
kvar2     = $02
channl    = $13
memsiz    = $37     ; WORD: Pointeur vers la fin de la mémoire BASIC.
tmpfp3    = $57     ; 10 octets i.e. 2 fp $57-$5b et $5c-$60
fac1      = $61     ;  5 octets i.e.      $61-$66
fac2      = $69     ;  5 octets i.e.      $69-$6e
chrget    = $73     ; Recup Basic car texte 24 octets i.e. $73-$8a
chrgot    = $79     ;  ...une seconde fois.
chrtst    = $7c
kiostatus = $90     ; Kernal I/O status word (st) (byte) 
verck     = $93     ; 0=LOAD, 1=VERIFY
dfltn     = $99     ; Numéro du périphérique d'entrée actuel.
msgflg    = $9d     ; Indicateur de contrôle des messages du noyau.
time      = $a0     ; 3 octets i.e. HR:$a0, MN:$a1, SC:$a2
curfnlen  = $b7     ; Longueur actuelle du nom de fichier (octets).
la        = $b8     ; Numéro de fichier logique actuel utilisé.
sa        = $b9     ; Adresse secondaire actuellement utilisée.
cursecadd = $b9     ; Adresse secondaire actuellement utilisée. (octet).
fa        = $ba     ; Numéro de périphérique actuel (octet).
curdevno  = $ba     ; Numéro de périphérique actuel (octet).
fnadr     = $bb     ; Pointeur de fichier actuel (mot).
curfptr   = $bb     ; Pointeur de fichier actuel (mot).
stal      = $c1     ; 
memuss    = $c3     ; Pointeur vers la zone de RAM en cours de chargement.(mot)
ndx       = $c6     ; Nombre de caractères (0-10) dans le tampon du clavier.
                    ; Tamppon à 631 ($277)
rvs       = $c7     ; Indicateur pour caractères d'écran inversés.
scrnlin   = $d1     ; pnt cur-scrn-line
tblx      = $d6     ; Curseur : numéro de la ligne physique actuelle sur 
                    ; laquelle se trouve le curseur à l’écran.
zp1       = $fb     ; 1er Zpage prog. usager address (word)
zpage1    = $fb     ; zero page 1 
zp2       = $fd     ; 2em Zpage prog. usager address (word)
zpage2    = $fd     ; zero page 2 address (word)
;------------------------------------------------------------------------------