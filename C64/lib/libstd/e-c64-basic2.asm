;-----------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-basic2.asm
; Dernière m.à j. : 20261026-223332
; Révision........: 20261024-222156, Francisation des commentaires,
; Inspiration ....: Mapping The C64 
;                   Sheldon Leemon 
;                   ISBN: 0-87455-082-3
;-----------------------------------------------------------------------------
; e-c64-basic2.asm - Carthographie memoire et declaration de constantes pour
; le Basic 2.0 du commodores 64 et 64c
;-----------------------------------------------------------------------------
; Segmentation principales de la mémoire
;-----------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou avec 64tass
; utilisez la syntaxes ...
;
;         .include "e-c64-basic2.asm"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire
; que votre programme.
;-----------------------------------------------------------------------------
; Commandes écran à utiliser avec l'appel chrout ($ffd2) du Kernal.
;-----------------------------------------------------------------------------
; Coleurs
;-----------------------------------------------------------------------------
b_black           =     144  ;0,  ctrl-1
b_white           =     5    ;1,  ctrl-2
b_red             =     28   ;2,  ctrl-3
b_cyan            =     159  ;3,  ctrl-4
b_purple          =     156  ;4,  ctrl-5
b_green           =     30   ;5,  ctrl-6
b_blue            =     31   ;6,  ctrl-7
b_yellow          =     158  ;7,  ctrl-8
b_orange          =     129  ;8,  C=-1
b_brown           =     149  ;9,  C=-2
b_ltred           =     150  ;10, C=-3
b_gray3           =     155  ;11, C=-4
b_grey3           =     155  ;11, C=-4
b_gray2           =     152  ;12, C=-5
b_grey2           =     152  ;13, C=-5
b_ltgreen         =     153  ;13, C=-6
b_ltblue          =     154  ;14, C=-7
b_gray1           =     151  ;15, C=-8
b_grey1           =     151  ;15, C=-8
;-----------------------------------------------------------------------------
; Pour le code francophone.
;-----------------------------------------------------------------------------
b_noir            =     144  ;0,  ctrl-1
b_blanc           =     5    ;1,  ctrl-2
b_rouge           =     28   ;2,  ctrl-3
; b_cyan           =     159  ;3,  ctrl-4 ; Pareil à l'anglais
b_mauve           =     156  ;4,  ctrl-5
b_vert            =     30   ;5,  ctrl-6
b_bleu            =     31   ;6,  ctrl-7
b_jaune           =     158  ;7,  ctrl-8
; b_orange         =     129  ;8,  C=-1    ; Pareil à l'anglais
b_brun            =     149  ;9,  C=-2
b_rose            =     150  ;10, C=-3
b_gris3           =     155  ;11, C=-4
b_grisf           =     155  ;11, C=-4
b_gris2           =     152  ;12, C=-5
b_grism           =     152  ;12, C=-5
b_vert2           =     153  ;13, C=-6
b_vertp           =     153  ;13, C=-6
b_bleu2           =     154  ;14, C=-7
b_bleup           =     154  ;14, C=-7
b_gris1           =     151  ;15, C=-8
b_grisp           =     151  ;15, C=-8
b_gris            =     151  ;15, C=-8
;-----------------------------------------------------------------------------
; Jeux de charactères.
;-----------------------------------------------------------------------------
b_rvs_on          =     18   ;    ctrl-9
b_rvs_off         =     146  ;    ctrl-0
b_lowercase       =     14
b_uppercase       =     142
;-----------------------------------------------------------------------------
; Mouvements du curseur
;-----------------------------------------------------------------------------
b_crsr_up         =     145
b_crsr_down       =     17
b_crsr_left       =     157
b_crsr_right      =     29
b_home            =     19
b_clr_home        =     147
b_insert          =     20
b_shft_ret        =     141
b_delete          =     148
;-----------------------------------------------------------------------------
; Clefs de fonction.
;-----------------------------------------------------------------------------
b_f1              =     133
b_f2              =     137
b_f3              =     134
b_f4              =     138
b_f5              =     135
b_f6              =     139
b_f7              =     136
b_f8              =     140
;-----------------------------------------------------------------------------
; Autres fonctions.
;-----------------------------------------------------------------------------
b_dis_cmd         =     8
b_ena_cmd         =     9
;-----------------------------------------------------------------------------
; Modèle de boîte disponible dans tous les jeux de caractères.
;-----------------------------------------------------------------------------
b_ul              =     172   ; Coin suppérieur gauche (Upper left corner). 
b_ur              =     187   ; Coin suppérieur droit  (Upper right corner). 
b_ll              =     188   ; Coin inférieur gauche  (Lower left corner). 
b_lr              =     190   ; Coin inférieur droit   (Lower right corner). 
b_vl              =     182   ; Ligne vertivale gauche (left vertical line). 
b_vr              =     181   ; Ligne vertivale droite (right vertical line). 
b_bo              =     184   ; Ligne inférieure       (Bottom line). 
b_to              =     185   ; Ligne suppérieur       (Top line). 
;-----------------------------------------------------------------------------
; Others
;-----------------------------------------------------------------------------
b_eot             =     $00   ; Fin du texte.
b_inpbuff         =     $0200 ; Tampon d'entrée
b_crlf            =     $0d
b_space           =     $20
b_fac1            =     $61
b_fac2            =     $69
;-----------------------------------------------------------------------------
; Consrtantes sur les elements importants (* = Appelé par ...)
;-----------------------------------------------------------------------------
; Basic 2.0 entry point
;-----------------------------------------------------------------------------
;Nom_fonction     =     Adres ; Description. Registre utilisé ->        ;INP;OUT;
b_opentxtspc      =     $a3bb ; Espace ouvert en texte BASIC.           ;a-y;---; Array top $yyaa
b_chkavailmem     =     $a408 ; Vérifier la mémoire disponible. *1      ;a-y;---; Array top $yyaa
b_outofmem        =     $a435 ; ?Mémoire insuffisante.                  ;---;---;        
b_errormesg       =     $a437 ; Envoyer un message d'erreur BASIC.      ;a--;---; a = errno
b_warmstart       =     $a474 ; Démarrage à chaud de Basic.             ;---;---;
b_chrgetentry     =     $a48a ; Entrée CHRGET principale.               ;---;---; 
                              ; Conditions préalables: $7a=#$ff,$7b=#$01, 
                              ;                        ($77,$78),
                              ;                        $01ff=Basic inbuf-1
b_newline         =     $a49c ; Traiter les jetons, insérer une ligne.  ;-x-;---; x = buff len
b_clrready        =     $a52a ; Correction d'enchaînement CLR et READY. ;---;---;
b_fixchaining     =     $a533 ; Correction d'enchaînement.              ;---;---;
b_kbgetline       =     $a560 ; Recevoir une ligne depuis le clavier.
                              ; Conditions préalables: $7a=#$ff,$7b=#$01, 
                              ;                        ($77,$78),
                              ;                        $01ff=Basic inbuf-1
b_crunchtkns      =     $a579 ; Traiter les jetons. *7                  ;-x-;---: x = buff len
b_findline        =     $a613 ; Rechercher une ligne en BASIC.          ;ax-;---; strBAS = $xxaa
b_new             =     $a642 ; Exécute NEW.                            ;---;---;
b_resetclr        =     $a659 ; Réinitialiser BASIC et exécuter CLR.    ;---;---; 
b_clr             =     $a65e ; Exécute CLR                             ;---;---;
;Pas dans BASIC 2  $xxxx       ; Vider la pile de toutes les valeurs de retour
b_rstchrget       =     $a68e ; Rétablir CHRGET au début du BASIC       ;---;a--; strBAS hi
b_continue        =     $a857 ; Exécute CONTINUE.                       ;a-y;---; curline $yyaa
b_getint          =     $a96b ; Extraire un entier d'un texte BASIC.    ;---;---;
                              ; Conditions préalables: $7a=#$ff,$7b=#$01, 
                              ;                        ($77,$78),
b_sndcr           =     $aad3 ; Envoyer RETURN, LF en mode écran.       ;---;a--; a = LF
b_sndcrlf         =     $aad7 ; Envoyer RETURN, LINEFEED.               ;---;a--; a = LF
b_outstr_ay       =     $ab1e ; Afficher la chaîne à partir de $yyaa.   ;a-y;---; sptr = $yyaa
b_puts            =     b_outstr_ay
b_outstrprep      =     $ab24 ; Afficher une chaîne précalculée.        ;a--;---; a = strlen
                              ; Conditions préalables: Adresse de chaine dans 
                              ; ... $22,$23 ($1f,$20)
b_printqm         =     $ab45 ; Imprimer '?'.                           ;---;---;                      
b_sendchar        =     $ab47 ; Envoyer 1 caractère vers périphérique.  ;a--;a--; a = char                      
b_intobuff        =     $abf9 ; Lire des caractères depuis l'entrée standard 
                              ; ... (stdin) et les écrire dans le tampon à 
                              ; ... l'adresse $200.
b_frmnum          =     $ad8a ; Évaluer une expression numérique et/ou 
                              ; ... vérifier l’absence d’incohérence entre 
                              ; ... les types de données
b_evalexpr        =     $ad9e ; Évaluer l'expression.                      
                              ; Conditions préalables: 
                              ; ... Adresse de l'expression dans le pointeur 
                              ; ... CHRGET.             
                              ; Resultat: chaine    $0d = #$FF ($07)    ;---;a-y; expaddr =     $yyaa               
                              ;           numerique $0d = #$00 ($07)    ;---;a--; a = result
b_chk4comma       =     $aefd ; Vérifier la présence d'ue virgule.      ;---;a--; a = char
b_chk4lpar        =     $aefa ; Vérifier la présence de « ( ».          ;---;a--; a = char
b_chk4rpar        =     $aef7 ; Vérifier la présence de « ) ».          ;---;a--; a = char
b_syntaxerr       =     $af08 ; Transmet « SYNTAX ERROR ».              ;---;---;
b_fort            =     $afe6 ; FAC1 = FAC1 or FAC2.
b_fandt           =     $afe9 ; FAC1 = FAC1 and FAC2.
b_fndfloatvar     =     $b0e7 ; Rechercher variable float par son nom.  ;---;a-y; addr = $yyaa
                              ; Conditions préalables: 
                              ;            Nom dans $45,$46 ($42,$43)
b_bumpvaraddr     =     $b185 ; Augmenter l'adresse de la variable de 2. *31
                              ; Conditions préalables: 
                              ;            Nom dans $45,$46 ($42,$43).
                              ;                                         ;---;a-y; addr = $yyaa
b_ftoint          =     $b1aa ; Convertie FAC1 en 16 bits dans $aayy    ;---;a-y; int = $aayy
b_float2int       =     $b1bf ; Convertie FAC1 en entier dans 
                              ; ... $64(lsb),$65(msb). Fonctionne uniquement 
                              ; ... si FAC1 se situe entre -32768 and +32767.
b_num2int         =     $b1d2 ; Convertie l'expression numérique flottante 
                              ; ... en entier dans $64(lsb),$65(msb). 
b_fcerr           =     $b248 ; Afficher le message d’erreur 
                              ; ... «ILLEGAL QUANTITY».
b_int2float       =     $b391 ; Conversion d'un entier en nombre à virgule 
                              ; ... flottante dans FAC1.                ;---;---;
b_ytofac1         =     $b3a2 ; Convertir int(y) en FAC1.               ;--y;---;
b_getacc1lsb      =     $b79e ; Obtien le LSB de FAC1 dans x.           ;---;-x-; x = FAC1 LSB
b_fac1tox         =     $b7a1 ; Convertir FAC1 en octet dans x.         ;---;-x-; x = byte
b_str2float       =     $b7b5 ; Évaluer une chaîne en nombre à virgule 
                              ; ... flottante (VAL)                     ;---;---;
                              ; Conditions préalables: Adresse de la chaine
                              ; ... CHRGET.
                              ; Resultat: Valeur en point flottant dans 
                              ; ... FAC1.
b_strxy2float     =     $b7b9 ; Évaluer un nombre à point flottant à 
                              ; ... partir d'une chaîne de caractères dans xy.       
                              ;                                         ;---;-xy; strptr = $yyxx
                              ; Resultat: Valeur en point flottant 
                              ; ... dans FAC1.
b_evfint2x        =     $b7e9 ; Convertir FAC1 en octet dans x.         ;---;-x-; x = byte  
b_getpokeprms     =     $b7eb ; Obtenez 2 paramètres pour POKE, WAIT.   ;---;-x-; x = Param2
                              ; Conditions préalables: Straddr in CHRGET ptr.  
                              ; Resultat: param2 dans FAC1.
b_getadr          =     $b7f7 ; Convertir un nombre à point flottant en un 
                              ; ... entier non signé de deux octets.
b_faddh           =     $b849 ; FAC1 = FAC1 + 0.5 
b_fsub            =     $b850 ; FAC1 = FVAR - FAC1.                     ;a-y;---; ptr = $yyaa
b_fsubt           =     $b853 ; FAC1 = FAC2 - FAC1.                     ;---;---;                      
b_fadd            =     $b867 ; FAC1 = FVAR + FAC1.                     ;a-y;---; ptr = $yyaa                
b_memfloatadd     =     $b867 ; Aditionner une valeur en mémoire.       ;a-y;---; ptr = $yyaa
b_faddt           =     $b86a ; FAC1 = FAC2 + FCA1 
b_f2addf1         =     $b86a ; FAC1 = FAC2 + FCA1
b_fcomp2          =     $b947 ; FAC1 = INV(FAC1) + 1
b_fmulv           =     $ba28 ; FCA1 = FAC1 * FVAR.                     ;a-y;---; ptr = $yyaa
b_memfloatmul     =     $ba28 ; Multiplier par une valeur en mémoire.   ;a-y;---; ptr = $yyaa
b_fmult           =     $ba2b ; FAC1 = FAC1 * FAC2
b_conupk          =     $ba8c ; Copier FVAR vers FAC2.                  ;a-y;---; ptr = $yyaa
b_mul10           =     $bae2 ; FAC1 = FAC1 * 10.
b_acc1mul10       =     $bae2 ; Multiplier FAC1 par 10.                 ;---;---; ptr = $yyaa
b_fdiv10          =     $bafe ; FAC1 = FAC1 / 10.
b_fdiv            =     $bb0f ; FAC1 = FVAR / FAC1                     
b_vdivf           =     $bb0f ; FAC1 = FVAR / FAC1.                     ;a-y;---; ptr = $yyaa
b_fdivt           =     $bb12 ; FAC1 = FAC2 / FAC1.
b_movfm           =     $bba2 ; Copy FVAR to FAC1.                      ;a-y;---; ptr = $yyaa
b_memvar2acc1     =     $bba2 ; FAC1 = FVAR                             ;a-y;---; ptr = $yyaa
b_cpfac1tow2      =     $bbc7 ; Copier FAC1 vers WORK#2 ($5c-$60)
b_cpfac1tow1      =     $bbca ; Copier FAC1 vers WORK#1 ($57-$5b)
b_cpfac1to49      =     $bbd0 ; Copier FAC1 vers FORPNT ($49-$4a)
b_fac1toaddr      =     $bbd4 ; Copier FAC1 vers memory.                ;-xy;---; ptr = $yyxx
b_cpfac1toxy      =     $bbd7 ; Copier FAC1 vers mem location.          ;-xy;---; ptr = $yyxx
b_movfa           =     $bbfc ; 
b_acc2toacc1      =     $bbfc ; Copier FAC2 to FAC1.                    ;---;---; 
b_fac1sign        =     $bc2b ; Vérifier le signe de FAC1.
b_sgn             =     $bc39 ; FAC1 = SIGN(FAC1)
b_atofac1         =     $bc3c ; Convertir l'entier a en FAC1.           ;a--;---; a = int 
b_int2fac1        =     $bc44 ; $62(lsb),$63(msb) entier dans FAC1
b_abs             =     $bc58 ; FAC1 = ABS(FAC1)
b_fcomp           =     $bc5b ; Acc. = Compare FAC1 et (FVAR).          ;a-y;a--; ptr = $yyaa
                              ;         Acc. devient 0 =, 1 >, $FF <
b_movaf           =     $bc0c ; Arrondi et déplace FAC1 vers FAC2.
b_rndac1ac2       =     $bc0c ; Arrondi et déplace FAC1 vers FAC2.      ;---;---;  
b_urndac1ac2      =     $bc0f ; Copie FAC1 dans FAC2.                   ;---;---;  
b_round           =     $bc1b ; Arrondi FAC1
b_rndac1          =     $bc1b ; Arrondi FAC1                            ;---;---; 
b_qint            =     $bc9b ; Convertit FAC1 en entier dans FAC1.
b_int             =     $bccc ; FAC1 = INT(FAC1)
b_fin             =     $bcf3 ; Convertir une chaine décimal (format ASCII) 
                              ; ... dans FAC1.
b_addf1acc        =     $bd7e ; Ajouter Acc à FAC1 (a=0-9)              ;a--;---;
b_linptr          =     $bdcd ; Afficher la valeur en virgule fixe.     ;ax-;---; Value = $aaxx  
b_putint          =     $bdcd ; Afficher la valeur en virgule fixe.     ;ax-;---; Value = $aaxx 
b_putfloat        =     $bdd7 ; Print FAC1 float.                       ;---;---;
b_fout            =     $bddd ; Converti FAC1 en chaine à $0100. *48    ;a-y;---; a=#$00, y=#$01
b_num2str         =     $bddd ; Converti FAC1 en chaine à $0100. *48    ;a-y;---; a=#$00, y=#$01
b_sqr             =     $bf71 ; FAC1 = SQRT(FAC1).
b_fpwrt           =     $bf7b ; FAC1 = FAC1 ^ FAC2. 
b_poly2           =     $e059 ; Évaluation de polynôme
b_initcgt         =     $e3bf ; Initialiser tous les emplacements de la page 
                              ; ... zéro du BASIC contenant des valeurs fixes.   
;-----------------------------------------------------------------------------
; Equates pour le livre Tool Kit: basic
;-----------------------------------------------------------------------------
b_chrget          =     $0073
b_chrgot          =     $0079
b_axout           =     $bdcd ; Afficher la valeur en virgule fixe.     ;ax-;---; Value = $xxaa 
b_intcgt          =     $e3bf ; Initialiser tous les emplacements de la page 
                              ; ... zéro du BASIC contenant des valeurs fixes.
b_ascflt          =     $bcf3 ; Conversion de nombre décimal ASCII en FAC1,
b_prompt          =     $abf9 ; Lire des caractères depuis l'entrée standard 
                              ; ... (stdin) et les écrire dans un tampon, à 
                              ; ... l'adresse $200.   
b_facasc          =     $bddd ; Conversion de nombre en chaîne à l'adresse 
                              ; ... $0100. *48                          ;a-y;---; a=#$00, y=#$01
b_fvtf1           =     $bba2 ; Copie FVAR vers FAC1.                   ;a-y;---; ptr = $yyaa
b_strout          =     $ab24 ; Afficher la chaîne précalculée.         ;a--;---; a = strlen
b_f1t57           =     $bbca ; Copie FAC1 vers WORK#1 (57-$5b)
b_f1xfv           =     $ba28 ; Multiplie FAC1 par FVAR.                ;a-y;---; ptr = $yyaa
b_f1tmem          =     $bbd4 ; Copier FAC1 vers FVAR.                  ;-xy;---; ptr = $yyxx
b_f1x10           =     $bae2 ; Multiplie FAC1 par 10.                  ;---;---; ptr = $yyaa
b_f1d10           =     $bafe ; FAC1 = FAC1 / 10.
b_sgnf1           =     $bc2b ; Vérifier le signe de FAC1
b_f1tf2           =     $bc0c ; Arrondie FAC1 et le copie dans FAC2.    ;---;---;  
b_f1xf2           =     $ba2b ; FAC1 = FAC1 * FAC2
b_fvdf1           =     $bb0f ; FAC1 = FVAR / FAC1.                     ;a-y;---; ptr = $yyaa
b_memtf2          =     $ba8c ; Copie FVAR dans FAC2.                   ;a-y;---; ptr = $yyaa
b_f2df1           =     $bb12 ; FAC1 = FAC2 / FAC1.
b_f1pfv           =     $b867 ; FAC1 = FAC1 + FVAR.                     ;a-y;---; ptr = $yyaa 
b_f2sf1           =     $b853 ; FAC1 = FAC2 - FAC1.                     ;---;---;  
b_fvsf1           =     $b850 ; FAC1 = FVAR - FAC1.                     ;a-y;---; ptr = $yyaa 
b_f1pacc          =     $bd7e ; Aditionne Acc. à FAC1 (a=0-9)           ;a--;---;
b_f1pf2           =     $b86a ; FAC1 = FAC2 + FCA1 
b_expon           =     $bf7b ; FAC1 = FAC1 ^ FAC2.  
b_fpand           =     $afe9 ; FAC1 = FAC1 and FAC2.
b_f1orf2          =     $afe6 ; FAC1 = FAC1 or FAC2.
b_sqrtf1          =     $bf71 ; FAC1 = SQRT(FAC1).
b_intf1           =     $bccc ; FAC1 = INT(FAC1)
b_f1t5c           =     $bbc7 ; Copier FAC1 vers WORK#2 ($5c-$60)
b_f1cfv           =     $bc5b ; FAC1 = FAC1 comp(FVAR).                 ;a-y;---; ptr = $yyaa  
b_comp            =     $bc5b ; FAC1 = FAC1 comp(FVAR).                 ;a-y;---; ptr = $yyaa 
b_f1tx            =     $b7a1 ; Conv FAC1 to byte in x.                 ;---;-x-; x = byte
b_fltay           =     $b1aa ; FAC1 to word in $aayy                   ;---;a-y; imt =     $aayy
b_ytfl1           =     $b3a2 ; Convertion int(y) to FAC1.                 ;--y;---;
b_poly            =     $e059 ; Évaluation de polynôme
