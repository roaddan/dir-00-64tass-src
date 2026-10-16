# -----------------------------------------------------------------------------
# ----- F i c h i e r   M a k e   p o u r  6 4 t a s s   avec   V i c e -------
# ----------------- e t  u t i l i t a i r e s  F T P . -----------------------
# ----------------------- V E R S I O N  L I N U X ----------------------------
# -----------------------------------------------------------------------------
# Note:
# 	A) 64tass peut être téléchargé de :
#		https://sourceforge.net/projects/tass64/
#
#	B) La documentation de 64tass est disponnible ici :
#		https://tass64.sourceforge.net/
#
# 	C) L'émulateur Vice peut être trouvé ici :
#			"https://vice-emu.sourceforge.io"
#
#	D) Vous devez spécifier un chemin d'accèes absolue (\path).
#	   Le lecteur doit être spécifié sous MS-Windows. (ex: C:\path...)
#
# -----------------------------------------------------------------------------
# ----------------------- P R O J E C T   S E C T I O N -----------------------
# -----------------------------------------------------------------------------
# Le nom de base du fichier principal de votre projet 
# (sans extension ; .asm est supposé).
# Cela peut varier d'un projet à l'autre.
SOURCENAME=charedit
# Emplacement final où les fichiers assemblés doivent être copiés.
PRGDIR=dir-00-64tass-bin
# Le chemin d'accès complet au répertoire partagé commun du projet pour des 
# éléments tels que librairies, fichiers data, images, etc.
BASEDIR=/Users/Locals/CBM/00-usbkey32go
# 64tass allows to include libraries of code and routines of your making.
# Le chemin complet vers le répertoire de votre bibliothèque globales.
LIBDIR=$(BASEDIR)/dir-00-64tass-src/C64/lib/libstd
#LIBDIR=$(BASEDIR)/dir-00-64tass-src/C64/lib/librom
# -----------------------------------------------------------------------------
# Dépendances des libraries pour valider tous les changements.
# -----------------------------------------------------------------------------
LIBDEPS=$(shell find $(LIBDIR) -maxdepth 1 -type f -iname "*.asm")
DEPSLOCALES=$(shell find . -maxdepth 1 -type f -iname "*.asm")
DEPENDANCES=$(DEPSLOCALES) $(LIBDEPS)
#
# Le fichier make étant exécuté depuis votre projet, les informations ... 
# ... suivantes servent à spécifier l'emplacement des fichiers générés. 
# Chemin complet où seront déposés les fichiers compilés.
OUTDIRC64=$(BASEDIR)/dir-00-64tass-src/C64/prgbin
OUTDIRV20=$(BASEDIR)/dir-00-64tass-src/V20/prgbin
#
# -----------------------------------------------------------------------------
# -----------------------S E C T I O N   6 4 T A S S  -------------------------
# -----------------------------------------------------------------------------
# Chemin complet vers le programme assembleur 64tass.
# Cela peut être remplacé par n'importe quel assembleur de votre choix.
TASS=/usr/bin/64tass
#
# -----------------------------------------------------------------------------
# ------------------------- V I C E   S E C T I O N ---------------------------
# -----------------------------------------------------------------------------
# Note:
# 	Dans le répertoire personnel de mon système (Linux), je dispose d'un dossier
#   ...  « bin » contenant des liens vers l'émulateur Vice et des commandes 
#    ... utilitaires.
# -----------------------------------------------------------------------------
# Complete path to the Vic20 emulator's programs.
VICEBIN=/home/daniel/bin
# Complete path to the Vic20 emulator program.
V20=$(VICEBIN)/xvic
# Complete path to the C64 emulator program.
X64=$(VICEBIN)/x64
# Complete path to the C64sc emulator program.
X64SC=$(VICEBIN)/x64sc
# Complete path to the c1541 disk creation program.
C1541=$(VICEBIN)/c1541
# Complete path to the cartconv cartridge converter program.
CARTCONV=$(VICEBIN)/cartconv
#
#-------------------------------------------------------------------------------
# ===== C B M   D R I V E S   S E C T I O N =====
#-------------------------------------------------------------------------------
# Ces options vous permettent de monter un image disque utilitaire dans le 
# lecteur 9.
# Chemin complet vers le disque utilitaire c64 à monter sur le lecteur 9.
TMPSEP06=-9 $(BASEDIR)/dir-disk-img/d64/turbo-macro-pro-sep06.d64
# Chemin complet vers le disque utilitaire Vic20 à monter sur le lecteur 9.
V20MKASM=-9 $(BASEDIR)/dir-00-64tass-src/V20/utils/V20MikroAsmbler.d64
# Chemin vers les programmes utilitaires que vous voulez copier sur les disques
# ... destination.
UTILSDIR=$(BASEDIR)/dir-00-64tass-src/C64/utils
DBC=$(UTILSDIR)/dbc
JBMON64=$(UTILSDIR)/jbmon
#CHAREDIT=charedit-fr.prg
J2TESTER=$(UTILSDIR)/j2tester
#
#-------------------------------------------------------------------------------
# Quelques autres variables, simplement pour réduire la longueur des lignes de 
# ... commande.
#-------------------------------------------------------------------------------
# C'est ici que vous choisissez l'émulateur VICE.
VICE=$(X64)
# 
OUTDIR=$(OUTDIRC64)
#OUTDIR=$(OUTDIRV20)

# Les paramètres de démarrage automatique de Vice.
#AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64:$(SOURCENAME)
AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d81/$(SOURCENAME).d81:$(SOURCENAME)
# -----------------------------------------------------------------------------
# ------------------ S E C T I O N   O P T I O N N E L L E --------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -------------------------- F T P   S E C T I O N ----------------------------
# -----------------------------------------------------------------------------
# Cette section a pour but de transférer les fichiers résultants vers la 
# ... cartouche Ultimate II avec le serveur FTP activé.
# Cet exemple utilise l'utilitaire lftp, disponible aussi bien sous macOS que 
# ... sous Linux.
# -----------------------------------------------------------------------------
# Configuration du serveur FTP
FTPSVRIP=192.168.2.200 # Check cartridge root menu for your address.
# Chemin d'accès complet au client FTP en ligne de commande.
FTPCMDPATH=/usr/bin/lftp
# Note:
#	E) L'utilisation du FTP est destinée aux utilisateurs du 1541 Ultimate II+ 
#      ... et des appareils compatibles.
#      La 1541 Ultimate II+ propose une interface FTP donnant accès au 
#      ... répertoire racine configuré dans la cartouche. Une fois celle-ci 
#      ... connectée à votre réseau local, l'adresse IP de la cartouche est 
#      ... visible à la racine du menu C64 de la cartouche.
# Liste des commandes destinées au serveur FTP, classées par type de fichier.
# Remarque : Le chemin suivant doit exister sur les disques USB de la cartouche
#            ... Ultimate II+.
# Où placer les fichiers sur l'Ultimate II+.
FTPBASDIR=/Usb0/dir-remote
FTPASMARG=cd $(FTPBASDIR)/asm; put $(SOURCENAME).asm; bye
FTPTXTARG=cd $(FTPBASDIR)/txt; put $(SOURCENAME).txt; bye
FTPPRGARG=cd $(FTPBASDIR)/prg; put $(SOURCENAME).prg; bye
FTPD64ARG=cd $(FTPBASDIR)/d64; put $(SOURCENAME).d64; bye
FTPD81ARG=cd $(FTPBASDIR)/d81; put $(SOURCENAME).d81; bye
FTPCRTARG=cd $(FTPBASDIR)/crt; put $(SOURCENAME).crt; bye
# Concaténation de commandes lftp complètes.
FTPASMCMD=$(FTPCMDPATH) -e "$(FTPASMARG)" $(FTPSVRIP)
FTPTXTCMD=$(FTPCMDPATH) -e "$(FTPTXTARG)" $(FTPSVRIP)
FTPPRGCMD=$(FTPCMDPATH) -e "$(FTPPRGARG)" $(FTPSVRIP)
FTPD64CMD=$(FTPCMDPATH) -e "$(FTPD64ARG)" $(FTPSVRIP)
FTPD81CMD=$(FTPCMDPATH) -e "$(FTPD81ARG)" $(FTPSVRIP)
FTPCRTCMD=$(FTPCMDPATH) -e "$(FTPCRTARG)" $(FTPSVRIP)
#
# -----------------------------------------------------------------------------
# Règles de la commande MAKE pour compiler, exécuter et nettoyer le programme.
# ** À l'aide de commentaires, vous pouvez masquer ou activer n'importe quelle 
#    ... action.
# -----------------------------------------------------------------------------
all: 	$(SOURCENAME).d64	# To compile the source file and crate disk.
#                       # Pour transférer ... 
		$(FTPPRGCMD)	# ... le fichier de programme PRG résultant.
		$(FTPD64CMD)	# ... le fichier disque D64 résultant.
		$(FTPD81CMD)	# ... le fichier disque D81 résultant.
		$(FTPASMCMD)	# ... le fichier source ASM.
		$(FTPTXTCMD) 	# ... le fichier TXT résultant.
#		$(FTPCRTCMD)	# ... le fichier de cartouche CRT résultant.
#		$(VICE) $(AUTOSTART) $(TMPSEP06) & # pour charger vice avec arguments.

# -----------------------------------------------------------------------------
# Lorsqu'il est appelé avec « make ftp ».
# ** À l'aide de commentaires, vous pouvez masquer ou activer n'importe quelle action.
ftp:
#                       # Pour transférer ... 
		$(FTPPRGCMD)	# ... le fichier de programme PRG résultant.
		$(FTPD64CMD)	# ... le fichier disque D64 résultant.
		$(FTPD81CMD)	# ... le fichier disque D81 résultant.
		$(FTPASMCMD)	# ... le fichier source ASM.
		$(FTPTXTCMD) 	# ... le fichier TXT résultant.
#		$(FTPCRTCMD)	# ... le fichier de cartouche CRT résultant.

# -----------------------------------------------------------------------------
# Pour nettoyer et repartir à zéro sur le projet (rarement utilisé).
clean:
		rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 $(SOURCENAME).d81
		rm $(BASEDIR)/$(PRGDIR)/prg/$(SOURCENAME).prg
		rm $(BASEDIR)/$(PRGDIR)/txt/$(SOURCENAME).txt
		rm $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64
		rm $(BASEDIR)/$(PRGDIR)/d81/$(SOURCENAME).d81
# -----------------------------------------------------------------------------
# Règle pour compiler le fichier source.
# -----------------------------------------------------------------------------
# Créez une image disque contenant le programme résultant.
# Le disque sera nommé d'après le fichier source.

$(SOURCENAME).d64: $(SOURCENAME).prg
		$(C1541) -format $(SOURCENAME),0 d64 $(SOURCENAME).d64 -attach $(SOURCENAME).d64 \
		-write $(SOURCENAME).prg $(SOURCENAME) \
		-write $(DBC) dbc \
		-write $(JBMON64) jbmon64 \
		-write $(J2TESTER) j2tester
		cp -f  $(SOURCENAME).d64 $(BASEDIR)/$(PRGDIR)/d64
		cp -f  $(SOURCENAME).d64 $(OUTDIR)
		$(C1541) -format $(SOURCENAME),0 d81 $(SOURCENAME).d81 -attach $(SOURCENAME).d81 \
		-write $(SOURCENAME).prg $(SOURCENAME) \
		-write $(DBC) dbc \
		-write $(JBMON64) jbmon64 \
		-write $(J2TESTER) j2tester
		cp -f  $(SOURCENAME).d81 $(BASEDIR)/$(PRGDIR)/d81
		cp -f  $(SOURCENAME).d81 $(OUTDIR)

# Assemblage et distribution des fichiers résultants.
$(SOURCENAME).prg: $(SOURCENAME).asm $(DEPENDANCES)
		$(TASS) -C -m -a -I $(LIBDIR) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
		cp -f  $(SOURCENAME).prg $(UTILSDIR)
		cp -f  $(SOURCENAME).prg $(BASEDIR)/$(PRGDIR)/prg
		cp -f  $(SOURCENAME).prg $(OUTDIR)
		cp -f  $(SOURCENAME).txt $(BASEDIR)/$(PRGDIR)/txt
		cp -f  $(SOURCENAME).txt $(OUTDIR)


