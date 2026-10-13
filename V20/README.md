# dir-00-64tass-src
English version below
---------------------

Développement pour CBM C64 et Vic20 avec 64tass.
================================================
Ces fichiers ont été créé pour expérimenter la programmation en language assembleur du Commodore 64 et du Vic20 avec un simple éditeur de fichier et de l'utilitaire « Make ».

L'assembleur interplateforme 64Tass a été choisi pour sa similarité avec l'assembleur Turbo-Macro-Pro roulant sur les machines CBM64.

Les fichiers "makefile" sont structurés par des variables en entête pour l'environnement MACOS, linux ou Windows et utilise les utilitaires l’émulateur Vice pour la création d'image de disquette *.d64 et l'exécution du programme. 
Ils contiennent aussi des lignes permettant la transmission des fichiers en mode client FTP vers la cartouche Ultimate II+

De toutes évidences, vous devrez modifier le fichier "Makefile" en fonction de votre configuration.

Commencer par explorer le répertoire "lib". Celui-ci contien le coeur de mes expérimentations et de mon développement.

Par choix et aussi parce que le français est peu présent sur le web, tous les commentaire présent dans le code seront graduellement traduit en francais même si les noms des variables et fonctions demeureront principalement en anglais.

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
