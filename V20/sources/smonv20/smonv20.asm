;--------------------------------------
; Fichier.......: smonv20.asm
; Basee sur.....: Supermon64
; Auteur........: Jim Butterfield
; Version Vic20 : Daniel Lafrance
;--------------------------------------
.enc "none"
     .include  "e-v20-bashead-ex.asm"
;     .include  "l-v20-bashead-ex.asm "
     .include  "m-v20-utils.asm"
;--------------------------------------
;
;main      .block
;          jsr  super
;          rts
;          .bend
;-----------------------------------------------------------------------------
;Point d 'entrée initiale
;-----------------------------------------------------------------------------
          .weak
          org = $3000
          .endweak
          *=org
main      =*
;-----------------------------------------------------------------------------
; Point d'entrée initial
;-----------------------------------------------------------------------------
super     jsr  scrinit
          lda  #147
          jsr  chrout
          lda  #$0e
          jsr  chrout
          lda  #$08
          jsr  chrout
          ldy  #msg9-msgbas    ; Affiche "? pour aide.".
          jsr  sndmsg

          ;ldy #msg4-msgbas    ; Affiche "..sys ".
          ;jsr sndmsg
          ;lda supad           ; Stocker l'adresse du point d'entrée dans tmp0.
          ;sta tmp0
          ;lda supad+1
          ;sta tmp0+1
          ;jsr cvtdec          ; Convertir l'adresse en décimal.
          ;lda #0
          ;ldx #6
          ;ldy #3
          ;jsr nmprnt          ; Afficher l'adresse du point d'entrée.
          ;jsr crlf
          lda linkad          ; Définir le vecteur brk.
          sta bkvec
          lda linkad+1
          sta bkvec+1
          lda #$80            ; Désactiver les messages de contrôle du noyau
          jsr setmsg          ; ... et activer les messages d'erreur.
          lda  #8
          sta  ddev
          #ldyxptr  greetings
          #styxmem  genword1
          jsr  popup
          brk
;-----------------------------------------------------------------------------
; gestionnaire de brk
;-----------------------------------------------------------------------------
break     ldx  #$05           ; Retirer les registres de la pile dans l'ordre:
bstack    pla                 ; ... y, x, a, sr, pcl, pch, stocker en mémoire.
          sta pch,x
          dex 
          bpl bstack
          cld                 ; Désactiver le mode bcd.
          tsx                 ; Stocker le pointeur de pile en mémoire.
          stx sp
          cli                 ; Activer les interruptions.
          jmp dsplyr

;-----------------------------------------------------------------------------
; boucle principale
;-----------------------------------------------------------------------------
strt      #outcar snoir
          #outcar $0d
          ;jsr  crlf           ; Nouvelle ligne à l'écran.

          ldx  #0             ; Pointe au début du tampon d'entrée.
          stx  chrpnt
          ;lda  #'>'           ; *DL* - Affiche un 
          ;jsr  chrout         ; *DL* - . invite.
smove     jsr  chrin          ; Appel chrin du noyau pour saisir un caractère
          cmp  #33
          bne  treatit
          jsr  mycmd
          cmp  #$00
          beq  strt
treatit   sta  inbuff,x       ; ... stocker dans le tampon d'entrée.
          inx 
          cpx  #endin-inbuff  ; Erreur si la mémoire tampon est pleine.
          bcs  error
          cmp  #$0d           ; Continue à lire jusqu'au CR.
          bne  smove
          lda  #0             ; Tampon d'entrée terminé par un caractère null.
          sta  inbuff-1,x     ; ... (remplace le cr)
st1       jsr  getchr         ; Récupére un caractère du tampon.
          beq  strt           ; Recommence si le tampon est vide.
          cmp  #$20           ; Sauter les espaces de début.
          beq  st1
s0        ldx  #keytop-keyw   ; Boucle parmis les caractères valides de cmd.
s1        cmp  keyw,x         ; Vérifie si le caractère saisi correspond.
          beq  s2             ; Commande correspondante, exécuter.
          dex                 ; Aucune correspondance, vérifie la commande 
                              ; ... suivante
          bpl  s1             ; Continuez d'essayer jusqu'à ce que nous les 
                              ; ... ayons tous vérifiés puis passer au 
                              ; ... gestionnaire d'erreurs.

;-----------------------------------------------------------------------------
; gérer les erreurs
;-----------------------------------------------------------------------------
error     ldy  #msg3-msgbas   ; Afficher «?» pour indiquer une erreur et 
                              ; ... passer à la ligne suivante.
          jsr  sndmsg
          jmp  strt           ; Retour à la boucle principale.

;-----------------------------------------------------------------------------
; Traite les commandes
;-----------------------------------------------------------------------------
s2        cpx  #$13           ; Les 3 dernières commandes du tableau sont 
                              ; ... charger/enregistrer/valider qui sont gérées
          bcs  lsv            ; ... par la même sous-routine.
          cpx  #$0f           ; Les 4 commandes suivantes sont des conversions
          bcs  cnvlnk         ; ... de base qui sont gérées par la même 
                              ; ... sous-routine.
          txa                 ; Les commandes restantes sont transmises via la
          asl  a              ; ... table des vecteurs multiplier l'indice de la 
          tax                 ; ... commande par 2 puisque la table contient des 
                              ; ... adresses de 2 octets.
          lda  kaddr+1,x      ; Place l'adresse de la table des vecteurs sur
          pha                 ; ... la pile de sorte que le rts de getpar saute à 
                              ; ... cet endroit.
          lda  kaddr,x
          pha
          jmp  getpar         ; Obtenir le premier paramètre de la commande
lsv       sta  savy           ; Gère le 
                              ; ... chargement/l'enregistrement/la validation
          jmp  ld
cnvlnk    jmp  convrt         ; Gère la conversion de base.

;-----------------------------------------------------------------------------
; Quitter le moniteur [x]
;-----------------------------------------------------------------------------
exit      #outcar   147

          jmp   (bcoldst)     ; Saute au démarrage à froid pour réinitialiser 
                              ; ... le système de base sans effacer la memoire.

;-----------------------------------------------------------------------------
; Afficher les registres - [r].
;-----------------------------------------------------------------------------
dsplyr    ldy  #msg2-msgbas   ; Affiche les en-têtes.
          jsr  sndclr
          lda  #$3b           ; S'enregistre avec le préfixe <;> pour 
                              ; ... permettre la modification.
          jsr  chrout
          lda  #$20
          jsr  chrout
          lda  pch            ; Affiche les 2 octets du compteur de programme. 
          jsr  wrtwo
          ldy  #1             ; Commence 1 octet après l'octet de poids fort 
                              ; ... du PC.
disj      lda  pch,y          ; Boucle parmis le reste des registres.
          jsr  wrbyte         ; Affiche la valeur du registre sur 1 octet.
          iny 
          cpy  #7             ; Il y a un total de 7 octets à afficher.
          bcc  disj
          jmp  strt

;-----------------------------------------------------------------------------
; Afficher mémoire [m]
;-----------------------------------------------------------------------------
dsplym    bcs  dspm11         ; Commencer à partir de l'adresse de fin 
                              ; ... précédente si aucune adresse n'est fournie.
          jsr  copy12         ; Enregistrer l'adresse de départ dans tmp2.
          jsr  getpar         ; Capture l'adresse de fin dans tmp0.
          bcc  dsmnew         ; L'utilisateur en a-t-il spécifié un?
dspm11    lda  #145           ; Remonte le curseur d'une ligne.
          jsr  chrout
          lda  #15            ; Sinon, on affiche 21 lignes par défaut.
          sta  tmp0
          bne  dspbyt         ; Toujours vrai, mais bne utilise 2. jmp 3.
dsmnew    jsr  sub12          ; Adresse de fin donnée, calculer les octets 
                              ; ... entre le début et la fin.
          bcc  merror         ; Erreur si le début est après la fin.
          ldx  #2             ; Diviser par (décaler vers la droite 3 fois).
dspm01    lsr  tmp0+1
          ror  tmp0
          dex   
          bne  dspm01
dspbyt    jsr  stop           ; Vérifie la touche [RUN/STOP].
          beq  dspmx          ; Quitte prématurément si pressé.
          ;-------------------------------------------------------------------
          ; CORRECTIFS-V20 ::: Changer le nombre d'octets a afficher de 8 à 4.
          ;-------------------------------------------------------------------
          jsr  dispmem        ; *DL* - Affiche 1 ligne contenant 4 octets.
          lda  #4             ; *DL* - Augmenter l'adresse de départ de 4 octets.
          ;-------------------------------------------------------------------
          jsr  bumpad2
          jsr  suba1          ; Décrémente le compteur de lignes.
          bcs  dspbyt         ; Affiche une autre ligne jusqu'à < 0.
dspmx     jmp  strt           ; Retour à la boucle principale.
merror    jmp  error          ; Gère les erreur.

;-----------------------------------------------------------------------------
; Modifier les registres [;]
;-----------------------------------------------------------------------------
altr      jsr  copy1p         ; Stocke le premier paramètre dans PC.
          ldy  #0             ; Initialise le compteur.
altr1     jsr  getpar         ; Recupère la valeur du registre suivant.
          bcs  altrx          ; Quitte prématurément si aucune autre valeur 
                              ; ... n'est fournie
          lda  tmp0           ; Stocke en mémoire, décalage par rapport à sr.
          sta  sr,y           ; Ces emplacements seront transférés aux caisses
          iny                 ; ... réelles avant la sortie de l'écran.
          cpy  #$05           ; Avons-nous déjà mis à jour les 5 ?
          bcc  altr1          ; Sinon, passez au suivant.
altrx     jmp  strt           ; Retour à la boucle principale.

;-----------------------------------------------------------------------------
; Modifier la mémoire [>]
;-----------------------------------------------------------------------------
altm      bcs  altmx          ; Quitte si aucun paramètre n'est fourni.
          jsr  copy12         ; Copie le paramètre à l'adresse de départ.
          ldy  #0
altm1     jsr  getpar         ; Recupère le prochain octet en mémoire.
          bcs  altmx          ; Ii aucune information fournie, on quitte.
          lda  tmp0           ; Sauve la valeur à l'adresse de départ + y
          sta  (tmp2),y
          iny                 ; Octet suivant.
          ;-------------------------------------------------------------------
          ; CORRECTIFS-V20 ::: Changer le nombre d'octets a afficher de 8 à 4.
          ;-------------------------------------------------------------------
          cpy  #4             ; *DL* - Avons-nous déjà lu 4 octets ?
          ;-------------------------------------------------------------------
          bcc  altm1          ; Sinon, lecture du suivant.
altmx     lda  #$91           ; Déplace le curseur vers le haut.
          jsr  chrout
          jsr  dispmem        ; Réaffiche la ligne pour que l'ASCII 
                              ; ... corresponde à l'Hexadécimal.
          jmp  strt           ; Retour à la boucle principale.

;-----------------------------------------------------------------------------
; goto (run) [g]
;-----------------------------------------------------------------------------
goto      ldx  sp             ; Charge le pointeur de pile depuis la mémoire.
          txs                 ; Enregistrer dans le registre sp.
goto2     jsr  copy1p         ; Copie l'adresse fournie dans PC.
          sei                 ; Désactiver les interruptions
          lda  pch            ; Place le MSB de PC sur la pile.
          pha
          lda  pcl            ; Place le LSB de PC sur la pile.
          pha
          lda  sr             ; Place l'octet de status sur la pile.
          pha
          lda  acc            ; Charge l'accumulateur depuis la mémoire.
          ldx  xr             ; Charge X depuis la mémoire.
          ldy  yr             ; Charge Y depuis la mémoire.
          rti                 ; Retour de l'interruption (dépile PC et sr).

;-----------------------------------------------------------------------------
; Saut vers la sous-routine [j]
;-----------------------------------------------------------------------------
jsub      ldx  sp             ; Charge le pointeur de pile depuis la mémoire.
          txs                 ; Sauve la valeur dans le registre sp.
          jsr  goto2          ; Identique à la commande goto.
          sty  yr             ; Enregistre y en mémoire.
          stx  xr             ; Enregistre x en mémoire.
          sta  acc            ; Enregistre acc en mémoire.
          php                 ; Place l'état du processeur sur la pile.
          pla                 ; Récupére l'état du processeur dans Acc.
          sta  sr             ; Enregistre l'état du processeur en mémoire.
          jmp  dsplyr         ; Afficher les registres.

;-----------------------------------------------------------------------------
; display 4 bytes of memory
;-----------------------------------------------------------------------------
dispmem   jsr  crlf           ; Nouvelle ligne.
          #outcar snoir
          lda  #">"           ; Préfixe > pour indiquer que la mémoire peut
                              ;  . être modifiée sur place.
          jsr  chrout
          jsr  showad         ; Afficher l'adresse du premier octet.
          ldy  #0
          beq  dmemgo         ; showad a déjà imprimé un espace après adresse.
dmemlp    jsr  space          ; Affiche un espace entre les octets.
dmemgo    lda  (tmp2),y       ; Charge un octet à partir du début + y.
          pha  
          tya
          asl
          sta  kcol
          pla
          jsr  wrtwo          ; Affiche l'octet en hexadécimal.
          iny                 ; Prochain octet.
          ;-------------------------------------------------------------------
          ; CORRECTIFS-V20 ::: Changer le nombre d'octets a afficher de 8 à 4.
          ;-------------------------------------------------------------------
          cpy  #4             ; *DL* - Avons-nous déjà affiché 4 octets ?
          ;-------------------------------------------------------------------
          bcc  dmemlp         ; Sinon, afficher l'octet suivant.
          ldy  #msg5-msgbas   ; Si oui, affichez et activez la lecture vidéo
          jsr  sndmsg         ;  . inversée avant d'afficher la représentation 
                              ;  . ASCII.
          
          #ldyxmem scrnlin    ; On calcul l'adresse ecran texte et couleur
          lda  #18            ; ... pour placer les representations petscii
          jsr  addatoyx       ; ... sans generer de crlf à la fin de la ligne.
          #styxzp1            ; Adresse texte dans ZP1.
          tya
          ora  #$94           ; ex $1005 devient $9505.
          tay
          #styxzp2            ; Adresse couleur dans ZP2

          ldy  #0             ; Retour au premier octet de la ligne.

dchar     lda  (tmp2),y       ; Charger octet à l'adresse de début + y.
;          tax                 ; Le cacher dans x.
;          and  #$bf           ; Effacer le 6ème bit.
;          cmp  #$22           ; Est-ce un guillemet ""?
;          beq  ddot           ; Si c'est le cas, affiche . à la place.
;          txa                 ; Sinon, restaurez le caractère.
;          and  #$7f           ; Effacer le bit supérieur
;          cmp  #$20           ; Est-ce un caractère affichable (>= $20)?
;          txa                 ; Restaurer le caractère.
;          bcs  dchrok         ; Si imprimable, affiche le caractère.
;ddot      lda  #$2e           ; Sinon, on met un '.' à la place
dchrok    sta  (zp1),y        ; *DL* - On affiche le caractere.
          tya                 ; *DL* - . et une couleur
          asl                 ; *DL* - .  sequencielle
          sta  (zp2),y        ; *DL* - . noir, rouge, mauve et bleu.
          ;jsr  chrout        ; On l'affiche.
          iny                 ; On passe à l'octet suivant
          ;-------------------------------------------------------------------
          ; CORRECTIFS-V20 ::: Changer le nombre d'octets a afficher de 8 à 4.
          ;-------------------------------------------------------------------
          cpy  #4             ; Avons-nous déjà affiché 4 octets ?
          ;-------------------------------------------------------------------
          bcc  dchar          ; Sinon, afficher l'octet suivant.
          rts 

;-----------------------------------------------------------------------------
; compare memory [c]
;-----------------------------------------------------------------------------
compar    lda  #0             ; bit 7 efface les signaux comparer
          .byte $2c           ; L'opcode de bit absolu consomme le mot suivant
                              ; ... (lda #$80).

;-----------------------------------------------------------------------------
; transfer memory [t]
;-----------------------------------------------------------------------------
trans     lda  #$80           ; Bit 7 place le transfert de signaux
          sta  savy           ; Enregistrer l'indicateur de 
                              ; ... comparaison/transfert dans Savy
          lda  #0             ; Suppose que nous comptons à rebours (b7 clair)
          sta  upflg          ; Enregistrer le drapeau de direction
          jsr  getdif         ; Obtien deux adresses et calcule la différence
                              ; ... tmp2  = debut de la source
                              ; ... stash = fin de la source end
                              ; ... store = longueur
          bcs  terror         ; Bit carry a un indique une erreur
          jsr  getpar         ; obtien l'adresse de destination dans tmp0
          bcc  tokay          ; Bit carry a un indique une erreur
terror    jmp  error          ; Gère les erreurs
tokay     bit  savy           ; Transférer ou comparer ?
          bpl  compar1        ; Bit 7 à 0 indique comparer
          lda  tmp2           ; S'il s'agit d'un transfert, nous devons 
          cmp  tmp0           ; ... prendre des mesures pour éviter d'écraser 
          lda  tmp2+1         ; ... les octets sources avant qu'ils n'aient été 
                              ; ... transférés  
          sbc  tmp0+1         ; Comparer la source (tmp2) à la destination
          bcs  compar1        ; ... (tmp0) et incrémenter si la source est 
                              ; ... antérieure à la destination.
          lda  store          ; Sinon, commencez par la fin et décomptez en 
          adc  tmp0           ; ... ajoutant la longueur (stockée) à la 
          sta  tmp0           ; ... destination (tmp0) pour calculer la fin de 
                              ; ... la destination.
          lda  store+1
          adc  tmp0+1
          sta  tmp0+1
          ldx  #1             ; Modifier le pointeur source du début à la fin
tdown     lda  stash,x        ; tmp2 = fin de la source (réserve).
          sta  tmp2,x
          dex  
          bpl  tdown
          lda  #$80           ; Le bit haut activé dans upflg signifie un 
                              ; ... compte à rebours.
          sta  upflg
compar1   jsr  crlf           ; Nouvelle ligne.
          ldy  #0             ; Aucun décalage par rapport au pointeur.
tcloop    jsr  stop           ; Vérifier la touche [RUN/STOP].
          beq  texit          ; Quitte si appuiée.
          lda  (tmp2),y       ; Charge un octet depuis la source.
          bit  savy           ; Transférer ou comparer?
          bpl  compar2        ; Ignorer la sauvegarde si comparaison.
          sta  (tmp0),y       ; Sinon, stocker dans la destination.
compar2   cmp  (tmp0),y       ; Comparer à la destination.
          beq  tmvad          ; Ne pas afficher l'adresse si égale
          jsr  showad         ; Afficher l'adresse
tmvad     bit  upflg          ; Compter en avant ou en arrière ?
          bmi  tdecad         ; Le bit 7 activé signifie que nous décomptons.
          inc  tmp0           ; Incrémenter l'octet LSB de la destination.
          bne  tincok
          inc  tmp0+1         ; Reporte au MSB si nécessaire.
          bne  tincok
          jmp  error          ; Erreur si dépassement de capacité du MSB.
tdecad    jsr  suba1          ; Décrémenter la destination (tmp0).
          jsr  sub21          ; Décrémenter la source (tmp2).
          jmp  tmor
tincok    jsr  adda2          ; Incrémenter la source (tmp2).
tmor      jsr  sub13          ; Décrémenter la longueur.
          bcs  tcloop         ; Boucle jusqu'à ce que la longueur soit 0.
texit     jmp  strt           ; Retour à la boucle principale.

;-----------------------------------------------------------------------------
; Chercher en mémoire [h]
;-----------------------------------------------------------------------------
hunt      jsr  getdif         ; Obtenir le début (tmp2) et la fin (tmp0) 
          bcs  herror         ; Le report indique une erreur
          ldy  #0
          jsr  getchr         ; Obtenir un seul caractère
          cmp  #"'"           ; S'agit-il d'un simple guillemet ?
          bne  nostrh         ; Sinon, saisir l'entrée sous forme hexadécimal.
          jsr  getchr         ; Si oui, saisir l'entrée sous forme de chaine.
          cmp  #0
          beq  herror         ; Erreur si l'entrée est vide.
hpar      sta  stage,y        ; Sauvegarder caractere dans la zone de stockage
          iny 
          jsr  getchr         ; Obtenir un autre caractère
          beq  htgo           ; Si la valeur est nulle, commencez la recherche.
          cpy  #estage-stage  ; Avons-nous rempli la zone de stockage?
          bne  hpar           ; Sinon, obtenir un autre personnage
          beq  htgo           ; Si oui, commencez à chercher
nostrh    jsr  rdpar          ; Lire les octets hexadécimaux si pas une chaîne.
hlp       lda  tmp0           ; Enregistrer dernier octet dans zone de stockage
          sta  stage,y
          iny                 ; Obtenir un autre octet hexadécimal
          jsr  getpar
          bcs  htgo           ; S'il n'y en a pas, commencez la recherche
          cpy  #estage-stage  ; Avons-nous rempli la zone de stockage ?
          bne  hlp            ; Sinon, récupérez un autre octet
htgo      sty  savy           ; Sauvegarder la longueur de la zone de stockage
          jsr  crlf           ; Nouvelle ligne
hscan     ldy  #0
hlp3      lda  (tmp2),y       ; Récupérer le premier octet de la zone de stock.
          cmp  stage,y        ; Comparez-le au premier octet.
          bne  hnoft          ; S'ilsne correspondent pas, alors rien trouvé.
          iny                 ; Si oui, vérifiez l'octet suivant
          cpy  savy           ; Est-ce la fin de la zone de stockage
          bne  hlp3           ; Sinon, continuez à comparer les octets
          jsr  showad         ; Correspondance trouvée, afficher l'adresse
hnoft     jsr  stop           ; Si non, vérifiez la touche [RUN/STOP]
          beq  hexit          ; Quitter si pressé
          jsr  adda2          ; Incrémente le pointeur de la zone de stockage
          jsr  sub13          ; Décrémente la longueur de la zone de stockage
          bcs  hscan          ; Il reste des octets, continuer la recherche.
hexit     jmp  strt           ; Retour à la boucle principale
herror    jmp  error          ; Gérer les erreurs.

;-----------------------------------------------------------------------------
; Charger (load), enregistrer (save), ou verifier [lsv]
;-----------------------------------------------------------------------------
ld        ldy  #1             ; Lecture par défaut sur bande, périphérique n° 1
          sty  fa
          sty  sa           ; Par défaut, l'adresse secondaire n° 1
          dey
          sty  curfnlen          ; Commencer par un nom de fichier vide
          sty  satus          ; Effacer le statut
          lda  #>stage        ; Pointer de nom de fichier sur la mémoire tampon
          sta  fnadr+1
          lda  #<stage
          sta  fnadr
l1        jsr  getchr         ; Obtenir un caractere.
          beq  lshort         ; Aucun nom de fichier fourni, essayez de charger 
                              ; ... ou de vérifier à partir de la bande
          cmp  #$20           ; Sauter les espaces de début
          beq  l1
          cmp  #$22           ; Erreur si nom de fichier ne commence pas par 
                              ; ... une guillemet
          bne  lerror
          ldx  chrpnt         ; Charger le pointeur de caractère courant dans le
                              ; ... registre d'index
l3        lda  inbuff,x       ; Charger le caractère courant du tampon dans 
                              ; ... l'accumulateur
          beq  lshort         ; Aucun nom de fichier fourni, essayez de charger 
                              ; ... ou de vérifier à partir de la bande
          inx                 ; Prochain caractère
          cmp  #$22           ; Est-ce un guillemet ?
          beq  l8             ; Si oui, nc'est la fin du nom de fichier
          sta  (fnadr),y      ; Sinon, enregistrez le caractère dans le tampon 
                              ; ... du nom de fichier
          inc  curfnlen          ; Incrémenter la longueur du nom de fichier
          iny 
          cpy  #estage-stage  ; Vérifier si le tampon est plein
          bcc  l3             ; Sinon, obtenir un autre personnage
lerror    jmp  error          ; Si oui, gérer l'erreur
l8        stx  chrpnt         ; Le pointeur de caractère sur l'index actuel
          jsr  getchr         ; Supprimer le séparateur entre le nom de fichier 
                              ; ... et le no. de périphérique
          beq  lshort         ; Pas de séparateur, essayez de charger ou de 
                              ; ... vérifier à partir de la bande
          jsr  getpar         ; Obtenir le numéro de périphérique
          bcs  lshort         ; Aucun numéro de périphérique indiqué, essayez de 
                              ; ... charger ou de vérifier à partir d'une bande
          lda  tmp0           ; Définir le numéro de périphérique pour les 
          sta  fa             ; ... routines du noyau
          jsr  getpar         ; Obtenir l'adresse de départ pour le chargement 
                              ; ... ou l'enregistrement dans tmp0
          bcs  lshort         ; Aucune adresse de départ, essayez de charger ou 
                              ; ... de vérifier
          jsr  copy12         ; L'adresse de début de transfert dans tmp2
          jsr  getpar         ; Obtenir l'adresse fin d'enregistrement de tmp0
          bcs  ldaddr         ; Aucune adresse de fin, tenter le chargement à 
                              ; ... l'adresse de début indiquée
          jsr  crlf           ; Nouvelle ligne
          ldx  tmp0           ; Placer le LSB de l'adresse de fin dans x
          ldy  tmp0+1         ; Placer le MSB de l'adresse de fin dans y
          lda  savy           ; Confirmez que nous effectuons une sauvegarde
          cmp  #"s"
          bne  lerror         ; Sinon, erreur due à trop de paramètres
          lda  #0
          sta  sa           ; Définir l'adresse secondaire à 0
          lda  #tmp2          ; Placer pointeur de page zéro dans acc
          jsr  save           ; Appel de la routine de sauvegarde du noyau
lsvxit    jmp  strt           ; Retour à la boucle principale
lshort    lda  savy           ; Vérifier quelle commande nous avons reçue
          cmp  #"v"
          beq  loadit         ; Vérification, donc ne pas mettre acc à 0.
          cmp  #"l"
          bne  lerror         ; Erreur due à un nombre insuffisant de paramètres
                              ; ... pour l'enregistrement
          lda  #0             ; 0 dans a chargement, autre chose verifier
loadit    jsr  load           ; Appel de la routine de chargement du noyau
          lda  satus          ; Obtenir l'état des E/S
          and  #$10           ; Vérifier le bit 5 pour une erreur de somme de 
                              ; ... contrôle
          beq  lsvxit         ; Si aucune erreur n'est détectée, 
                              ; ... retour à la boucle principale
          lda  savy           ; ?? not sure what these two lines are for...
          beq  lerror         ; ?? savy will never be 0, so why check?
          ldy  #msg6-msgbas   ; « erreur » si la somme de contrôle differe
          jsr  sndmsg
          jmp  strt           ; Retour à la boucle principale
ldaddr    ldx  tmp2           ; Placer le LSB de l'adresse de fchargement dans x
          ldy  tmp2+1         ; Placer le MSB de l'adresse de fchargement dans y
          lda  #0             ; 0 dans a indique chargement
          sta  sa           ; L'adresse secondaire 0 signifie l'adresse de 
                              ; ... chargement est dans x et y
          beq  lshort         ; Exécuter le chargement

;-----------------------------------------------------------------------------
; peupler (fill) la memoire [f]
;-----------------------------------------------------------------------------
fill      jsr  getdif         ; Début dans tmp2, fin dans stash, 
                              ; ... longueur dans store
          bcs  aerror         ; C à 1 indique une erreur
          jsr  getpar         ; Obtenir la valeur à peupler dans tmp0
          bcs  aerror         ; C à 1 indique une erreur
          jsr  getchr         ; Tout caractère de plus déclenche une erreur
          bne  aerror
          ldy  #0             ; Pas de décalage
fillp     lda  tmp0           ; Charge la valeur à peupler dans acc
          sta  (tmp2),y       ; Stocke la valeur dans l'adresse actuelle
          jsr  stop           ; Vérifiez la touche [RUN/STOP]
          beq  fstart         ; Si appuyé, retour à la boucle principale
          jsr  adda2          ; Incrémenter l'adresse
          jsr  sub13          ; Décrémenter la longueur
          bcs  fillp          ; Continuez jusqu'à ce que la longueur atteigne 0
fstart    jmp  strt           ; Retour à la boucle principale

;-----------------------------------------------------------------------------
; assemble [a.]
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; lire la mnemonique
;-----------------------------------------------------------------------------
assem     bcs  aerror         ; Erreur si aucune adresse n'est fournie
          jsr  copy12         ; Copier l'adresse dans tmp2
aget1     ldx  #0
          stx  u0aa0+1        ; Octet d'effacement dans lequel le mnémonique 
                              ; ... est déplacé
          stx  digcnt         ; Effacer le compte de caractere
aget2     jsr  getchr         ; Obtenir un caractere
          bne  almor          ; Poursuivre si le caractère n'est pas nul
          cpx  #0             ; C'est nul, avez-nous déjà lu une mneumonique ?
          beq  fstart         ; Sinon, retourneà la boucle principale
almor     cmp  #$20           ; Sauter les espaces de début
          beq  aget1
          sta  mnemw,x        ; Placer le caractère dans le tampon mnémonique
          inx
          cpx  #3             ; Avons-nous déjà lu 3 caracteres ?
          bne  aget2          ; Sinon, passez au caractère suivant
;-----------------------------------------------------------------------------
; compresser le mnémonique en deux octets
;-----------------------------------------------------------------------------
asqeez    dex                 ; Passer au caractère précédent
          bmi  aoprnd         ; Si terminé avec mnémonique, cherche opérande
          lda  mnemw,x        ; Obtenir le caractere actuel
          sec                 ; Condenser mnémonique de 3 lettres en (15 bits)
          sbc  #$3f           ; Soustraire $3f du code ASCII, donc a-z=2 à 27
          ldy  #$05           ; Les lettres tiennent désormais sur 5 bits ; 
ashift    lsr  a              ; ... décalez-les dans les deux premiers octets 
                              ; ...du tampon d'instructions.
          ror  u0aa0+1        ; Récupérer LSB de l'accumulateur dans l'octet 
                              ; ... de droite
          ror  u0aa0          ; Récupérer LSB de l'octet de droite dans 
                              ; ... l'octet de gauche
          dey                 ; Decompter les bits.
          bne  ashift         ; Continuer la boucle jusqu'à atteindre zéro
          beq  asqeez         ; Branche inconditionnelle pour gérer le 
                              ; ... prochain caractère
aerror    jmp  error          ; Gérer l'erreur
;-----------------------------------------------------------------------------
; parse operand
;-----------------------------------------------------------------------------
aoprnd    ldx  #2             ; Le mnémonique se trouve dans les deux premiers
                              ; ... octets, donc commencez au troisième.
ascan     lda  digcnt         ; Avons-nous trouvé les chiffres de l'adresse la
                              ; ... dernière fois ?
          bne  aform1         ; Si oui, recherchez les caractères de mode
          jsr  rdval          ; Sinon, cherchez une adresse
          beq  aform0         ; Nous n'avons pas trouvé d'adresse, recherchez 
                              ; ... des caractères
          bcs  aerror         ; Le CARRY indique une erreur
          lda  #"$"
          sta  u0aa0,x        ; Préfixez les adresses avec $
          inx                 ; Prochaine position dans le tampon
          ldy  #4             ; Les adresses non-zero page comportent 4 
                              ; ... chiffres hexadécimaux
          lda  numbit         ; Vérifier la base numérique dans laquelle 
                              ; ... l'adresse a été donnée
          cmp  #8             ; Pour les adresses données en octal ou en 
          bcc  aaddr          ; ... binaire, utilisez uniquement l'octet de 
                              ; ... poids fort pour déterminer la page
          cpy  digcnt         ; Pour les formats décimal ou hexadécimal, 
          beq  afill0         ; ... forcer l'adressage de page non nul si 
                              ; ... l'adresse fournie comporte quatre chiffres
                              ; ... ou plus
aaddr     lda  tmp0+1         ; Vérifier si le MSB de l'adresse est nul
          bne  afill0         ; Un octet MSB non nul signifie que nous ne 
                              ; ... sommes pas en mode page zéro
          ldy  #2             ; Si elle se trouve sur la page zéro, l'adresse 
                              ; ... est composée de 2 chiffres hexadécimaux
afill0    lda  #$30           ; Utilisez 0 comme espace réservé pour chaque 
                              ; ... chiffre hexadécimal dans l'adresse
afil0l    sta  u0aa0,x        ; Insérer un espace réservé dans le tampon 
                              ; ... d'assemblage
          inx                 ; Passer à l'octet suivant dans le tampon
          dey                 ; Décrémenter le nombre de chiffres restants
          bne  afil0l         ; Boucler jusqu'à ce que tous les chiffres aient 
                              ; ... été placés
aform0    dec  chrpnt         ; Entrée non numérique; revenez au caractère 
                              ; ... précédent pour voir ce qu'il contenait
aform1    jsr  getchr         ; obtenir le prochain personnage
          beq  aescan         ; S'il n'y en a pas, numérisation est terminée
          cmp  #$20           ; Sauter les espaces
          beq  ascan
          sta  u0aa0,x        ; Ltocker le caractère dans tampon d'assemblage
          inx                 ; Passer à l'octet suivant dans le tampon
          cpx  #u0aae-u0aa0   ; Le tampon d'instructions est-il plein?
          bcc  ascan          ; Sinon, continuez à scanner
          bcs  aerror         ; Erreur si la mémoire tampon est pleine
;-----------------------------------------------------------------------------
; find matching opcode
;-----------------------------------------------------------------------------
aescan  stx store           ; save number of bytes in assembly buffer
        ldx #0              ; start at opcode $00 and check every one until
        stx opcode          ;   we find one that matches our criteria
atryop  ldx #0
        stx u9f             ; reset index into work buffer
        lda opcode
        jsr instxx          ; look up instruction format for current opcode
        ldx acmd            ; save addressing command for later
        stx store+1
        tax                 ; use current opcode as index
        lda mnemr,x         ; check right byte of compressed mnemonic
        jsr chekop
        lda mneml,x         ; check left byte of compressed mnemonic
        jsr chekop
        ldx #6              ; 6 possible characters to check against operand
tryit   cpx #3              ; are we on character 3?
        bne trymod          ; if not, check operand characters
        ldy length          ; otherwise, check number of bytes in operand
        beq trymod          ; if zero, check operand characters
tryad   lda acmd            ; otherwise, look for an address
        cmp #$e8            ; special case for relative addressing mode
                            ;   since it's specified with 4 digits in assembly
                            ;   but encoded with only 1 byte in object code
        lda #$30            ; '0' is the digit placeholder we're looking for
        bcs try4b           ; acmd >= $e8 indicates relative addressing
        jsr chek2b          ; acmd < $e8 indicates normal addressing
        dey                 ; consume byte
        bne tryad           ; check for 2 more digits if not zero-page
trymod  asl acmd            ; shift a bit out of the addressing command
        bcc ub4df           ; if it's zero, skip checking current character
        lda char1-1,x
        jsr chekop          ; otherwise first character against operand
        lda char2-1,x       ; get second character to check
        beq ub4df           ; if it's zero, skip checking it
        jsr chekop          ; otherwise check it against hte operand
ub4df   dex                 ; move to next character
        bne tryit           ; repeat tests
        beq trybran
try4b   jsr chek2b          ; check for 4 digit address placeholder
        jsr chek2b          ;   by checking for 2 digits twice
trybran lda store           ; get number of bytes in assembly buffer
        cmp u9f             ; more bytes left to check?
        beq abran           ; if not, we've found a match; build instruction
        jmp bumpop          ; if so, this opcode doesn't match; try the next
;-----------------------------------------------------------------------------
; convert branches to relative address
;-----------------------------------------------------------------------------
abran   ldy length          ; get number of bytes in operand
        beq a1byte          ; if none, just output the opcode
        lda store+1         ; otherwise check the address format
        cmp #$9d            ; is it a relative branch?
        bne objput          ; if not, skip relative branch calculation
        lda tmp0            ; calculate the difference between the current
        sbc tmp2            ;   address and the branch target (low byte)
        tax                 ; save it in x
        lda tmp0+1          ; borrow from the high byte if necessary
        sbc tmp2+1
        bcc abback          ; if result is negative, we're branching back
        bne serror          ; high bytes must be equal when branching forward
        cpx #$82            ; difference between low bytes must be < 130
        bcs serror          ; error if the address is too far away
        bcc abranx
abback  tay                 ; when branching backward high byte of target must
        iny                 ;   be 1 less than high byte of current address
        bne serror          ; if not, it's too far away
        cpx #$82            ; difference between low bytes must be < 130
        bcc serror          ; if not, it's too far away
abranx  dex                 ; adjust branch target relative to the 
        dex                 ;   instruction following this one
        txa
        ldy length          ; load length of operand
        bne objp2           ; don't use the absolute address
;-----------------------------------------------------------------------------
; assemble machine code
;-----------------------------------------------------------------------------
objput  lda tmp0-1,y        ; get the operand
objp2   sta (tmp2),y        ; store it after the opcode
        dey
        bne objput          ; copy the other byte of operand if there is one
a1byte  lda opcode          ; put opcode into instruction
        sta (tmp2),y
        jsr crlf            ; carriage return
        lda #$91            ; back up one line
        jsr chrout
        ldy #msg7-msgbas    ; "a " prefix
        jsr sndclr          ; clear line
        jsr dislin          ; disassemble the instruction we just assembled
        inc length          ; instruction length = operand length + 1 byte
        lda length          ;   for the opcode
        jsr bumpad2         ; increment address by length of instruction
        lda #"a"            ; stuff keyboard buffer with next assemble command:
        sta keyd            ;   "a xxxx " where xxxx is the next address
        lda #" "            ;   after the previously assembled instruction
        sta keyd+1
        sta keyd+6
        lda tmp2+1          ; convert high byte of next address to hex
        jsr asctwo
        sta keyd+2          ; put it in the keyboard buffer
        stx keyd+3
        lda tmp2            ; convert low byte of next address to hex
        jsr asctwo
        sta keyd+4          ; put it in the keyboard buffer
        stx keyd+5
        lda #7              ; set number of chars in keyboard buffer
        sta ndx
        jmp strt            ; back to main loop
serror  jmp error           ; handle error
;-----------------------------------------------------------------------------
; check characters in operand
;-----------------------------------------------------------------------------
chek2b  jsr chekop          ; check two bytes against value in accumulator
chekop  stx savx            ; stash x
        ldx u9f             ; get current index into work buffer
        cmp u0aa0,x         ; check whether this opcode matches the buffer
        beq opok            ;   matching so far, check the next criteria
        pla                 ; didn't match, so throw away return address
        pla                 ;   on the stack because we're starting over
bumpop  inc opcode          ; check the next opcode
        beq serror          ; error if we tried every opcode and none fit
        jmp atryop          ; start over with new opcode
opok    inc u9f             ; opcode matches so far; check the next criteria
        ldx savx            ; restore x
        rts

;-----------------------------------------------------------------------------
; disassemble [d]
;-----------------------------------------------------------------------------
disass  bcs dis0ad          ; if no address was given, start from last address
        jsr copy12          ; copy start address to tmp2
        jsr getpar          ; get end address in tmp0
        bcc dis2ad          ; if one was given, skip default
dis0ad  lda #10             ; DL: disassemble 11 bytes by default
        sta tmp0            ; store length in tmp0
        bne disgo           ; skip length calculation
dis2ad  jsr sub12           ; calculate number of bytes between start and end
        bcc derror          ; error if end address is before start address
disgo   jsr cline           ; clear the current line
        jsr stop            ; Vérifiez la touche [RUN/STOP]
        beq disexit         ; exit early if pressed
        jsr dsout1          ; output disassembly prefix ". "
        inc length
        lda length          ; add length of last instruction to start address
        jsr bumpad2
        lda length          ; subtract length of last inst from end address
        jsr suba2
        bcs disgo
disexit jmp strt            ; back to mainloop
derror  jmp error

dsout1  #outcar snoir
        lda #"."            ; output ". " prefix to allow edit and reassemble
        jsr chrout
        jsr space

dislin  jsr showad          ; show the address of the instruction
        jsr space           ; insert a space
        ldy #0              ; no offset
        lda (tmp2),y        ; load operand of current instruction
        jsr instxx          ; get mnemonic and addressing mode for opcode
        pha                 ; save index into mnemonic table
        ldx length          ; get length of operand
        inx                 ; add 1 byte for opcode
dsbyt   dex                 ; decrement index
        bpl dshex           ; show hex for byte being disassembled
        sty savy            ; save index
        ldy #msg8-msgbas    ; skip 3 spaces
        jsr sndmsg
        ldy savy            ; restore index
        jmp nxbyt
dshex   lda (tmp2),y        ; show hex for byte
        jsr wrbyte

nxbyt   iny                 ; next byte
        cpy #3              ; have we output 3 bytes yet?
        bcc dsbyt           ; if not, loop
        ; ici on affiche l'instruction.
        #print mneuprfx
        pla                 ; restore index into mnemonic table
        ldx #3              ; 3 letters in mnemonic
        jsr propxx          ; print mnemonic
        ldx #6              ; 6 possible address mode character combos
pradr1  cpx #3              ; have we checked the third combo yet?
        bne pradr3          ; if so, output the leading characters
        ldy length          ; get the length of the operand
        beq pradr3          ; if it's zero, there's no operand to print
pradr2  lda acmd            ; otherwise, get the addressing mode
        cmp #$e8            ; check for relative addressing
        php                 ; save result of check
        lda (tmp2),y        ; get the operand
        plp                 ; restore result of check
        bcs relad           ; handle a relative address
        jsr wrtwo           ; output digits from address
        dey
        bne pradr2          ; repeat for next byte of operand, if there is one
pradr3  asl acmd            ; check whether addr mode uses the current char
        bcc pradr4          ; if not, skip it
        lda char1-1,x       ; look up the first char in the table
        jsr chrout          ; print first char
        lda char2-1,x       ; look up the second char in the table
        beq pradr4          ; if there's no second character, skip it
        jsr chrout          ; print second char
pradr4  dex                 ; next potential address mode character
        bne pradr1          ; loop if we haven't checked them all yet
        rts                 ; back to caller
relad   jsr ub64d           ; calculate absolute address from relative
        clc
        adc #1              ; adjust address relative to next instruction
        bne relend          ; don't increment high byte unless we overflowed
        inx                 ; increment high byte
relend  jmp wraddr          ; print address

ub64d   ldx tmp2+1          ; get high byte of current address
        tay                 ; is relative address positive or negative?
        bpl relc2           ; if positive, leave high byte alone
        dex                 ; if negative, decrement high byte
relc2   adc tmp2            ; add relative address to low byte
        bcc relc3           ; if there's no carry, we're done
        inx                 ; if there's a carry, increment the high byte
relc3   rts

;-----------------------------------------------------------------------------
; get opcode mode and length
;-----------------------------------------------------------------------------
; note: the labels are different, but the code of this subroutine is almost
; identical to the insds2 subroutine of the apple mini-assembler on page 78 of
; the apple ii red book. i'm not sure exactly where this code originated
; (mos or apple) but it's clear that this part of supermon64 and the 
; mini-asssembler share a common heritage.  the comments showing the way the 
; opcodes are transformed into indexes for the mnemonic lookup table come
; from the mini-assembler source.

instxx  tay                 ; stash opcode in accumulator in y for later
        lsr a               ; is opcode even or odd?
        bcc ieven
        lsr a
        bcs err             ; invalid opcodes xxxxxx11
        cmp #$22
        beq err             ; invalid opcode 10001001
        and #$07            ; mask bits to 10000xxx
        ora #$80
ieven   lsr a               ; lsb determines whether to use left/right nybble
        tax                 ; get format index using remaining high bytes
        lda mode,x
        bcs rtmode          ; look at left or right nybble based on carry bit
        lsr a               ; if carry = 0, use left nybble
        lsr a
        lsr a
        lsr a
rtmode  and #$0f            ; if carry = 1, use right nybble
        bne getfmt
err     ldy #$80            ; substitute 10000000 for invalid opcodes
        lda #0
getfmt  tax
        lda mode2,x         ; lookup operand format using selected nybble
        sta acmd            ; save for later use
        and #$03            ; lower 2 bits indicate number of bytes in operand
        sta length
        tya                 ; restore original opcode
        and #$8f            ; mask bits to x000xxxx
        tax                 ; save it
        tya                 ; restore original opcode
        ldy #3
        cpx #$8a            ; check if opcode = 1xxx1010
        beq gtfm4
gtfm2   lsr a               ; transform opcode into index for mnemonic table
        bcc gtfm4
        lsr a               ; opcodes transformed as follows:
gtfm3   lsr a               ; 1xxx1010->00101xxx
        ora #$20            ; xxxyyy01->00111xxx
        dey                 ; xxxyyy10->00111xxx
        bne gtfm3           ; xxxyy100->00110xxx
        iny                 ; xxxxx000->000xxxxx
gtfm4   dey
        bne gtfm2
        rts

;-----------------------------------------------------------------------------
; extract and print packed mnemonics
;-----------------------------------------------------------------------------
propxx  tay                 ; use index in accumulator to look up mnemonic
        lda mneml,y         ;   and place a temporary copy in store
        sta store
        lda mnemr,y
        sta store+1
prmn1   lda #0              ; clear accumulator
        ldy #$05            ; shift 5 times
prmn2   asl store+1         ; shift right byte
        rol store           ; rotate bits from right byte into left byte
        rol a               ; rotate bits from left byte into accumulator
        dey                 ; next bit
        bne prmn2           ; loop until all bits shifted
        adc #$3f            ; calculate ascii code for letter by adding to '?'
        jsr chrout          ; output letter
        dex                 ; next letter
        bne prmn1           ; loop until all 3 letters are output
        jmp space           ; output space

;-----------------------------------------------------------------------------
; read parameters
;-----------------------------------------------------------------------------
rdpar   dec chrpnt          ; back up one char
getpar  jsr rdval           ; read the value
        bcs gterr           ; carry set indicates error
        jsr gotchr          ; check previous character
        bne ckterm          ; if it's not null, check if it's a valid separator
        dec chrpnt          ; back up one char
        lda digcnt          ; get number of digits read
        bne getgot          ; found some digits
        beq gtnil           ; didn't find any digits
ckterm  cmp #$20            ; space or comma are valid separators
        beq getgot          ; anything else is an error
        cmp #","
        beq getgot
gterr   pla                 ; encountered error
        pla                 ; get rid of command vector pushed on stack
        jmp error           ; handle error
gtnil   sec                 ; set carry to indicate no parameter found
        .byte $24           ; bit zp opcode consumes next byte (clc)
getgot  clc                 ; clear carry to indicate paremeter returned
        lda digcnt          ; return number of digits in a
        rts                 ; return to address pushed from vector table

;-----------------------------------------------------------------------------
; read a value in the specified base
;-----------------------------------------------------------------------------
rdval   lda #0              ; clear temp
        sta tmp0
        sta tmp0+1
        sta digcnt          ; clear digit counter
        txa                 ; save x and y
        pha
        tya
        pha
rdvmor  jsr getchr          ; get next character from input buffer
        beq rdnilk          ; null at end of buffer
        cmp #$20            ; skip spaces
        beq rdvmor
        ldx #3              ; check numeric base [$+&%]
gnmode  cmp hikey,x
        beq gotmod          ; got a match, set up base
        dex
        bpl gnmode          ; check next base
        inx                 ; default to hex
        dec chrpnt          ; back up one character
gotmod  ldy modtab,x        ; get base value
        lda lentab,x        ; get bits per digit
        sta numbit          ; store bits per digit 
nudig   jsr getchr          ; get next char in a
rdnilk  beq rdnil           ; end of number if no more characters
        sec
        sbc #$30            ; subtract ascii value of 0 to get numeric value
        bcc rdnil           ; end of number if character was less than 0
        cmp #$0a
        bcc digmor          ; not a hex digit if less than a
        sbc #$07            ; 7 chars between ascii 9 and a, so subtract 7
        cmp #$10            ; end of number if char is greater than f
        bcs rdnil
digmor  sta indig           ; store the digit
        cpy indig           ; compare base with the digit
        bcc rderr           ; error if the digit >= the base
        beq rderr
        inc digcnt          ; increment the number of digits
        cpy #10
        bne nodecm          ; skip the next part if not using base 10
        ldx #1
declp1  lda tmp0,x          ; stash the previous 16-bit value for later use
        sta stash,x
        dex
        bpl declp1
nodecm  ldx numbit          ; number of bits to shift
times2  asl tmp0            ; shift 16-bit value by specified number of bits
        rol tmp0+1
        bcs rderr           ; error if we overflowed 16 bits
        dex
        bne times2          ; shift remaining bits
        cpy #10
        bne nodec2          ; skip the next part if not using base 10
        asl stash           ; shift the previous 16-bit value one bit left
        rol stash+1
        bcs rderr           ; error if we overflowed 16 bits
        lda stash           ; add shifted previous value to current value
        adc tmp0
        sta tmp0
        lda stash+1
        adc tmp0+1
        sta tmp0+1
        bcs rderr           ; error if we overflowed 16 bits
nodec2  clc 
        lda indig           ; load current digit
        adc tmp0            ; add current digit to low byte
        sta tmp0            ; and store result back in low byte
        txa                 ; a=0
        adc tmp0+1          ; add carry to high byte
        sta tmp0+1          ; and store result back in high byte
        bcc nudig           ; get next digit if we didn't overflow
rderr   sec                 ; set carry to indicate error
        .byte $24           ; bit zp opcode consumes next byte (clc)
rdnil   clc                 ; clear carry to indicate success
        sty numbit          ; save base of number
        pla                 ; restore x and y
        tay
        pla
        tax
        lda digcnt          ; return number of digits in a
        rts

;-----------------------------------------------------------------------------
; print address
;-----------------------------------------------------------------------------
showad  lda tmp2
        ldx tmp2+1

wraddr  pha                 ; save low byte
        txa                 ; put high byte in a
        jsr wrtwo           ; output high byte
        pla                 ; restore low byte

wrbyte  jsr wrtwo           ; output byte in a

space   lda #$20            ; output space
        bne flip

chout   cmp #$0d            ; output char with special handling of cr
        bne flip
crlf    lda #$0d            ; load cr in a
        bit $13             ; check default channel
        bpl flip            ; if high bit is clear output cr only
        jsr chrout          ; otherwise output cr+lf
        lda #$0a            ; output lf
flip    jmp chrout

fresh   jsr crlf            ; output cr
        lda #$20            ; load space in a
        jsr chrout
        jmp snclr

;-----------------------------------------------------------------------------
; output two hex digits for byte
;-----------------------------------------------------------------------------
wrtwo   stx savx            ; save x
        jsr asctwo          ; get hex chars for byte in x (lower) and a (upper)
        jsr chrout          ; output upper nybble
        txa                 ; transfer lower to a
        ldx savx            ; restore x
        jmp chrout          ; output lower nybble

;-----------------------------------------------------------------------------
; convert byte in a to hex digits
;-----------------------------------------------------------------------------
asctwo  pha                 ; save byte
        jsr ascii           ; do low nybble
        tax                 ; save in x
        pla                 ; restore byte
        lsr a               ; shift upper nybble down
        lsr a
        lsr a
        lsr a
;-----------------------------------------------------------------------------
; convert low nybble in a to hex digit
;-----------------------------------------------------------------------------
ascii   and #$0f            ; clear upper nibble
        cmp #$0a            ; if less than a, skip next step
        bcc asc1
        adc #6              ; skip ascii chars between 9 and a
asc1    adc #$30            ; add ascii char 0 to value
        rts

;-----------------------------------------------------------------------------
; get prev char from input buffer
;-----------------------------------------------------------------------------
gotchr  dec chrpnt
;-----------------------------------------------------------------------------
; get next char from input buffer
;-----------------------------------------------------------------------------
getchr  stx savx
        ldx chrpnt          ; get pointer to next char
        lda inbuff,x        ; load next char in a
        beq nochar          ; null, :, or ? signal end of buffer
        cmp #":"        
        beq nochar
        cmp #"?"
nochar  php
        inc chrpnt          ; next char
        ldx savx
        plp                 ; z flag will signal last character
        rts

;-----------------------------------------------------------------------------
; copy tmp0 to tmp2
;-----------------------------------------------------------------------------
copy12  lda tmp0            ; low byte
        sta tmp2
        lda tmp0+1          ; high byte
        sta tmp2+1
        rts

;-----------------------------------------------------------------------------
; subtract tmp2 from tmp0
;-----------------------------------------------------------------------------
sub12   sec
        lda tmp0            ; subtract low byte
        sbc tmp2
        sta tmp0
        lda tmp0+1
        sbc tmp2+1          ; subtract high byte
        sta tmp0+1
        rts

;-----------------------------------------------------------------------------
; subtract from tmp0
;-----------------------------------------------------------------------------
suba1   lda #1              ; shortcut to decrement by 1
suba2   sta savx            ; subtrahend in accumulator
        sec
        lda tmp0            ; minuend in low byte
        sbc savx
        sta tmp0
        lda tmp0+1          ; borrow from high byte
        sbc #0
        sta tmp0+1
        rts

;-----------------------------------------------------------------------------
; subtract 1 from store
;-----------------------------------------------------------------------------
sub13   sec
        lda store
        sbc #1              ; decrement low byte
        sta store
        lda store+1
        sbc #0              ; borrow from high byte
        sta store+1
        rts

;-----------------------------------------------------------------------------
; add to tmp2
;-----------------------------------------------------------------------------
adda2   lda #1              ; shortcut to increment by 1
bumpad2 clc
        adc tmp2            ; add value in accumulator to low byte
        sta tmp2
        bcc bumpex
        inc tmp2+1          ; carry to high byte
bumpex  rts 

;-----------------------------------------------------------------------------
; subtract 1 from tmp2
;-----------------------------------------------------------------------------
sub21   sec
        lda tmp2            ; decrement low byte
        sbc #1
        sta tmp2
        lda tmp2+1          ; borrow from high byte
        sbc #0
        sta tmp2+1
        rts

;-----------------------------------------------------------------------------
; copy tmp0 to pc
;-----------------------------------------------------------------------------
copy1p  bcs cpy1px          ; do nothing if parameter is empty
        lda tmp0            ; copy low byte
        ldy tmp0+1          ; copy high byte
        sta pcl
        sty pch
cpy1px  rts 

;-----------------------------------------------------------------------------
; get start/end addresses and calc difference
;-----------------------------------------------------------------------------
getdif  bcs gdifx           ; exit with error if no parameter given
        jsr copy12          ; save start address in tmp2
        jsr getpar          ; get end address in tmp0
        bcs gdifx           ; exit with error if no parameter given
        lda tmp0            ; save end address in stash
        sta stash
        lda tmp0+1
        sta stash+1
        jsr sub12           ; subtract start address from end address
        lda tmp0
        sta store           ; save difference in store
        lda tmp0+1
        sta store+1
        bcc gdifx           ; error if start address is after end address
        clc                 ; clear carry to indicate success
        .byte $24           ; bit zp opcode consumes next byte (sec)
gdifx   sec                 ; set carry to indicate error
        rts

;-----------------------------------------------------------------------------
; convert base [$+&%]
;-----------------------------------------------------------------------------
convrt  jsr rdpar           ; read a parameter
        jsr fresh           ; next line and clear
        lda #sbleu
        jsr chrout
        lda #"$"            ; output $ sigil for hex
        jsr chrout
        lda tmp0            ; load the 16-bit value entered
        ldx tmp0+1
        jsr wraddr          ; print it in 4 hex digits
        jsr fresh
        lda #smauve
        jsr chrout
        lda #"+"            ; output + sigil for decimal
        jsr chrout
        jsr cvtdec          ; convert to bcd using hardware mode
        lda #0              ; clear digit counter
        ldx #6              ; max digits + 1
        ldy #3              ; bits per digit - 1
        jsr nmprnt          ; print result without leading zeros
        jsr fresh           ; next line and clear
        lda #srouge
        jsr chrout
        lda #"&"            ; print & sigil for octal
        jsr chrout
        lda #0              ; clear digit counter
        ldx #8              ; max digits + 1
        ldy #2              ; bits per digit - 1
        jsr prinum          ; output number
        jsr fresh           ; next line and clear
        lda #svert
        jsr chrout
        lda #"%"            ; print % sigil for binary
        jsr chrout
        lda #0              ; clear digit counter
        ldx #$18            ; max digits + 1
        ldy #0              ; bits per digit - 1
        jsr prinum          ; output number
        lda #snoir
        jsr chrout
        jmp strt            ; back to mainloop

;-----------------------------------------------------------------------------
; convert binary to bcd
;-----------------------------------------------------------------------------
cvtdec  jsr copy12          ; copy value from tmp0 to tmp2
        lda #0
        ldx #2              ; clear 3 bytes in work buffer
decml1  sta u0aa0,x
        dex
        bpl decml1
        ldy #16             ; 16 bits in input
        php                 ; save status register
        sei                 ; make sure no interrupts occur with bcd enabled
        sed
decml2  asl tmp2            ; rotate bytes out of input low byte
        rol tmp2+1          ; .... into high byte and carry bit
        ldx #2              ; process 3 bytes
decdbl  lda u0aa0,x         ; load current value of byte
        adc u0aa0,x         ; add it to itself plus the carry bit
        sta u0aa0,x         ; store it back in the same location
        dex                 ; decrement byte counter
        bpl decdbl          ; loop until all bytes processed
        dey                 ; decrement bit counter
        bne decml2          ; loop until all bits processed
        plp                 ; restore processor status
        rts

;-----------------------------------------------------------------------------
; load the input value and fall through to print it
;-----------------------------------------------------------------------------
prinum  pha                 ; save accumulator
        lda tmp0            ; copy input low byte to work buffer
        sta u0aa0+2
        lda tmp0+1          ; copy input high byte to work buffer
        sta u0aa0+1
        lda #0              ; clear overflow byte in work buffer
        sta u0aa0
        pla                 ; restore accumulator

;-----------------------------------------------------------------------------
; Affiche un nombre dans la base spécifiée sans précéder de zéros.
;-----------------------------------------------------------------------------
nmprnt  sta digcnt          ; number of digits in accumulator
        sty numbit          ; bits per digit passed in y register
digout  ldy numbit          ; get bits to process
        lda #0              ; clear accumulator
rolbit  asl u0aa0+2         ; shift bits out of low byte
        rol u0aa0+1         ; ..... into high byte
        rol u0aa0           ; ..... into overflow byte
        rol a               ; ..... into accumulator
        dey                 ; decrement bit counter
        bpl rolbit          ; loop until all bits processed
        tay                 ; check whether accumulator is 0
        bne nzero           ; if not, print it
        cpx #1              ; have we output the max number of digits?
        beq nzero           ; if not, print it
        ldy digcnt          ; how many digits have we output?
        beq zersup          ; skip output if digit is 0
nzero   inc digcnt          ; increment digit counter
        ora #$30            ; add numeric value to ascii '0' to get ascii char
        jsr chrout          ; output character
zersup  dex                 ; decrement number of leading zeros
        bne digout          ; next digit
        rts

;-----------------------------------------------------------------------------
; disk status/command [@]
;-----------------------------------------------------------------------------
dstat     bne  chgdev         ; si une adresse de périphérique a été fournie, 
                              ; utilisez-la
          ldx  #8             ; sinon, la valeur par défaut est 8
          .byte $2c           ; L'opcode de bit absolu consomme le mot suivant
                              ; ... (ldx tmp0)
chgdev    ldx  tmp0           ; Charge l'adresse du périphérique à partir du 
                              ; ... paramètre.
          cpx  #4             ; S'assure que l'adresse du périphérique se 
                              ; ... situe dans la plage 4-31.
          bcc  ioerr
          cpx  #32
          bcs  ioerr
          stx  tmp0
          lda  #0             ; Efface le status.
          sta  satus
          sta  curfnlen          ; Vide le nom de fichier.
          jsr  getchr         ; Obtient le prochain caractere.
          beq  instat1        ; nul, afficher l'état
          dec  chrpnt         ; reculez d'un caractère
          cmp  #"$"           ; $, Affiche le repertoire.
          beq  direct
          lda  tmp0           ; Ordonne LISTEN au périphérique spécifié.
          jsr  listen
          lda  #$6f           ; adresse secondaire 15 
                              ; ... (seul le nibble de poids faible est utilisé)
          jsr  second
;-----------------------------------------------------------------------------
; Envoyer une commande au périphérique.
;-----------------------------------------------------------------------------
dcomd     ldx  chrpnt         ; Récupére le caractère suivant du tampon.
          inc  chrpnt
          lda  inbuff,x
          beq  instat         ; Sort de la boucle si la valeur est nulle.
          jsr  ciout          ; Sinon, envoyez-le sur le bus série.
          bcc  dcomd          ; Boucle inconditionnelle: ciout efface carry.
          rts
;-----------------------------------------------------------------------------
; obtenir l'état du périphérique.
;-----------------------------------------------------------------------------
instat    jsr  unlsn          ; Ordonne UNLISTEN au périphérique.
instat1   jsr  crlf           ; Nouvelle ligne.
          lda  tmp0           ; charger l'adresse du périphérique.
          jsr  talk           ; Ordonne TALK au périphérique.
          lda  #$6f           ; adresse secondaire 15 
                              ;(seul le nibble de poids faible est utilisé)
          jsr  tksa
rdstat    jsr  acptr          ; Li un octet depuis le bus série
          jsr  chrout         ; Affiche-le.
          cmp  #$0d           ; Si l'octet est cr-lf, sortir de la boucle.
          beq  dexit
          lda  satus          ; Vérifie l'état.
          and  #$bf           ; Ignore le bit eoi.
          beq  rdstat         ; En l'absence d'erreurs, lire l'octet suivant.
dexit     jsr  untlk          ; Ordonne UNTALK au périphérique.
          jmp  strt           ; Retour à la boucle principale.
ioerr     jmp  error          ; Gère les erreurs.
;-----------------------------------------------------------------------------
; Obtenir le répertoire
;-----------------------------------------------------------------------------
direct    lda  tmp0           ; Charger l'adresse du périphérique.
          jsr  listen         ; Ordonne LISTEN au périphérique.
          lda  #$f0           ; adresse secondaire 0 
                              ; ...(seul le nibble de poids faible est utilisé).
          jsr  second
          ldx  chrpnt         ; Obtien l'index du caractère suivant.
dir2      lda  inbuff,x       ; Récupère le caractère suivant du tampon.
          beq  dir3           ; Interrompre si la valeur est nulle.
          jsr  ciout          ; Envoie un caractère au périphérique.
          inx                 ; Incrémente l'indexe du caractère.
          bne  dir2           ; Boucle si la valeur n'est pas revenue à zéro.
dir3      jsr  unlsn          ; Ordonne UNLISTEN au périphérique.
          jsr  crlf           ; Nouvelle ligne.
          lda  tmp0           ; Charger l'adresse du périphérique.
          pha                 ; Enregistre sur la pile.
          jsr  talk           ; Ordonne TALK au périphérique.
          lda  #$60           ; Adresse second. 0 (seul le LSN est utilisé)
          jsr  tksa
          ldy  #3             ; Lire 3 valeurs de 16 bits du périphérique.
dirlin    sty  store          ; ... Ignorez les deux premiers; 
                              ; ... le troisième est la taille du fichier.
dlink     jsr  acptr          ; Lit le LSB depuis le périphérique.
          sta  tmp0           ; L'enregistre.
          lda  satus          ; Vérifie l'état.
          bne  drexit         ; Quitte en cas d'erreur ou de fin de fichier.
          jsr  acptr          ; Lit le MSB depuis le périphérique.
          sta  tmp0+1         ; L'enregistre.
          lda  satus          ; Vérifie l'état.
          bne  drexit         ; Quitte en cas d'erreur ou de fin de fichier.
          dec  store          ; Décrémenter le compteur d'octets.
          bne  dlink          ; Boucle si des octets restent.
          jsr  cvtdec         ; Convertir dernière valeur 16 bits en décimal.
          lda  #0             ; Met le compteur de caracteres a 0.
          ldx  #6             ; Max 6 chiffres.
          ldy  #3             ; 3 bits par chiffre.
          jsr  nmprnt         ; Affiche le nombre.
          lda  #" "           ; Affiche un espace.
          jsr  chrout
dname     jsr  acptr          ; Récupère un caractère de nom de fichier depuis
                              ; ... le périphérique
          beq  dmore          ; Si la valeur est nulle, sortir de la boucle
          ldx  satus          ; Vérifie les erreurs ou la fin du fichier.
          bne  drexit         ; Si trouvé, on sort.
          jsr  chrout         ; Affiche le caractere.
          clc
          bcc  dname          ; Branchement incond. pour lire carac. suivant.
dmore     jsr  crlf
          jsr  stop           ; Vérifier la touche [RUN/STOP]
          beq  drexit         ; Quitter si pressée.
          jsr  getin          ; Pause si une touche a été pressée.
          beq  nopaws
paws      jsr  getin          ; Attendre qu'une autre touche soit enfoncée.
          beq  paws            
nopaws    ldy  #2
          bne  dirlin         ; Branchement incond. pour lire fichier suivant.
drexit    jsr  untlk          ; Ordonne UNTALK au périphérique.
          pla                 ; restaurer l'accumulateur
          jsr  listen         ; Ordonne LISTEN au périphérique.
          lda  #$e0           ; adresse secondaire 0 
                              ; ...(seul le nibble de poids faible est utilisé).
          jsr  second
          jsr  unlsn          ; Ordonne UNLISTEN au périphérique.
          jmp  strt           ; Retour à la boucle principale.

;-----------------------------------------------------------------------------
; Routines d'affichage et d'effacement
;-----------------------------------------------------------------------------
cline     jsr  crlf           ; Envoie cr+lf.
          jmp  snclr          ; Efface la ligne.
sndclr    jsr  sndmsg
          ;-------------------------------------------------------------------
          ; CORRECTIFS-V20 : Changer le nombre d'octets a afficher de 40 à 22.
          ;                  le Vic20 possere 22 colonnes au lieu de 40.
          ;-------------------------------------------------------------------
snclr     ldy  #22           ; Boucle 22 fois
          ;-------------------------------------------------------------------
snclp     lda  #$20           ; output space character
          jsr  chrout
          lda  #$14           ; output delete character
          jsr  chrout
          dey
          bne  snclp
          rts

;-----------------------------------------------------------------------------
; Affiche un message de la table des messages.
;-----------------------------------------------------------------------------
sndmsg  .block
          lda  msgbas,y       ; Y contient le décalage dans la table msg.
          beq  msgout
          jsr  chout
          iny
          jmp  sndmsg       ; Boucle jusqu'à ce que le bit 7 soit activé.
msgout    rts
          .bend

;-----------------------------------------------------------------------------
; initialise l'écran en noir sur fond blanc à bordure verte.
; Interlace off et centre l'ecran
;-----------------------------------------------------------------------------
scrinit
          .block
          php
          pha
          lda  #(128+4)
          sta  vic0
bord      lda  $900f          ;place la couleur
          and  #%00001000
          ora  #%00010110    
          sta  $900f   
text      lda  #$00           ;place la couleur
          sta  $0286          ; du texte.
          lda  #$93           ;efface l'ecran par
          jsr  $ffd2          ; chrout du kernal.
          pla
          plp
          rts
          .bend
;-----------------------------------------------------------------------------
; Aide à l'ecran !e
;-----------------------------------------------------------------------------
popup      .block
          jsr  pushall
          jsr  clrkbbuf
          lda  kcol
          pha
          jsr  cursave
          jsr  scrnsave
          #outcar 147
          ldx  #6
          lda  #102
          jsr  fillscreen
          #ldyxmem genword1 
          jsr  putsyx
          jsr  anykey
          jsr  scrnrest
          jsr  currest
          pla
          sta  kcol
          jsr  popall
          ;jmp  strt
          rts
          .bend

;-----------------------------------------------------------------------------
; ajout des commandes c, h, g
;-----------------------------------------------------------------------------
mycmd     .block
          jsr  pushregs
          jsr  chrin
          cmp  #'t'      ; cmd test
          bne  cmdd
          jsr  popscr
          jmp  mycmdout
cmdd      cmp  #'d'      ; cmd dir
          bne  cmdh
          jsr  dirdisk
          jmp  mycmdout
cmdh      cmp  #'h'      ; cmd help
          bne  cmdg
          #ldyxptr  helpscrp1
          #styxmem  genword1
          jsr  popup
          #ldyxptr  helpscrp2
          #styxmem  genword1
          jsr  popup
          #ldyxptr  helpscrp3
          #styxmem  genword1
          jsr  popup
          #ldyxptr  helpscrp4
          #styxmem  genword1
          jsr  popup
          #ldyxptr  greetings
          #styxmem  genword1
          jsr  popup
          jmp  mycmdout

cmdg      cmp  #'g'      ; cmd greetings
          bne  cmdc
          #ldyxptr  greetings
          #styxmem  genword1
          jsr  popup
          jmp  mycmdout

cmdc      cmp  #'c'      ;cmd cls
          bne  notmycmd
          #outcar 147
mycmdout  #print backspace
          jsr  popregs
          lda  #$00
          rts
notmycmd  jsr  popregs
          rts
          .bend

dirdisk   .block
          jsr  pushall
          jsr  clrkbbuf
          lda  kcol
          pha
          jsr  cursave
          jsr  scrnsave
          #outcar 147
          jsr  directory 
          jsr  anykey
          #outcar 147
          jsr  scrnrest
          jsr  currest
          pla
          sta  kcol
          jsr  popall
          rts
          .bend

;-----------------------------------------------------------------------------
; message table; last character has high bit set
;-----------------------------------------------------------------------------
msgbas  =*
msg2      .byte $0d,$20,31,18     ; header for registers
          .text " SuperMon sur VIC20 "
          .byte 146,$0d,31        ; header for registers
          .text "   pc  sr ac xr yr sp"
          .byte 144,$0d,$00
msg3      .byte $1d,$3f,$00       ; syntax error: move right, display "?"
msg4      .text "..sys"           ; sys call to enter monitor
          .byte $20,$00
msg5      .byte $3a,$12,$00       ; ":" then rvs on for memory ascii dump
msg6      .text " erro"           ; i/o error: display " error"
          .byte "r",$00
msg7      .byte $41,$20,$00       ; assemble next instruction: "a " + addr
msg8      .text "  "              ; pad non-existent byte: skip 3 spaces
          .byte $20,$00
msg9      .byte 28,32,32,32,32,32,18
          .text "!h pour aide"
          .byte 146,144,0

version   = "20260307-000000"

;-----------------------------------------------------------------------------
; addressing mode table - nybbles provide index into mode2 table
; for opcodes xxxxxxy0, use xxxxxx as index into table
; for opcodes wwwxxy01  use $40 + xx as index into table
; use right nybble if y=0; use left nybble if y=1
;-----------------------------------------------------------------------------
mode    .byte $40,$02,$45,$03   ; even opcodes
        .byte $d0,$08,$40,$09
        .byte $30,$22,$45,$33
        .byte $d0,$08,$40,$09
        .byte $40,$02,$45,$33
        .byte $d0,$08,$40,$09
        .byte $40,$02,$45,$b3
        .byte $d0,$08,$40,$09
        .byte $00,$22,$44,$33
        .byte $d0,$8c,$44,$00
        .byte $11,$22,$44,$33
        .byte $d0,$8c,$44,$9a
        .byte $10,$22,$44,$33
        .byte $d0,$08,$40,$09
        .byte $10,$22,$44,$33
        .byte $d0,$08,$40,$09
        .byte $62,$13,$78,$a9   ; opcodes ending in 01

;-----------------------------------------------------------------------------
; addressing mode format definitions indexed by nybbles from mode table
;-----------------------------------------------------------------------------
; left 6 bits define which characters appear in the assembly operand
; left 3 bits are before the address; next 3 bits are after
;-----------------------------------------------------------------------------
; right-most 2 bits define length of binary operand
;-----------------------------------------------------------------------------
; index               654 321
; 1st character       $(# ,),  
; 2nd character        $$ x y    length  format      idx mode
;-----------------------------------------------------------------------------
mode2   .byte $00   ; 000 000    00                  0   error
        .byte $21   ; 001 000    01      #$00        1   immediate
        .byte $81   ; 100 000    01      $00         2   zero-page
        .byte $82   ; 100 000    10      $0000       3   absolute
        .byte $00   ; 000 000    00                  4   implied
        .byte $00   ; 000 000    00                  5   accumulator
        .byte $59   ; 010 110    01      ($00,x)     6   indirect,x
        .byte $4d   ; 010 011    01      ($00),y     7   indirect,y
        .byte $91   ; 100 100    01      $00,x       8   zero-page,x
        .byte $92   ; 100 100    10      $0000,x     9   absolute,x
        .byte $86   ; 100 001    10      $0000,y     a   absolute,y
        .byte $4a   ; 010 010    10      ($0000)     b   indirect
        .byte $85   ; 100 001    01      $00,y       c   zero-page,y
        .byte $9d   ; 100 111    01      $0000*      d   relative

;-----------------------------------------------------------------------------
; * relative is special-cased so format bits don't match
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; character lookup tables for the format definitions in mode2
;-----------------------------------------------------------------------------
char1   .byte $2c,$29,$2c       ; ","  ")"  ","
        .byte $23,$28,$24       ; "#"  "("  "$"

char2   .byte $59,$00,$58       ; "y"   0   "x"
        .byte $24,$24,$00       ; "$"  "$"   0
;-----------------------------------------------------------------------------
; 3-letter mnemonics packed into two bytes (5 bits per letter)
;-----------------------------------------------------------------------------
        ; left 8 bits
        ; xxxxx000 opcodes
mneml   .byte $1c,$8a,$1c,$23   ; brk php bpl clc
        .byte $5d,$8b,$1b,$a1   ; jsr plp bmi sec
        .byte $9d,$8a,$1d,$23   ; rti pha bvc cli
        .byte $9d,$8b,$1d,$a1   ; rts pla bvs sei
        .byte $00,$29,$19,$ae   ; ??? dey bcc tya
        .byte $69,$a8,$19,$23   ; ldy tay bcs clv
        .byte $24,$53,$1b,$23   ; cpy iny bne cld
        .byte $24,$53,$19,$a1   ; cpx inx beq sed
        ; xxxyy100 opcodes
        .byte $00,$1a,$5b,$5b   ; ??? bit jmp jmp
        .byte $a5,$69,$24,$24   ; sty ldy cpy cpx
        ; 1xxx1010 opcodes
        .byte $ae,$ae,$a8,$ad   ; txa txs tax tsx
        .byte $29,$00,$7c,$00   ; dex ??? nop ???
        ; xxxyyy10 opcodes
        .byte $15,$9c,$6d,$9c   ; asl rol lsr ror
        .byte $a5,$69,$29,$53   ; stx ldx dec inc
        ; xxxyyy01 opcodes
        .byte $84,$13,$34,$11   ; ora and eor adc
        .byte $a5,$69,$23,$a0   ; sta lda cmp sbc

        ; right 7 bits, left justified
        ; xxxxx000 opcodes
mnemr   .byte $d8,$62,$5a,$48   ; brk php bpl clc
        .byte $26,$62,$94,$88   ; jsr plp bmi sec
        .byte $54,$44,$c8,$54   ; rti pha bvc cli
        .byte $68,$44,$e8,$94   ; rts pla bvs sei
        .byte $00,$b4,$08,$84   ; ??? dey bcc tya
        .byte $74,$b4,$28,$6e   ; ldy tay bcs clv
        .byte $74,$f4,$cc,$4a   ; cpy iny bne cld
        .byte $72,$f2,$a4,$8a   ; cpx inx beq sed
        ; xxxyy100 opcodes
        .byte $00,$aa,$a2,$a2   ; ??? bit jmp jmp
        .byte $74,$74,$74,$72   ; sty ldy cpy cpx
        ; 1xxx1010 opcodes
        .byte $44,$68,$b2,$32   ; txa txs tax tsx
        .byte $b2,$00,$22,$00   ; dex ??? nop ???
        ; xxxyyy10 opcodes
        .byte $1a,$1a,$26,$26   ; asl rol lsr ror
        .byte $72,$72,$88,$c8   ; stx ldx dec inc
        ; xxxyyy01 opcodes
        .byte $c4,$ca,$26,$48   ; ora and eor adc
        .byte $44,$44,$a2,$c8   ; sta lda cmp sbc
        .byte $0d,$20,$20,$20

;-----------------------------------------------------------------------------
; single-character commands
;-----------------------------------------------------------------------------
keyw    .text "acdfghjmrtx@.>;"
hikey   .text "$+&%lsv"
keytop  =*

;-----------------------------------------------------------------------------
; vectors corresponding to commands above
;-----------------------------------------------------------------------------
kaddr   
          .word assem-1,compar-1,disass-1,fill-1
          .word goto-1,hunt-1,jsub-1,dsplym-1
          .word dsplyr-1,trans-1,exit-1,dstat-1
          .word assem-1,altm-1,altr-1

;-----------------------------------------------------------------------------
modtab  .byte $10,$0a,$08,02    ; modulo number systems
lentab  .byte $04,$03,$03,$01   ; bits per digit

linkad  .word break             ; address of brk handler
supad   .word super             ; address of entry point


;-----------------------------------------------------------------------------
     ;.include  "string-fr.asm"
     .include  "string-en.asm"
;-----------------------------------------------------------------------------
;     .include  "l-v20-push.asm" 
;     .include  "l-v20-string.asm" 
;     .include  "l-v20-mem.asm"           
;     .include  "l-v20-math.asm"           
;     .include  "l-v20-conv.asm" 
;     .include  "l-v20-keyb.asm" 
;     .include  "l-v20-disk.asm"
     .include  "l-v20-screen.asm"
     .include  "l-routines.asm"
;     .include  "l-v20-showregs.asm"
;prgend    .word $1234     
;--------------------------------------
     .include  "e-v20-page0.asm"
     .include  "e-v20-float.asm"
     .include  "e-v20-basic-map.asm"
     .include  "e-v20-kernal-map.asm"
     .include  "e-v20-vic.asm"
     .include  "e-v20-vars.asm"
     .include  "e-local-equates.asm"
     .include  "e-local-vars.asm"

;--------------------------------------

