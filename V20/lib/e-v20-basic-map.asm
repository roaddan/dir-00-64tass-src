;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .: e-v20-basic-map.asm
; Dernière m.à j. : 
; Inspiration ....: 
;------------------------------------------------------------------------------
; e-v20-basic-map.asm - Carthographie memoire et declaration de constantes 
; pour le BASIC 2.0 du commodore Vic 20.
;------------------------------------------------------------------------------
; Segmentation principales de la mémoire $c000 - $dfff
;------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "ee-v20-basic-map.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire 
; que votre programme.
;------------------------------------------------------------------------------
; A D R E S S E S   D E S   E L E M E N T S   E T   F O N C T I O N S
;------------------------------------------------------------------------------
bcoldst =   $c000   ; Vecteur vers la routine de démarrage à froid BASIC $e378.
bwarmst =   $c002   ; Vecteur vers la routine de démarrage à chaud BASIC $e467.
cbmBASIC=   $c004   ; Les caractères "CBMBASIC".
bstmdsp =   $c00c   ; Tableau vectoriel de répartition des mots clés, dans 
                    ; l'ordre des jetons.
bfundsp =   $c052   ; Tableau des vecteurs de répartition des fonctions dans 
                    ; l'ordre des jetons.
boptab  =   $c080   ; Tableau vectoriel de répartition des opérations 
                    ; mathématiques, dans l'ordre des jetons.
breslst =   $c09e   ; Tableau des mots-clés BASIC dans l'ordre des jetons.
berrtab =   $c19e   ; Tableau des messages d'erreur BASIC.
bbmsgs  =   $c328   ; Tableau de Vecteurs de messages d'erreur BASIC.
bmiscmsg=   $c364   ; Messages divers.
bscntk  =   $c38a   ; Trouvez les entrées FOR et GOSUB sur la pile.
bmakspc =   $c3b8   ; Libérer de l'espace en mémoire pour une nouvelle ligne 
                    ; ou variable BASIC.
bmovebl =   $c3bf   ; Déplacer un bloc de mémoire.
bstkspc =   $c3fb   ; Vérifiez si l'espace demandée est disponible sur la pile.
bramspc =   $c408   ; Vérifiez que l'espace demandé dans la zone dynamique est 
                    ; disponible.
bmemerr =   $c435   ; Définir le code du message d'erreur OUT OF MEMORY.
berror  =   $c437   ; Routine de message d'erreur BASIC.
bprdy   =   $c469   ; Afficher ERREUR, ou un autre message indiqué.
bready  =   $c474   ; Afficher le message READY.
bmain   =   $c480   ; Boucle principale BASIC, recevoir et exécuter ou stocker 
                    ; la ligne BASIC.
bnewlin =   $c49c   ; Stocker/remplacer une ligne de programme BASIC.
blnkprg =   $c533   ; Rechaîner les lignes du programme BASIC.
bgetlin =   $c560   ; Recevoir les données du périphérique et remplir la 
                    ; mémoire tampon de texte BASIC.
bcrnch  =   $c579   ; Tokenisez la ligne BASIC dans le tampon de texte BASIC.
bfinlin =   $c613   ; Trouvez la ligne BASIC à partir de son numéro de ligne.
bnew    =   $c642   ; Commande BASIC NEW.
bclr    =   $c642   ; Commande BASIC CLR.
bstxtpt =   $c69c   ; Ramener TXTPTR au début du programme.
blist   =   $c69c   ; Commande BASIC LIST.
bqplop  =   $c71a   ; Liste des mots-clés BASIC détokenisés.
bfor    =   $c742   ; Commande BASIC FOR.
bnewstt =   $c7ae   ; Recherche (pour exécution) l'instruction BASIC suivante.
bgone   =   $c7e4   ; Exécutez l'instruction BASIC actuelle.
brestore=   $c81d   ; Commande BASIC RESTORE.
btststop=   $c82c   ; Testez la touche STOP.
bbstop  =   $c82f   ; Commande BASIC STOP.
bend    =   $c831   ; Commande BASIC END.
bcont   =   $c857   ; Commande BASIC CONT.
brun    =   $c871   ; Commande BASIC RUN.
bgosub  =   $c883   ; Commande BASIC GOSUB.
bgoto   =   $c8a0   ; Commande BASIC GOTO.
breturn =   $c8d2   ; Commande BASIC RETURN.
bskipst =   $c8f8   ; Commande BASIC DATA.
bbumptp =   $c8fb   ; Incrémenter TXTPTR du montant en .Y.
bfind2  =   $c906   ; Scannez le tampon de texte BASIC à 512 ($200) pour les
                    ; délimiteurs.
bif     =   $c928   ; Commande BASIC IF.
brem    =   $c93b   ; Commande BASIC REM.
bon     =   $c94b   ; Commande BASIC ON.
bdecbin =   $c96b   ; Convertir un numéro de ligne décimal au format LSB/MSB.
blet2   =   $c9c2   ; LET : Affecter une variable entière.
blet5   =   $c9da   ; LET : Affecter TI$.
blet8   =   $ca2c   ; LET : Affecter une variable de type chaîne de caractères.
bcmd    =   $ca86   ; Commande BASIC CMD.
bprti   =   $ca9a   ; Partie de la routine PRINT.
bprint  =   $caa0   ; Commande BASIC PRINT.
bprt6   =   $cae8   ; Partie de la routine PRINT.
bprt7   =   $caf8   ; Commande BASIC TAB, SPC commands,
bprtstr =   $cb1e   ; Imprimez $YYAA jusqu'à $0d ou jusqu'à ce que le nombre
                    ; de longueurs soit décrémenté à 0.
bprtos  =   $cb3b   ; Format d'impression des caractères d'espace, de curseur
                    ; droit ou ?.
bigrerr =   $cb4d   ; Routine de formatage des messages d'erreur pour GET,
                    ; INPUT et READ.
bget    =   $cb7b   ; Commande BASIC GET.
binputn =   $cba5   ; Commande BASIC INPUT#.
binput  =   $cbbf   ; Commande BASIC INPUT.
bread   =   $cc06   ; Commande BASIC READ.
bextra  =   $ccfc   ; Messages d'erreur de INPUT.
bnext   =   $cd1e   ; Commande BASIC NEXT.
btypchk =   $cd8a   ; Vérification du type de variable.
bfrmevl =   $cd9e   ; Évaluation de formules/expressions.
beval   =   $ce83   ; Évaluer un seul terme d'une expression.
bpival  =   $ce8a   ; Le NVF. PI = $82 $49 $0f $da $a1.
bnot    =   $ced4   ; Commande BASIC NOT.
bparexp =   $cef1   ; L'évaluation entre parenthèses est effectuée.
brpachk =   $cef7   ; Vérification syntaxique pour ")".
blpachk =   $cefa   ; Vérification syntaxique pour "(".
bcomchk =   $cefd   ; Vérification syntaxique pour ",".
bsynchr =   $ceff   ; Vérification syntaxique d'un caractère spécifique dans
                    ; .A à partir de CHRGET.
bsynerr =   $cf08   ; Provoquez un message d'ERREUR DE SYNTAXE via un saut
                    ; vers ERREUR ($c437).
bfactio =   $cf0d   ; Configurer l'index pour "-" (moins monadique).
bvarrange=  $cf14   ; Vérifier la plage de la variable ?
bfacti2 =   $cf28   ; Obtenir le nom et le type de la variable à partir de
                    ; EVLVAR ($d08b).
bfacti7 =   $cfa7   ; Appel une fonction.
borr    =   $cfe6   ; Commande BASIC OR.
ffpor   =   $Cfe6   ; FONCTION NVF.: f1=f1 or f2.
bandd   =   $cfe9   ; Commande BASIC AND.
ffpand  =   $cfe9   ; FONCTION NVF.: f1=f1 and f2.

bcompar =   $d016   ; Comparer des nombres ou des chaînes de caractères.
bcmpst  =   $d02e   ; Comparez les chaînes de caractères.
bdim    =   $d081   ; Commande BASIC DIM.
bevlvar =   $d08b   ; Localiser ou créer une variable.
bfndvar =   $d0e7   ; Localiser la variable.
bchrtst =   $d113   ; Vérifie si le caractère ASCII est alphabétique.
bmakvar =   $d11d   ; Créez une nouvelle variable.
bretvp  =   $d185   ; Renvoie l'adresse de la variable trouvée ou créée.
baryhed =   $d194   ; Calculer la longueur d'un descripteur de tableau.
bmaxint =   $d1a5   ; Valeur entière maximale de 32768 en Fonction NVF.:
bintidx =   $d1aa   ; Convertir les nombres à virgule flottante en nombres à 
                    ; virgule fixe de deux octets dans les formats .A et .Y.
ff1wrday=   $d1aa   ; FONCTION NVF.: f1=word->$aayy                    
bgetsub =   $d1b2   ; Convertir une expression en nombre entier.
bmakint =   $d1bf   ; Convertir un NVF. en entier signé.
ff1swd64=   $d1bf   ; FONCTION NVF.: f1=sw(f1)->64
bary    =   $d1d1   ; Trouver un élément d'un tableau ou créer un tableau.
ff1wrd64=   $d1d2   ; FONCTION NVF.: f1=uw(f1)->64
bbadsub =   $d245   ; Affiche le message "BAD SUBSCRIPT".
bilquan =   $d248   ; Afficher le message "ILLEGAL QUANTITY".
bary2   =   $d24d   ; Tableau trouvé, vérifiez la plage d'indices.
bary6   =   $d261   ; Créer un tableau.
bary14  =   $d2ea   ; Localiser un élément particulier du tableau.
bmi6    =   $d34c   ; Calculer la taille du tableau multidimensionnel.
bfre    =   $d37d   ; Commande BASIC FRE.
bmkfp   =   $d391   ; Convertir l'entier .AAYY .Y (LSB) et .A (MSB) en virgule
                    ; flottante.
fwrdayf1=   $d391   ; FONCTION NVF.: $aayy->f1
mpos    =   $d39e   ; Commande BASIC POS.
fiyytf1 =   $d3a2   ; FONCTION NVF.: f1=float(y)
bnidirm =   $d3a6   ; Vérifiez si l'instruction est saisie en mode direct.
bundef  =   $d3ae   ; Émet un message « UNDEF'D FUNCTION » pour EVALFN ($d3f4).
bdef    =   $d3b3   ; Commande BASIC DEF.
bfn     =   $d3e1   ; Vérifie la syntaxe de DEF FN et FN.
bevalfn =   $d3f4   ; Commande BASIC FN.
bevfn3  =   $d44f   ; Stocker les valeurs DEF FN dans le descripteur de
                    ; fonction à partir de la pile.
bstr    =   $d465   ; Commande BASIC STR$.
balci   =   $d475   ; Calcul le vecteur et la longueur de la nouvelle chaine.
bmakstr =   $d487   ; Analyse et configure la chaîne.
balcspc =   $d4f4   ; Alloue de l'espace mémoire pour une chaîne de caractères.
bgrbcol =   $d526   ; Collecteur de dechets.
bgcoli3 =   $d5b5   ; Vérifiez si la chaîne la plus éligible est à collecter.
bcolect =   $d606   ; Collecte en déchets une chaine.
baddstr =   $d63d   ; Commande BASIC "+", Concaténer des chaines de caractères.
bxferstr=   $d67a   ; Déplacer la chaîne de caractères en mémoire.
bdelst  =   $d6a3   ; Supprimez une chaîne temporaire.
bdeltsd =   $d6db   ; Nettoyez la pile de descripteurs de chaînes temporaires.
bchr    =   $d6ec   ; Commande BASIC CHR$.
bleft   =   $d700   ; Commande BASIC LEFT$.
bright  =   $d72c   ; Commande BASIC RIGHT$.
bmid    =   $d737   ; Commande BASIC MID$.
bfinlmr =   $d761   ; Obtenir les paramètres de chaîne pour LEFT$, MID$ et
                    ; RIGHT$.
blen    =   $d77c   ; Commande BASIC LEN.
bgsinfo =   $d782   ; Obtenez des informations sur la chaîne.
basc    =   $d78b   ; Commande BASIC ASC.
bgetbyt =   $d79b   ; Obtenir un nombre compris entre 0 et 255.
ff1evalx=   $d79e   ; FONCTION NVF.: eval. expr. f1 to x.
ff1bytxx=   $d7a1   ; FONCTION NVF.: f1 to byte in x
bval    =   $d7ad   ; Commande BASIC VAL.
bgetad  =   $d7eb   ; Récupération de deux paramètres pour POKE et WAIT.
bmakadr =   $d7f7   ; Convertir le NVF. FAC en un entier
                    ; positif de deux octets.
ff1to20 =   $d7f7   ; FONCTION NVF.: f1 -> int($14,$15)
bpeek   =   $d80d   ; Commande BASIC PEEK.
bpoke   =   $d824   ; Commande BASIC POKE.
bwait   =   $d82d   ; Commande BASIC WAIT.
badd05  =   $d849   ; Additionner 0,5 à f1.
ff1p05  =   $d849   ; FONCTION NVF.: f1=f1+0,5.
blamin  =   $d850   ; Soustraction du contenu de la mémoire de f1.
ffvsf1  =   $d850   ; FONCTION NVF.: f1=fv-f1 ($yyaa)
bsub    =   $d853   ; Commande BASIC "-" (Soustraction)
ff2sf1  =   $d853   ; FONCTION NVF.: f1=f2-f1.
bplus1  =   $d862   ; Effectuer un prédécalage d'exposant (?) et continue
                    ; ci-dessous.
blaplus =   $d867   ; Ajoute FV à f1.
ffvpf1  =   $d867   ; FONCTION NVF.: f1=fv+f1 ($yyaa)
bplus   =   $d86a   ; Commande BASIC"+".
ff2pf1  =   $d86a   ; FONCTION NVF.: f1=f2+f1
bplus6  =   $d8a7   ; Rendre le résultat négatif si un emprunt a été effectué.
bzerfac =   $d8f7   ; Met f1 à zéro et rend le signe positif puisque le
                    ; résultat est nul.
fzerof1 =   $d8f7   ; FONCTION NVF.: f1=0.0
bnormlz =   $d8fe   ; Renormaliser le résultat f1.
bcomfac =   $d947   ; Complément à 2 de f1 entièrement.
ff1com2 =   $d947   ; FONCTION NVF.: f1=two's compl f1
boverfl =   $d97e   ; Affiche le message OVERFLOW et quitte.
basrres =   $d983   ; Effectuer un prédécalage d'exposant (?) et continue
                    ; ci-dessous.
bfpci   =   $d9bc   ; Constante de un pour un accumulateur à Fonction NVF.:
bloggon =   $d9c1   ; Constantes de la fonction LOG.
blog    =   $d9ea   ; Commande BASIC LOG.
btimes  =   $da28   ; Commande BASIC "*".
ff1xfv  =   $da28   ; FONCTION NVF.: f1=f1*fv ($yyaa)
ff1xf2  =   $da2b   ; FONCTION NVF.: f1=f1*f2
btimes3 =   $da59   ; Sous-programme de multiplication de .A.
ff1maa  =   $da59   ; FONCTION NVF.: f1=f1*.A
blodarg =   $da8c   ; Déplacer la mémoire à virgule flottante vers FAC2.
ffvtf2  =   $da8c   ; FONCTION NVF.: fv $(yyaa) -> f2
bmuldiv =   $dab7   ; Additionne les exposants de f1 et f2
bmulten =   $dae2   ; Multiplie f1 par 10.
ff1x10  =   $dae2   ; FONCTION NVF.: f1=f1*10
bfpcten =   $daf9   ; +10 constante à virgule flottante : $84,$20,$00,$00,$00.
bdivten =   $dafe   ; Divise F1 par 10.
ff1d10  =   $dafe   ; FONCTION NVF.: f1=f1/10
bladiv  =   $db0f   ; Déplace le NVF. en mémoire vers f2.
ffvdf1  =   $db0f   ; FONCTION NVF.: f1=fv/f1 ($yyaa)
bdivide =   $db12   ; Commande BASIC "/".
ff2df1  =   $db12   ; FONCTION NVF.: f1=f2/f1
blodfac =   $dba2   ; Déplace le NVF. en mémoire dans f1.
ffvtf1  =   $dba2   ; copie fv $(yyaa) to f1
bfactf2 =   $dbc7   ; Déplace f1 en mémoire.
ff1t5c  =   $dbc7   ; FONCTION NVF.: Copie f1 vers $5c-$60.
bfactf1 =   $dbca   ; Déplace f1 en mémoire.
ff1t57  =   $dbca   ; FONCTION NVF.: copie f1 vers $57-$5b.
bfactfp =   $dbd0   ; Déplace f1 en mémoire.
ff1t49  =   $dbd0   ; FONCTION NVF.: copie f1 vers $49-$4a.
bstorfac=   $dbd4   ; Déplace FAC1 en mémoire.  
ff1tyx  =   $dbd4   ; FONCTION NVF.: Copie f1 mem $yyxx.
batof   =   $dbfc   ; Transférer FAC2 vers FAC1.
ff2tf1  =   $dbfc   ; FONCTION NVF.: copie f2 to f1.
brftoa  =   $dc0c   ; Déplace FAC1 vers FAC2, avec arrondissement.
ff1tf2r =   $dc0c   ; FONCTION NVF.: Copie f1 to f2 avec arrondissement.
bftoa   =   $dc0f   ; Déplace FAC1 vers FAC2, sans arrondissement.
ff1tf2  =   $dc0f   ; FONCTION NVF.: Copie f1 to f2 sans arrondissement.
bround  =   $dc1b   ; Arrondir FAC1 en ajustant l'octet d'arrondi.
ff1rnd  =   $dc1b   ; FONCTION NVF.: f1=round(f1). 
bshgfac =   $dc2b   ; Tester le signe de FAC1.
fsngf1  =   $dc2b   ; FONCTION NVF.: Tester le signe de FAC1.
bsgn    =   $dc39   ; Commande BASIC SGN.
ff1sign =   $dc39   ; FONCTION NVF.: f1=sgn(f1).
bintfp  =   $dc3c   ; Convertie .A en NVF. dans FAC1.
fiaatf1 =   $dc3c   ; FONCTION NVF.: Conv. .A->F1.
bintfp1 =   $dc44   ; Convertir un entier 16 bits ($62,$63) en NVF. dans FAC1.
fi62tf1 =   $dc44   ; FONCTION NVF.: Conv. mot 16 bits $62,$63 a f1.
babs    =   $dc58   ; Commande BASIC ABS.
ff1abs  =   $dc58   ; FONCTION NVF.: f1=abs(f1).
bcmpfac =   $dc5b   ; Comparez FAC1 à la mémoire ($YYAA).
ffvcmp  =   $dc5b   ; FONCTION NVF.: f1=f1 comp fv ($yyaa)
bfpint  =   $dc9b   ; Convertir FAC1 en entier signé. dans $62-$65 Double-mot
ff1tudw =   $dc9b   ; FONCTION NVF.: f1-> 32 octets signé ($62-$65)
bint    =   $dccc   ; Commande BASIC INT.
ff1int  =   $dccc   ; FONCTION NVF.: f1=int(f1).
bfilfac =   $dce9   ; Stockez le contenu de .A dans les emplacements ($62-$65).
bascflt =   $dcf3   ; Convertir une chaîne ASCII en un NVF. dans FAC1.
fasctf1 =   $dcf3   ; FONCTION NVF.: f1=float(ascii)
basc18  =   $dd7e   ; Aditionne .A à FAC1.
ff1pac  =   $dd7e   ; FONCTION NVF.: f1=f1+ra val ra=0-9
bfpc12  =   $ddb3   ; Constante de conversion de chaîne de caractères en NVF.
bprtin  =   $ddc2   ; Émet le message IN.
bprtfix =   $ddcd   ; Routine d'affichage des nombres décimaux.
fiaxtf1 =   $ddcd   ; FONCTION NVF.: f1=float($aaxx)+print
bfltasc =   $dddd   ; Convertir FAC en TI$ ou en chaîne ASCII.
ff1tasc =   $dddd   ; FONCTION NVF.: f1 to ascii ($yyaa)
bflp05  =   $df11   ; 0,5 constante pour l'arrondi et SQR.
bfltcon =   $df16   ; Table des puissances de 10, au format entier fixe de
                    ; quatre octets.
bhmscon =   $df3a   ; Constantes pour la conversion de division TI$, au format
                    ; entier fixe de quatre octets
bsqr    =   $df71   ; Commande BASIC SQR.
ff1sqr  =   $df71   ; FONCTION NVF.: f1=sqrt(f1).
bexpont =   $df7b   ; Commande BASIC Puissance (touche flêche vers le haut).
ff1ef2  =   $df7b   ; FONCTION NVF.: f1=f1^f2
bnegfac =   $dfb4   ; Commande BASIC - monadique.
ff1nf1  =   $dfb4   ; FONCTION NVF.: f1=-f1.
bexpcon =   $dfbf   ; Tableau pour EXP, au format à virgule flottante.
bexp    =   $dfed   ; Commande BASIC EXP.
;------------------------------------------------------------------------------
; $e000 - $e49f Debordement de basic dans la puce du Kernal.
;------------------------------------------------------------------------------
bserevl =   $e040   ; Routine d’évaluation des séries.
bser2   =   $e056   ; Routine d'évaluation des séries mathématiques.
brndc1  =   $e08a   ; Tableau des constantes pour RND.
brnd    =   $e094   ; Commande BASIC RND.
bpatchbas=  $e0f6   ; Routines de patch BASIC.
bsystem =   $e127   ; Commande BASIC SYS.
bsave   =   $e153   ; Commande BASIC SAVE.
bbverif =   $e162   ; Commande BASIC VERIFY.
bbload  =   $e165   ; Commande BASIC LOAD.
bfopen  =   $e1bb   ; Commande BASIC OPEN.
bfclose =   $e1c4   ; Commande BASIC CLOSE.
bparsl  =   $e1d1   ; Définie les paramètres LOAD, VERIFY et SAVE.
bifchrg =   $e203   ; Vérifiez si la commande actuelle contient d'autres
                    ; caractères.
bskpcom =   $e20b   ; Ignorer toute virgule dans les paramètres analysés.
bchrerr =   $e20e   ; S'assurez qu'un paramètre soit présent après une virgule.
bparoc  =   $e216   ; Gérer les paramètres de OPEN et CLOSE.
bcos    =   $e261   ; Commande BASIC COS.
ff1cos  =   $e261   ; FONCTION NVF.: f1=sin(f1+(pi/2)).. FAC1 copié en ram.
ff1cos  =   $e264   ; FONCTION NVF.: f1=sin(f1+(pi/2)).
bsin    =   $e268   ; Commande BASIC SIN.
fFAC1sin=   $e26b   ; FONCTION NVF.: f1=sin(f1). FAC1 copié en ram.
ff1sin  =   $e26b   ; FONCTION NVF.: f1=sin(f1)
btan    =   $e2b1   ; Commande BASIC TAN.
fFAC1tan=   $e2b1   ; FONCTION NVF.: f1=sin(f1)/cos(f1). FAC1 copié en ram.
ff1tan  =   $e2b4   ; FONCTION NVF.: f1=sin(f1)/cos(f1)
bfpc20  =   $e2dd   ; Valeurs des constantes d'évaluation trigonométriques
                    ; utilisées pour COS, SIN et TAN.
batn    =   $e30b   ; Commande BASIC ATN.
ffac1atn=   $e30e   ; FONCTION NVF.: ff1=atn(f1). FAC1 copié en ram.
ff1atn  =   $e30e   ; FONCTION NVF.: ff1=atn(f1).
batncon =   $e33b   ; Tableau des valeurs constantes pour l'évaluation ATN.
bcoldba =   $e378   ; Effectue un démarrage à froid de BASIC.
bcgimag =   $e387   ; La routine CHRGET et la graine RND doivent être copiées
                    ; dans la page zéro de la RAM.
binitba =   $e3a4   ; Initialisation de BASIC : Restauration de CHRGET et des
                    ; pointeurs de page zéro.
bfremsg =   $e404   ; Afficher le message de démarrage à froid de BASIC.
bcbmmsg =   $e429   ; Message de démarrage à froid de BASIC.
bbasvctrs=  $e44f   ; Six vecteurs BASIC à copier à l'emplacement 768 ($300).
binitvctrs= $e45b   ; Copie des vecteurs BASIC de la ROM vers la RAM.
bwarmbas=   $e467   ; Effectue un démarrage à chaud de BASIC.
bpatcher=   $e476   ; Zone de "patch" programme.
;------------------------------------------------------------------------------
