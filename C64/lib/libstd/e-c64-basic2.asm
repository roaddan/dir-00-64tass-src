;-----------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-Basic2.asm
; Type fichier....: Variables
; Creation........: 20151208 
; Version.........:
; Révision........: 20261026-223332
;                   20261024-222156, Francisation des commentaires,
; Inspiration ....: Mapping The C64 
;                   Sheldon Leemon 
;                   ISBN: 0-87455-082-3
;-----------------------------------------------------------------------------
; e-c64-Basic2.asm - Carthographie memoire et declaration de constantes pour
; le Basic 2.0 du commodores 64 et 64c
;-----------------------------------------------------------------------------
; Segmentation principales de la mémoire
;-----------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass
; utilisez la syntaxes ...
;
;         .include "e-c64-Basic2.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire
; que votre programme.
;-----------------------------------------------------------------------------
; Sauf avis contraire, le signe [C=] représente la touche Commodore.
;-----------------------------------------------------------------------------
; Commandes écran à utiliser avec l'appel chrout ($ffd2) du Kernal.
;-----------------------------------------------------------------------------
; Coleurs à utiliser avec $ffd2 ou PRINT. 
; Le mot GRAY s'écrit de manière différente selon le pays d'origine.
;  Canada, Grande Bretagne = GRAY, USA = GREY.
; Le premier nombre apres le ; est le code à placer en mémoire vidéo pour 
; ... obtenir la même couleur.
;-----------------------------------------------------------------------------
b_black        =     144   ;$00, Touches Basic = [CTRL]+[1]. Noir.
b_white        =     5     ;$01, Touches Basic = [CTRL]+[2]. Blanc.
b_red          =     28    ;$02, Touches Basic = [CTRL]+[3]. Rouge.
b_cyan         =     159   ;$03, Touches Basic = [CTRL]+[4]. Cyan.
b_purple       =     156   ;$04, Touches Basic = [CTRL]+[5]. Mauve.
b_magenta      =     156   ;$04, Touches Basic = [CTRL]+[5]. Mauve.
b_green        =     30    ;$05, Touches Basic = [CTRL]+[6]. Vert.
b_blue         =     31    ;$06, Touches Basic = [CTRL]+[7]. Bleu.
b_yellow       =     158   ;$07, Touches Basic = [CTRL]+[8]. Jaune.
b_orange       =     129   ;$08, Touches Basic = [C=]+[1].   Orange.
b_brown        =     149   ;$09, Touches Basic = [C=]+[2].   Brun.
b_ltred        =     150   ;$0a, Touches Basic = [C=]+[3].   Rose.
b_gray3        =     155   ;$0b, Touches Basic = [C=]+[4].   Gris foncé.
b_grey3        =     155   ;$0b, Touches Basic = [C=]+[4].   Gris foncé.
b_gray2        =     152   ;$0c, Touches Basic = [C=]+[5].   Gris moyen.
b_grey2        =     152   ;$0d, Touches Basic = [C=]+[5].   Gris moyen.
b_ltgreen      =     153   ;$0d, Touches Basic = [C=]+[6].   Vert pâle.
b_ltblue       =     154   ;$0e, Touches Basic = [C=]+[7].   Bleu pâle.
b_gray1        =     151   ;$0f, Touches Basic = [C=]+[8].   Gris pâle.
b_grey1        =     151   ;$0f, Touches Basic = [C=]+[8].   Gris pâle.
;-----------------------------------------------------------------------------
; Pour le code francophone à utiliser avec $ffd2 ou PRINT.
; Le premier chiffre en commentaire représente la valeur à placer en mémoire 
; ... vidéo pour obtenir la même couleur.
;-----------------------------------------------------------------------------
b_noir         =     144   ;$00, Touches Basic = [CTRL]+[1]. Noir.
b_blanc        =     5     ;$01, Touches Basic = [CTRL]+[2]. Blanc.
b_rouge        =     28    ;$02, Touches Basic = [CTRL]+[3]. Rouge.
;b_cyan        =     159   ;$03, Touches Basic = [CTRL]+[4]. Cyan
b_mauve        =     156   ;$04, Touches Basic = [CTRL]+[5]. Mauve.
b_vert         =     30    ;$05, Touches Basic = [CTRL]+[6]. Vert.
b_bleu         =     31    ;$06, Touches Basic = [CTRL]+[7]. Bleu.
b_jaune        =     158   ;$07, Touches Basic = [CTRL]+[8]. Jaune.
;b_orange      =     129   ;$08, Touches Basic = [C=]+[1].   Orange.
b_brun         =     149   ;$09, Touches Basic = [C=]+[2].   Brun.
b_rose         =     150   ;$0a, Touches Basic = [C=]+[3].   Rose.
b_gris3        =     155   ;$0b, Touches Basic = [C=]+[4].   Gris foncé.
b_grisf        =     155   ;$0b, Touches Basic = [C=]+[4].   Gris foncé.
b_gris2        =     152   ;$0c, Touches Basic = [C=]+[5].   Gris moyen.
b_grism        =     152   ;$0c, Touches Basic = [C=]+[5].   Gris moyen.
b_vert2        =     153   ;$0d, Touches Basic = [C=]+[6].   Vert pâle.
b_vertp        =     153   ;$0d, Touches Basic = [C=]+[6].   Vert pâle.
b_bleu2        =     154   ;$0e, Touches Basic = [C=]+[7].   Bleu pâle.
b_bleup        =     154   ;$0e, Touches Basic = [C=]+[7].   Bleu pâle.
b_gris1        =     151   ;$0f, Touches Basic = [C=]+[8].   Gris pâle. 
b_grisp        =     151   ;$0f, Touches Basic = [C=]+[8].   Gris pâle. 
b_gris         =     151   ;$0f, Touches Basic = [C=]+[8].   Gris pâle.    
;-----------------------------------------------------------------------------
; Code des jeux de charactères à utiliser avec $ffd2 ou PRINT.
;-----------------------------------------------------------------------------
b_rvs_on       =     18    ; Touches Basic = [CTRL]+[9]
b_rvs_off      =     146   ; Touches Basic = [CTRL]+[0]
b_lowercase    =     14    ; Touches Basic = [C=]+[SHIFT] (Bascule)
b_uppercase    =     142   ; Touches Basic = [C=]+[SHIFT] (Bascule)
b_dis_cmd      =     8     ;     Bloque la combinaison de touches [C=]+[SHIFT]. 
b_ena_cmd      =     9     ;     Permet la combinaison de touches [C=]+[SHIFT]. 
;-----------------------------------------------------------------------------
; Mouvements du curseur à utiliser avec $ffd2 ou PRINT.
;-----------------------------------------------------------------------------
b_crsr_up      =     145   ; Touches Basic = [SHIFT]+[CRSR] (vertical)
b_crsr_down    =     17    ; Touches Basic = [CRSR] (vertical)
b_crsr_left    =     157   ; Touches Basic = [SHIFT]+[CRSR] (horizontal)
b_crsr_right   =     29    ; Touches Basic = [CRSR] (horizontal)
b_home         =     19    ; Touches Basic = [CLR/HOME]
b_clr_home     =     147   ; Touches Basic = [SHIFT]+[CLR/HOME]
b_insert       =     20    ; Touches Basic = [INST/DEL]
b_delete       =     148   ; Touches Basic = [SHIFT]+[INST/DEL]
b_shft_ret     =     141   ; Touches Basic = [SHIFT]+[RETURN]
;-----------------------------------------------------------------------------
; Codes des clefs de fonction.
;-----------------------------------------------------------------------------
b_f1           =     133   ; Touches Basic = [F1/F2]
b_f2           =     137   ; Touches Basic = [SHIFT]+[F1/F2]
b_f3           =     134   ; Touches Basic = [F3/F4]
b_f4           =     138   ; Touches Basic = [SHIFT]+[F3/F4]
b_f5           =     135   ; Touches Basic = [F5/F6]
b_f6           =     139   ; Touches Basic = [SHIFT]+[F5/F6]
b_f7           =     136   ; Touches Basic = [F7/F8]
b_f8           =     140   ; Touches Basic = [SHIFT]+[F7/F8]
;------------------------------------------------------------------------------
; Constantes pour fichier l-c64-drawbox.asm.
; Constantes des caractères de dessin de boîte disponnible dans tous les modes
; de caractères (majuscule et minuscule).
;------------------------------------------------------------------------------
tleft          =     176   ; Coin suppérieur gauche.
tright         =     174   ; Coin suppérieur droit.
bleft          =     173   ; Coin inférieur gauche.
bright         =     189   ; Coin inférieur droit.
hleft          =     171   ; Extrémité gauche d'une ligne médianne.
hright         =     179   ; Extrémité droite d'une ligne médianne.
vline          =     221   ; Ligne verticale.
hline          =     192   ; Ligne horizontale.
space          =     32    ; Caractère espace.
;-----------------------------------------------------------------------------
; Modèle de boîte disponible dans tous les jeux de caractères.
;-----------------------------------------------------------------------------
b_ul           =     172   ; Coin suppérieur gauche (Upper left corner).
                           ; Touches Basic = [C=]+[D]  
b_ur           =     187   ; Coin suppérieur droit  (Upper right corner). 
                           ; Touches Basic = [C=]+[F]  
b_ll           =     190   ; Coin inférieur gauche  (Lower left corner). 
                           ; Touches Basic = [C=]+[C]  
b_lr           =     188   ; Coin inférieur droit   (Lower right corner). 
                           ; Touches Basic = [C=]+[V]  
b_vl           =     182   ; Ligne vertivale gauche (left vertical line). 
                           ; Touches Basic = [C=]+[K]  
b_vr           =     181   ; Ligne vertivale droite (right vertical line). 
                           ; Touches Basic = [C=]+[H]  
b_bo           =     184   ; Ligne inférieure       (Bottom line). 
                           ; Touches Basic = [C=]+[U]  
b_to           =     185   ; Ligne suppérieur       (Top line). 
                           ; Touches Basic = [C=]+[O]  
;-----------------------------------------------------------------------------
; Others
;-----------------------------------------------------------------------------
b_eot          =     $00   ; Fin du texte.
b_inpbuff      =     $0200 ; Tampon d'entrée
b_crlf         =     $0d   ; Retour de charriot + nouvelle ligne.
b_space        =     $20   ; Caractère d'espacement
b_fac1         =     $61   ; Accumulateur #1 point flottant. (sur 7 octets)
b_fac2         =     $69   ; Accumulateur #2 point flottant. (sur 7 octets)
;-----------------------------------------------------------------------------
; Constantes sur les éléments importants.
;-----------------------------------------------------------------------------
; Basic 2.0 entry point
;-----------------------------------------------------------------------------
;Nom_fonction  =     Adres ; Description. Registre utilisé ->        ;INP;OUT;
b_opentxtspc   =     $a3bb ; Espace ouvert en texte BASIC.           ;a-y;---; Array top $yyaa
b_chkavailmem  =     $a408 ; Vérifier la mémoire disponible.         ;a-y;---; Array top $yyaa
b_outofmem     =     $a435 ; ?Mémoire insuffisante.                  ;---;---;        
b_errormesg    =     $a437 ; Envoyer un message d'erreur BASIC.      ;a--;---; a = errno
b_warmstart    =     $a474 ; Démarrage à chaud de Basic.             ;---;---;
b_chrgetentry  =     $a48a ; Entrée CHRGET principale.               ;---;---; 
                           ; Conditions préalables: $7a=#$ff,$7b=#$01, 
                           ;                        ($77,$78),
                           ;                        $01ff=Basic inbuf-1
b_newline      =     $a49c ; Traiter les jetons, insérer une ligne.  ;-x-;---; x = buff len
b_clrready     =     $a52a ; Correction d'enchaînement CLR et READY. ;---;---;
b_fixchaining  =     $a533 ; Correction d'enchaînement.              ;---;---;
b_kbgetline    =     $a560 ; Recevoir une ligne depuis le clavier.
                           ; Conditions préalables: $7a=#$ff,$7b=#$01, 
                           ;                        ($77,$78),
                           ;                        $01ff=Basic inbuf-1
b_crunchtkns   =     $a579 ; Traiter les jetons.                     ;-x-;---: x = buff len
b_findline     =     $a613 ; Rechercher une ligne en BASIC.          ;ax-;---; strBAS = $xxaa
b_new          =     $a642 ; Exécute NEW.                            ;---;---;
b_resetclr     =     $a659 ; Réinitialiser BASIC et exécuter CLR.    ;---;---; 
b_clr          =     $a65e ; Exécute CLR                             ;---;---;
;Pas dans BASIC 2  $xxxx   ; Vider la pile de toutes les valeurs de retour
b_rstchrget    =     $a68e ; Rétablir CHRGET au début du BASIC       ;---;a--; strBAS hi
b_continue     =     $a857 ; Exécute CONTINUE.                       ;a-y;---; curline $yyaa
b_getint       =     $a96b ; Extraire un entier d'un texte BASIC.    ;---;---;
                           ; Conditions préalables: $7a=#$ff,$7b=#$01, 
                           ;                        ($77,$78),
b_sndcr        =     $aad3 ; Envoyer RETURN, LF en mode écran.       ;---;a--; a = LF
b_sndcrlf      =     $aad7 ; Envoyer RETURN, LINEFEED.               ;---;a--; a = LF
b_outstr_ay    =     $ab1e ; Afficher la chaîne à partir de $yyaa.   ;a-y;---; sptr = $yyaa
b_puts         =     b_outstr_ay
b_outstrprep   =     $ab24 ; Afficher une chaîne précalculée.        ;a--;---; a = strlen
                           ; Conditions préalables: Adresse de chaine dans 
                           ; ... $22,$23 ($1f,$20)
b_printqm      =     $ab45 ; Imprimer '?'.                           ;---;---;                      
b_sendchar     =     $ab47 ; Envoyer 1 caractère vers périphérique.  ;a--;a--; a = char                      
b_intobuff     =     $abf9 ; Lire des caractères depuis l'entrée standard 
                           ; ... (stdin) et les écrire dans le tampon à 
                           ; ... l'adresse $200.
b_frmnum       =     $ad8a ; Évaluer une expression numérique et/ou 
                           ; ... vérifier l’absence d’incohérence entre 
                           ; ... les types de données
b_evalexpr     =     $ad9e ; Évaluer l'expression.                      
                           ; Conditions préalables: 
                           ; ... Adresse de l'expression dans le pointeur 
                           ; ... CHRGET.             
                           ; Resultat: chaine    $0d = #$FF ($07)    ;---;a-y; expaddr =  $yyaa               
                           ;           numerique $0d = #$00 ($07)    ;---;a--; a = result
b_chk4comma    =     $aefd ; Vérifier la présence d'ue virgule.      ;---;a--; a = char
b_chk4lpar     =     $aefa ; Vérifier la présence de « ( ».          ;---;a--; a = char
b_chk4rpar     =     $aef7 ; Vérifier la présence de « ) ».          ;---;a--; a = char
b_syntaxerr    =     $af08 ; Transmet « SYNTAX ERROR ».              ;---;---;
b_fort         =     $afe6 ; FAC1 = FAC1 or FAC2.
b_fandt        =     $afe9 ; FAC1 = FAC1 and FAC2.
b_fndfloatvar  =     $b0e7 ; Rechercher variable float par son nom.  ;---;a-y; addr = $yyaa
                           ; Conditions préalables: 
                           ;            Nom dans $45,$46 ($42,$43)
b_bumpvaraddr  =     $b185 ; Augmenter l'adresse de la variable de 2. 
                           ; Conditions préalables: 
                           ;            Nom dans $45,$46 ($42,$43).
                           ;                                         ;---;a-y; addr = $yyaa
b_ftoint       =     $b1aa ; Convertie FAC1 en 16 bits dans $aayy    ;---;a-y; int = $aayy
b_float2int    =     $b1bf ; Convertie FAC1 en entier dans 
                           ; ... $64(lsb),$65(msb). Fonctionne uniquement 
                           ; ... si FAC1 se situe entre -32768 and +[3]2767.
b_num2int      =     $b1d2 ; Convertie l'expression numérique flottante 
                           ; ... en entier dans $64(lsb),$65(msb). 
b_fcerr        =     $b248 ; Afficher le message d’erreur 
                           ; ... «ILLEGAL QUANTITY».
b_int2float    =     $b391 ; Conversion d'un entier en nombre à virgule 
                           ; ... flottante dans FAC1.                ;---;---;
b_ytofac1      =     $b3a2 ; Convertir int(y) en FAC1.               ;--y;---;
b_getacc1lsb   =     $b79e ; Obtien le LSB de FAC1 dans x.           ;---;-x-; x = FAC1 LSB
b_fac1tox      =     $b7a1 ; Convertir FAC1 en octet dans x.         ;---;-x-; x = byte
b_str2float    =     $b7b5 ; Évaluer une chaîne en nombre à virgule 
                           ; ... flottante (VAL)                     ;---;---;
                           ; Conditions préalables: Adresse de la chaine
                           ; ... CHRGET.
                           ; Resultat: Valeur en point flottant dans 
                           ; ... FAC1.
b_strxy2float  =     $b7b9 ; Évaluer un nombre à point flottant à 
                           ; ... partir d'une chaîne de caractères dans xy.       
                           ;                                         ;---;-xy; strptr = $yyxx
                           ; Resultat: Valeur en point flottant 
                           ; ... dans FAC1.
b_evfint2x     =     $b7e9 ; Convertir FAC1 en octet dans x.         ;---;-x-; x = byte  
b_getpokeprms  =     $b7eb ; Obtenez 2 paramètres pour POKE, WAIT.   ;---;-x-; x = Param2
                           ; Conditions préalables: Straddr in CHRGET ptr.  
                           ; Resultat: param2 dans FAC1.
b_getadr       =     $b7f7 ; Convertir un nombre à point flottant en un 
                           ; ... entier non signé de deux octets.
b_faddh        =     $b849 ; FAC1 = FAC1 + 0.5 
b_fsub         =     $b850 ; FAC1 = FVAR - FAC1.                     ;a-y;---; ptr = $yyaa
b_fsubt        =     $b853 ; FAC1 = FAC2 - FAC1.                     ;---;---;                      
b_fadd         =     $b867 ; FAC1 = FVAR + FAC1.                     ;a-y;---; ptr = $yyaa                
b_memfloatadd  =     $b867 ; Aditionner une valeur en mémoire.       ;a-y;---; ptr = $yyaa
b_faddt        =     $b86a ; FAC1 = FAC2 + FCA1 
b_f2addf1      =     $b86a ; FAC1 = FAC2 + FCA1
b_fcomp2       =     $b947 ; FAC1 = INV(FAC1) + 1
b_fmulv        =     $ba28 ; FCA1 = FAC1 * FVAR.                     ;a-y;---; ptr = $yyaa
b_memfloatmul  =     $ba28 ; Multiplier par une valeur en mémoire.   ;a-y;---; ptr = $yyaa
b_fmult        =     $ba2b ; FAC1 = FAC1 * FAC2
b_conupk       =     $ba8c ; Copier FVAR vers FAC2.                  ;a-y;---; ptr = $yyaa
b_mul10        =     $bae2 ; FAC1 = FAC1 * 10.
b_acc1mul10    =     $bae2 ; Multiplier FAC1 par 10.                 ;---;---; ptr = $yyaa
b_fdiv10       =     $bafe ; FAC1 = FAC1 / 10.
b_fdiv         =     $bb0f ; FAC1 = FVAR / FAC1                     
b_vdivf        =     $bb0f ; FAC1 = FVAR / FAC1.                     ;a-y;---; ptr = $yyaa
b_fdivt        =     $bb12 ; FAC1 = FAC2 / FAC1.
b_movfm        =     $bba2 ; Copy FVAR to FAC1.                      ;a-y;---; ptr = $yyaa
b_memvar2acc1  =     $bba2 ; FAC1 = FVAR                             ;a-y;---; ptr = $yyaa
b_cpfac1tow2   =     $bbc7 ; Copier FAC1 vers WORK#2 ($5c-$60)
b_cpfac1tow1   =     $bbca ; Copier FAC1 vers WORK#1 ($57-$5b)
b_cpfac1to49   =     $bbd0 ; Copier FAC1 vers FORPNT ($49-$4a)
b_fac1toaddr   =     $bbd4 ; Copier FAC1 vers memory.                ;-xy;---; ptr = $yyxx
b_cpfac1toxy   =     $bbd7 ; Copier FAC1 vers mem location.          ;-xy;---; ptr = $yyxx
b_movfa        =     $bbfc ; 
b_acc2toacc1   =     $bbfc ; Copier FAC2 to FAC1.                    ;---;---; 
b_fac1sign     =     $bc2b ; Vérifier le signe de FAC1.
b_sgn          =     $bc39 ; FAC1 = SIGN(FAC1)
b_atofac1      =     $bc3c ; Convertir l'entier a en FAC1.           ;a--;---; a = int 
b_int2fac1     =     $bc44 ; $62(lsb),$63(msb) entier dans FAC1
b_abs          =     $bc58 ; FAC1 = ABS(FAC1)
b_fcomp        =     $bc5b ; Acc. = Compare FAC1 et (FVAR).          ;a-y;a--; ptr = $yyaa
                           ;         Acc. devient 0 =, 1 >, $FF <
b_movaf        =     $bc0c ; Arrondi et déplace FAC1 vers FAC2.
b_rndac1ac2    =     $bc0c ; Arrondi et déplace FAC1 vers FAC2.      ;---;---;  
b_urndac1ac2   =     $bc0f ; Copie FAC1 dans FAC2.                   ;---;---;  
b_round        =     $bc1b ; Arrondi FAC1
b_rndac1       =     $bc1b ; Arrondi FAC1                            ;---;---; 
b_qint         =     $bc9b ; Convertit FAC1 en entier dans FAC1.
b_int          =     $bccc ; FAC1 = INT(FAC1)
b_fin          =     $bcf3 ; Convertir une chaine décimal (format ASCII) 
                              ; ... dans FAC1.
b_addf1acc     =     $bd7e ; Ajouter Acc à FAC1 (a=0-9)              ;a--;---;
b_linptr       =     $bdcd ; Afficher la valeur en virgule fixe.     ;ax-;---; Value = $aaxx  
b_putint       =     $bdcd ; Afficher la valeur en virgule fixe.     ;ax-;---; Value = $aaxx 
b_putfloat     =     $bdd7 ; Print FAC1 float.                       ;---;---;
b_fout         =     $bddd ; Converti FAC1 en chaine à $0100.        ;a-y;---; a=#$00, y=#$01
b_num2str      =     $bddd ; Converti FAC1 en chaine à $0100.        ;a-y;---; a=#$00, y=#$01
b_sqr          =     $bf71 ; FAC1 = SQRT(FAC1).
b_fpwrt        =     $bf7b ; FAC1 = FAC1 ^ FAC2. 
b_poly2        =     $e059 ; Évaluation de polynôme
b_initcgt      =     $e3bf ; Initialiser tous les emplacements de la page 
                           ; ... zéro du BASIC contenant des valeurs fixes.   
;-----------------------------------------------------------------------------
; Equates pour le livre Tool Kit: Basic
;-----------------------------------------------------------------------------
b_chrget       =     $0073
b_chrgot       =     $0079
b_axout        =     $bdcd ; Afficher la valeur en virgule fixe.     ;ax-;---; Value = $xxaa 
b_intcgt       =     $e3bf ; Initialiser tous les emplacements de la page 
                           ; ... zéro du BASIC contenant des valeurs fixes.
b_ascflt       =     $bcf3 ; Conversion de nombre décimal ASCII en FAC1,
b_prompt       =     $abf9 ; Lire des caractères depuis l'entrée standard 
                           ; ... (stdin) et les écrire dans un tampon, à 
                           ; ... l'adresse $200.   
b_facasc       =     $bddd ; Conversion de nombre en chaîne à l'adresse 
                           ; ... $0100.                              ;a-y;---; a=#$00, y=#$01
b_fvtf1        =     $bba2 ; Copie FVAR vers FAC1.                   ;a-y;---; ptr = $yyaa
b_strout       =     $ab24 ; Afficher la chaîne précalculée.         ;a--;---; a = strlen
b_f1t57        =     $bbca ; Copie FAC1 vers WORK#1 (57-$5b)
b_f1xfv        =     $ba28 ; Multiplie FAC1 par FVAR.                ;a-y;---; ptr = $yyaa
b_f1tmem       =     $bbd4 ; Copier FAC1 vers FVAR.                  ;-xy;---; ptr = $yyxx
b_f1x10        =     $bae2 ; Multiplie FAC1 par 10.                  ;---;---; ptr = $yyaa
b_f1d10        =     $bafe ; FAC1 = FAC1 / 10.
b_sgnf1        =     $bc2b ; Vérifier le signe de FAC1
b_f1tf2        =     $bc0c ; Arrondie FAC1 et le copie dans FAC2.    ;---;---;  
b_f1xf2        =     $ba2b ; FAC1 = FAC1 * FAC2
b_fvdf1        =     $bb0f ; FAC1 = FVAR / FAC1.                     ;a-y;---; ptr = $yyaa
b_memtf2       =     $ba8c ; Copie FVAR dans FAC2.                   ;a-y;---; ptr = $yyaa
b_f2df1        =     $bb12 ; FAC1 = FAC2 / FAC1.
b_f1pfv        =     $b867 ; FAC1 = FAC1 + FVAR.                     ;a-y;---; ptr = $yyaa 
b_f2sf1        =     $b853 ; FAC1 = FAC2 - FAC1.                     ;---;---;  
b_fvsf1        =     $b850 ; FAC1 = FVAR - FAC1.                     ;a-y;---; ptr = $yyaa 
b_f1pacc       =     $bd7e ; Aditionne Acc. à FAC1 (a=0-9)           ;a--;---;
b_f1pf2        =     $b86a ; FAC1 = FAC2 + FCA1 
b_expon        =     $bf7b ; FAC1 = FAC1 ^ FAC2.  
b_fpand        =     $afe9 ; FAC1 = FAC1 and FAC2.
b_f1orf2       =     $afe6 ; FAC1 = FAC1 or FAC2.
b_sqrtf1       =     $bf71 ; FAC1 = SQRT(FAC1).
b_intf1        =     $bccc ; FAC1 = INT(FAC1)
b_f1t5c        =     $bbc7 ; Copier FAC1 vers WORK#2 ($5c-$60)
b_f1cfv        =     $bc5b ; FAC1 = FAC1 comp(FVAR).                 ;a-y;---; ptr = $yyaa  
b_comp         =     $bc5b ; FAC1 = FAC1 comp(FVAR).                 ;a-y;---; ptr = $yyaa 
b_f1tx         =     $b7a1 ; Conv FAC1 to byte in x.                 ;---;-x-; x = byte
b_fltay        =     $b1aa ; FAC1 to word in $aayy                   ;---;a-y; imt =  $aayy
b_ytfl1        =     $b3a2 ; Convertion int(y) to FAC1.                 ;--y;---;
b_poly         =     $e059 ; Évaluation de polynôme
