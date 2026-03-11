;---------------------------------------
popscr    .block
          jsr  pushall

          lda  #$0e
          jsr  chrout
          lda  #$08
          jsr  chrout

          jsr  clrkbbuf
          lda  kcol
          pha
          jsr  cursave
          jsr  scrnsave
          #outcar 147
          ldx  #6
          lda  #102
          jsr  fillscreen
          jsr  drawbox
          ldy  #$00
morestr   jsr  pushregs
          ldx  #$02
          tya  
          clc
          lsr
          tay
          iny
          iny
          jsr  gotoxy
          #print hsih
          jsr  popregs
          lda  ($fb),y
          tax
          iny
          lda  ($fb),y
          iny
          cmp  #$ff
          beq  over
          jsr  putsax
          #print hsif
          jmp  morestr
over      jsr  anykey
          jsr  scrnrest
          jsr  currest
          pla
          sta  kcol
 
          lda  #142
          jsr  chrout
          lda  #$09
          jsr  chrout

         jsr  popall
          rts
          .bend

prnvcttab .block
          jsr  pushall
          stx  $fb
          sty  $fc
          jsr  popscr
          jsr  popall
          rts
          .bend

showhelp  .block
          jsr  pushregs
          ldy  #>hs1vect
          ldx  #<hs1vect
          jsr  prnvcttab
          ldy  #>hs2vect
          ldx  #<hs2vect
          jsr  prnvcttab
          ldy  #>hs3vect
          ldx  #<hs3vect
          jsr  prnvcttab
          ldy  #>hs4vect
          ldx  #<hs4vect
          jsr  prnvcttab
          jmp  popcred
          .bend

credits   jsr  pushregs
popcred   ldy  #>gs1vect
          ldx  #<gs1vect
          jsr  prnvcttab
          jsr  popregs
          rts


drawbox   .block
          jsr  pushall
          #prnloc 1, 1,  hstitle
          ldy  #$02
another   ldx  #1
          jsr  gotoxy
          tya
          ldx  #<hsempty
          ldy  #>hsempty
          jsr  putsyx
          tay
          iny
          cpy  #21
          bne  another
          #prnloc 1, 21, hsfoot
          jsr popall
          rts
          .bend


prnloc    .macro x, y, sptr
          ldx  #\x
          ldy  #\y
          jsr  gotoxy
          ldx  #<\sptr
          ldy  #>\sptr
          stx $fb    ;$yyxx dans
          sty $fb+1  ; zp1
          jsr puts
          .endm
;---------------------------------------
; from l-v20-push.asm
;---------------------------------------
pushall
         .block  ;s:pcl,pch
         php     ;s;rp,pcl,pch
         sta ra  ;sauve a
         pla     ;s:pcl,pch
         sta rp  ;sauve rp
         ;------------------------------
         ; adresse de retour presente
         pla     ;s:pch
         sta pc  ;sauve pcl
         pla     ;s:
         sta pc+1;sauve pch
         ;------------------------------
         lda $fb ;sauve fb
         pha     ;s:fb
         lda $fc ;sauve fc
         pha     ;s:fc,fb
         lda $fd ;sauve fd
         pha     ;s:fd,fc,fb
         lda $fe ;sauve fe
         pha     ;s:fe,fd,fc,fb
         ;------------------------------
         lda rp  ;sauve rp
         pha     ;s:rp,fe,fd,fc,fb
         lda ra  ;sauve ra
         pha     ;s:ra,rp,fe,fd,fc,fb
         txa     ;sauve rx
         pha     ;s:rx,ra,rp,fe-fb
         tya     ;sauve y
         pha     ;s:ry,rx,ra,rp,fe-fb
         ;------------------------------
         ; adresse de retour presente
         lda pc+1;replace l'adresse
         pha     ;s:pch,ry,rx,ra,...
         lda pc  ; de retour.
         pha     ;s:pcl,pch,ru,rx,ra,...
         ;------------------------------
         lda rp  ;place les flags
         pha     ; sur le stack.
         lda ra  ;recupere ra
         plp     ;recupere les flags.
         rts
         .bend
;---------------------------------------
popall
         .block  ;s:pcl,pch,ry,rx,...
         php     ;s:rp,pcl,pch,ry,rx,...
         sta ra
         pla     ;s:pcl,pch,ry,rx,...
         sta rp  ;s:pch,ry,rx,ra,rp,...
         ;------------------------------
         ; adresse de retour presente
         pla
         sta pc  ;sauve pcl
         pla     ;s:ry,rx,ra,rp,fe...fb
         sta pc+1;sauve pch
         ;------------------------------
         pla     ;s:rx,ra,rp,fe,fd,fc,fb
         tay     ;recupere ry
         pla     ;s:ra,rp,fe,fd,fc,fb
         tax     ;recupere rx
         pla     ;s:rp,fe,fd,fc,fb
         sta ra  ;recupere ra
         pla     ;s:fe,fd,fc,fb
         sta rp  ;recupere les flags.
         ;------------------------------
         pla     ;s:fd,fc,fb
         sta $fe ;reccupere fe
         pla     ;s:fc,fb
         sta $fd ;recupere fd
         pla     ;s:fb
         sta $fc ;recupere fc
         pla     ;s:
         sta $fb ;recupere fb
         ;------------------------------
         ; adresse de retour presente
         lda pc+1;replaace l'adresse de
         pha     ;s:pch
         lda pc  ;retour sur la pile
         pha     ;s:pcl,pch
         ;------------------------------
         lda rp  ;recupere les flags
         pha     ;s:rp,pcl,pch
         lda ra  ;recupere ra
         plp     ;s:pcl,pch
         rts
         .bend
;---------------------------------------
pushregs
         .block  ;s:pcl,pch
         php     ;s;rp,pcl,pch
         sta ra  ; -- sauve a
         pla     ;s:pcl,pch
         sta rp  ; -- sauve rp
         ;------------------------------
         ; adresse de retour presente
         pla     ;s:pch
         sta pc  ; -- sauve pcl
         pla     ;s:
         sta pc+1; -- sauve pch
         ;------------------------------
         lda rp  ; -- sauve rp
         pha     ;s:rp
         lda ra  ; -- sauve ra
         pha     ;s:ra,rp
         txa     ; -- tfr rx
         pha     ;s:rx,ra,rp
         tya     ; -- tfr ry
         pha     ;s:ry,rx,ra,rp
         ;------------------------------
         ; adresse de retour presente
         lda pc+1; -- replace l'adresse
         pha     ;s:pch,ry,rx,ra,rp
         lda pc  ; -- de retour.
         pha     ;s:pcl,pch,ru,rx,ra,rp
         ;------------------------------
         lda rp  ; -- place les flags
         pha     ;    sur le stack.
         lda ra  ; -- recupere ra
         plp     ; -- recupere flags.
         rts     ;s:pcl,pch,ru,rx,ra,rp
         .bend
;---------------------------------------
popregs
         .block
         php
         sta ra
         pla
         sta rp
         ;------------------------------
         ; adresse de retour presente
         pla     ;s:pch,ry,rx,ra,rp
         sta pc  ; -- sauve pcl
         pla     ;s:ry,rx,ra,rp
         sta pc+1; -- sauve pch
         ;------------------------------
         pla     ;s:rx,ra,rp
         tay     ;recupere ry
         pla     ;s:ra,rp
         tax     ;recupere rx
         pla     ;s:rp
         sta ra  ;recupere ra
         pla     ;s:
         sta rp  ;recupere les flags.
         ;------------------------------
         ; adresse de retour presente
         lda pc+1;replace l'adresse de
         pha     ;s:pch
         lda pc  ;retour sur la pile
         pha     ;s:pcl,pch
         ;------------------------------
         lda rp  ;recupere les flags
         pha     ;s:rp,pcl,pch
         lda ra  ;recupere ra
         plp     ;s:pcl,pch
         rts
         .bend
;---------------------------------------

;--------------------------------------
; de fichier..: l-string.asm (seq)
;---------------------------------------

;--------------------------------------
; Affiche une chaine pointee par $FBFC
;--------------------------------------
puts      .block
          jsr pushall
          ldy #$00   ; y = offset
nextc     lda ($fb),y;lit un caractere
          beq out    ;si 0 on sort
          jsr chrout ;on l'affiche
          jsr inczp1 ;pointe le prochain
          jmp nextc  ; et l'affiche
out       jsr popall
          rts
          .bend
;--------------------------------------
; Affiche une chaine pointee par $yyxx
;--------------------------------------
putsyx    .block
          jsr pushall;sauve reg + zps
          stx $fb    ;$yyxx dans
          sty $fb+1  ; zp1
          jsr puts
          jsr popall ;recup reg + zps
          rts
          .bend

putsax    .block
          jsr  pushregs
          tay
          jsr  putsyx
          jsr  popregs
          rts
          .bend
;--------------------------------------
; $(yyxx) pointeur sur la chaine
; retourne A longueur de la chaine
strlen
        .block
        jsr pushall
        sty zp1+1
        stx zp1
        ldy #$00
        sty len
next    lda (zp1),y
        beq out
        inc len
        iny
        jmp next
out     jsr popall
        lda len
        rts
        .bend
;--------------------------------------
; Positionne C=1 ou Sauvegarde C=0 le
; curseur et la couleur par défaut.
; Entrée  : Carry = 0 pour sauvegarder,
; carry = 1 pour récupérer.
; Sortie  : Aucune.
;--------------------------------------
cursor    .block
          jsr  pushregs
          bcc  get    ;C=0 récupération.
          jsr  plot  ;récupère position
          sty  cx     ;curseur et sauve 
          stx  cy     ;dans vars locales.
          lda  kcol   ;Sauve couleur  
          sta  bcol   ; BASIC du texte.
          jmp  out    ;Fini on sort.
get       ldx  cy     ;C=1, charge x    
          ldy  cx     ; ligne, y col.
          jsr  plot  ;Position curseur.
          lda  bcol   ;replace couleur  
          sta  kcol ; basic sauvegardé.
out       jsr  popregs 
          rts
          .bend
;--------------------------------------
; Sauvegarde de la position du curseur.
; Entrée  : Aucune.
; Sortie  : Aucune.
; Voir cette fonction plus haut.
;--------------------------------------
curget
cursave   .block
          php
          sec
          jsr  cursor         
          plp
          rts
          .bend
;--------------------------------------
; Récupere de la position du curseur.
; Entrée  : Aucune.
; Sortie  : Aucune.
; Voir cette fonction plus haut.
;--------------------------------------
curput
currest   .block
          php
          clc
          jsr  cursor 
          plp
          rts
          .bend
;--------------------------------------
isprnable .block
          php
          cmp  #160
          bcs  yes
          cmp  133
          bcs  no          
          cmp  #32
          bcs  yes
no        plp
          clc
          rts
yes       plp
          sec
          rts
          .bend
;--------------------------------------

;--------------------------------------
; de fichier..: l-mem.asm
;--------------------------------------
;--------------------------------------
; Incrementation 16 bits de $fcfb
;--------------------------------------
inczp1
         .block
         php
         inc zp1
         bne repzp1
         inc zp1+1
repzp1   plp
         rts
         .bend
;--------------------------------------

;--------------------------------------
; fichier......: l-math.asm (seq)
; type fichier.: equates
; auteur.......: Daniel Lafrance
; version......: 0.0.2
; revision.....: 20151210
;--------------------------------------
;$(yyxx) = pointeur sur le mot
;acc     = valeur a ajouter.
;rep     = $yyxx
addatoyx 
        .block
        php
        pha
        sty reponse+1
        stx reponse
        clc
        adc reponse
        bcc norep
        inc reponse+1
norep   sta reponse
        ldy reponse+1
        ldx reponse
        pla
        plp
        rts
        .bend
;--------------------------------------

;---------------------------------------
; nom fichier..: l-conv.asm (seq)
; type fichier.: code
; auteur.......: daniel lafrance
; version......: 1.0.1
; revision.....: 20251117
;---------------------------------------
; routines d'affichage de chaine de
;  caractereponse utilisant les routines du
;  kernal du ãommodore 64.
;---------------------------------------
putyxhex
        .block
        jsr pushall
        tya
        pha
        jsr lsr4bits
        jsr nibtohex
        sta hexstr+0
        pla
        jsr nibtohex
        sta hexstr+1
        txa
        jsr atohex
        ldx #<hexstr+0
        ldy #>hexstr+0
        jsr putsyx
        jsr popall
        rts
        .bend
;---------------------------------------
putahex
        .block
        jsr pushregs
        jsr atohex
        ldx #<hexstr+2
        ldy #>hexstr+2
        jsr putsyx
        jsr popregs
        rts
        .bend
;---------------------------------------
atohex
        .block
        php
        pha
        pha
        jsr lsr4bits
        jsr nibtohex
        sta hexstr+2
        pla
        jsr nibtohex
        sta hexstr+3
        lda #$00
        sta hexstr+4
        pla
        plp
        rts
        .bend
;-----------------------------------------------------------------------------
; Affiche le contenu de abin à la position du curseur.
;-----------------------------------------------------------------------------
putabin   .block
          jsr     pushregs
          jsr     atobin
          ldx     #<binstr
          ldy     #>binstr
          jsr     putsyx
          jsr     popregs
          rts
          .bend
;-----------------------------------------------------------------------------
; Converti le contenu de A en chaine  binaire dans binstr. 
;-----------------------------------------------------------------------------
atobin    .block
          jsr  pushregs
          ldx  #8
          ldy  #0
          clc
nextbit   rol
          pha
          adc  #$00
          and  #$01
          jsr  nibtohex
          sta  binstr,y
          pla
          iny
          dex
          bne  nextbit
          lda  #0
          sta  binstr,y
          jsr  popregs
          rts
          .bend          
;---------------------------------------
lsr4bits
          .block
          php
          lsr a
          lsr a
          lsr a
          lsr a
          plp
          rts
          .bend
;---------------------------------------
nibtohexb
        .block
        php
        and #$0f
        sed
        clc
        adc #$90
        adc #$40
        cld
        plp
        rts
        .bend
;---------------------------------------
nibtohex
        .block
        php
        sty myy
        and #$0f
        tay
        lda hextbl,y
        ldy myy
        plp
        rts
hextbl  .byte $30,$31,$32,$33,$34
        .byte $35,$36,$37,$38,$39
        .byte $41,$42,$43,$44,$45
        .byte $46
myy     .byte $00      
        .bend

;---------------------------------------
;$(yyxx)= adreponsese du premier octet.
;Acc    = le nombre d'octets.
gbytestohex
        .block
        jsr pushall
        sty zp1+1
        stx zp1
        #outcar 32
        #outcar 5
        #outcar 36
        jsr putyxhex   ; prn adreponsese
        #outcar $20
        #outcar 159
        ldy #$00
        tax
another sty offset
        lda (zp1),y
        jsr putahex
        pha
        jsr petsciiaddr
        pla
petscii sta $0400
        pha
        lda #$0d
petcol  sta $d800        
        pla
        #outcar $20
        iny
        dex
        bne another
        ;#outcar 36
        ;jsr putyxhex
        jsr popall
        rts
;---------------------------------------
; Routine qui modifie le code precedent
;---------------------------------------
petsciiaddr
        jsr pushregs
;        #ldyxptr scrnlin 
        ;jsr putyxhex
        lda #31
        clc
        adc offset
        jsr addatoyx
        sty petscii+2
        stx petscii+1
        stx petcol+1
        tya
        and #%11111011 ;#%00000100
        ora #$d8
        sta petcol+2
        tay
        ;#outcar $0d
        ;jsr putyxhex
        jsr popregs
        rts
        .bend
;---------------------------------------
showra    .block
          jsr  pushregs
          ldy  kcol  
          #outcar snoir
          jsr  isprnable
          bcs  okprn
          pha
          #outcar srouge
          lda  #'.'
          jsr  chrout
          pla
          jmp  noprn
okprn     jsr  chrout
noprn     #outcar 32
          #outcar sbleu
          #outcar 36
          jsr putahex
          #outcar 32
          #outcar srouge
          #outcar 37
          jsr putabin
          #outcar 32
          #outcar smauve
          pha
          tax
          lda #$00
          jsr fiaxtf1
          pla
          sty kcol
          jsr popregs
          rts
          .bend
;--------------------------------------

;--------------------------------------
; de Fichier......: l-keyb.asm (seq)
;--------------------------------------
;--------------------------------------
; Vide le tampon du clavier
clrkbbuf
;--------------------------------------
          .block
          php
          pha
          lda #0
          sta 198
          jsr $ffe1
          pla
          plp
          rts
          .bend
;--------------------------------------
; attend qu'une touche du clavier soit 
; appuyee/relachee.
anykey
;--------------------------------------
          .block
          php         
          pha        
          jsr clrkbbuf
wait      lda 203    ;lit la matrice de 
          cmp #64    ; 64 = aucune clef
          beq wait   ; on en attend une.
          jsr kbfree ; Clavier relache.
          jsr clrkbbuf
          pla         
          plp
          rts
          .bend
;--------------------------------------
; attend que les touches du clavier 
; soient relachees.
kbfree
;--------------------------------------
        .block
        php 
        pha
wait    lda 203    ; lit la matrice 
        cmp #64    ; 64 = aucune clef
        bne wait   ; attend la relache
        pla
        plp
        rts
        .bend
;--------------------------------------
; retourne une clef appuyee dans acc.
getkey
;--------------------------------------
        .block
        php
        jsr $ffe1
try     jsr getin  ;tente de lire 
        cmp #0     ; 0 si aucune.
        beq try    ; on reessaye
        plp
        rts
        .bend
;--------------------------------------
; attend une cle en particulier donnee 
; dans acc..
waitkey
;--------------------------------------
        .block
        php  
        pha 
        sta clef   ;Sauve clef voulue          
        jsr clrkbbuf
wait    jsr getin  ;Sonde le clavier 
        cmp clef   ;Compare avec clef
        bne wait   ;Pas la bonne. 
        pla 
        plp
        rts
        .bend
;--------------------------------------
showkey 
        .block
        jsr pushregs
        sec
        jsr plot
        stx curx
        sty cury
        #locate 0,22
        jsr chrout
        jsr showra
        clc
        ldy cury
        ldx curx
        jsr plot
        jsr popregs
        rts
        .bend
;--------------------------------------

;--------------------------------------
; de fichier .: l-disk.asm
;--------------------------------------
; Description : 
; Affiche la derniere erreur de disque.
;--------------------------------------
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
;--------------------------------------
; Affiche erreur disque a l'ecran
;--------------------------------------
diskerror      
     .block
     jsr pushregs
     lda  ddev ;Device 8
     sta  $ba  ;
     jsr  talk 
     lda  #$6f
     sta  $b9   
     jsr  tksa
next jsr  acptr
     jsr  chrout
     cmp  #$0d ;Est-ce un CR ?
     bne  next ;Non, au prochain
     jsr  untlk
     jsr  popregs
     rts
     .bend
;--------------------------------------
; Display disk directory on screen.
;--------------------------------------
diskdir     
     .block
     jsr  pushall
     lda  #$24      ;nfichier = "$"
     sta  $fb       ;zp1 msb
     lda  #$fb      ;Set nom-fichier actuel
     sta  $bb       ;lsb nfichier actuel.
     lda  #$00      ;vers zp1
     sta  $bc       ;msb nfichier actuel.
     lda  #$01      ;Indique -
     sta  $b7       ;- longueur de nfichier
     lda  ddev      ;Indique 8 as comme - 
     sta  $ba       ;- periph serie actuel
     lda  #$60      ;Peuple $60 a l'adresse-
     sta  $b9       ;- secondaire.
     jsr  open      ;Ouverture de  fichier
     lda  $ba       ;Cmd dev $ba %10111010
     jsr  talk      ;talk.
     lda  $b9       ;Cmd sec. adr. ($60) ...
     jsr  tksa      ;tksa ... to talk.
     lda  #$00      ;Met $00 dans ...
     sta  $90       ;... kernal status word.
; Bit 0 : Time out (Write).
; Bit 1 : Time out (Read).
; Bit 6 : EOI (End of Identify).
; Bit 7 : Device not present.
     ldy  #$03 ;pour lire 3 Byt, -
loop1
     sty  $fb       ;-mettre $3 dans zp1 MSB
     jsr  acptr     ;acptr Recoit un byte.
     sta  $fc       ;Met octet dans zp1 LSB
     ldy  $90       ;Lit kernal status word.
     bne  exit      ;Si erreur, EXIT.
     jsr  acptr     ;Recoit un caractere provenant du port serie
     ldy  $90       ;Lit compteur d'octet.
     bne  exit
     ldy  $fb
     dey
     bne  loop1     ;si pas dernier, loop
     ldx  $fc       ;Chrg Octet recu dans x.
     jsr  bprtfix   ;bputint print file size    
     lda  #$20      ;Chrg Espace et ...
     jsr  chrout    ;chrout ... l'affiche.
loop3     
     jsr  acptr     ;acptr Recoit un byte.
     ldx  $90       ;Chrg kernal status word
     bne  exit      ;Si erreur, EXIT.
     tax            ;tfr a dans x
     beq  loop2     ;Byte est =0 loop2
     jsr  chrout    ;chrout,  >0 l'affiche. 
     jmp  loop3     ;Chrg un autre octets
loop2     
     lda  #$0d      ;Chrg CR dans a ...
     jsr  chrout    ;chrout ... l'affiche.
     ldy  #$02      ;Met 2 dans y.
     bne  loop1     ;-a la prochaine entree.
exit      
     jsr  clall     ;sfclose ... close file.
     jsr  popall
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
     jsr  chrout
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
;--------------------------------------
; Positionne le curseur a l'ecran.
; x=colonne, y=ligne
; limites x(0-39), Y(0-24)
;--------------------------------------
gotoxy    .block
          jsr pushregs
          txa ; interchange x et y
          pha ; ...
          tya ; ...
          tax ; ...
          pla ; ...
          tay ; ...
txlow     cpy #0
          bpl txhigh
          ldx #0
txhigh    cpx #25
          bmi tylow
          ldx #24
tylow     cpy #0
          bpl tyhigh
          ldy #0
tyhigh    cpy #40
          bmi allok
          ldy #39
allok     clc
          jsr plot
          jsr popregs
          rts
          .bend
;--------------------------------------
