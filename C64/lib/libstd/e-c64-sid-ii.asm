;------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, Québec, canada.
; Nom du fichier .: e-c64-sid-ii.asm
; Cernière m.à j. : 20261025-001445
; Inspiration ....: 
;------------------------------------------------------------------------------
sidbase =   $d400
; Voice 1
frelo1  =   $d400 ; 54272 - Voice 1 contrôle de la fréquence (LSB).
frehi1  =   $d401 ; 54273 - Voice 1 contrôle de la fréquence (MSB).
pwlo1   =   $d402 ; 54274 - Voice 1 largeur de forme d'onde impulsion (LSB).
pwhi1   =   $d403 ; 54275 - Voice 1 largeur de forme d'onde impulsion (MSB).
vcreg1  =   $d404 ; 54276 - Voice 1 registre de contrôle.
atdcy1  =   $d405 ; 54277 - Voive 1 registre d'attaque/déclin.
surel1  =   $d406 ; 54278 - Voice 1 registre de contrôle Maintien/Relâchement.
; Voice 2
frelo2  =   $d407 ; 54279 - Voice 2 contrôle de la fréquence (LSB).
frehi2  =   $d408 ; 54280 - Voice 2 contrôle de la fréquence (MSB).
pwlo2   =   $d409 ; 54281 - Voice 2 largeur de forme d'onde impulsion (LSB).
pwhi2   =   $d40a ; 54282 - Voice 2 largeur de forme d'onde impulsion (MSB).
vcreg2  =   $d40b ; 54283 - Voice 2 registre de contrôle.
atdcy2  =   $d40c ; 54284 - Voive 2 registre d'attaque/déclin.
surel2  =   $d40d ; 54285 - Voice 2 registre de contrôle Maintien/Relâchement.
; Voice 3
frelo3  =   $d40e ; 54286 - Voice 2 contrôle de la fréquence (LSB).
frehi3  =   $d40f ; 54287 - Voice 2 contrôle de la fréquence (MSB).
pwlo3   =   $d410 ; 54288 - Voice 2 largeur de forme d'onde impulsion (LSB).
pwhi3   =   $d411 ; 54289 - Voice 2 largeur de forme d'onde impulsion (MSB).
vcreg3  =   $d412 ; 54290 - Voice 2 registre de contrôle.
atdcy3  =   $d413 ; 54291 - Voive 2 registre d'attaque/déclin.
surel3  =   $d414 ; 54292 - Voice 2 registre de contrôle Maintien/Relâchement.

cutlo   =   $d415 ; 54293 - Bits 0-2 = Partie basse de la fréquence de coupure 
                  ;                    du filtre.
                  ;         Bits 5-7 Non-Utilisé
cuthi   =   $d416 ; 54294 - Fréquence de coupure du filtre (MSB).
reson   =   $d417 ; 54295 - Registre de contrôle résonance du filtre.
                  ;         Bit 0: Filtre voix 1 Sortie? 1=Oui.
                  ;         Bit 1: Filtre voix 2 Sortie? 1=Oui.
                  ;         Bit 2: Filtre voix 3 Sortie? 1=Oui.
                  ;         Bit 3: Filtrer la sortie par une entrée externe?
               ;                   1=Oui.
                  ;         Bits 4-7: Sélectionner la résonance du filtre 0-15.
sigvol  =   $d418 ; 54296 - Registre de sélection du volume et du filtre
                  ;         Bits 0-3: Sélectionner le volume de sortie (0-15)
                  ;         Bit 4: Sélectionnez le filtre passe-bas, 1=on.
                  ;         Bit 5: Sélectionnez le filtre passe-bande, 1=on.
                  ;         Bit 6: Sélectionnez le filtre passe-haut, 1=on.
                  ;         Bit 7: Déconnecter la sortie de la voix 3, 1=off.
potx    =   $d419 ; 54297 - Lire la position X de la manette de jeu 1 (ou 3).
poty    =   $d41a ; 54298 - Lire la position Y de la manette de jeu 1 (ou 3).
random  =   $d41b ; 54299 - Lire oscillateur/générateur de nombres aléatoires.
env3    =   $d41c ; 54300 - Sortie du générateur d'enveloppe 3.

                  
