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
SOURCENAME=template
BASEDIR=/Users/Locals/CBM/00-usbkey32go
# Emplacement final où les fichiers assemblés doivent être copiés.
PRGDIR=$(BASEDIR)/dir-00-64tass-bin
SRCDIR=$(BASEDIR)/dir-00-64tass-src
UTILSDIR=$(SRCDIR)/V20/utils
LIBDIR=$(SRCDIR)/V20/lib
DEPSLOCALES=$(shell find . -maxdepth 1 -type f -iname "*.asm")
#DEPSLOCALES=strings_fr.asm  strings_en.asm
# -----------------------------------------------------------------------------
# Dépendances des libraries pour valider tous les changements.
# -----------------------------------------------------------------------------
LIBDEPS=$(shell find $(LIBDIR) -maxdepth 1 -type f -iname "*.asm")
DEPENDANCES=$(DEPSLOCALES) $(LIBDEPS)
SD2IEC=/media/daniel/SD2IECV20
PI1541=/media/daniel/PI1541
V20=/usr/bin/xvic -directory /usr/local/share/vice
C1541=/usr/bin/c1541
TASS=/usr/bin/64tass
EXPORTDIR=/media/daniel/DATASSET/d-remote
# Chemin complet vers le disque utilitaire Vic20 à monter sur le lecteur 9.
V20MKASM=-9 $(UTILSDIR)/V20MikroAsmbler.d64
V20MON=-9 $(UTILSDIR)/vicmon.d64
V20MON6000=-9$(UTILSDIR)/vicmon-6000.d64
PRGBIN=$(SRCDIR)/V20/prgbin
VICE=$(V20)
DISK8DIR=

all: $(SOURCENAME).d64
#	$(VICE) -8 $(UTILSDIR)$(SOURCENAME).d81 -keybuf "sys 40960\n" -autostartprgmode 0 $(SOURCENAME).prg 
	$(VICE) $(V20MON) -autostartprgmode 1 $(SOURCENAME).d81:vic20-wedge
#	$(VICE) $(V20MON) -autostart $(UTILSDIR)$(SOURCENAME).d81:$(SOURCENAME) 
#	$(VICE) $(V20MON) -autostart $(SOURCENAME).d64:$(SOURCENAME) 
#	$(VICE) $(V20MON) -autostart $(SOURCENAME).d64:fb

$(SOURCENAME).d64: $(SOURCENAME).prg $(DEPENDANCES)
	$(C1541) -format $(SOURCENAME),0 d64 $(SOURCENAME).d64 -attach $(SOURCENAME).d64 \
	-write $(UTILSDIR)/fb fb \
	-write $(UTILSDIR)/fb20 fb20 \
	-write $(UTILSDIR)/fb20-3k fb20-3k \
	-write $(UTILSDIR)/fb20-8k fb20-8k \
	-write $(UTILSDIR)/fb20-mc fb20-mc \
	-write $(UTILSDIR)/prg/vic20-wedge.prg vic20-wedge \
	-write smonv20.prg smonv20 \
	-write smonv20-en.prg smonv20-en \
	-write smonv20-fr.prg smonv20-fr \
	-write $(UTILSDIR)/prg/showkeys.prg showkeys

	$(C1541) -format $(SOURCENAME),0 d81 $(SOURCENAME).d81 -attach $(SOURCENAME).d81 \
	-write $(UTILSDIR)/fb fb \
	-write $(UTILSDIR)/fb20 fb20 \
	-write $(UTILSDIR)/fb20-3k fb20-3k \
	-write $(UTILSDIR)/fb20-8k fb20-8k \
	-write $(UTILSDIR)/fb20-mc fb20-mc \
	-write $(UTILSDIR)/prg/vic20-wedge.prg vic20-wedge \
	-write smonv20.prg smonv20 \
	-write smonv20-en.prg smonv20-en \
	-write smonv20-fr.prg smonv20-fr \
	-write $(UTILSDIR)/prg/showkeys.prg showkeys

	cp -f  ${SOURCENAME}.d81 ${PRGBIN}/d81
	cp -f  ${SOURCENAME}.d64 ${PRGBIN}/d64
	
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.d81 ${EXPORTDIR}/d81;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.d64 ${EXPORTDIR}/d64;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.asm ${EXPORTDIR}/asm;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.prg ${EXPORTDIR}/prg;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.txt ${EXPORTDIR}/txt;fi

	cp -f ${SOURCENAME}.prg $(UTILSDIR) 
	cp -f ${SOURCENAME}.d64 $(UTILSDIR) 
	cp -f ${SOURCENAME}.d81 $(UTILSDIR) 

	cp -f ${SOURCENAME}.d81 ${PRGBIN}/d81
	cp -f ${SOURCENAME}.d64 ${PRGBIN}/d64

	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.prg ${SD2IEC}/;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.prg ${SD2IEC}/d-remote/prg;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.asm ${SD2IEC}/d-remote/asm;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.txt ${SD2IEC}/d-remote/txt;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.d64 ${SD2IEC}/d-remote/d64;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.d81 ${SD2IEC}/d-remote/d81;fi
	if [ -d "${PI1541}" ]; then cp -f  ${SOURCENAME}.prg ${PI1541}/;fi
	if [ -d "${PI1541}" ]; then cp -f  ${SOURCENAME}.prg ${PI1541}/d-remote/vic20/prg;fi
	if [ -d "${PI1541}" ]; then cp -f  ${SOURCENAME}.asm ${PI1541}/d-remote/vic20/asm;fi
	if [ -d "${PI1541}" ]; then cp -f  ${SOURCENAME}.txt ${PI1541}/d-remote/vic20/txt;fi
	if [ -d "${PI1541}" ]; then cp -f  ${SOURCENAME}.d64 ${PI1541}/d-remote/vic20/d64;fi
	if [ -d "${PI1541}" ]; then cp -f  ${SOURCENAME}.d81 ${PI1541}/d-remote/vic20/d81;fi

$(SOURCENAME).prg: $(SOURCENAME).asm $(DEPENDANCES)
	$(TASS) -C -m -a -I $(LIBDIR) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
	cp -f  ${SOURCENAME}.prg ${PRGDIR}/prg
	cp -f  ${SOURCENAME}.txt ${PRGDIR}/txt
	cp -f  ${SOURCENAME}.asm ${PRGBIN}/asm
	cp -f  ${SOURCENAME}.prg ${PRGBIN}/prg
	cp -f  ${SOURCENAME}.txt ${PRGBIN}/txt
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.d81 ${EXPORTDIR}/d81;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.d64 ${EXPORTDIR}/d64;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.asm ${EXPORTDIR}/asm;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.prg ${EXPORTDIR}/prg;fi
	if [ -d "${EXPORTDIR}" ]; then cp -f  ${SOURCENAME}.txt ${EXPORTDIR}/txt;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.prg ${SD2IEC}/d-remote/prg;fi
	if [ -d "${SD2IEC}" ]; then cp -f  ${SOURCENAME}.txt ${SD2IEC}/d-remote/txt;fi

clean:
	rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 
	rm ${PRGDIR}/prg/$(SOURCENAME).prg
	rm ${PRGDIR}/txt/$(SOURCENAME).txt
	rm ${PRGDIR}/d64/$(SOURCENAME).d64

