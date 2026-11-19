;-------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: l-c64-ultimateii.asm
; Type fichier....: Constantes/code/variables/macros
; Creation........: 20161117 
; Version.........: 0.0.1
; Révisions.......: 20161117 Francisation des commentaires,
;------------------------------------------------------------------------------
; Fichier d'inclusion DOS pour 1541 Ultimate II+ contenant des constantes et 
; des fonctions :
;------------------------------------------------------------------------------
               .include    "m-c64-ultimateii.asm"
;------------------------------------------------------------------------------
; 1541 Ultimate II+ 
;registre      =     adresse
;------------------------------------------------------------------------------
uiictrlreg     =     $df1c ;(Write)          * CONTROL REGISTER *
   ;------------------------------------------------------------------------
   ; Status register flag and constants
   ;------------------------------------------------------------------------
   ; Bit 7 ; Bit 6 ; Bit 5 ; Bit 4 ; Bit 3 ;  Bit 2  ;   Bit 1  ;   Bit 0  ;
   ;-------;-------;---------------;-------;---------;----------;-----------
   ;DATA_AV;STAT_AV;     STATE     ; ERROR ; ABORT_P ; DATA_ACC ; CMD_BUSY ;
   ;------------------------------------------------------------------------
   uiiidle     =     $00
   uiicmdbusy  =     $01
   uiidatalast =     $02
   uiidatamore =     $03
   ; 
   uiicmdstat  =     $df1c ;(Lecture) ($00) * REGISTRE D'ÉTAT DE COMMANDE
   uiicmddata  =     $df1d ;(Écriture)      * REGISTRE DE DONNÉES DE COMMANDE
   uiiidenreg  =     $df1d ;(Lecture) ($c9) * REGISTRE D'IDENTIFIANT API
   uiirxdata   =     $df1e ;(Lecture seule) * REGISTRE DE DONNÉES
   uiidatastat =     $df1f ;(Lecture seule) * rEGISTRE DE STATUS DES DONNÉES
;------------------------------------------------------------------------------
; Structure des commandes DOS du 1541 Ultimate II+ :  $01 CMD [XX] <FILENAME> 
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; CMD list
;------------------------------------------------------------------------------
uii_identify   =     $01   ; $01 $01 -> Lire la chaîne d’identifiant comme:
                           ;                        "ULTIMATE-II DOS V1.0"
;------------------------------------------------------------------------------
; Commandes d'accès aux fichiers.
;------------------------------------------------------------------------------
uii_file_open  =     $02   ; Ouvrir le fichier pour...
;------------------------------------------------------------------------------
; File access sub-command.
;------------------------------------------------------------------------------
uii_fa_read    =     $01   ; $01 $02 $01 <nomfichier> -> ... lecture.
uii_fa_write   =     $02   ; $01 $02 $02 <nomfichier> -> ... ecriture. 
uii_fa_new     =     $04   ; $01 $02 $04 <nomfichier> -> ... creation/ecriture.
uii_fa_ovwri   =     $08   ; $01 $02 $08 <nomfichier> -> ... remplacement.
uii_file_close =     $03   ; $01 $03 -> ferme le fichier ouvert.
uii_read_data  =     $04   ; $01 $04 [len_lo] [len_hi]
uii_writ_data  =     $05   ; $01 $05 [dummy] [dummy] [data...]
uii_file_seek  =     $06   ; $01 $06 [posl] [posml] [posmh] [posh].
;------------------------------------------------------------------------------
uii_file_info  =     $07   ; $01 $07 -> renvoie des informations sur le ...
                           ;            ... fichier actuellement ouvert.
uii_file_stat  =     $08   ; $01 $08 <nomfichier> -> Renvoie des informations 
                           ;                         ... sur le fichier.
;------------------------------------------------------------------------------
; Structure des informations/statistiques de fichier.
;------------------------------------------------------------------------------
; dword  size -> grandeur du fichier
; word   date -> date de la dernière modification.
; word   time -> heure de la dernière modification.
; char   extension[3]
; byte   attributs
; char   nomfichier[] 
;------------------------------------------------------------------------------
uii_file_del   =     $09   ; $01 $09 <nomfichier> -> Supprimer/effacer fichier.
uii_file_ren   =     $0a   ; $01 $0a <nomfichier> $00 <nouveaunom> -> renommer.
uii_file_copy  =     $0b   ; $01 $0b <source> $00 <destination> -> copier.
;------------------------------------------------------------------------------
; Commandes d'accès aux répertoires.
;------------------------------------------------------------------------------
uii_dir_change =     $11   ; $01 $11 <nom du répertoire> Change de répertoire.
uii_dir_pwd    =     $12   ; $01 $12 Retourne le nom du répertoire actuel.
uii_dir_open   =     $13   ; $01 $13 Ouvre un répertoire.
uii_dir_read   =     $14   ; $01 $14 Lit le contenu du répertoire.
;------------------------------------------------------------------------------
; Structure de la lecture d'un répertoire :
;  attr <nomfichier> attr <nomfichier> ... 
;              byte  attr   
;              char  nomfichier []
; 
; Description de l’attribut.
;  ; Bit 7-6 ; Bit 5   ; Bit 4 ; Bit 3  ; Bit 2  ; Bit 1  ; Bit 0  ;
;  ; Unused  ; Archive ; Dir   ; Volume ; System ; Hidden ; Readonly ; 
;------------------------------------------------------------------------------
uii_dir_cp_ui  =     $15   ; $01 $15 -> Définit le chemin actuel de l'interface
                           ;            ... utilisateur comme étant le chemin 
                           ;            ... actuel de l'API.
uii_dir_mkdir  =     $16   ; $01 $16 <nomrep> 
                           ;         -> Créer un répertoire dans le 
                           ;            ... répertoire courant.
uii_dir_home   =     $17   ; $01 $17 -> Définit le chemin d'accueil de 
                           ;            ... l'interface utilisateur comme étant
                           ;            ...  le chemin actuel de l'API.
;------------------------------------------------------------------------------
; Commande d'accès REU.
;------------------------------------------------------------------------------
uii_reu_load   =     $21   
;     $01 $21 [addL] [addML] [addMH] [addH] [lenL] [lenML] [lenMH] [lenH] 
uii_reu_save   =     $22   
;     $01 $22 [addL] [addML] [addMH] [addH] [lenL] [lenML] [lenMH] [lenH] 
;------------------------------------------------------------------------------
; Commande de lecteur de disque virtuel.
;------------------------------------------------------------------------------
uii_dsk_mount  =     $23   ; $01 $23 <id> <nomfichier>
uii_dsk_umount =     $24   ; $01 $24 <id>
uii_dsk_swap   =     $25   ; $01 $25 <id>
;------------------------------------------------------------------------------
; Commande RTC
;------------------------------------------------------------------------------
uii_time_get   =     $26   ; $01 $26 [id] -> Renvoie l'heure/la date actuelle 
                           ;                 ... du RTC.
;                          ; Si id = 1, le format renvoyé est :
                           ;        « www yyyy/mm/dd hh:mm:ss ».
uii_time_set   =     $27   ; $01 $27 <Y> <M> <D> <H> <M> <S>
;                          ; Y = année en cours - 1900
uii_dos_echo   =     $f0   ; $01 $f0 
;==============================================================================
; Définition de la liste des commandes pour le 1541 Ultimate II+
;==============================================================================
uiicmdgetid    .byte $01,$01,$00
uiicmdgettime  .byte $01,$26,$00

;------------------------------------------------------------------------------
; Tampon de communication R/X avec pointeur et status.
;  - Si start=end et Bit 0 de flag = 0 le buffer est vide
;  - Si start=end et Bit 0 de flag = 0 le buffer est plein
;    - Si le bit 7 de rxflag = 1 la routine de réception doit être appelée quand 
;      le buffer sera vidé.  
;------------------------------------------------------------------------------
rxbuffer       .fill 256
rxbstart       .byte 0
rxbend         .byte 0
rxbflag        .byte 0
txbuffer       .fill 256
txbstart       .byte 0
txbend         .byte 0
txbflag        .byte 0

;*******************************************************************************
;         G e r e r   l e   r e g i s t r e   d e   s t a t u s
;*******************************************************************************

;------------------------------------------------------------------------------
; Retourne le drapeau « Zero » si le 1541 Ultimate II+ est occupé.
; Z=0 si le drapeau « occupé » est activé, 
; Z=1 si le drapeau « occupé » est désactivé.
;------------------------------------------------------------------------------
uiifisbusy     .block
               pha
               lda   uiicmdstat  
               and   #%00000001     ; Masquer le bit 0 du registre d'état. 
                                    ; 1 = Occupé, 0 = Libre.
                                    ; Zf=0  , Zf=1,  
                                    ; BNE si occupé, BEQ si libre.
               eor   #%00000001     ; Logique inversée : BEQ si occupé, 
                                    ;                    BNE si libre.  
               pla
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Attend pendant que le 1541 Ultimate II+ est occupé.
;------------------------------------------------------------------------------
uiifbusywait   .block
               php
wait           jsr   uiifisbusy
               beq   wait           ; En attente de la disparition de « Busy ».
               plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Vérifiez si le 1541 Ultimate II+ a envoyé un accusé de réception de données.
; Z=1 si Data Acc vaut 1 
; Z=0 si Data Acc vaut 0.
;------------------------------------------------------------------------------
uiifisdataacc  .block
               pha
               lda   uiidatastat
               and   #%00000010     ; Masquer le bit 1 du registre d'état de 
                                    ; ... la commande.
                                    ; 1=Dacc, 0=/Dacc.
                                    ; Zf=0  , Zf=1,  BNE si Dacc, BEQ si /Dacc.
               eor   #%00000010     ; Logique inversée : BEQ si Dacc,  
                                    ;                    BNE si /Dacc.     
               pla
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Attendre l'apparition du témoin Acc.
;------------------------------------------------------------------------------
uiifdaccwait   .block
               php
wait           jsr   uiifisdataacc
               bne   wait           ; En attente de l'apparition de Dacc.
               plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Renvoie le drapeau Carry (retenue) indiquant une condition d'abandon (bit 2) 
; sur le 1541 Ultimate II+.
; Z=1 si une annulation est en attente, 
; Z=0 si aucune annulation n’est en attente.
;------------------------------------------------------------------------------
uiifisabortp   .block
               pha                  ; Bit 2
               lda   uiicmdstat
               and   #%00000100     ; Masquer le bit 2 du registre d'état de la
                                    ; ... commande.
                                    ;        1 = abandon en attente, 
                                    ;        0 = /abandon en attente.
                                    ;  Zf=0, Zf=1, 
                                    ;        BNE si abandon est en attente
                                    ;        BEQ si aucun abandon.
               eor   #%00000100     ; Logique inv. 
                                    ;        BEQ si abandon est en attente
                                    ;        BNE si aucun abandon.
               pla
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Attendre l'abandon d'un processus.
;------------------------------------------------------------------------------
uiifabortpwait .block
               php
wait           jsr   uiifisabortp
               bne   wait           ; En attendant que Dacc apparaisse.
               plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Renvoie un indicateur (flag) correspondant à la condition d'erreur (bit 3) 
; du 1541 Ultimate II+.
; Z=1 en cas d’erreur, Z=0 en l’absence d’erreur
;------------------------------------------------------------------------------
uiifiscerror   .block
               pha                  ; Bit 3
               lda   uiicmdstat
               and   #%00001000     ; Masquer le bit 3 du registre d'état de 
                                    ; ... la commande.
                                    ; 1=ERREUR, 0=/ERRRUR
                                    ; Zf=0, Zf=1,     BNE si ERREUR
                                    ;                 BEQ si pas d'ERREUR
               eor   #%00001000     ; Logique inv.    BEQ si ERREUR   
                                    ;                 BNE si pas d'ERREUR
               pla 
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Renvoie l'état de la commande du 1541 Ultimate II+ dans les bits 1 et 0 du 
; registre A :
;    %00000000 >>>> %00000000, 0 = En attente.
;    %0001xxxx >>>> %00000001, 1 = Commande occupé.
;    %0010xxxx >>>> %00000010, 2 = Dernière donnée.
;    %0011xxxx >>>> %00000011, 3 = Encore des données.
;------------------------------------------------------------------------------
uiifgetcmdstat .block
               php                  ; Bits 5,4
               lda   uiicmdstat
               lsr                  ; Décaler les bits de 4 positions à droite. 
               lsr                  ; Les bits 5 et 4 se trouvent désormais  
               lsr                  ; ... aux emplacements des bits 1 et 0.
               lsr
               and   #%00000011     ; On masque les bits 2 à 7.
               plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Attend que le 1541 Ultimate II+ soit en mode inactif.
;------------------------------------------------------------------------------
uiifisrdataavail
               .block
               pha
               jsr   uiifgetcmdstat
               and   #%00000010     ; Masquer le bit 3 du registre d'état de 
                                    ; ... la commande.
                                    ; 11=ERREUR, %0X ou %X0 : aucune donnée.
                                    ; Zf=0, Zf=1,     BNE si ERREUR
                                    ;                 BEQ si pas d'ERREUR
               eor   #%00000010     ; Logique inv.    BEQ si ERREUR   
                                    ;                 BNE si pas d'ERREUR
               pla
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Renvoie un indicateur (flag) nul représentant l'état (bit 6) des données du 
; 1541 Ultimate II+.
;------------------------------------------------------------------------------
uiifisstatdata .block
               pha                  ; Bit 6
               lda   uiicmdstat
               and   #%01000000     ; Masquer le bit 6 du registre d'état de la 
                                    ; ... commande. 
                                    ; 1 = données statistiques disponibles, 
                                    ; 0 = aucune donnée statistique disponible.
                                    ; Zf=0, Zf=1,  
                                    ; BNE, si données statistiques disponibles.
                                    ; BEQ, si aucune donnée statistique.
               eor   #%01000000     ; Logique inversée. 
                                    ; BEQ, si données statistiques disponibles.
                                    ; BNE, si aucune donnée statistique.
               pla 
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Retourne Zéro représentant les données de réponse du 1541 Ultimate II+ 
; (bit 7).
;------------------------------------------------------------------------------
uiifisrespdata .block
               pha                  ; Bit 7
               lda   uiicmdstat
               and   #%10000000     ; Masquer le bit 7 du registre d'état de la 
                                    ; ... commande.
                                    ; 1 = données statistiques disponibles, 
                                    ; 0 = aucune donnée statistique disponible.
                                    ; Zf=0, Zf=1,  
                                    ; BNE, si données statistiques disponibles.
                                    ; BEQ, si aucune donnée statistique.
               eor   #%10000000     ; Logique inversée. 
                                    ; BEQ, si données statistiques disponibles.
                                    ; BNE, si aucune donnée statistique.
               pla 
               rts                  ; Môman, c'est fini.
               .bend

;*******************************************************************************
;        G E S T I O N   D U   R E G I S T R E   D E   C O N T R Ô L E.
;*******************************************************************************

;------------------------------------------------------------------------------
; Envoie une commande « push » au registre de contrôle du 1541 Ultimate II+.
;------------------------------------------------------------------------------
uiifsendpushcmd   
               .block
               php
               pha
               lda   #%00000001
               sta   uiictrlreg  
               pla
               plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Envoie une commande « data acc » au registre de contrôle du 
; 1541 Ultimate II+.
;------------------------------------------------------------------------------
uiifsenddataacc   
               .block
               php
               pha
               lda   #%00000010
               sta   uiictrlreg  
               pla
               plp
               rts                  ; Môman, c'est fini.
               .bend
         
;------------------------------------------------------------------------------
; Envoie une commande d'abandon au registre de contrôle du 1541 Ultimate II+.
;------------------------------------------------------------------------------
uiifsendabort  .block
               php
               pha
               lda   #%00000100
               sta   uiictrlreg  
               pla
               plp
               rts                  ; Môman, c'est fini.
               .bend
         
;------------------------------------------------------------------------------
; Attend que le 1541 Ultimate II+ soit en mode inactif.
;------------------------------------------------------------------------------
uiifwaitidle   .block
               php
notyet         jsr   uiifgetcmdstat
               cmp   #$00
               bne   notyet
               plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Attend que le 1541 Ultimate II+ soit en mode inactif.
;------------------------------------------------------------------------------
uiifismoredata .block
               pha
               jsr   uiifgetcmdstat
               and   #%00000010
               eor   #%00000010
               pla
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Écrit un octet dans le registre de commande (cmd) lorsque le 
; 1541 Ultimate II+ n'est pas occupé.
;------------------------------------------------------------------------------
uiifputcmdbyte .block
               jsr   uiifbusywait
               sta   uiicmddata
               rts                  ; Môman, c'est fini.
               .bend
;------------------------------------------------------------------------------
; Écrit une commande terminée par un octet nul dans le tampon de commandes du
; 1541 Ultimate II+, désigné par $YYXX.
;------------------------------------------------------------------------------
uiifsndcmd     .block
               jsr   push
               stx   zpage1
               sty   zpage1+1
               ldy   #$00
next           lda   (zpage1),y
               beq   finish
               jsr   uiifputcmdbyte
               iny
               jmp   next
finish         lda   #$01
               sta   uiictrlreg
               jsr   pop
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Lit une données si elle est disponnible.
;------------------------------------------------------------------------------
uiifreadrxdata .block
               php
               jsr   uiifbusywait
               jsr   uiifisrdataavail
               beq   nodata
               lda   uiirxdata   
               jmp   outdata
nodata         lda   #$00
outdata        plp
               rts                  ; Môman, c'est fini.
               .bend

;------------------------------------------------------------------------------
; Lit une donnée de status si celle-ci est disponnible.
;------------------------------------------------------------------------------
uiifreadsdata  .block
               php
               jsr   uiifbusywait
               jsr   uiifisstatdata
               beq   nodata
               lda   uiidatastat 
               jmp   outdata
nodata         lda   #$00
outdata        plp
               rts                  ; Môman, c'est fini.
               .bend

