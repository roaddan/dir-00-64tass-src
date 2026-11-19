;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-sid.asm
; Type fichier....: Constantes
; Creation........: 20151208 
; Version.........: 0.1.0
; Révisions.......: 20261027-151103 Francisation des commentaires,
;------------------------------------------------------------------------------
sidbase =   $d400
; Voix 1
sidfrelo1  =   $d400 ; 54272 - Voix 1 contrôle de la fréquence (LSB).
sidfrehi1  =   $d401 ; 54273 - Voix 1 contrôle de la fréquence (MSB).
sidpwlo1   =   $d402 ; 54274 - Voix 1 largeur de forme d'onde impulsion (LSB).
sidpwhi1   =   $d403 ; 54275 - Voix 1 largeur de forme d'onde impulsion (MSB).
sidregctl1 =   $d404 ; 54276 - Voix 1 registre de contrôle.
sidatdcy1  =   $d405 ; 54277 - Voiv 1 registre d'attaque/déclin.
sidsurel1  =   $d406 ; 54278 - Voix 1 registre contrôle Maintien/Relâchement.
; Voix 2
sidfrelo2  =   $d407 ; 54279 - Voix 2 contrôle de la fréquence (LSB).
sidfrehi2  =   $d408 ; 54280 - Voix 2 contrôle de la fréquence (MSB).
sidpwlo2   =   $d409 ; 54281 - Voix 2 largeur de forme d'onde impulsion (LSB).
sidpwhi2   =   $d40a ; 54282 - Voix 2 largeur de forme d'onde impulsion (MSB).
sidregctl2 =   $d40b ; 54283 - Voix 2 registre de contrôle.
sidatdcy2  =   $d40c ; 54284 - Voiv 2 registre d'attaque/déclin.
sidsurel2  =   $d40d ; 54285 - Voix 2 registre contrôle Maintien/Relâchement.
; Voix 3
sidfrelo3  =   $d40e ; 54286 - Voix 3 contrôle de la fréquence (LSB).
sidfrehi3  =   $d40f ; 54287 - Voix 3 contrôle de la fréquence (MSB).
sidpwlo3   =   $d410 ; 54288 - Voix 3 largeur de forme d'onde impulsion (LSB).
sidpwhi3   =   $d411 ; 54289 - Voix 3 largeur de forme d'onde impulsion (MSB).
sidregctl3 =   $d412 ; 54290 - Voix 3 registre de contrôle.
sidatdcy3  =   $d413 ; 54291 - Voiv 3 registre d'attaque/déclin.
sidsurel3  =   $d414 ; 54292 - Voix 3 registre contrôle Maintien/Relâchement.

sidcutlo   =   $d415 ; 54293 - Bits 0-2 = Partie basse de la fréquence de 
                     ;                    coupure du filtre.
                     ;         Bits 5-7 Non-Utilisé
sidcuthi   =   $d416 ; 54294 - Fréquence de coupure du filtre (MSB).
sidreson   =   $d417 ; 54295 - Registre de contrôle résonance du filtre.
                     ;         Bit 0: Filtre voix 1 Sortie? 1=Oui.
                     ;         Bit 1: Filtre voix 2 Sortie? 1=Oui.
                     ;         Bit 2: Filtre voix 3 Sortie? 1=Oui.
                     ;         Bit 3: Filtrer la sortie par une entrée externe?
                     ;                   1=Oui.
                     ;         Bits 4-7: Sélectionner la résonance du filtre 0-15.
sidsigvol  =   $d418 ; 54296 - Registre de sélection du volume et du filtre
                     ;         Bits 0-3: Sélectionner le volume de sortie (0-15)
                     ;         Bit 4: Sélectionnez le filtre passe-bas, 1=on.
                     ;         Bit 5: Sélectionnez le filtre passe-bande, 1=on.
                     ;         Bit 6: Sélectionnez le filtre passe-haut, 1=on.
                     ;         Bit 7: Déconnecter la sortie de la voix 3, 1=off.
sidpotx    =   $d419 ; 54297 - Lire la position X de la manette de jeu 1 (ou 3).
sidpoty    =   $d41a ; 54298 - Lire la position Y de la manette de jeu 1 (ou 3).
sidrandom  =   $d41b ; 54299 - Lire oscillateur/générateur de nombres aléatoires.
sidenv3    =   $d41c ; 54300 - Sortie du générateur d'enveloppe 3.

                  
