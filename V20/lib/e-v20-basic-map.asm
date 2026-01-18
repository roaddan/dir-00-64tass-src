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
;         .include "e-v20-basic-map.asm"
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
bstxtpt =   $c69c   ; Ramener TXTPTR au début du programme.
bqplop  =   $c71a   ; Liste des mots-clés BASIC détokenisés.
bnewstt =   $c7ae   ; Recherche (pour exécution) l'instruction BASIC suivante.
bgone   =   $c7e4   ; Exécutez l'instruction BASIC actuelle.
btststop=   $c82c   ; Testez la touche STOP.
bbumptp =   $c8fb   ; Incrémenter TXTPTR du montant en .Y.
bfind2  =   $c906   ; Scannez le tampon de texte BASIC à 512 ($200) pour les
                    ; délimiteurs.
bdecbin =   $c96b   ; Convertir un numéro de ligne décimal au format LSB/MSB.
blet2   =   $c9c2   ; LET : Affecter une variable entière.
blet5   =   $c9da   ; LET : Affecter TI$.
blet8   =   $ca2c   ; LET : Affecter une variable de type chaîne de caractères.
bprti   =   $ca9a   ; Partie de la routine PRINT.
bprt6   =   $cae8   ; Partie de la routine PRINT.
bprtstr =   $cb1e   ; Imprimez $YYAA jusqu'à $0d ou jusqu'à ce que le nombre
                    ; de longueurs soit décrémenté à 0.
bprtos  =   $cb3b   ; Format d'impression des caractères d'espace, de curseur
                    ; droit ou ?.
bigrerr =   $cb4d   ; Routine de formatage des messages d'erreur pour GET,
                    ; INPUT et READ.
bextra  =   $ccfc   ; Messages d'erreur de INPUT.
btypchk =   $cd8a   ; Vérification du type de variable.
bfrmevl =   $cd9e   ; Évaluation de formules/expressions.
beval   =   $ce83   ; Évaluer un seul terme d'une expression.
bpival  =   $ce8a   ; Le NVF. PI = $82 $49 $0f $da $a1.
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
bcompar =   $d016   ; Comparer des nombres ou des chaînes de caractères.
bcmpst  =   $d02e   ; Comparez les chaînes de caractères.
bevlvar =   $d08b   ; Localiser ou créer une variable.
bfndvar =   $d0e7   ; Localiser la variable.
bchrtst =   $d113   ; Vérifie si le caractère ASCII est alphabétique.
bmakvar =   $d11d   ; Créez une nouvelle variable.
bretvp  =   $d185   ; Renvoie l'adresse de la variable trouvée ou créée.
baryhed =   $d194   ; Calculer la longueur d'un descripteur de tableau.
bmaxint =   $d1a5   ; Valeur entière maximale de 32768 en Fonction NVF.:
bintidx =   $d1aa   ; Convertir les nombres à virgule flottante en nombres à 
                    ; virgule fixe de deux octets dans les formats .A et .Y.
bgetsub =   $d1b2   ; Convertir une expression en nombre entier.
bmakint =   $d1bf   ; Convertir un NVF. en entier signé.
bary    =   $d1d1   ; Trouver un élément d'un tableau ou créer un tableau.
bbadsub =   $d245   ; Affiche le message "BAD SUBSCRIPT".
bilquan =   $d248   ; Afficher le message "ILLEGAL QUANTITY".
bary2   =   $d24d   ; Tableau trouvé, vérifiez la plage d'indices.
bary6   =   $d261   ; Créer un tableau.
bary14  =   $d2ea   ; Localiser un élément particulier du tableau.
bmi6    =   $d34c   ; Calculer la taille du tableau multidimensionnel.
bmkfp   =   $d391   ; Convertir l'entier .AAYY .Y (LSB) et .A (MSB) en virgule
                    ; flottante.
bnidirm =   $d3a6   ; Vérifiez si l'instruction est saisie en mode direct.
bundef  =   $d3ae   ; Émet un message « UNDEF'D FUNCTION » pour EVALFN ($d3f4).
bfn     =   $d3e1   ; Vérifie la syntaxe de DEF FN et FN.
bevfn3  =   $d44f   ; Stocker les valeurs DEF FN dans le descripteur de
                    ; fonction à partir de la pile.
balci   =   $d475   ; Calcul le vecteur et la longueur de la nouvelle chaine.
bmakstr =   $d487   ; Analyse et configure la chaîne.
balcspc =   $d4f4   ; Alloue de l'espace mémoire pour une chaîne de caractères.
bgrbcol =   $d526   ; Collecteur de dechets.
bgcoli3 =   $d5b5   ; Vérifiez si la chaîne la plus éligible est à collecter.
bcolect =   $d606   ; Collecte en déchets une chaine.
bxferstr=   $d67a   ; Déplacer la chaîne de caractères en mémoire.
bdelst  =   $d6a3   ; Supprimez une chaîne temporaire.
bdeltsd =   $d6db   ; Nettoyez la pile de descripteurs de chaînes temporaires.
bfinlmr =   $d761   ; Obtenir les paramètres de chaîne pour LEFT$, MID$ et
                    ; RIGHT$.
bgsinfo =   $d782   ; Obtenez des informations sur la chaîne.
bgetbyt =   $d79b   ; Obtenir un nombre compris entre 0 et 255.
bgetad  =   $d7eb   ; Récupération de deux paramètres pour POKE et WAIT.
bmakadr =   $d7f7   ; Convertir le NVF. FAC en un entier
                    ; positif de deux octets.
badd05  =   $d849   ; Additionner 0,5 à f1.
blamin  =   $d850   ; Soustraction du contenu de la mémoire de f1.
bplus1  =   $d862   ; Effectuer un prédécalage d'exposant (?) et continue
                    ; ci-dessous.
blaplus =   $d867   ; Ajoute FV à f1.
bplus6  =   $d8a7   ; Rendre le résultat négatif si un emprunt a été effectué.
bzerfac =   $d8f7   ; Met f1 à zéro et rend le signe positif puisque le
                    ; résultat est nul.
bnormlz =   $d8fe   ; Renormaliser le résultat f1.
bcomfac =   $d947   ; Complément à 2 de f1 entièrement.
boverfl =   $d97e   ; Affiche le message OVERFLOW et quitte.
basrres =   $d983   ; Effectuer un prédécalage d'exposant (?) et continue
                    ; ci-dessous.
bfpci   =   $d9bc   ; Constante de un pour un accumulateur à Fonction NVF.:
bloggon =   $d9c1   ; Constantes de la fonction LOG.
btimes3 =   $da59   ; Sous-programme de multiplication de .A.
blodarg =   $da8c   ; Déplacer la mémoire à virgule flottante vers FAC2.
bmuldiv =   $dab7   ; Additionne les exposants de f1 et f2
bmulten =   $dae2   ; Multiplie f1 par 10.
bfpcten =   $daf9   ; +10 constante à virgule flottante : $84,$20,$00,$00,$00.
bdivten =   $dafe   ; Divise F1 par 10.
bladiv  =   $db0f   ; Déplace le NVF. en mémoire vers f2.
blodfac =   $dba2   ; Déplace le NVF. en mémoire dans f1.
ffvtf1  =   $dba2   ; copie fv $(yyaa) to f1
bfactf2 =   $dbc7   ; Déplace f1 en mémoire.
bfactf1 =   $dbca   ; Déplace f1 en mémoire.
bfactfp =   $dbd0   ; Déplace f1 en mémoire.
bstorfac=   $dbd4   ; Déplace FAC1 en mémoire.  
batof   =   $dbfc   ; Transférer FAC2 vers FAC1.
brftoa  =   $dc0c   ; Déplace FAC1 vers FAC2, avec arrondissement.
bftoa   =   $dc0f   ; Déplace FAC1 vers FAC2, sans arrondissement.
bround  =   $dc1b   ; Arrondir FAC1 en ajustant l'octet d'arrondi.
bshgfac =   $dc2b   ; Tester le signe de FAC1.
bintfp  =   $dc3c   ; Convertie .A en NVF. dans FAC1.
bintfp1 =   $dc44   ; Convertir un entier 16 bits ($62,$63) en NVF. dans FAC1.
bcmpfac =   $dc5b   ; Comparez FAC1 à la mémoire ($YYAA).
bfpint  =   $dc9b   ; Convertir FAC1 en entier signé. dans $62-$65 Double-mot
bfilfac =   $dce9   ; Stockez le contenu de .A dans les emplacements ($62-$65).
bascflt =   $dcf3   ; Convertir une chaîne ASCII en un NVF. dans FAC1.
basc18  =   $dd7e   ; Aditionne .A à FAC1.
bfpc12  =   $ddb3   ; Constante de conversion de chaîne de caractères en NVF.
bprtin  =   $ddc2   ; Émet le message IN.
bprtfix =   $ddcd   ; Routine d'affichage des nombres décimaux.
bfltasc =   $dddd   ; Convertir FAC en TI$ ou en chaîne ASCII.
bflp05  =   $df11   ; 0,5 constante pour l'arrondi et SQR.
bfltcon =   $df16   ; Table des puissances de 10, au format entier fixe de
                    ; quatre octets.
bhmscon =   $df3a   ; Constantes pour la conversion de division TI$, au format
                    ; entier fixe de quatre octets
bexpcon =   $dfbf   ; Tableau pour EXP, au format à virgule flottante.
;------------------------------------------------------------------------------
; $e000 - $e49f Debordement de basic dans la puce du Kernal.
;------------------------------------------------------------------------------
bserevl =   $e040   ; Routine d’évaluation des séries.
bser2   =   $e056   ; Routine d'évaluation des séries mathématiques.
brndc1  =   $e08a   ; Tableau des constantes pour RND.
bpatchbas=  $e0f6   ; Routines de patch BASIC.
bparsl  =   $e1d1   ; Définie les paramètres LOAD, VERIFY et SAVE.
bifchrg =   $e203   ; Vérifiez si la commande actuelle contient d'autres
                    ; caractères.
bskpcom =   $e20b   ; Ignorer toute virgule dans les paramètres analysés.
bchrerr =   $e20e   ; S'assurez qu'un paramètre soit présent après une virgule.
bparoc  =   $e216   ; Gérer les paramètres de OPEN et CLOSE.
bfpc20  =   $e2dd   ; Valeurs des constantes d'évaluation trigonométriques
                    ; utilisées pour COS, SIN et TAN.
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
