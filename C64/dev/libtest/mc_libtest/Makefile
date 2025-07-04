# -----------------------------------------------------------------------------
# --------- 6 4 t a s s   m a k e   f i l e   w i t h   V i c e ---------------
# ----------------- a n d   F T P   u t i l i t i e s . -----------------------
# ---------------------- M A C O S   V E R S I O N ----------------------------
# -----------------------------------------------------------------------------
# Note:  
# 	A) 64tass can be downloaded from :
#		https://sourceforge.net/projects/tass64/ 
#
#	B) 64tass documentation can be found at :
#		https://tass64.sourceforge.net/
#
# 	C) Vice emulator utility is mandatory and available at : 
#			"https://vice-emu.sourceforge.io"
#
#	D) You must decide of an absolute output directory (\path). 
#	   Drive name should be specified under windows. (ex: C:\path...)
#
# -----------------------------------------------------------------------------
# ----------------------- 6 4 T A S S   S E C T I O N -------------------------
# -----------------------------------------------------------------------------
# Tis can be change to any assembler of your liking.
# Complete path to the 64tass assembler program.
TASS=/Users/Locals/bin/64tass_dir/64tass
# Final location where the assembled files must be copied. 
PRGDIR=d-00-64tass-bin
#
# -----------------------------------------------------------------------------
# ----------------------- P R O J E C T   S E C T I O N -----------------------
# -----------------------------------------------------------------------------
# The basename of your project main file ((no extension) .asm is presumed).
# Could be different for every project.
SOURCENAME=mc_libtest
DEPSLOCALES=strings_fr.asm  strings_en.asm
# -----------------------------------------------------------------------------
# Dépendances des libraries pour valider tous les changements.
# -----------------------------------------------------------------------------
LIBDEPS=$(shell find /Users/Locals/C64/00-usbkey32go/d-00-64tass-src/lib -maxdepth 1 -type f -iname "*.asm")
DEPENDANCES=$(DEPSLOCALES) $(LIBDEPS)
# The lowest common project shared directory complete path for things like ... 
# librairies, data files, images, etc.
BASEDIR=/Users/Locals/C64/00-usbkey32go
# Since the make file will be executed from within your project ...
# ... the following detail is used to specify where the resulting ...
# ... files will be placed. # Complete path where the compiled files will be deposited. 
# Since the make file will be executed from within your project the following
# detail is used to specify where the resulting files will be placed. 
# >> Complete path where the compiled files will be placed. 
OUTDIRC64=/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/prgbin
OUTDIRV20=/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/prgbin
#
# 64tass allows to include libraries of code and routines of your making.
# The Complete path to your library directory.
LIBDIR=$(BASEDIR)/d-00-64tass-src/lib
#
# -----------------------------------------------------------------------------
# ------------------------- V I C E   S E C T I O N ---------------------------
# -----------------------------------------------------------------------------
# Note:
# 	On my system (MacOS) home dir I have a bin folder containing lins to ...
# 	the Vice emulator and utility commands.
# -----------------------------------------------------------------------------
# Complete path to the Vic20 emulator's programs.
VICEBIN=/Users/Locals/bin
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
# Complete path to some other emulator programs.
X64SCSDL=/Applications/vice-x86-64-sdl2-3.6.1/x64sc.app/Contents/MacOS/x64sc
X64SCGTK=/Applications/vice-x86-64-gtk3-3.6.1/x64sc.app/Contents/MacOS/x64sc
#
#-------------------------------------------------------------------------------
# ===== C B M   D R I V E S   S E C T I O N =====
#-------------------------------------------------------------------------------
# These options enable you to mount utility disk image in drive 9.
# Complete path to the c64 Utility disk to be mounted on drive 9.
TMPSEP06=-9 $(BASEDIR)/d-tmp-dskimg/turbo-macro-pro-sep06.d64
# Complete path to the Vic20 Utility disk to be mounted on drive 9.
V20MKASM=-9 /Users/Locals/Vic20/roms/tools/4k/D64/V20MikroAsmbler.d64
# Complete local path to be mounted as a disk on drive 8 and/or 9.  
# **** tests not yet conclusive.
DISK8DIR=
DISK9DIR=
DBC=/Users/Locals/C64/00-usbkey32go/dbc
JBMON64=/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/From-Books/40-best-subrouines/00-supermon/jbmon/jbmon64
CHAREDIT=/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/dev/charedit/charedit-fr.prg
J2TESTER=/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/dev/joystick/j2tester.prg
#
#-------------------------------------------------------------------------------
# Some other variables just to reduce command line length.
#-------------------------------------------------------------------------------
# Here you choose the vice emulator of your choosing.
VICE=$(X64SCGTK)
OUTDIR=$(OUTDIRC64)
#OUTDIR=$(OUTDIRV20)

# The Vice autostart parameters. 
AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64:$(SOURCENAME)
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
FTPCMDPATH=/usr/local/bin/lftp
# List of commands by filetype intended to the FTP server.
# Note:  The following path must exist on the Ultimate II+ cartridge usb ...
#        disks.
# Where to put the files on the Ultimate II +.
FTPBASDIR=/Usb0/d-remote
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
#		$(FTPD64CMD)	# To transfer the resulting D64 disk file.
#		$(FTPD81CMD)	# To transfer the resulting D64 disk file.
#		$(FTPASMCMD)	# To transfer the source ASM file.
#		$(FTPTXTCMD) 	# To transfer the resulting TXT file.
#		$(FTPCRTCMD)	# To transfer the resulting CRT cartridge file.
#		$(VICE) $(AUTOSTART) $(TMPSEP06) # to load vice with arguments.

# -----------------------------------------------------------------------------
# When called with "make ftp". 
# ** Using comment, you can mask or enable anny action.
ftp:		
		$(SOURCENAME).d64	# To compile the source file and crate disk.
		$(FTPPRGCMD)	# To transfer the resulting PRG program file.
		$(FTPD64CMD)	# To transfer the resulting D64 disk file.
		$(FTPD81CMD)	# To transfer the resulting D64 disk file.
		$(FTPASMCMD)	# To transfer the source ASM file.
		$(FTPTXTCMD) 	# To transfer the resulting TXT file.
#		$(FTPCRTCMD)	# To transfer the resulting CRT cartridge file.

# -----------------------------------------------------------------------------
# To clean and start project fresh. (seldome used). 
clean:	
		rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 
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
		-write $(CHAREDIT) charedit \
		-write $(J2TESTER) j2tester
		cp -f  $(SOURCENAME).d64 $(BASEDIR)/$(PRGDIR)/d64
		cp -f  $(SOURCENAME).d64 $(OUTDIR)
		$(C1541) -format $(SOURCENAME),0 d81 $(SOURCENAME).d81 -attach $(SOURCENAME).d81 \
		-write $(SOURCENAME).prg $(SOURCENAME) \
		-write $(DBC) dbc \
		-write $(JBMON64) jbmon64 \
		-write $(CHAREDIT) charedit \
		-write $(J2TESTER) j2tester
		cp -f  $(SOURCENAME).d81 $(BASEDIR)/$(PRGDIR)/d81
		cp -f  $(SOURCENAME).d81 $(OUTDIR)

# Assembling and distributing resulting files.
$(SOURCENAME).prg: $(SOURCENAME).asm $(DEPENDANCES)
		$(TASS) -C -m -a -I $(LIBDIR) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
		cp -f  $(SOURCENAME).prg $(BASEDIR)/$(PRGDIR)/prg
		cp -f  $(SOURCENAME).prg $(OUTDIR)
		cp -f  $(SOURCENAME).txt $(BASEDIR)/$(PRGDIR)/txt
		cp -f  $(SOURCENAME).txt $(OUTDIR)


