# dir-00-64tass-src/lib
### English version below
---------------------

# Librairie pour CBM C64 et Vic20 avec 64tass.
================================================
Ces fichiers ont été créé pour expérimenter la programmation en language assembleur du Commodore 64 et du Vic20 avec un simple éditeur de fichier et de l'utilitaire « Make ».

L'assembleur interplateforme 64Tass a été choisi pour sa similarité avec l'assembleur Turbo-Macro-Pro roulant sur les machines CBM64.

Les fichiers "makefile" sont structurés par des variables en entête pour l'environnement MACOS, linux ou Windows et utilise les utilitaires l’émulateur Vice pour la création d'image de disquette *.d64 et l'exécution du programme. 
Ils contiennent aussi des lignes permettant la transmission des fichiers en mode client FTP vers la cartouche Ultimate II+

De toutes évidences, vous devrez modifier le fichier "Makefile" en fonction de votre configuration.

Commencer par explorer le répertoire "lib". Celui-ci contien le coeur de mes expérimentations et de mon développement.

Par choix et aussi parce que le français est peu présent sur le web, tous les commentaire présent dans le code seront graduellement traduit en francais même si les noms des variables et fonctions demeureront principalement en anglais.

Ce répertoire contient les librairies qui sont en développement.

Nomentlature des fichiers librairies:
  Prefixes : 
    lib-     Contient du code assembleur relatif à l'environnement décrit par le nom.
    header-  Contient le code initial des programmes pour être lancer sous basic 2.0.
    macro-   Contient divers macros ecrite dans la syntaxe 64Tass.
    map-     contien des déclarations de constantes des éléments décrite par le nom.
  
  Préfixe niveau 2:
      c64-  Code spécifique au Commodore 64.
      v20-  Code spécifique au Commodore Vic20.
      cbm-  Code applicable au commodore C64 et Vic20.
  
  Suffixe:  Représentatif de l'environnement auquel le code s'applique.
            ex. kernal, basic2, sid, vicII, vic (vic 20), etc
            aussi les thermes std et mcd signifie respectivement STandard Display et Multi-Colour-Display.
      
Amusez-vous.

English version.
----------------
CBM C64 and Vic20 development using 64tass.
===========================================
Those files where created to experiment assembly lamguage programming for the Commodore 64 and Vic20 using a simple text editor and the make utility. 

The 64tass cross assembler was chosen for its similarity with the Turbo-Macro-Pro assembler running under the CBM64 machines.

The "makefile" is structured by variables in it's header for the MACOS, Linux or Windows environment and uses the Vice emulator to create the *.d64 disk image and to run the program.
It also contains lines that permits ftp transmission of files to the Ultimate II+ cartridge. 

You must evidently modify the "Makefile" to reflect your work environnement.

Other versions of the makefile are also available.

You should start by exploring the "lib" directory. It contains the heart of my experiments and developpements.

By choice and also because french is not verry present on the web, all comments in the code will progressively be translated in french even though the variables and function names will remain mostly in english.

Have fun.
