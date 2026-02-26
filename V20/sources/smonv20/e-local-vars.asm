;--------------------------------------
; Variables du block 0
;--------------------------------------
          *=blk0s
; -----------------------------------------------------------------------------
; temporary pointers
tmp0      =    $c1       ; utilisé pour renvoyer une entrée, 
                         ;      contient souvent l'adresse de fin
tmp2      =    $c3       ; contient généralement l'adresse de départ
satus     =    status
adrptr    .fill     2
scraddr   .fill     2
coladdr   .fill     2
myflags   .fill     1
mybyte    .fill     1
;----------------------------------------------------------------------------
; V a r i a b l e s   i s s u e s   d e   J i m   B u t t e r f i e l d
;----------------------------------------------------------------------------
acmd      .fill     1    ; commande d'adressage
length    .fill     1    ; longueur de l'opérande
mnemw     .fill     3    ; tampon mnémonique à 3 lettres 
savx      .fill     1    ; Mémoire temporaire de 1 octet, souvent utilisée 
                         ; pour sauvegarder le registre x
opcode    .fill     1    ; opcode actuel pour assembleur/désassembleur
upflg     .fill     1    ; indicateur : comptage ascendant (bit 7 effacé) ou 
                         ; descendant (bit 7 activé)
digcnt    .fill     1    ; nombre de chiffres
indig     .fill     1    ; valeur numérique d'un seul chiffre
numbit    .fill     1    ; base numérique de l'entrée
stash     .fill     2    ; stockage temporaire de 2 octets
u0aa0     .fill     10   ; debut dutampon de travail
u0aae     =*             ; fin du tampon de travail
stage     .fill     30   ; tampon de transit pour le nom de fichier, la 
                         ; recherche, etc.
estage    =*             ; fin du tampon de transit

;        *= $0200        ; stocker davantage de variables dans le tampon de 

                         ; l'éditeur de ligne de base
inbuff    .fill     40   ; Tampon d'entrée de 40 caractères
endin     =*             ; fin du tampon d'entrée
;----------------------------------------------------------------------------
; les 7 emplacements suivants servent à stocker les registres lorsque
; le moniteur est démaré et les restaure en sortant.
;----------------------------------------------------------------------------
; Déjà definies dans showregs.
;----------------------------------------------------------------------------
;pch      .fill     1    ; octet de poids fort du compteur de programme
;pcl      .fill     1    ; octet de poids faible du compteur de programme
;sr       .fill     1    ; registre de statut
;acc      .fill     1    ; accumulateur
;xr       .fill     1    ; registre x
;yr       .fill     1    ; registre y
;sp       .fill     1    ; pointeur de pile

store     .fill     2    ; stockage temporaire de 2 octets
chrpnt    .fill     1    ; position actuelle dans le tampon d'entrée
savy      .fill     1    ; stockage temporaire, souvent pour sauvegarder le 
                         ; registre Y.
u9f       .fill     1    ; index dans le tampon de travail de l'assembleur


