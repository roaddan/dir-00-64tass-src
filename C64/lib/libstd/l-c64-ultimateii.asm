;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: l-c64-ultimateii.asm
; Type fichier....: Constantes/code/variables/macros
; Creation........: 20161117 
; Version.........: 0.0.1
; Révisions.......: 20161117 Francisation des commentaires,
;------------------------------------------------------------------------------
; Fichier d'inclusion DOS pour 1541 Ultimate II+ contenant des constantes et 
; des fonctions :
;-------------------------------------------------------------------------------
               .include    "m-c64-ultimateii.asm"
;-------------------------------------------------------------------------------
; 1541 Ultimate II+ 
;registre      =     adresse
;-------------------------------------------------------------------------------
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
;-------------------------------------------------------------------------------
; Structure des commandes DOS du 1541 Ultimate II+ :  $01 CMD [XX] <FILENAME> 
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; CMD list
;-------------------------------------------------------------------------------
uii_identify   =     $01   ; $01 $01 -> Lire la chaîne d’identifiant comme:
                           ;                        "ULTIMATE-II DOS V1.0"
;-------------------------------------------------------------------------------
; Commandes d'accès aux fichiers.
;-------------------------------------------------------------------------------
uii_file_open  =     $02   ; Ouvrir le fichier pour...
;-------------------------------------------------------------------------------
; File access sub-command.
;-------------------------------------------------------------------------------
uii_fa_read    =     $01   ; $01 $02 $01 <nomfichier> -> ... lecture.
uii_fa_write   =     $02   ; $01 $02 $02 <nomfichier> -> ... ecriture. 
uii_fa_new     =     $04   ; $01 $02 $04 <nomfichier> -> ... creation/ecriture.
uii_fa_ovwri   =     $08   ; $01 $02 $08 <nomfichier> -> ... remplacement.
uii_file_close =     $03   ; $01 $03 -> ferme le fichier ouvert.
uii_read_data  =     $04   ; $01 $04 [len_lo] [len_hi]
uii_writ_data  =     $05   ; $01 $05 [dummy] [dummy] [data...]
uii_file_seek  =     $06   ; $01 $06 [posl] [posml] [posmh] [posh].
;-------------------------------------------------------------------------------
uii_file_info  =     $07   ; $01 $07 -> renvoie des informations sur le ...
                           ;            ... fichier actuellement ouvert.
uii_file_stat  =     $08   ; $01 $08 <nomfichier> -> Renvoie des informations 
                           ;                         ... sur le fichier.
;-------------------------------------------------------------------------------
; Structure des informations/statistiques de fichier.
;-------------------------------------------------------------------------------
; dword  size -> grandeur du fichier
; word   date -> date de la dernière modification.
; word   time -> heure de la dernière modification.
; char   extension[3]
; byte   attributs
; char   nomfichier[] 
;-------------------------------------------------------------------------------
uii_file_del   =     $09   ; $01 $09 <nomfichier> -> Supprimer/effacer fichier.
uii_file_ren   =     $0a   ; $01 $0a <nomfichier> $00 <nouveaunom> -> renommer.
uii_file_copy  =     $0b   ; $01 $0b <source> $00 <destination> -> copier.
;-------------------------------------------------------------------------------
; Commandes d'accès aux répertoires.
;-------------------------------------------------------------------------------
uii_dir_change =     $11   ; $01 $11 <nom du répertoire> Change de répertoire.
uii_dir_pwd    =     $12   ; $01 $12 Retourne le nom du répertoire actuel.
uii_dir_open   =     $13   ; $01 $13 Ouvre un répertoire.
uii_dir_read   =     $14   ; $01 $14 Lit le contenu du répertoire.
;-------------------------------------------------------------------------------
; Structure de la lecture d'un répertoire :
;  attr <nomfichier> attr <nomfichier> ... 
;              byte  attr   
;              char  nomfichier []
; 
; Description de l’attribut.
;  ; Bit 7-6 ; Bit 5   ; Bit 4 ; Bit 3  ; Bit 2  ; Bit 1  ; Bit 0  ;
;  ; Unused  ; Archive ; Dir   ; Volume ; System ; Hidden ; Readonly ; 
;-------------------------------------------------------------------------------
uii_dir_cp_ui  =     $15   ; $01 $15 -> Définit le chemin actuel de l'interface
                           ;            ... utilisateur comme étant le chemin 
                           ;            ... actuel de l'API.
uii_dir_mkdir  =     $16   ; $01 $16 <nomrep> 
                           ;         -> Créer un répertoire dans le 
                           ;            ... répertoire courant.
uii_dir_home   =     $17   ; $01 $17 -> Définit le chemin d'accueil de 
                           ;            ... l'interface utilisateur comme étant
                           ;            ...  le chemin actuel de l'API.
;-------------------------------------------------------------------------------
; Commande d'accès REU.
;-------------------------------------------------------------------------------
uii_reu_load   =     $21   
;     $01 $21 [addL] [addML] [addMH] [addH] [lenL] [lenML] [lenMH] [lenH] 
uii_reu_save   =     $22   
;     $01 $22 [addL] [addML] [addMH] [addH] [lenL] [lenML] [lenMH] [lenH] 
;-------------------------------------------------------------------------------
; Commande de lecteur de disque virtuel.
;-------------------------------------------------------------------------------
uii_dsk_mount  =     $23   ; $01 $23 <id> <nomfichier>
uii_dsk_umount =     $24   ; $01 $24 <id>
uii_dsk_swap   =     $25   ; $01 $25 <id>
;-------------------------------------------------------------------------------
; Commande RTC
;-------------------------------------------------------------------------------
uii_time_get   =     $26   ; $01 $26 [id] -> Renvoie l'heure/la date actuelle 
                           ;                 ... du RTC.
;                          ; Si id = 1, le format renvoyé est :
                           ;        « www yyyy/mm/dd hh:mm:ss ».
uii_time_set   =     $27   ; $01 $27 <Y> <M> <D> <H> <M> <S>
;                          ; Y = année en cours - 1900
uii_dos_echo   =     $f0   ; $01 $f0 
;===============================================
; 541 Ultimate II+ Commandlist definition
;===============================================
uiicmdgetid    .byte $01,$01,$00
uiicmdgettime  .byte $01,$26,$00

;-------------------------------------------------------------------------------
; Tampon de communication R/X avec pointeur et status.
;  - Si start=end et Bit 0 de flag = 0 le buffer est vide
;  - Si start=end et Bit 0 de flag = 0 le buffer est plein
;    - Si le bit 7 de rxflag = 1 la routine de réception doit être appelée quand 
;      le buffer sera vidé.  
;-------------------------------------------------------------------------------
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

;-------------------------------------------------------------------------------
; Return Zero flag set if 1541 Ultimate II+ busy.
; Z=0 if Busy flag is on, Z=1 If busy is off.
;-------------------------------------------------------------------------------
uiifisbusy  .block
         pha
         lda   uiicmdstat  
         and   #%00000001  ; Mask bit 0 of the command status register. 
                     ; 1=Busy, 0=Free.
                     ; Zf=0  , Zf=1,  BNE if Busy, BEQ if free.
         eor   #%00000001  ; Reverse Logic  BEQ if Busy, BNE if free.   
         pla
         rts
         .bend

;-------------------------------------------------------------------------------
; Wait while 1541 Ultimate II+ is busy.
;-------------------------------------------------------------------------------
uiifbusywait   .block
         php
wait        jsr   uiifisbusy
         beq   wait        ; Waiting for Busy to disappear.
         plp
         rts
         .bend

;-------------------------------------------------------------------------------
; Check if 1541 Ultimate II+ has send a data acc.
; Z=1 Data Acc is 1, z=0 if Data acc os 0
;-------------------------------------------------------------------------------
uiifisdataacc  .block
         pha
         lda   uiidatastat
         and   #%00000010  ; Mask bit 1 of the command status register. 
                     ; 1=Dacc, 0=/Dacc.
                     ; Zf=0  , Zf=1,  BNE if Dacc, BEQ if /Dacc.
         eor   #%00000010  ; Reverse Logic  BEQ if Dacc, BNE if /Dacc.     
out         pla
         rts
         .bend

;-------------------------------------------------------------------------------
; Wait for Acc flag to appear.
;-------------------------------------------------------------------------------
uiifdaccwait   .block
         php
wait        jsr   uiifisdataacc
         bne   wait        ; Waiting for Dacc to appears.
         plp
         rts
         .bend

;-------------------------------------------------------------------------------
; Return Carry flag representing 1541 Ultimate II+ abort (bit 2) condition.
; Z=1 if abort pending, Z=0 if no abort pending.
;-------------------------------------------------------------------------------
uiifisabortp   .block
         pha ; Bit 2
         lda   uiicmdstat
         and   #%00000100  ; Mask bit 2 of the command status register. 
                     ; 1=Abort pending, 0=/Abort pending.
                     ; Zf=0, Zf=1,  BNE if Abort pending
                     ;              BEQ if No Abort pending.
         eor   #%00000100  ; Rev. Logic   BEQ if Abort pending 
                     ;              BNE if No Abort pending.
         pla
         rts
         .bend

uiifabortpwait .block
         php
wait        jsr   uiifisabortp
         bne   wait        ; Waiting for Dacc to appears.
         plp
         rts
         .bend

;-------------------------------------------------------------------------------
; Return Zero flag representing 1541 Ultimate II+ ERROR (bit 3) condition.
; Z=1 if error, Z=0 if no error
;-------------------------------------------------------------------------------
uiifiscerror   .block
         pha ; Bit 3
         lda   uiicmdstat
         and   #%00001000  ; Mask bit 3 of the command status register. 
                     ; 1=ERROR, 0=/ERROR
                     ; Zf=0, Zf=1,  BNE if ERROR
                     ;              BEQ if No ERROR
         eor   #%00001000  ; Rev. Logic   BEQ if ERROR   
                     ;              BNE if No ERROR
         pla 
         rts
         .bend

;-------------------------------------------------------------------------------
; Returns 1541 Ultimate II+ Command status in A bits 1,0:
;    %00000000, 0 = Idle
;  %00000001, 1 = Command Busy
;    %00000010, 2 = Data Last
;    %00000011, 3 = Data More
;-------------------------------------------------------------------------------
uiifgetcmdstat .block
         php   ; Bits 5,4
         lda   uiicmdstat
         lsr            ; Shifting bits 4 position to the right. 
         lsr            ; Bits 5 and 4 are now in bits 1 and 0 
         lsr
         lsr
         and   #%00000011
         plp
         rts
         .bend

;-------------------------------------------------------------------------------
; Wait for 1541 Ultimate II+ to be in idle mode.
;-------------------------------------------------------------------------------
uiifisrdataavail
         .block
         pha
notyet      jsr   uiifgetcmdstat
         and   #%00000010  ; Mask bit 3 of the command status register. 
                     ; 11=ERROR, %0X or %X0 no more data.
                     ; Zf=0, Zf=1,  BNE if ERROR
                     ;              BEQ if No ERROR
         eor   #%00000010  ; Rev. Logic   BEQ if ERROR   
                     ;              BNE if No ERROR
         pla
         rts
         .bend

;-------------------------------------------------------------------------------
; Return Zero flag representing 1541 Ultimate II+ stat data (bit 6) condition.
;-------------------------------------------------------------------------------
uiifisstatdata .block
         pha ; Bit 6
         lda   uiicmdstat
         and   #%01000000  ; Mask bit 6 of the command status register. 
                     ; 1=stat data avail. , 0=No stat data avail.
                     ; Zf=0, Zf=1,  BNE if stat data avail.
                     ;              BEQ if No stat data avail.
         eor   #%01000000  ; Rev. Logic   BEQ if stat data avail. 
                     ;              BNE if No stat data avail.
         pla 
         rts

         .bend

;-------------------------------------------------------------------------------
; Return Zero flag representing 1541 Ultimate II+ Response data (bit 7) cond.
;-------------------------------------------------------------------------------
uiifisrespdata .block
         pha ; Bit 7
         lda   uiicmdstat
         and   #%10000000  ; Mask bit 6 of the command status register. 
                     ; 1=stat data avail. , 0=No stat data avail.
                     ; Zf=0, Zf=1,  BNE if stat data avail.
                     ;              BEQ if No stat data avail.
         eor   #%10000000  ; Rev. Logic   BEQ if stat data avail. 
                     ;              BNE if No stat data avail.
         pla 
         rts

         .bend

;*******************************************************************************
;          M A N A G I N G   T H E   C O N T R O L   R E G I S T E R.
;*******************************************************************************

;-------------------------------------------------------------------------------
; Send a push command to the 1541 Ultimate II+ Control Register.
;-------------------------------------------------------------------------------
uiifsendpushcmd   
         .block
         php
         pha
         lda   #%00000001
         sta   uiictrlreg  
         pla
         plp
         rts
         .bend

;-------------------------------------------------------------------------------
; Send a data acc command to the 1541 Ultimate II+ Control Register.
;-------------------------------------------------------------------------------
uiifsenddataacc   
         .block
         php
         pha
         lda   #%00000010
         sta   uiictrlreg  
         pla
         plp
         rts
         .bend
         
;-------------------------------------------------------------------------------
; Send a abort command to the 1541 Ultimate II+ Control Register.
;-------------------------------------------------------------------------------
uiifsendabort  
         .block
         php
         pha
         lda   #%00000100
         sta   uiictrlreg  
         pla
         plp
         rts
         .bend
         
;-------------------------------------------------------------------------------
; Wait for 1541 Ultimate II+ to be in idle mode.
;-------------------------------------------------------------------------------
uiifwaitidle   .block
         php
notyet      jsr   uiifgetcmdstat
         cmp   #$00
         bne   notyet
         plp
         rts
         .bend

;-------------------------------------------------------------------------------
; Wait for 1541 Ultimate II+ to be in idle mode.
;-------------------------------------------------------------------------------
uiifismoredata .block
         pha
         jsr   uiifgetcmdstat
         and   #%00000010
         eor   #%00000010
         pla
         rts
         .bend

;-------------------------------------------------------------------------------
; Write a byte to the cmd register wher the 1541 Ultimate II+ is not busy.
;-------------------------------------------------------------------------------
uiifputcmdbyte .block
         jsr   uiifbusywait
         sta   uiicmddata
         rts
         .bend
;-------------------------------------------------------------------------------
; Write a zero ended command to the the 1541 Ultimate II+ command buffer.
; pointex by $YYXX.
;-------------------------------------------------------------------------------
uiifsndcmd  .block
         jsr   push
         stx   zpage1
         sty   zpage1+1
         ldy   #$00
next        lda   (zpage1),y
         beq   finish
         jsr   uiifputcmdbyte
         iny
         jmp   next
finish      lda   #$01
         sta   uiictrlreg
         jsr   pop
         rts
         .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
uiifreadrxdata .block
         php
         jsr   uiifbusywait
         jsr   uiifisrdataavail
         beq   nodata
         lda   uiirxdata   
         jmp   outdata
nodata      lda   #$00
outdata     plp
         rts
         .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
uiifreadsdata  .block
         php
         jsr   uiifbusywait
         jsr   uiifisstatdata
         beq   nodata
         lda   uiidatastat 
         jmp   outdata
nodata      lda   #$00
outdata     plp
         rts
         .bend

