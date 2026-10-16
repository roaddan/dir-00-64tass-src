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
# -----------------------S E C T I O N   6 4 T A S S  -------------------------
# -----------------------------------------------------------------------------
# Chemin complet vers le programme assembleur 64tass.
# Cela peut être remplacé par n'importe quel assembleur de votre choix.
TASS=/usr/bin/64tass
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
# -----------------------------------------------------------------------------
# Dépendances des libraries pour valider tous les changements.
# -----------------------------------------------------------------------------
LIBDEPS=$(shell find $(LIBDIR) -maxdepth 1 -type f -iname "*.asm")
DEPSLOCALES=$(shell find . -maxdepth 1 -type f -iname "*.asm")
DEPENDANCES=$(DEPSLOCALES) $(LIBDEPS)

UTILSDIR=$(BASEDIR)/dir-00-64tass-src/C64/utils
#
# Le fichier make étant exécuté depuis votre projet, les informations ... 
# ... suivantes servent à spécifier l'emplacement des fichiers générés. 
# Chemin complet où seront déposés les fichiers compilés.
OUTDIRC64=$(BASEDIR)/dir-00-64tass-src/C64/prgbin
# OUTDIRV20=$(BASEDIR)/dir-00-64tass-src/V20/prgbin
#
# -----------------------------------------------------------------------------
# ------------------------- V I C E   S E C T I O N ---------------------------
# -----------------------------------------------------------------------------
# Note:
# 	On my system (MacOS) home dir I have a bin folder containing lins to ...
# 	the Vice emulator and utility commands.
# -----------------------------------------------------------------------------
# Complete path to the Vic20 emulator's programs.
VICEBIN=/usr/bin
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
# These options enable you to mount utility disk image in drive 9.
# Complete path to the c64 Utility disk to be mounted on drive 9.
TMPSEP06=-9 $(BASEDIR)/dir-disk-img/d64/turbo-macro-pro-sep06.d64
# Complete path to the Vic20 Utility disk to be mounted on drive 9.
V20MKASM=-9 $(BASEDIR)/dir-00-64tass-src/V20/utils/V20MikroAsmbler.d64
# Complete local path to be mounted as a disk on drive 8 and/or 9.
# **** tests not yet conclusive.
DISK8DIR=
DISK9DIR=
DBC=$(UTILSDIR)/dbc
JBMON64=$(UTILSDIR)/jbmon
#CHAREDIT=charedit-fr.prg
J2TESTER=$(UTILSDIR)/j2tester
#
#-------------------------------------------------------------------------------
# Some other variables just to reduce command line length.
#-------------------------------------------------------------------------------
# Here you choose the vice emulator of your choosing.
VICE=$(X64)
OUTDIR=$(OUTDIRC64)
#OUTDIR=$(OUTDIRV20)

# The Vice autostart parameters.
#AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64:$(SOURCENAME)
AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d81/$(SOURCENAME).d81:$(SOURCENAME)
# -----------------------------------------------------------------------------
# --------------------- O P T I O N N A L   S E C T I O N ---------------------
# -----------------------------------------------------------------------------
# Note:
#	E) FTP usage is intended for the 1541 Ultimate II+ and compatible users.
#	   The 1541 Ultimate II+ provide an FTP interface leading to the root ...
#       directory configured in the cartridge. When connected to your LAN, ...
#	   the IP address of your cartridge can be found at the root level of ...
# 	   cartridge C64 menu. Other systems might use an FTP interface.
#
# -----------------------------------------------------------------------------
# -------------------------- F T P   S E C T I O N ----------------------------
# -----------------------------------------------------------------------------
# This section is intended to transfer the resulting files to the Ultimite ...
# cartridge II with the ftpserver enabeled.
# In this example it uses the lftp utility available in both Mac-OS and Linux.
# -----------------------------------------------------------------------------
# FTP SERVER CONFIG
FTPSVRIP=192.168.2.200 # Check cartridge root menu for your address.
# FTP CLI client full path.
FTPCMDPATH=/usr/bin/lftp
# List of commands by filetype intended to the FTP server.
# Note:  The following path must exist on the Ultimate II+ cartridge usb ...
#        disks.
# Where to put the files on the Ultimate II +.
FTPBASDIR=/Usb0/dir-remote
FTPASMARG=cd $(FTPBASDIR)/asm; put $(SOURCENAME).asm; bye
FTPTXTARG=cd $(FTPBASDIR)/txt; put $(SOURCENAME).txt; bye
FTPPRGARG=cd $(FTPBASDIR)/prg; put $(SOURCENAME).prg; bye
FTPD64ARG=cd $(FTPBASDIR)/d64; put $(SOURCENAME).d64; bye
FTPD81ARG=cd $(FTPBASDIR)/d81; put $(SOURCENAME).d81; bye
FTPCRTARG=cd $(FTPBASDIR)/crt; put $(SOURCENAME).crt; bye
# Concatenating lftp full commands.
FTPASMCMD=$(FTPCMDPATH) -e "$(FTPASMARG)" $(FTPSVRIP)
FTPTXTCMD=$(FTPCMDPATH) -e "$(FTPTXTARG)" $(FTPSVRIP)
FTPPRGCMD=$(FTPCMDPATH) -e "$(FTPPRGARG)" $(FTPSVRIP)
FTPD64CMD=$(FTPCMDPATH) -e "$(FTPD64ARG)" $(FTPSVRIP)
FTPD81CMD=$(FTPCMDPATH) -e "$(FTPD81ARG)" $(FTPSVRIP)
FTPCRTCMD=$(FTPCMDPATH) -e "$(FTPCRTARG)" $(FTPSVRIP)
#
# -----------------------------------------------------------------------------
# Make command rules to build, execute and clean program.
# ** Using comment, you can mask or enable anny action.
# -----------------------------------------------------------------------------
all: 	$(SOURCENAME).d64	# To compile the source file and crate disk.
		$(FTPPRGCMD)	# To transfer the resulting PRG program file.
		$(FTPD64CMD)	# To transfer the resulting D64 disk file.
		$(FTPD81CMD)	# To transfer the resulting D81 disk file.
		$(FTPASMCMD)	# To transfer the source ASM file.
		$(FTPTXTCMD) 	# To transfer the resulting TXT file.
#		$(FTPCRTCMD)	# To transfer the resulting CRT cartridge file.
#		$(VICE) $(AUTOSTART) $(TMPSEP06) & # to load vice with arguments.

# -----------------------------------------------------------------------------
# When called with "make ftp".
# ** Using comment, you can mask or enable anny action.
ftp:
		$(SOURCENAME).d64	# To compile the source file and crate disk.
		$(FTPPRGCMD)	# To transfer the resulting PRG program file.
		$(FTPD64CMD)	# To transfer the resulting D64 disk file.
		$(FTPD81CMD)	# To transfer the resulting D81 disk file.
		$(FTPASMCMD)	# To transfer the source ASM file.
		$(FTPTXTCMD) 	# To transfer the resulting TXT file.
#		$(FTPCRTCMD)	# To transfer the resulting CRT cartridge file.

# -----------------------------------------------------------------------------
# To clean and start project fresh. (seldome used).
clean:
		rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 $(SOURCENAME).d81
		rm $(BASEDIR)/$(PRGDIR)/prg/$(SOURCENAME).prg
		rm $(BASEDIR)/$(PRGDIR)/txt/$(SOURCENAME).txt
		rm $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64
		rm $(BASEDIR)/$(PRGDIR)/d81/$(SOURCENAME).d81
# -----------------------------------------------------------------------------
# Rule to compile the source file.
# -----------------------------------------------------------------------------
# Create disk image containing the resulting program.
# The disk will be named as per the source file.

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

# Assembling and distributing resulting files.
$(SOURCENAME).prg: $(SOURCENAME).asm $(DEPENDANCES)
		$(TASS) -C -m -a -I $(LIBDIR) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
		cp -f  $(SOURCENAME).prg $(UTILSDIR)
		cp -f  $(SOURCENAME).prg $(BASEDIR)/$(PRGDIR)/prg
		cp -f  $(SOURCENAME).prg $(OUTDIR)
		cp -f  $(SOURCENAME).txt $(BASEDIR)/$(PRGDIR)/txt
		cp -f  $(SOURCENAME).txt $(OUTDIR)


