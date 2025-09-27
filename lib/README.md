# dir-00-64tass-src/lib
### English version below
# Développement pour CBM C64 et Vic20 avec 64tass.
Ces fichiers ont été créé pour expérimenter la programmation en language assembleur du Commodore 64 et du Vic20 avec un simple éditeur de fichier et de l'utilitaire « Make ».

L'assembleur interplateforme 64Tass a été choisi pour sa similarité avec l'assembleur Turbo-Macro-Pro roulant sur les machines CBM64.

Les fichiers "makefile" sont structurés par des variables en entête pour l'environnement MACOS, linux ou Windows et utilise les utilitaires l’émulateur Vice pour la création d'image de disquette *.d64 et l'exécution du programme. Ils contiennent aussi des lignes permettant la transmission des fichiers en mode client FTP vers la cartouche Ultimate II+

De toutes évidences, vous devrez modifier le fichier "Makefile" en fonction de votre configuration.

Commencer par explorer le répertoire "lib". Celui-ci contien le coeur de mes expérimentations et de mon développement.

Par choix et aussi parce que le français est peu présent sur le web, tous les commentaire présent dans le code seront graduellement traduit en francais même si les noms des variables et fonctions demeureront principalement en anglais.

# Nomenclature des fichiers:

###  Prefixes : 

    - lib-     Contient du code assembleur relatif à l'environnement décrit par le nom.
    - header-  Contient le code initial des programmes pour être lancer sous basic 2.0.
    - macro-   Contient divers macros ecrite dans la syntaxe 64Tass.
    - map-     Contien des déclarations de constantes des éléments décrite par le nom.

###  Préfixe niveau 2:

    -  c64-  Code spécifique au Commodore 64.
    -  v20-  Code spécifique au Commodore Vic20.
    -  cbm-  Code applicable au commodore C64 et Vic20.

###  Suffixe:  

    - Représentatif de l'environnement auquel le code s'applique.
    - ex. kernal, basic2, sid, vicII, vic (vic 20), etc. 
    - aussi les thermes std et mcd signifie respectivement:
                        STandard Display et Multi-Colour-Display.
      
Amusez-vous.

### __English version.__
# CBM C64 and Vic20 development using 64tass.
Those files where created to experiment assembly lamguage programming for the Commodore 64 and Vic20 using a simple text editor and the make utility. 
Those files where created to experiment assembly lamguage programming for the Commodore 64 and Vic20 using a simple text editor and the make utility. 

The 64tass cross assembler was chosen for its similarity with the Turbo-Macro-Pro assembler running under the CBM64 machines.

### Prefix level 1:

    - lib-     Contains assembly code relativ to the environnement described by the file suffix.
    - header-  Contains program initial code to allow fireind-up under Basic 2.0.
    - macro-   Contains macros writteh under 64Tass syntax.
    - map-     Contains declarations and constants relatives to the environnement described by the file suffix.
    - map-     Contains declarations and constants relatives to the environnement described by 
               the file suffix.

###  Prefix level 2:

    -  c64-  Commodore 64 specific code.
    -  v20-  Vic20 specific code.
    -  cbm-  both C64 et Vic20 applicable code.

###  Suffix:  

    - Représents the environnement in whish code is applicable.
    - ex. kernal, basic2, sid, vicII, vic (vic 20), etc. 
    - also thermes std and mcd indicate respectively: 
                        STandard Display and Multi-Colour-Display.

Have fun.
