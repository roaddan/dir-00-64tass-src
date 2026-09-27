;--------------------------------------
; Scripteur ......: Daniel Lafrance
; Nom du fichier .: l-disk.asm
; derniere m.à j. : 20251229
; Version ........: 0.1.1
;--------------------------------------
; Description : 
; Affiche la derniere erreur de disque.
;--------------------------------------
;======================================
;    mem2fileusage 
;       #mpushr
;       lda  #<fname
;       sta  dfnptr
;       lda  #<fname
;       sta  dfnptr+1
;       lda  #12
;       sta  dfnlen
;       lda  device
;       sta  dlfsno
;       lda  #<datastart
;       sta  ddatas
;       lda  #>datastart
;       sta  ddatas+1
;       lda  #<dataend
;       sta  ddatae
;       lda  #>dataend
;       sta  ddatae+1
;       jsr  memtofile
;       #mpopr
;       rts     
;======================================
;--------------------------------------
; Affiche erreur disque a l'ecran
;--------------------------------------
diskerror      
     .block
     #mpushr
     lda  ddev ;Device 8
     sta  $ba  ;
     jsr  $ffb4;talk 
     lda  #$6f
     sta  $b9   
     jsr  $ff96;tksa
next jsr  $ffa5;acptr
     jsr  $ffd2;chrout
     cmp  #$0d ;Est-ce un CR ?
     bne  next ;Non, au prochain
     jsr  $ffab;untlk
     #mpopr
     rts
     .bend
;--------------------------------------
; Display disk directory on screen.
;--------------------------------------
diskdir     
     .block
     #mpushr
     lda  #$24 ;nfichier = "$"
     sta  $fb  ;zp1 msb
     lda  #$fb ;Set nom-fichier actuel
     sta  $bb  ;mab nfichier actuel.
     lda  #$00 ;vers zp1
     sta  $bc  ;lsb nfichier actuel.
     lda  #$01 ;Indique -
     sta  $b7  ;- longueur de nfichier
     lda  ddev ;Indique 8 as comme - 
     sta  $ba  ;- periph serie actuel
     lda  #$60 ;Peuple $60 a l'adresse-
     sta  $b9  ;- secondaire.
     jsr  $f3d5;sfopen ouvert. fichier
     lda  $ba  ;Cmd dev $ba %10111010
     jsr  $ffb4;talk.
     lda  $b9  ;Cmd sec. adr. ($60) ...
     jsr  $ff96;tksa ... to talk.
     lda  #$00 ;Met $00 dans ...
     sta  $90  ;... kernal status word.
; Bit 0 : Time out (Write).
; Bit 1 : Time out (Read).
; Bit 6 : EOI (End of Identify).
; Bit 7 : Device not present.
     ldy  #$03 ;pour lire 3 Byt, -
loop1
     sty  $fb  ;-mettre $3 dans zp1 Msb
     jsr  $ffa5;acptr Recoit un byte.
     sta  $fc  ;Met octet dans zp1 lsb
     ldy  $90  ;Lit kernal status word.
     bne  exit ;Si erreur, EXIT.
     jsr  $ffa5;acptr
     ldy  $90  ;Lit compteur d'octet.
     bne  exit
     ldy  $fb
     dey
     bne  loop1;si pas dernier, loop
     ldx  $fc  ;Chrg Octet recu dans x.
     jsr  $bdcd;bputint print file size    
     lda  #$20 ;Chrg Espace et ...
     jsr  $ffd2;chrout ... l'affiche.
loop3     
     jsr  $ffa5;acptr Recoit un byte.
     ldx  $90  ;Chrg kernal status word
     bne  exit ;Si erreur, EXIT.
     tax       ;tfr a dans x
     beq  loop2;Byte est =0 loop1
     jsr  $ffd2;chrout,  >0 l'affiche. 
     jmp  loop3;Chrg un autre octets
loop2     
     lda  #$0d ;Chrg CR dans a ...
     jsr  $ffd2;chrout ... l'affiche.
     ldy  #$02 ;Met 2 dans y.
     bne  loop1;-a la prochaine entree.
exit      
     jsr  $f642;sfclose ... close file.
     #mpopr
     rts
     .bend
;--------------------------------------
; Affiche le repertoire du disque ...
; ... suivi du status du disque
;--------------------------------------
directory     
     .block
     jsr  diskdir
     jsr  diskerror
     rts
     .bend
;--------------------------------------
; Save memory content to file.
;--------------------------------------
memtofile      
     .block
     jsr  dputsavemesg
     #mpushr
     lda  dfnlen
     ldx  dfnptr    ;Chrg fn addr. lsb 
     ldy  dfnptr+1  ;Chrg fn addr. msb
     jsr  $ffbd     ;setnam
     lda  dlfsno
     ldx  ddev      ;Periph. specifie
skip      
     ldy  #$00
     jsr  $ffba     ;setlfs
     lda  ddatas    ;ddatas lsb->stal
     sta  stal
     lda  ddatas+1  ;ddatas msb->stal+1
     sta  stal+1
     ldx  ddatae    ;Met ddatae lsb->x
     ldy  ddatae+1  ;Met ddatae msb->y
     lda  #stal     ;Adr debut->$c1/$c2
     jsr  $ffd8     ;save
     bcc  noerror   ;Si C=1, erreur
noerror     
     #mpopr
     rts 
     .bend
;--------------------------------------
; Load file to memory.
;--------------------------------------
filetomem      
     .block
     #mpushr
     jsr dputsloadmesg 
     lda dfnlen  ;Chrg nfichier len.
     ldx dfnptr  ;Pointe $yyxx sur ptr-
     ldy dfnptr+1;- nfichier
     jsr $ffbd   ;setnam
     lda dlfsno  ;Chrg lfn dans a
     ldx ddev    ;Periph #8
     ldy #$01    ;$00:adresse<-yyxx
                 ;$01:adresse<-fichier
     jsr $ffba   ;setlfs
     lda #$00    ;$00:Chrg en memoire
                 ;$01:Verifier   
     jsr $ffd5   ;load
     bcc noerror ;C=1, Erreur
     jsr dskerror       
noerror     
     #mpopr
     rts
     .bend
;--------------------------------------
; Error messages management.  * TODO *
;--------------------------------------
dskerror     
     .block
     #mpushr
     ; acc. contient code d'erreur
     ; la plus probable:
; a = $01 (file not open)
isit01      
     cmp  #$01
     bne  isit02
     ldx  #<dmsge1      
     ldy  #>dmsge1
     jmp  printerror 
; a = $02 (write error)
isit02      
     cmp  #$02
     bne  isit05
     ldx  #<dmsge2      
     ldy  #>dmsge2
     jmp  printerror 
; a = $05 (device not present)
isit05      
     cmp  #$05
     bne  isit04
     ldx  #<dmsge5      
     ldy  #>dmsge5
     jmp  printerror 
; a = $04 (file not found)
isit04      
     cmp  #$04
     bne  isit1d
     ldx  #<dmsge4      
     ldy  #>dmsge4
     jmp  printerror      
; a = $1d (load error)
isit1d      
     cmp  #$1d
     bne  isit00
     ldx  #<dmsge1d      
     ldy  #>dmsge1d
     jmp  printerror      
; a = $00 (break, run/stop has been
;         pressed during loading)
isit00      
     cmp  #$00
     bne  noerror
     ldx  #<dmsge0      
     ldy  #>dmsge0
     jmp  printerror      
; ... error handling ...
printerror     
     jsr  putsyx
noerror     
     #mpopr
     rts
     .bend
;--------------------------------------
dputsavemesg    
     .block
     #mpushr
     ldx  #<dmsg0      
     ldy  #>dmsg0
     jmp  putmsg
     .bend

dputsloadmesg    
     .block
     #mpushr
     ldx  #<dmsgc      
     ldy  #>dmsgc
     jmp  putmsg
     .bend
putmsg 
     .block
     jsr  putsyx    
     ldx  dfnptr      
     ldy  dfnptr+1   
     jsr  putsyx
     lda  #33
     jsr  $ffd2
     lda  dlfsno
     jsr  close    
     #mpopr
     rts    
     .bend      
;--------------------------------------
; Miscilinaous file message.
;--------------------------------------
dmsg0   .byte $0d,141 
     .null "sauvegarde de "
dmsgc   .byte $0d,141 
     .null "chargement de "
dmsg1   .byte $0d,141
     .null "reussi" 
dmsge1  .byte $0d,141
     .null "fichier non ouvert"
dmsge2  .byte $0d,17
     .null "erreur d'ecriture"
dmsge5  .byte $0d,17
     .null "lecteur absent"
dmsge4  .byte $0d,17
     .null "fichier introuvable"
dmsge1d .byte $0d,17
     .null "erreur de chargement"
dmsge0  .byte $0d,17
     .null "break error"
