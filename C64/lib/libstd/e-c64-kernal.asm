;-----------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-kernal.asm
; Cernière m.à j. : 20261025-001445
; Inspiration ....: 
;-----------------------------------------------------------------------------
; c64_map.asm - Carthographie memoire et declaration de constantes pour les
; commodores 64 et 64c
;-----------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass 
; utilisez la syntaxes ...
;
;         .include "c64_map.s"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire 
; que votre programme.
;-----------------------------------------------------------------------------
;* macro sur les elements importants *
;-----------------------------------------------------------------------------
u6510ddr    =  $00   ; 0      6510 Données de direction du port 
                     ;        ... (défaut: %xx101111), (0=input, 1=output)
u6510map    =  $01   ; 1      6510 port utilisé comme registre de
                     ;        ... cartographie mémoire.
                     ;        bit-0 LORAM sélectionne ROM ou RAM à $a000
                     ;           1=Basic ROM, 0=RAM          
                     ;        bit-1 HIRAM sélectionne ROM ou RAM à $e000
                     ;           1=Kernal ROM, 0=RAM          
                     ;        bit-2 CHARGEN signal
                     ;           1=Périphérique I/O, 0=CharRom          
                     ;        bit-3 Sortie ligne (DATA Out)          
                     ;        bit-4 Détection de bouton de cassette
                     ;           0=Appuyé, 1=Relaché          
                     ;        bit-5 Commande du moteur de la cassette
                     ;           1=Moteur en marche, 0=Moteur arrêté.
                     ;        bit-6 Non utilisée.
                     ;        bit-7 Non utilisée.
unused2     =  $02   ; 2      Non utilisée.                
adray1      =  $03   ; 3-4    Routine permettant de convertir un nombre en
                     ;        ... virgule flottante en un entier signé.                                            
adray2      =  $05   ; 5-6    Routine permettant de convertir un nombre 
                     ;        ... entier en nombre à virgule flottante.
b_charac    =  $07   ; 7      Recherche de caractère pour l'analyse d'une
                     ;        ...  saisie de texte en BASIC.
b_endchr    =  $08   ; 8      Recherche de caractère pour l'analyse du 
                     ;        ... terminateur ou du guillemet d'une 
                     ;        ... instruction BASIC.
b_trmpos    =  $09   ; 9      Position de colonne du curseur avant la
                     ;        ... dernière tabulation ou le dernier espace.
verck       =  $0a   ; 10     Drapeau: 0 = Charger ou 1 = Vérifier
b_count     =  $0b   ; 11     Index dans le tampon de texte / Nombre d'indices
                     ;        ... de tableau.
dimflg      =  $0c   ; 12     Indicateurs pour une routine qui localise ou
                     ;        ... construit un tableau.
valtyp      =  $0d   ; 13     Drapeau: Type de donnée ($ff = chaîne ou
                     ;        ... $00 = numérique)
intflg      =  $0e   ; 14     Type de donnée numérique 
                     ;        ... ($80= entier ou $00= nombre point flottant)
garbfl      =  $0f   ; 15     Marquage pour les listes, ramasse-miettes 
                     ;        ... (garbage collection) et tokenisation de 
                     ;        ... programmes.
subflg      =  $10   ; 16     Drapeau: Référence indicée à un tableau ou
                     ;        ... appel à une fonction définie par 
                     ;        ... l'utilisateur (FN).
inpflg      =  $11   ; 17     Drapeau: Données fournies à GET, READ ou INPUT.
                     ;        ... (98$=LECTURE, 40$=OBTENTION, 00$=ENTRÉE)                                                                     
tansgn      =  $12   ; 18     Drapeau: Signe du résultat de TAN ou SIN.
channl      =  $13   ; 19     Numéro du canal d’E/S courant 
                     ;        ... (fichier logique CMD).
linnum      =  $14   ; 20-21  Nombre entièr correspondant à un # de ligne.
temppt      =  $16   ; 22     Pointeur vers l'emplacement suivant dans la pile
                     ;        ... de chaînes temporaires.
lastpt      =  $17   ; 23-24  Pointeur vers la dernière chaîne dans la pile
                     ;       ... de chaînes temporaires.
txttab      =  $2b   ; 43-44  Pointeur de début du texte d'un programme BASIC.
vartab      =  $2d   ; 45-46  Pointeur de début de la zone des variables BASIC.
arytab      =  $2f   ; 47-48  Pointeur de début de la zone des tableaux BASIC.
strebd      =  $31   ; 49-50  Pointeur+1 de FIN de la zone des tableaux BASIC.
                     ;        ... et vers le début de la mémoire (RAM) libre.
fretop      =  $33   ; 51-52  Pointeur de bas de la zone de texte.
frespc      =  $35   ; 53-54  Pointeur temporaire pour chaîne de caractères.
memsiz      =  $37   ; 55-56  Pointeur d'adresse la plus élevée utilisée par 
                     ;        ... BASIC.
curlib      =  $39   ; 57-58  Numéro de ligne BASIC actuel.
oldlin      =  $3b   ; 59-60  Numéro de ligne BASIC précédent.
oldtxt      =  $3d   ; 61-62  Pointeur vers l'adresse de l'instruction BASIC 
                     ;        ... en cours.
datlin      =  $3f   ; 63-64  Numéro de ligne DATA actuel.
datptr      =  $41   ; 65-66  Pointeur vers l'adresse de l'élément de données
                     ;        ... (DATA) actuel.
impptr      =  $43   ; 67-68  Pointeur de la source des informations pour GET,
                     ;        ... READ ou INPUT.
varnam      =  $45   ; 69-70  Nom de la variable BASIC actuelle.
varpnt      =  $47   ; 71-72  Pointeur vers la valeur actuelle d'une variable BASIC.
forpnt      =  $49   ; 73-74  Pointeur temporaire vers la variable d'index utilisée par une boucle FOR.
opptr       =  $4b   ; 75-76  Déplacement dans la table des opérateurs mathématiques.
opmask      =  $4d   ; 77     Masque pour opération de comparaison.
defpnt      =  $4e   ; 78-79  Pointeur vers le descripteur FN actuel.
dscpnt      =  $50   ; 80-82  Pointeur temporaire vers le descripteur de 
                     ;        ... chaîne actuel.
                     ; 80-81  Pointeur vers une chaîne de caractères.
                     ; 82     Longueur de chaîne.
four6       =  $53   ; 83     Constante du ramasseur d'ordures.
jmper       =  $54   ; 84-86  Passer à l'instruction de fonction.
fac1        =  $61   ; 97-102 Accumulateur en virgule flottante n° 1
chrget      =  $73   ; 115
chrgot      =  $79   ; 121
kiostatus   =  $90   ; 144    Mot d'état d'E/S du noyau (st) (octet). 
curfnlen    =  $b7   ; 183    Longueur actuelle du nom de fichier (octets).
cursecadd   =  $b9   ; 185    Adresse secondaire actuelle (octet).
curdevno    =  $ba   ; 186    Numéro de périphérique actuel (byte).
curfptr     =  $bb   ; 187    Pointeur de fichier actuel (mot).
stal        =  $c1   ; $c1    Pointeur vers une adresse RAM pour le 
                     ;        ... chargement/la sauvegarde.
lstx        =  $c5   ; 197    Coordonnée matricielle de la dernière touche.
ndx         =  $c6   ; 198    Nombre de caractères dans le tampon clavier.
zpage1      =  $fb   ; 251    Pointeur 1 de zero page (word).
zpage2      =  $fd   ; 253    Pointeur 2 de zero page (word).
zeropage    =  zpage1; 251    Pointeur 1 de zero page (word).
zonepage    =  zpage2; 253    Pointeur 2 de zero page (word).
kbbuff      =  $277  ; 631    Tampon du clavier.     
carcol      =  $286  ; 646    Couleur du prochain caractère affiché par Basic.
kcarcol     =  carcol; 646    Couleur du prochain caractère affiché par Basic.
bascol      =  carcol; 646    Couleur du prochain caractère affiché par Basic.
curscol     =  $287  ; 647    Couleur de caractère sous le curseur. 
hibase      =  $288  ; 648    Haut de la page de la mémoire écran.
xmax        =  $289  ; 649    Taille maximale du tampon clavier.
rptflg      =  $28a  ; 650    Drapeau: Quel clef sera répétée.
kount       =  $28b  ; 651    Compteur permettant de mesurer le délai entre les
                     ;        ... répétitions de touches.
repdelay    =  $28c  ; 652    Compteur servant à mesurer le délai avant le 
                     ;        ... début de la première répétition de touche.
shflag      =  $28d  ; 653    Drapeau: Appui sur les touches SHIFT/CTRL/Logo
lstshf      =  $28e  ; 654    Dernière séquence d’appui sur les touches 
                     ;        ... SHIFT/CTRL/Logo.
keylog      =  $28f  ; 655(2) Routine de configuration de la table de vecteurs 
                     ;        ... vers le clavier.
mode        =  $291  ; 657    Indicateur: Activer ou désactiver le changement 
                     ;        ... de jeu de caractères via la touche SHFT/Logo.
autodn      =  $292  ; 658    Drapeau: Défilement d’écran activé.
; rs232reg  =  $293  ; 659(5) Registres pseudo-6551 pour RS-232.
m51crt      =  $293  ; 659    RS-232: Emul. du registre de contrôle du 6551.
m51cdr      =  $294  ; 660    RS-232: Emul. du registre de commande du 6551.
m51ajb      =  $295  ; 661(2) RS-232: Synchronisation des bits non normalisée.
rsstat      =  $297  ; 663    RS-232: Emul. du registre d’état du 6551.
bitnum      =  $298  ; 664    RS-232: Nombre de bits restant envoyer/recevoir.
baudof      =  $299  ; 665(2) Temps nécessaire pour envoyer un peu.
;m51buff     =  $29b  ; 667(4) Indices d'octets du début et de la fin de la 
;                     ;        ... réception et de la transmission Tampons.
ridbe       =  $29b  ; 667    RS-232: Index vers la fin du tampon rx.
ridbs       =  $29c  ; 668    RS-232: Index du début du tampon rx.
rodbs       =  $29d  ; 669    RS-232: Index du début du tampon tx.
rodbe       =  $29e  ; 670    RS-232: Index vers la fin du tampon tx.
irqtmp      =  $29f  ; 671(2) Zone de sauvegarde pour le vecteur IRQ lors des 
                     ;        ... opérations d'E/S sur cassette.
enabl       =  $2a1  ; 673    Interruptions RS-232 activées.
libvars1    =  $2a7  ; 679(89)Octets de libre pour l'usager.
;basvect     =  $300  ; 768(12)     
ierror      =  $300  ; 768(2) Vecteur vers la routine de gestion des messages 
                     ;        ... d'erreur de BASIC.
imain       =  $302  ; 770(2) Vecteur vers la boucle principale du programme 
                     ;        ... BASIC.
icrnch      =  $304  ; 772(2) Pointeur vers la routine qui transforme le texte
                     ;        ... ASCII des mots-clés en jetons.
iqplop      =  $306  ; 774(2) Vecteur vers la routine qui convertit les jetons
                     ;        ... d'un programme BASIC en texte ASCII.
igone       =  $3008 ; 776(2) Vecteur vers la routine qui exécute le jeton
                     ;        ... suivant du programme BASIC.
ieval       =  $30a  ; 778(2) Vecteur de la routine qui évalue une expression
                     ;        ... arithmétique à un seul terme.
sareg       =  $30c  ; 780    Zone de stockage pour le registre .A.
sxreg       =  $30d  ; 781    Zone de stockage pour le registre d'index .X.
syreg       =  $30e  ; 782    Zone de stockage pour le registre d'index .Y.
spreg       =  $30f  ; 783    Zone de stockage pour le registre .P (État).
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
; = = = = = = = =   T R A D U I R E  E N  F R A N Ç A I S   = = = = = = = = =                       
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
usradd      =  $311  ; 785(2) Adresse de la routine USR.
libvar1     =  $313  ; 7887   Octet libre.
cinv        =  $314  ; 788(2) Vecteur vers la routine d'interruption IRQ.
cbinv       =  $316  ; 790(2) Vecteur: Interruption par instruction BRK.
nminv       =  $318  ; 792(2) Vecteur: Interruption non masquable.
iopen       =  $31a  ; 794(2) Vecteur vers la routine OPEN du noyau.
                     ;        ... (actuellement à 62282, $F34A)
iclose      =  $31c  ; 796(2) Vecteur vers la routine CLOSE du noyau.
                     ;        ... (actuellement à 62097, $F291)
ichkin      =  $31e  ; 798(2) Vecteur vers la routine CHKIN du noyau.
                     ;        ... (actuellement à 61966, $F20E)
ichkout     =  $320  ; 800(2) Vecteur vers la routine CKOUT du noyau.
                     ;        ... (actuellement à 62032, $F250)
iclrch      =  $322  ; 802(2) Vecteur vers la routine CLRCHN.
                     ;        ... (actuellement à 62259, $F333)
ibasin      =  $324  ; 804(2) Vecteur vers la routine CHRIN du noyau.
                     ;        ... (actuellement à 61783, $F157)
ibsout      =  $326  ; 806(2) Vecteur vers la routine CHROUT du noyau.
                     ;        ... (actuellement à 61898, $F1CA)
istop       =  $328  ; 808(2) Vecteur vers la routine d'arrêt (STOP) du noyau.
                     ;        ... (actuellement à 63213, $F6ED)
igetin      =  $32a  ; 810(2) Vecteur vers la routine GETIN du noyau.
                     ;        ... (actuellement à 61758, $F13E)
iclall      =  $32c  ; 812(2) Vecteur vers la routine CLALL du noyau.
                     ;        ... (actuellement à 62255, $F32F)
usrcmd      =  $32e  ; 814(2) Vecteur vers une commande définie par
                     ;        ... l'utilisateur.
                     ;        ...(pointe actuellement vers BRK à 65126, $FE66)
iload       =  $330  ; 816(2) Vecteur vers la routine de chargement (LOAD) du
                     ;        ... noyau.
                     ;        ... (actuellement à 62622, $F49E)
isave       =  $332  ; 818(2) Vecteur : Routine de sauvegarde (SAVE) du noyau
                     ;        ... (Kernal).
                     ;        ... (actuellement à 62941, $F5DD)
librevars2  =  $334  ; 820(8) Octets libres.
tbuffer     =  $33c  ; 828(192)Tampon d'E/S pour cassette.
librevars3  =  $3fc  ; 1020(4) Octets libres.
;-----------------------------------------------------------------------------
; = = = = =   M é m o i r e   v i d é o   = = = = =
;-----------------------------------------------------------------------------
scrnram     =  $400  ; 1024   Mémoire vive (RAM) vidéo (Caractères)
scrram0     =  scrnram        ; Page 0    
scrram1     =  $500  ; 1280   ; Page 1     
scrram2     =  $600  ; 1536   ; Page 2  
scrram3     =  $700  ; 1792   ; Page 3  
basicsta    =  $801  ; 2049   Adresse de début BASIC
basicrom    =  $a000 ; 40960  Adresse de base de la ROM BASIC
chargen     =  $d000 ; 53248  Adresse de base de la ROM CHARGEN
sid         =  $d400 ; 54272  Adresse de base de la SID
colorram    =  $d800 ; 55296  Mémoire couleur vidéo (RAM)
colram      =  $d800 ; 55296  Mémoire couleur vidéo (RAM)
colram0     =     colorram    ; Page 0
colram1     =  $d900 ; 55552  ; Page 1
colram2     =  $da00 ; 55808  ; Page 2
colram3     =  $db00 ; 56064  ; Page 3
colorptr    .word    colram0,colram1,colram2,colram3
; ------------------------------------------------------------
; - C O M P L E X   I N T E R F A C E   A D A P T O R   # 1
; ------------------------------------------------------------
cia1        =  $dc00 ; 56320 Adresse de base du CIA1.
cia1pra     =  $dc00 ; 56320 Port données A (écriture colonne du clavier).
cia1prb     =  $dc01 ; 56321 Port données B (Lecture ligne du clavier).
cia1ddra    =  $dc02 ; 56322 Direction du port A.
cia1ddrb    =  $dc03 ; 56323 Direction du port B.
cia1tmalo   =  $dc04 ; 56324 LSB du timer A.
cia1tmahi   =  $dc05 ; 56325 MSB du timer A.
cia1tmblo   =  $dc06 ; 56326 LSB du timer B.
cia1tmbhi   =  $dc07 ; 56327 MSB du timer B.
cia1todten  =  $dc08 ; 56328 Secondes/10 de l'heure de la journée.
cia1todsec  =  $dc09 ; 56329 Secondes de l'heure de la journée.
cia1todmin  =  $dc0a ; 56330 Minutes de l'heure de la journée.
cia1todhrs  =  $dc0b ; 56331 Heures de l'heure de la journée.
cia1sdr     =  $dc0c ; 56332 Port de données série.
cia1icr     =  $dc0d ; 56333 Registre de contrôle des interruptions.
cia1cra     =  $dc0e ; 56334 Registre de contrôle A.
cia1crb     =  $dc0f ; 56335 Registre de contrôle B.
; ------------------------------------------------------------
; - C O M P L E X   I N T E R F A C E   A D A P T O R   # 2
; ------------------------------------------------------------
cia2        =  $dd00 ; 56576 Adresse de base du CIA2.
cia2pra     =  $dd00 ; 56576 Port données A.
cia2prb     =  $dd01 ; 56577 Port données B.
cia2ddra    =  $dd02 ; 56578 Direction du port A.
cia2ddrb    =  $dd03 ; 56579 Direction du port B.
cia2tmalo   =  $dd04 ; 56580 LSB du timer A.
cia2tmahi   =  $dd05 ; 56581 MSB du timer A.
cia2tmblo   =  $dd06 ; 56582 LSB du timer B.
cia2tmbhi   =  $dd07 ; 56583 MSB du timer B.
cia2todten  =  $dd08 ; 56584 Secondes/10 de l'heure de la journée.
cia2todsec  =  $dd09 ; 56585 Secondes de l'heure de la journée.
cia2todmin  =  $dd0a ; 56586 Minutes de l'heure de la journée.
cia2todhrs  =  $dd0b ; 56587 Heures de l'heure de la journée.
cia2sdr     =  $dd0c ; 56588 Port de données série.
cia2icr     =  $dd0d ; 56589 Registre de contrôle des interruptions.
cia2cra     =  $dd0e ; 56590 Registre de contrôle A.
cia2crb     =  $dd0f ; 56501 Registre de contrôle A.
;-----------------------------------------------------------------------------
kernalrom   =  $e000 ; 57344 start of kernal rom
irq         =  $ea31 ; 59953 irq entry point
;-----------------------------------------------------------------------------
;  Caractères de contrôle PETSCII de base, obtenus via `?chr$(##)` ou 
;  `jsr $ffd2`. Lorsque des touches sont indiquées, `[]+[]` signifie une 
;  combinaison de touches.
;-----------------------------------------------------------------------------
bstop       =  $03   ;  03 [STOP],     [CTRL]-[C]
bwhite      =  $05   ;  05 [CTRL]+[2], [CTRL]-[E], Sélectionne le blanc
block       =  $08   ;  08 Désactiver le changement de table de caractères 
                     ;     ...  avec [SHIFT]+[C=].     
bunlock     =  $09   ;  09 Activer le changement de table de caractères 
                     ;     ...  avec [SHIFT]+[C=].
bcarret     =  $0d   ;  11 [RETURN]
btext       =  $0e   ;  14 CTRL]-[N] Sélectionner le jeu de caractères 
                     ;     ... majuscules/minuscules.
bcrsdn      =  $11   ;  17 [CRS-D]        Déscend le curseur d'une ligne.
brevcol     =  $12   ;  18 [CTRL]+[9]     Vidéo Inversée Activée.
bhome       =  $13   ;  19 [HOME]         Curseur en début d'écran.
bdelete     =  $14   ;  20 [DELETE]       Supprimer 1 caractère.
bred        =  $1c   ;  28 [CTRL]+[3]     Sélectionne le ROUGE
bcuright    =  $1d   ;  29 [CRS-R]        Déplace le curseur vers la DROITE.
bgreen      =  $1e   ;  30 [CTRL]+[6]     Sélectionne le VERT.
bblue       =  $1f   ;  31 [CTRL]+[7]     Sélectionne le BLEU.
borange     =  $81   ; 129 [C=]+[1]       Sélectionne le ORANGE.
; Clefs fonctions.
f1key       =  $85   ; 133 Code de la touche [F1].
f2key       =  $86   ; 134 Code de la touche [F2].
f3key       =  $87   ; 135 Code de la touche [F3].
f4key       =  $88   ; 136 Code de la touche [F4].
f5key       =  $89   ; 137 Code de la touche [F5].
f6key       =  $8a   ; 138 Code de la touche [F6].
f7key       =  $8b   ; 139 Code de la touche [F7].
f8key       =  $8c   ; 140 Code de la touche [F8].
; Autres touches.
dcurskey    =  $11   ;  17 Code de la touche curseur vers le bas.
ucurskey    =  $91   ; 145 Code de la touche curseur vers le haut.
rcurskey    =  $1d   ;  29 Code de la touche curseur vers la droite.
lcurskey    =  $9d   ; 157 Code de la touche curseur vers la gauche.
larrowkey   =  $5f   ;  95 Code de la touche flèche à gauche [<-].
uarrowkey   =  $5e   ;  94 Code de la touche flèche vers le haut.
homekey     =  $13   ;  19 Code de la touche [HOME].
clearkey    =  $93   ; 147 Code de la touche [CLEAR]. 
delkey      =  $14   ;  20 Code de la touche [DELETE]. 
inskey      =  $94   ; 148 Code de la touche [INSERT]. 
; 
bcarret1    =  $8d   ; 141 [SHIFT]+[RETURN].
bgraph      =  $8e   ; 142 Sélectionner le jeu majuscules + graphiques.
bblack      =  $90   ; 144 [CTRL]+[1]        Sélectionne le NOIR.
bcuup       =  $91   ; 145 [SHIFT]+[CRS-D]   Curseur 1 ligne vers le haut.
brevoff     =  $92   ; 146 [CTRL]+[0]        Vidéo Inversée désactivée.
bclear      =  $93   ; 147 [SHIFT]+[HOME]    CLEAR SCREEN.
binsert     =  $94   ; 148 [SHIFT]+[DELETE]  INSERT a char.
bbrown      =  $95   ; 149 [C=]+[2]          Sélectionne le BRUN.
bltred      =  $96   ; 150 [C=]+[3]          Sélectionne le ROSE.
bdkgrey     =  $97   ; 151 [C=]+[4]          Sélectionne le GRIS FONCÉ.
bmdgrey     =  $98   ; 152 [C=]+[5]          Sélectionne le GRIS MOYEN.
bltgreen    =  $99   ; 153 [C=]+[6]          Sélectionne le VERT PÂLE.
bltblue     =  $9a   ; 154 [C=]+[7]          Sélectionne le BLEU PÂLE.
bltgrey     =  $9b   ; 155 [C=]+[8]          Sélectionne le GRIS PÂLE.
bmagenta    =  $9c   ; 156 [CTRL]+[5]        Sélectionne le MAGENTA.
bculeft     =  $9d   ; 157 [SHIFT]+[CRS-R]   Déplace le curseur vers la GAUCHE.
byellow     =  $9e   ; 158 [CTRL]+[8]        Sélectionne le JAUNE. 
bcyan       =  $9f   ; 159 [CTRL]+[4]        Sélectionne le CYAN.
bspace1     =  $a0   ; 169                   Espace.
bspace2     =  $e0   ; 224                   Espace.
;+----+----------------------+-------------------------------------------------------------------------------------------------------+
;|    |                      |                           Lecture à partir de $dc01 (code entre parenthèses) :                        |
;|row:| $dc00:               +------------+------------+------------+------------+------------+------------+------------+------------+
;|    |                      |   BIT 7    |   BIT 6    |   BIT 5    |   BIT 4    |   BIT 3    |   BIT 2    |   BIT 1    |   BIT 0    |
;+----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
;|1.  | #%11111110 (254/$fe) | DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
;|2.  | #%11111101 (253/$fd) |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
;|3.  | #%11111011 (251/$fb) |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
;|4.  | #%11110111 (247/$f7) |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
;|5.  | #%11101111 (239/$ef) |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
;|6.  | #%11011111 (223/$df) |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
;|7.  | #%10111111 (191/$bf) |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
;|8.  | #%01111111 (127/$7f) | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
;+----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
; +==========================================================================+
; |     C o u l e u r s   p o s s i b l e   d e s   c a r a c t e r e s      |
; +==========================================================================+
; | dec | hex |  binaire  | couleur    || dec | hex |  binaire  | couleur    |
; +-----+-----+-----------+------------++-----+-----+-----------+------------+
; |  0  | $0  | b00000000 | noir       ||  1  | $1  | b00000001 | blanc      |
; |  2  | $0  | b00000010 | rouge      ||  3  | $3  | b00000011 | ocean      |
; |  4  | $0  | b00000100 | mauve      ||  5  | $5  | b00000101 | vert       |
; |  6  | $0  | b00000110 | bleu       ||  7  | $7  | b00000111 | jaune      |
; |  8  | $0  | b00001000 | orange     ||  9  | $9  | b00001001 | brun       |
; | 10  | $0  | b00001010 | rose       || 11  | $b  | b00001011 | gris fonce |
; | 12  | $0  | b00001100 | gris moyen || 13  | $d  | b00001101 | vert pale  |
; | 14  | $0  | b00001110 | blue pale  || 15  | $f  | b00001111 | gris pale  |
; +-----+-----+-----------+------------++-----+-----+-----------+------------+
; Code de couleurs pour la mémoire vidéo en français.
cnoir       =  $0
cblanc      =  $1
crouge      =  $2
cocean      =  $3
cmauve      =  $4
cvert       =  $5
cbleu       =  $6
cjaune      =  $7
corange     =  $8
cbrun       =  $9
crose       =  $a
cgrisfonce  =  $b
cgrismoyen  =  $c
cgris0      =  $b
cgris1      =  $c
cvertpale   =  $d
cbleupale   =  $e
cgrispale   =  $f
cgris3      =  $f
; pour anglosaxons
cblack      =  $0
cwhite      =  $1
cred        =  $2
ccyan       =  $3
cpurple     =  $4
cgreen      =  $5
cblue       =  $6
cyellow     =  $7
;corange     =  $8 ; same as french :-)
cbrown      =  $9
clightred   =  $a
cdarkgray   =  $b
cmidgray    =  $c
clightgreen =  $d
clightblue  =  $e
clightgray  =  $f
;-----------------------------------------------------------------------------
;* vic code couleur en francais *
; couleur %xxxx0000
;              |||+-> bit 0   : Inverse tous les autres bits
;              |++--> bit 1,2 : 00=rgb, 01=Rgb, 10=rGb, 11=rgB 
;              +----> bit 3   : Intensit          
;     0000=noir,  0001=Blanc, 1000=orange, 1001=brun        
;     0010=rouge, 0010=Cyan,  1010=rose  , 1011=gris      
;     0100=vert,  0101=mauve, 1100=gris1 , 1101=vert2           
;     0110=vleu,  0111=jaune, 1110=bleu1 , 1111=gris2           
;-----------------------------------------------------------------------------
vnoir       =     %00000000
vblack      =     %00000000
vblanc      =     %00000001
vwhite      =     %00000001
vrouge      =     %00000010
vred        =     %00000010
vocean      =     %00000011
vcyan       =     %00000011
vmauve      =     %00000100
vpurple     =     %00000100
vvert       =     %00000101
vgreen      =     %00000101
vbleu       =     %00000110
vblue       =     %00000110
vjaune      =     %00000111
vyellow     =     %00000111
vorange     =     %00001000
vbrun       =     %00001001
vbrown      =     %00001001
vrose       =     %00001010
vpink       =     %00001010
vgris       =     %00001011
vgray       =     %00001011
vgrey       =     %00001011
vgris1      =     %00001100
vgray1      =     %00001100
vgrey1      =     %00001100
vvert1      =     %00001101
vgreen1     =     %00001101
vbleu1      =     %00001110
vblue1      =     %00001110
vgris2      =     %00001111
vgray2      =     %00001111
vgrey2      =     %00001111
;-----------------------------------------------------------------------------
; R o u t i n e s   p o u r   l a   c o m m u n i c a t i o n   s é r i e
;-----------------------------------------------------------------------------
;name=$0000       ; Fait quelque chose.
;                 ;-----------------------------------------------------------
;                 ; Description:
setprms=$e1d4     ; Définir les paramètres pour le LOAD, la SAVE et VERIFY.
                  ;-----------------------------------------------------------
                  ; Cette routine est utilisée en commun par LOAD, SAVE et 
                  ; VERIFY pour définir le nom de fichier, le fichier 
                  ; logique, le numéro de périphérique et l'adresse 
                  ; secondaire ; toutes ces opérations doivent être 
                  ; effectuées préalablement à l'exécution de ces commandes. 
;-----------------------------------------------------------------------------
stalk=$ed09       ; Envoyer la commande « Talk » sur le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  stalk envoie une commande de communication sur le bus 
                  ;  série.
                  ; Entrée :  Acc =  Numéro de périphérique
                  ; Sortie :  -
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
slisten=$ed0c     ; Envoyer la commande LISTEN sur le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  slisten envoie la commande LISTEN sur le bus série.
                  ; Entrée :     Acc =  Numéro de périphérique
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sflush=$ed40      ; Vider le cache de sortie du bus série, situé à l'adresse
                  ; mémoire $0095, vers le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  Vider le cache de sortie du bus série, situé à l'adresse
                  ;  mémoire $0095, vers le bus série.
                  ; Entrée : Nil
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
slisten2=$edb9    ; Envoyer l'adresse secondaire LISTEN sur le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  slisten2 envoie la commande LISTEN sur le bus série.
                  ; Entrée : Acc = Adresse secondaire
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
stalk2=$edb9      ; Envoyer l'adresse secondaire TALK sur le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  stalk2 envoie la commande LISTEN sur le bus série.
                  ; Entrée : Acc = Adresse secondaire
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sbout=$eddd       ; Écrire un octet sur le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  sbout écrit un octet sur le bus série.
                  ; Entrée : Acc = Adresse secondaire
                  ; Sortie : Nil
                  ; Registres modifiés : - 
;-----------------------------------------------------------------------------
sutalk=$edef      ; Envoyer la commande UNTALK sur le bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  sutalk envoie la commande UNTALK sur le bus série.
                  ; Entrée : Nil
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sulisten=$edfe    ; Envoyer la commande UNLISTEN au bus série.
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  slisten envoie la commande UNLISTEN sur le bus série.
                  ; Entrée : Nil
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sclkhigh=$ee85    ; Réglez CLOCK OUT sur « High »
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  sclkhi règle CLOCK OUT sur « High ».
                  ; Entrée : Nil
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sclklow=$ee8e     ; Réglez CLOCK OUT sur « Low »
                  ;-----------------------------------------------------------
                  ; Description:                
                  ;  sclkhi règle CLOCK OUT sur « High ».
                  ; Entrée : Nil
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sdathigh=$ee97    ; Réglez DATA OUT sur l'état « High ».
                  ;-----------------------------------------------------------
                  ; Description:
                  ;  sdtahigh règle DATA OUT sur l'état « High ».
                  ; Entrée : Nils
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sdatlow=$eea0     ; Réglez DATA OUT sur l'état «Low ».
                  ;-----------------------------------------------------------
                  ; Description:                
                  ;  - sdatlow règle DATA OUT sur l'état « Low ».
                  ; Entrée : Nil
                  ; Sortie : Nil
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sclkdtAcc = $eea9 ; Lire CLOCK IN et DATA IN.
                  ;-----------------------------------------------------------
                  ; Description:                
                  ;  sclkdtAcc Lit CLOCK IN et DATA IN.
                  ; Entrée : Nil
                  ; Sortie :    (C)arry      = DATA IN; 
                  ;             (N)egative   = CLOCK IN; 
                  ;             Acc          = CLOCK IN (sur bit #7)
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sbread=$f1ad      ; Lire un octet depuis le port série.
                  ;-----------------------------------------------------------
                  ; Description:                
                  ;  sbread lit un octet depuis le port série.
                  ; Imput: Nil
                  ; Sortie:    Acc Octet lu. 
                  ;            (Lit $0d, Return, si état de l'appareil <> 0.)
                  ; Registres modifiés : Acc 
;-----------------------------------------------------------------------------
sstdin=$f237      ; Définitz le bus série comme entrée standard,
                  ;  n’envoit pas l’adresse secondaire TALK si le bit 
                  ;  d’adresse secondaire #7 = 1.
                  ;-----------------------------------------------------------
                  ; Entrées: Acc =  Numéro de périphérique.
                  ; Sortie: –
                  ; Registers utilisés....: A, X.
;-----------------------------------------------------------------------------
sstdout=$f279     ; Définissez le bus série comme sortie standard; 
                  ;  N’envoit pas l’adresse secondaire LISTEN si le bit 
                  ;  d’adresse secondaire #7 = 1.
                  ;-----------------------------------------------------------
                  ; Entrées: Acc =  Numéro de périphérique.
                  ; Sortie: –
                  ; Registers utilisés....: A, X.                
;-----------------------------------------------------------------------------
sfopen=$f3d5      ; Ouvrir le fichier sur le bus série ; ne pas envoyer 
                  ;  le nom du fichier si le bit d'adresse secondaire #7 = 1 ou 
                  ;  si la longueur du nom du fichier=0.
                  ;-----------------------------------------------------------
                  ; Entrées: –
                  ; Sortie: –
                  ; Registers utilisés....: A, Y.
;-----------------------------------------------------------------------------
sutclose=$f528    ; Envoyer les commandes UNTALK et CLOSE sur le bus série.
                  ;-----------------------------------------------------------
                  ; Entrées: –
                  ; Sortie: –
                  ; Registers utilisés....: A.
;-----------------------------------------------------------------------------
sulclose=$f63f    ; Envoyer les commandes UNLISTEN et CLOSE sur le bus série.
                  ;-----------------------------------------------------------
                  ; Entrées: –
                  ; Sortie: –
                  ; Registers utilisés....: A.
;-----------------------------------------------------------------------------
sfclose=$f642     ; Ferme le fichier sur le bus série;
                  ;  n'envoyez pas l'adresse secondaire CLOSE si le bit 
                  ;  d'adresse secondaire #7 = 1.
                  ;-----------------------------------------------------------
                  ; Entrées: –
                  ; Sortie: –
                  ; Registers utilisés....: –
;-----------------------------------------------------------------------------
stimeout=$fe21    ; Définir le délai d’attente du bus série.
                  ;-----------------------------------------------------------
                  ; Entrées: Acc =  Valeur du delai d'attente. (ms)
                  ; Sortie: –
                  ; Registers utilisés....: –
;-----------------------------------------------------------------------------
; r o u t i n e s   p r é s e n t e s   d a n s   l e   k e r n a l
;-----------------------------------------------------------------------------
acptr=$ffa5       ; jmp $ee13 Recoit un caractère provenant du port serie
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - acptr est utilisé pour recupérer des données provenant du port série.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: –
                  ; Registres de sortie...: Acc =  Byte read.
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: 13
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Preparation.: TALK, TKSA
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Talk et tksa doivent d'abord Ãªtre appelé.
                  ;       jsr acptr
                  ;       sta $0800
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Cet exemple ne montre que le résultat final.
                  ; - Effectuez d'abord l'appel de talk et tksa.
;-----------------------------------------------------------------------------
chkin=$ffc6       ; jmp ($031e) Define an input channel. 
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - chkin sert à définir tout fichier ouvert comme fichier 
                  ;   d'entrée.
                  ; - OPEN doit être appelé en premier.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: X
                  ; Registres de sortie...: -
                  ; Registers utilisés....: X.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: OPEN
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: 3,5,6
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Définit le fichier logique n° 2 comme canal d'entrée.
                  ;       ldx #2
                  ;       jsr chkin
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Le registre x désigne le numéro de fichier.
;-----------------------------------------------------------------------------
chkout=$ffc9      ; jmp ($0320) Définir un canal de sortie.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Tout comme chkin, mais permet de définir le fichier de 
                  ;   sortie. 
                  ; - OPEN doit être appelé en premier.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: X
                  ; Registres de sortie...: -
                  ; Registers utilisés....: X.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: OPEN
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: 3,5,7
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Définit le fichier logique n°4 comme fichier de sortie.
                  ;       ldx #4
                  ;       jsr chkout
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Le registre x désigne le numéro de fichier.
;-----------------------------------------------------------------------------
chrin=$ffcf       ; jmp ($0324) Récupère 1 caractère depuis le canal d'entrée.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - chrin récupère un caractère depuis le périphérique 
                  ;   d'entrée actuel.
                  ; - L'appel de OPEN et CHKIN peut modifier le périphérique 
                  ;   d'entrée.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: A
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: OPEN, CHKIN
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: Voir READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Enregistre une chaîne saisie à l’écran.
                  ;       ldy #$00
                  ; loop  jsr chkin
                  ;       sta $0800,y
                  ;       iny
                  ;       cmp #$0d
                  ;       bne loop
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Cet exemple s'apparente à une instruction INPUT. 
                  ;   Essayez de l'exécuter.
;-----------------------------------------------------------------------------
chrout=$ffd2      ; jmp ($0326) Sortie de caractère au périphérique actuel.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Charge l'accumulateur avec votre caractère et appelez. 
                  ; - open et chkout modifieront le périphérique de sortie.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A
                  ; Registres de sortie...: -
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: CHKOUT, OPEN
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: Voir READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Duplique la commande CMD 4 : print "a";
                  ;       ldx #4
                  ;       jsr chkout
                  ;       lda #'a
                  ;       jsr chrout
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - La lettre « a » s’affiche à l’écran.
                  ; - Appel de OPEN en premier pour l'imprimante.
;-----------------------------------------------------------------------------
cint=$ff81        ; jsr $e518 Initialise l'éditeur d'écran et la puce vic-ii.
                  ;-----------------------------------------------------------
                  ; Description:
                  ; - cint réinitialise la puce de contrôle vidéo 6567 ainsi 
                  ;   que l'éditeur d'écran.
                  ;-----------------------------------------------------------
                  ; Exemple:
                  ; - Réinitialisez la puce 6567 et la puce VIC 6566.
                  ;       jsr cint
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note:
                  ; - En gros, c’est exactement comme si l’on appuyait sur les
                  ;   touches « STOP » et « RESTORE ».
;-----------------------------------------------------------------------------
ciout=$ffa8       ; jmp $eddd Transmit a byte over the serial bus
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - ciout will send data to the serial bus. 
                  ; - listen and second must be called first. 
                  ; - Call unlsn to finish up neatly.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: Acc =  Byte to write.
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: LISTEN, [SECOND]
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Send the letter x to the serial bus.
                  ;       lda #'x
                  ;       jsr ciout
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator is used to transfer the data.
;-----------------------------------------------------------------------------
clall=$ffe7       ; jmp ($032c) Close all open files
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - clall really does what its name implies-it closes all files 
                  ;   and resets all channels.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: -
                  ; Registers utilisés....: -
                  ; Pile utilisées........: 11
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Close all files.
                  ;       jsr clall
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The clrchn routine is called automatically.
;-----------------------------------------------------------------------------
close=$ffc3       ; jmp ($031c) Close a logical file
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - This routine will close any logical file that has been 
                  ;   opened.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A
                  ; Registres de sortie...: -
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Close logical file #2.
                  ;       lda #2
                  ;       jsr close
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator designates the file #.
;-----------------------------------------------------------------------------
clrchn=$ffcc      ; jmp ($0322) - Clear all i/o channels.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - clrchn resets all channels and i/o registers - the input to 
                  ;   keyboard and the output to screen.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: -
                  ; Registers utilisés....: -
                  ; Pile utilisées........: 9
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: OPEN, CHKIN
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Restore default values to i/o devices.
                  ;       jsr clrchn
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator and the x register are altered.
;-----------------------------------------------------------------------------
getin=$ffe4       ; jmp ($032a) Get a character.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - getin will get one piece of data from the input device. 
                  ; - Open and chkin can be used to change the input device.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: A
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Wait for a key to be pressed.
                  ;       wait    jsr getin
                  ;               cmp #0
                  ;               beq wait
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - If the serial bus is used, then all registers are altered.
;-----------------------------------------------------------------------------
iobase=$fff3      ; jmp $e500 Define i/o memory page
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - iobase returns the low and high bytes of the starting 
                  ;   address of the i/o devices in the x and y registers.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: X, Y
                  ; Registers utilisés....: X, Y.
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Set the data direction register of the user port to 0 
                  ;   (input).
                  ;       jsr iobase
                  ;       stx point
                  ;       sty point+1
                  ;       ldy #2
                  ;       lda #0
                  ;       sta (point),y
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Point is a zero-page address used to access the ddr 
                  ;   indirectly.
;-----------------------------------------------------------------------------
ioinit=$ff84      ; ($fda3) Initialize i/o devices.
                  ;-----------------------------------------------------------
                  ; Description:
                  ; - ioinit initializes all i/o devices and routines. 
                  ; - It is part of the system's powering-up routine.
                  ;-----------------------------------------------------------
                  ; Exemple:
                  ; - Initialize all i/o devices.
                  ;       jsr ioinit
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note:
                  ; - All registers are altered.
;-----------------------------------------------------------------------------
listen=$ffb1      ; jmp ($ed0c) Command a device on the serial bus to listen.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - listen will command any device on the serial bus to receive 
                  ;   data.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: Acc =  Numéro de périphérique.
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Command device #8 to listen.
                  ;       lda #8
                  ;       jsr listen
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator designates the device #.
;-----------------------------------------------------------------------------
load=$ffd5        ; jmp $f4e9 Load device to RAM.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - The computer will perform either the load or the verify 
                  ;   command. 
                  ; - If the ac cumulator is a 1, then load; if 0, then verify.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: A
                  ; Registers utilisés....: A.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X, y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: SETLFS, SETNAM
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: 0, 4, 5, 8, 9
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Load a program into memory.
                  ;       lda #$08
                  ;       ldx #$02
                  ;       ldy #$00
                  ;       jsr setlfs
                  ;       lda #$04
                  ;       ldx #<name
                  ;       ldy #>name
                  ;       jsr setnam
                  ;       lda #$00
                  ;       ldy #$20
                  ;       jsr load
                  ;       rts
                  ;       name .byte 'file'
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Program 'file' will be loaded into memory starting at 8192 
                  ;   decimal, x being the low byte and y being the high byte for 
                  ;   the load.
;-----------------------------------------------------------------------------
membot=$ff9c      ; jmp $fe34 Get/set bottom of memory.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - If the carry bit is set, then the low byte and the 
                  ;   high byte of ram are returned in the x and y registers. 
                  ; - If the carry bit is clear, the bottom of ram is set to the 
                  ;   x and y registers.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: X, Y (C=0)
                  ; Registres de sortie...: X, Y (C=1)
                  ; Registers utilisés....: X, Y.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés:None
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Move bottom of memory up one page.
                  ;       sec
                  ;       jsr membot
                  ;       iny
                  ;       clc
                  ;       jsr membot
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator is left alone.
;-----------------------------------------------------------------------------
memtop=$ff99      ; jmp $fe25 Get/Set top of ram
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Same principle as membot, except the top of ram is affected.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: X, Y (C=0)
                  ; Registres de sortie...: X, Y (C=1)
                  ; Registers utilisés....: X, Y.
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Protect 1k of memory from basic.
                  ;       sec
                  ;       jsr memtop
                  ;       dey
                  ;       clc
                  ;       jsr memtop
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator is left alone.
;-----------------------------------------------------------------------------
open=$ffc0        ; jmp ($031a) Open a logical file
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - After setlfs and setnam have been called, you can open a 
                  ;   logical file.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A, X, Y
                  ; Registres de sortie...: -
                  ; Registers utilisés....: A, X, Y.
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: SETLFS, SETNAM
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: 1, 2, 4, 5, 6
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; Duplicate the command open 15,8,15,'i/o'
                  ;       lda #3
                  ;       ldx #<name
                  ;       ldy #>name
                  ;       jsr setnam
                  ;       lda #15
                  ;       ldx #8
                  ;       ldy #15
                  ;       jsr setlfs
                  ;       jsr open
                  ;       rts
                  ;       name .by 'i/o'
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Opens the current name file with the current lfs.
;-----------------------------------------------------------------------------
plot=$fff0        ; jmp $e50a Set or retrieve cursor location x=column, y=line
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - If the carry bit of the accumulator is set, then the 
                  ;   cursor x,y is returned in the y and x registers. 
                  ; - If the carry bit is clear, then the cursor is moved to x,y 
                  ;   as determined by the y and x registers.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: X, Y (C=0)
                  ; Registres de sortie...: X, Y (C=1)
                  ; Registers utilisés....: X, Y.
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: A, X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Move cursor to row 12, column 20 (12,20).
                  ;       ldx #12
                  ;       ldy #20
                  ;       clc
                  ;       jsr plot
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The cursor is now in the middle of the screen.
;-----------------------------------------------------------------------------
ramtas=$ff87      ; ($fd50) Initialise ram, tape buffer and screen.
                  ;-----------------------------------------------------------
                  ; Description:
                  ; - ramtas is used to test ram, reset the top and bottom of 
                  ;   memory pointers, clear $0000 to $0101 and $0200 to $03ff, 
                  ;   and set the screen memory to $0400.
                   ;-----------------------------------------------------------
                  ; Exemple:
                  ; - Do ram test.
                  ;       jsr ramtas
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note:
                  ; - All registers are altered.
;-----------------------------------------------------------------------------
rdtim=$ffde       ; jmp $f6dd Read system clock
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Locations 160-162 are transferred, in order, to the y 
                  ;   and x registers and the accumulator.
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Store system clock to screen.
                  ;       jsr rdtim
                  ;       sta 1026
                  ;       stx 1025
                  ;       sty 1024
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The system clock can be translated as hours/minutes/seconds.
;-----------------------------------------------------------------------------
readst=$ffb7      ; jmp $fe07 Read i/o status word
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - When called, readst returns the status of the i/o devices. 
                  ; - Any error code can be translated as operator error.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: A
                  ; Registers utilisés....: A
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Check for read error.
                  ;       jsr readst
                  ;       cmp #16
                  ;       beq error
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - In this case, if the accumulator is 16, a read error 
                  ;   occurred.
;-----------------------------------------------------------------------------
restor=$ff8a      ; jmp $fd15 Restore default I/O vectors.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: –
                  ; Registers utilisés....: -
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ;     jsr restor
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - All registers are altered.
;-----------------------------------------------------------------------------
save=$ffd8        ; jmp $f5dd Save memory to a device.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - The computer will perform either the load or the verify 
                  ;   command. 
                  ; - If the ac cumulator is a 1, then load; if 0, then verify.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A, X, Y
                  ; Registres de sortie...: -
                  ; Registers utilisés....: A, X, Y
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: SETLFS, SETNAM
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: 5, 8, 9
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Load a program into memory.
                  ;prog   lda #$08
                  ;       jsr setlfs
                  ;       lda #fnend-fname     ; filename lenght calculation.
                  ;       ldx #<name       ; fname string addr. low byte.
                  ;       ldy #>name       ; fname string addr. high byte.
                  ;       jsr setnam       ; set filename to kernal.
                  ;       lda prog         ; load prog addr. low byte.
                  ;       sta stal         ; save to stal $c1
                  ;       lda prog+1       ; load prog addr. high byte.
                  ;       sta stal+1       ; save to stal+1 $c2
                  ;       ldx #<prgend     ; 
                  ;       ldy #>prgend
                  ;       ldy #$20         ; 
                  ;       lda #<stal       ; a contains page 0 to pointer
                  ;       jsr save
                  ;       rts
                  ;       fname .byte 'progfile.prg'
                  ;       fnend ; pointer to calculate filename lenght
                  ;prgend
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Program 'file' will be saved onto disk at 8192 
                  ;   decimal, x being the low byte and y being the high byte for 
                  ;   the load.
;-----------------------------------------------------------------------------
scnkey=$ff9f      ; jmp $ea87 Scan the keyboard
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - TScan the keyboard to see if a key is pressed. 
                  ;   Place that key into the keyboard buffer. 
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: -
                  ; Registers utilisés....: -
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A, X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; get   jsr scnkey
                  ;       jsr getin
                  ;       cmp #0
                  ;       beq get
                  ;       jsr chrout
                  ;-----------------------------------------------------------
                  ; Note.:
;-----------------------------------------------------------------------------
screen=$ffed      ; jmp $e505 Return screen format
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Screen returns the number of columns and rows the screen has 
                  ;   in the x and y registers.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: X, Y
                  ; Registers utilisés....: X, Y
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Determine the screen size.
                  ;       jsr screen
                  ;       stx maxcol
                  ;       sty maxrow
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - screen allows further compatibility between the 64, the 
                  ;   vic-20, and future versions of the 64.
;-----------------------------------------------------------------------------
second=$ff93      ; jmp $edb9 Send secondary address after listen
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - After listen has been called, a secondary address may be 
                  ;   sent.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: Acc = Adresse secondaire.
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Address device #8 with secondary address #15.
                  ;       lda #8
                  ;       jsr listen
                  ;       lda #15
                  ;       ora #60
                  ;       jsr second
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator designates the address number.
;-----------------------------------------------------------------------------
setlfs=$ffba      ; jmp $fe00 Set up a logical file
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - setlfs stands for set logical address, file address, and 
                  ;   secondary address. 
                  ; - After setlfs is called, open may be called.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A, X, Y
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A, X, Y
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Set logical file #1, device #8, secondary address of 15.
                  ;       lda #1
                  ;       ldx #8
                  ;       ldy #15
                  ;       jsr setlfs
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - If open is called, the command will be open 1,8,15.
;-----------------------------------------------------------------------------
setmsg=$ff90      ; jmp $fe18 Set kernal message output flag
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Depending on the accumulator, either error messages, control 
                  ;   messages, or neither is printed.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Turn on control messages.
                  ;       lda #$40
                  ;       jsr setmsg
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - A 128 is for error messages; a zero, for turning both off.
;-----------------------------------------------------------------------------
setnam=$ffbd      ; jmp $fdf9 Set up file name
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - In order to access the open, load, or save routines, 
                  ; - Setnam must be called first.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A, X, Y
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A, X, Y
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Setnam will prepare the disk drive for'file#1'.
                  ;       lda #6
                  ;       ldx #l,name
                  ;       ldy #h,name
                  ;       jsr setnam
                  ;       name.by 'file#l'
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Accumulator is file length, x= low byte, and y= high byte.
;-----------------------------------------------------------------------------
settim=$ffdb      ; jmp $f6e4 Set the system clock.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - settim is the opposite of rdtim: it sets the system clock
                  ;   instead of reading it.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A, X, Y
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A, X, Y
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Set system clock to 10 minutes=3600 jiffies.
                  ;       lda #0
                  ;       ldx #l,3600
                  ;       ldy #h,3600
                  ;       jsr settim
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - This allows very accurate timing for many things.
;-----------------------------------------------------------------------------
settmo=$ffa2      ; jmp $fe21 Set ieee bus card timeout flag
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - settmo is used only with an ieee add-on card to access the 
                  ;   serial bus.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: Acc =  Timeout value.
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Disable time-outs on serial bus.
                  ;       lda #0
                  ;       jsr settmo
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - To enable time-outs, set the accumulator to a 128 and call 
                  ;   settmo.
;-----------------------------------------------------------------------------
stop=$ffe1        ; jmp ($0328) Check if stop key is pressed.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - Stop will set the z flag of the accumulator if the stop key 
                  ;   was pressed.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: A
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Check for stop key being pressed.
                  ;        wait      jsr stop
                  ;                  bne wait
                  ;                  rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - stop must be called if the stop key is to remain functional.
;-----------------------------------------------------------------------------
talk=$ffb4        ; jmp $ed09 Command a device on the serial bus to talk
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - This routine will command a device on the serial bus to 
                  ;   send data.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: Acc =  Numéro de périphérique.
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Command device #8 to talk.
                  ;       lda #8
                  ;       jsr talk
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The accumulator designates the file number.
;-----------------------------------------------------------------------------
tksa = $ff96      ; jmp $edc7 Send a secondary address to a device commanded to talk
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - tksa is used to send a secondary address for a talk device.
                  ; - Function talk must be called first.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: Acc = Adresse secondaire.
                  ; Registres de sortie...: –
                  ; Registers utilisés....: A
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: Aucun
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: TALK
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Signal device #4 to talk with command #7.
                  ;       lda #4
                  ;       jsr talk
                  ;       lda #7
                  ;       jsr tksa
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - This example will tell the printer to print in uppercase.
;-----------------------------------------------------------------------------
udtim=$ffea       ; jmp $f69b Update the system clock
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - If you are using your own interrupt system, you can update 
                  ;   the system clock by calling udtim.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: –
                  ; Registers utilisés....: -
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Update the system clock.
                  ;       jsr udtim
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - It is useful to call udtim before calling stop.
;-----------------------------------------------------------------------------
unlsn=$ffae       ; jmp $edfe Send an unlisten command
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - unlsn commands all devices on the serial bus to stop
                  ;   receiving data.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: -
                  ; Registres de sortie...: –
                  ; Registers utilisés....: -
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Command the serial bus to unlisten.
                  ;       jsr unlsn
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The serial bus can now be used for other things.
;-----------------------------------------------------------------------------
untlk=$ffab       ; jmp $edef Send an untalk command
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - All devices previously set to talk will stop sending data.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: –
                  ; Registres de sortie...: –
                  ; Registers utilisés....: -
                  ; Pile utilisées........: Aucun
                  ; Registres modifiés....: A
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés: See READST
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Command serial bus to stop sending data.
                  ;       jsr untlk
                  ;       rts
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - Sending untlk commands all talking devices to get off the 
                  ;   serial bus.
;-----------------------------------------------------------------------------
vector=$ff8d      ; jmp $fd1a Read/set I/O vectors.
                  ;-----------------------------------------------------------
                  ; Description.:
                  ; - If the carry bit of the accumulator is set, the start 
                  ;   of a list of the current contents of the ram vectors is 
                  ;   returned in the x and y registers. 
                  ; - If the carry bit is clear, there the user list pointed to by 
                  ;   the x and y registers is transferred to the system ram 
                  ;   vectors.
                  ;-----------------------------------------------------------
                  ; Registres d'entrées...: X, Y (C=0)
                  ; Registres de sortie...: X, Y (C=1)
                  ; Registers utilisés....: -
                  ; Pile utilisées........: 2
                  ; Registres modifiés....: A, X, Y
                  ;-----------------------------------------------------------
                  ; Routines préparatoires: Aucune
                  ;-----------------------------------------------------------
                  ; Erreurs retournés.....: Aucun
                  ;-----------------------------------------------------------
                  ; Exemple.:
                  ; - Change the input routines to new system.
                  ;       sec
                  ;       jsr vector
                  ;       lda #l,myinp
                  ;       sta user+10
                  ;       lda #h,myinp
                  ;       sta user+11
                  ;       ldx #l,user
                  ;       ldy #h,user
                  ;       clc
                  ;       jsr vector
                  ;       rts
                  ;       user .de 26
                  ;-----------------------------------------------------------
                  ; Note.:
                  ; - The new input list can start anywhere. user is the location 
                  ;   for temporary strings, and 35-36 is the utility pointer 
                  ;   area.
;-----------------------------------------------------------------------------
;* kernal function vectors *
;ayx=input ayx=outputs (c)=1 (c)=0
;-----------------------------------------------------------------------------
kd_poly1    =  $e043
kd_poly2    =  $e059
kd_rmulc    =  $e08d       ;
kd_raddc    =  $e092       ;
kd_rnd      =  $e097
kd_sys      =  $e12a
kd_save     =  $e156
kd_verify   =  $e165
kd_load     =  $e168
kd_chrout   =  $f1ca
kcint       =     cint        ;   , init vic + ecran.
kioinit     =     ioinit      ;   , init i/o dev.
kramtas     =     ramtas      ;   , test de memoire.
kciout      =     ciout       ;a  ,tx byte  acia
krestor     =     restor      ;   , set ram plafond
kvector     =     vector      ;
ksetmsg     =     setmsg      ;a  , set sys. msg. out
ksecond     =     second      ;a  , tx adresse sec.
ktksa       =     tksa        ;a  , talk adresse sec.
kmemtop     =     memtop      ; yx, (c) get mem high
kmembot     =     membot      ; yx, (c) get mem low
kscankey    =     scnkey      ;   , scan clavier
ksettmo     =     settmo      ;a  , set ieee timeout
kacptr      =     acptr       ;a  ,rx serie.
kuntlk      =     untlk       ;   , iec-cmc stop talk
kunlsn      =     unlsn       ;   , iec-cmd stop lsn
klisten     =     listen      ;a  , iec-cmd dev ecout
ktalk       =     talk        ;a  , iec-cmd dev parle
kreadst     =     readst      ;a  , lecture i/o stats
ksetlfs     =     setlfs      ;ayx, init fich logi.
ksetnam     =     setnam      ;ayx, init num.nom.fich
kopen       =     open        ;axy, ouvre fich-nom
kclose      =     close       ;a  , ferme fichier #a.
kchkin      =     chkin       ;  x,open canal in.
kchkout     =     chkout      ;  x,open canal out
kclrchn     =     clrchn      ;   , ferme canaux i/o.
kchrin      =     chrin       ;a  ,recup. un car.
kchrout     =     chrout      ;a  ,sort un car.
kload       =     load        ;ayx, dev->ram
ksave       =     save        ;   , sauve mem->dev
ksettim     =     settim      ;axy, init sysclock
krdtim      =     rdtim       ;axy, lecture sysclock
kstop       =     stop        ;a  , ret. stopkey stat
kgetin      =     getin       ;a  , recup. car. #dev.
kclall      =     clall       ;   , ferme fichiers.
kudtim      =     udtim       ;   , maj sysclock
kscreen     =     screen      ; yx, get format ecran
kplot       =     plot        ; yx, (c) get csr pos.
kiobase     =     iobase      ; yx, def. i/o mem page
;-----------------------------------------------------------------------------
; Kernal entry point
;-----------------------------------------------------------------------------
k_echostartup     =  $e39a
k_putch           =  $e716; 52) Print a character.       ;a--;---; Acc =  char
k_cls             =  $e7a0
k_cursordown      =  $e87c
k_scrollup        =  $e8ea
k_home            =  $e94e
k_insertline      =  $e965
k_screlldown      =  $e9c8
k_devsndlstn      =  $ed0c ; 55) Send 'LISTEN'>IEEE/Serial.    ;a--;---; Acc = dev # 
k_ieeein          =  $ee13 ; 60) Entrées from IEEE/Serial.     ;---;a--; Acc = Data byte  
k_devsndutalk     =  $eef6 ; 58) Send 'UNTALK'>IEEE/Serial.    ;---;---;
k_devsndulstn     =  $ef04 ; 59) Send 'UNLISTEN'>IEEE/Serial.  ;---;---; 
k_putsysmsg       =  $f12f ; 53) Print system message.         ;--y;---; y=msg offset
k_cloself         =  $f291 ; 61) Close logical file .          ;a--;---; Acc = file # 
k_loadsub         =  $f49e ; 63) LOAD subroutine.              ;axy;---; Acc = # start=yyxx
k_prnsrch         =  $f5af ; 64) Print SEARCHING if imm mode.  ;---;---;
k_echosearch      =  $f5b3 ; 64b) Skipping test part of 64.    ;---;---; 
k_prnfnam         =  $f5c1 ; 65) Print filename.               ;---;---;
k_stop            =  $f6ed ; 62) Check for STOP key.           ;---;---; z=1 pressed
k_gettaphdblk     =  $f7ea ; 66) Find a tape hdr blk.          ;a--;---; Acc = len 
                           ;     Prerequisit: Pointer to string in zpage1  
k_fndtaphdblk     =    $f7ea; 67) Find any tape hdr blk.          ;---;---; 
k_waittapplay     =    $f817; 68) Press PLAY... (wait)            ;---;---;
k_rdtape2buff     =    $f841; 69) Read tape to buffer.            ;---;---;
k_readtape        =    $f847; 70) Read tape.                      ;---;---;
k_wrbuff2tape     =    $f864; 71) write buffer to tape.           ;---;---;
k_wrtape          =    $f869; 72) write tape.                     ;a--;---; Acc = ldr len
k_resettapeio     =    $fb8e; 73) Reset tape I/O.                 ;---;---;
k_setintvect      =    $fcbd; 74) set interupt vector.            ;---;---;
k_coldreset       =    $fce2; 75) Power on reset.                 ;---;---;
k_coldstart       =    $fce2; 75) Power on reset.                 ;---;---;
k_coldboot        =    $fce2; 75) Power on reset.                 ;---;---;
k_warmreset       =    $fe66;     Warm resetstart
k_warmboot        =    $fe66;     Warm resetstart
k_warmstart       =    $fe66;     Warm resetstart
k_devsndaddr2     =    $ff93; 56) Send second address.            ;a--;---; Acc = SAor#$60 
;-----------------------------------------------------------------------------
; getin key values
;-----------------------------------------------------------------------------
arrowleft         =  $5f
ctrl_al           =  $06
escape            =  $5f
ctrl_escape       =  $06
pound             =  $a9
home              =  $13
clear             =  $93
uparrow           =  $5e
pisign            =  $de
runstop           =  $03
cursd             =  $11
cursu             =  $91
cursr             =  $1d
cursl             =  $9d
key_f1            =  $85
key_f3            =  $86
key_f5            =  $87
key_f7            =  $88
key_f2            =  $89
key_f4            =  $8a
key_f6            =  $8b
key_f8            =  $8c
enter             =  $0d
comd_enter        =  $8d
key_a             =  $41
key_b             =  $42
key_c             =  $43
key_d             =  $44
key_e             =  $45
key_f             =  $46
key_g             =  $47
key_h             =  $48
key_i             =  $49
key_j             =  $4a
key_k             =  $4b
key_l             =  $4c
key_m             =  $4d
key_n             =  $4e
key_o             =  $4f
key_p             =  $50
key_q             =  $51
key_r             =  $52
key_s             =  $53
key_t             =  $54
key_u             =  $55
key_v             =  $56
key_w             =  $57
key_x             =  $58
key_y             =  $59
key_z             =  $5a
shift_a           =  $c1
shift_b           =  $c2
shift_c           =  $c3
shift_d           =  $c4
shift_e           =  $c5
shift_f           =  $c6
shift_g           =  $c7
shift_h           =  $c8
shift_i           =  $c9
shift_j           =  $ca
shift_k           =  $cb
shift_l           =  $cc
shift_m           =  $cd
shift_n           =  $ce
shift_o           =  $cf
shift_p           =  $d0
shift_q           =  $d1
shift_r           =  $d2
shift_s           =  $d3
shift_t           =  $d4
shift_u           =  $d5
shift_v           =  $d6
shift_w           =  $d7
shift_x           =  $d8
shift_y           =  $d9
shift_z           =  $da
ctrl_a            =  $01
ctrl_b            =  $02
ctrl_c            =  $03
ctrl_d            =  $04
ctrl_e            =  $05
ctrl_f            =  $06
ctrl_g            =  $07
ctrl_h            =  $08
ctrl_i            =  $09
ctrl_j            =  $0a
ctrl_k            =  $0b
ctrl_l            =  $0c
ctrl_m            =  $0d
key_enter         =  $0d
ctrl_n            =  $0e
ctrl_o            =  $0f
ctrl_p            =  $10
ctrl_q            =  $11
ctrl_r            =  $12
ctrl_s            =  $13
ctrl_t            =  $14
ctrl_u            =  $15
ctrl_v            =  $16
ctrl_w            =  $17
ctrl_x            =  $18
ctrl_y            =  $19
ctrl_z            =  $1a
comd_a            =  $b0    
comd_b            =  $bf    
comd_c            =  $bc    
comd_d            =  $ac    
comd_e            =  $b1    
comd_f            =  $bb    
comd_g            =  $a5    
comd_h            =  $b4    
comd_i            =  $a2    
comd_j            =  $b5    
comd_k            =  $a1    
comd_l            =  $b6    
comd_m            =  $a7    
comd_n            =  $aa    
comd_o            =  $b9    
comd_p            =  $af    
comd_q            =  $ab    
comd_r            =  $b2    
comd_s            =  $ae    
comd_t            =  $a3    
comd_u            =  $b8    
comd_v            =  $be    
comd_w            =  $b3    
comd_x            =  $bd    
comd_y            =  $b7    
comd_z            =  $ad    
;-----------------------------------------------------------------------------
; error codes
;-----------------------------------------------------------------------------
; if an error occurs during a kernal routine, then the carry bit of the 
; accumulator is set and the error code is returned in the accumulator.
;---------------+---------------------------------------------------------------
; number    ; meaning
;---------------+---------------------------------------------------------------
kerr00            =     0     ; routine ended by the stop key.
kerr01            =     1     ; too many files open.
kerr02            =     2     ; file already open.
kerr03            =     3     ; file not open.
kerr04            =     4     ; file not found.
kerr05            =     5     ; device not present.
kerr06            =     6     ; file is not an input file.
kerr07            =     7     ; file is not an output file.
kerr08            =     8     ; file name is missing.
kerr09            =     9     ; illegal Numéro de périphérique.
kerrf0            =     240   ; top-of-memory change rs-232 buffer allocation.
;---------------+---------------------------------------------------------------
;------------------------------ d e c i m a l-----------------------------------
;0000000001111111111222222222233333333334444444444555555555566666666667777777777
;1234567890123456789012345678901234567890123456789012345678901234567890123456789
;========================= h e x a - d e c i m a l==============================
;0000000000000001111111111111111222222222222222233333333333333334444444444444444
;123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
;-----------------------------------------------------------------------------
; a p p e l   d e   l a   s o u s   r o u t i n e   p r i n c i p a l e
;-----------------------------------------------------------------------------
;libtart        jsr  main       ; Programme principale doit s'appeler "main"
           ;jsr      k_coldboot
           ;rts
