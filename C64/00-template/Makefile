# -----------------------------------------------------------------------------
# --------- 6 4 t a s s   m a k e   f i l e   w i t h   V i c e ---------------
# ----------------- a n d   F T P   u t i l i t i e s . -----------------------
# -----------------------------------------------------------------------------
# Note:  
# 	A) 64tass can be dounloaded from :
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
# ----------------------- P R O J E C T   S E C T I O N -----------------------
# -----------------------------------------------------------------------------
# The basename of your project main file ((no extension) .asm is presumed).
# Could be different for every project.
SOURCENAME=colour
# The lowest common project shared directory complete path.
# for things like librairies, data files, images, etc.
BASEDIR=/Users/Locals/C64/00-usbkey32go
# Since the make file will be executed from within your project ...
# ... the following detail is used to specify where the resulting ...
# ... files will be placed. 
# Complete path where the compiled files will be deposited. 
OUTDIR=/Users/Locals/temp/Output
#
# ===============================================
# ========= 6 4 T A S S   S E C T I O N =========
# ===============================================
# Tis can be change to any assembler od your liking.
# Complete path to the 64tass assembler program.
TASS=/Users/daniel/bin/64tass_dir/64tass
# The Complete path to the library directory.
TASSLIB=$(BASEDIR)/dir-00-64tass-src/lib
#
# ===============================================
# =========== V I C E   S E C T I O N ===========
# ===============================================
# Complete path to the Vic20 emulator's programs.
VICEBIN=/Users/daniel/bin
#
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
X64SCSDL=/Applications/vice-x86-64-sdl2-3.7.1/x64sc.app/Contents/MacOS/x64sc
X64SCGTK=/Applications/vice-x86-64-gtk3-3.7.1/x64sc.app/Contents/MacOS/x64sc
#
# -----------------------------------------------------------------------------
# --------------------- O P T I O N N A L   S E C T I O N ---------------------
# -----------------------------------------------------------------------------
#
#	E) FTP usage is intended for the 1541 Ultimate II+ and compatible users.
#	   The 1541 Ultimate II+ provide an FTP interface leading to the root ...
#       directory configured in the cartridge. When connected to your LAN, ...
#	   the IP address of your cartridge can be found at the root level of ...
# 	   cartridge menu.   
#
# ===============================================
# ============ F T P   S E C T I O N ============
# ===============================================
# This section is to transfer the resulting files to the Ultimite cartridge II ...
# ... the ftpserver enabeled.
# FTP SERVER CONFIG
FTPSVRIP=192.168.2.200
FTPCMDPATH=/usr/local/bin/lftp 
FTPASMARG=cd /Usb0/dir-00-64tass-bin/asm; put $(SOURCENAME).asm; bye
FTPTXTARG=cd /Usb0/dir-00-64tass-bin/txt; put $(SOURCENAME).txt; bye
FTPPRGARG=cd /Usb0/dir-00-64tass-bin/prg; put $(SOURCENAME).prg; bye
FTPD64ARG=cd /Usb0/dir-00-64tass-bin/d64; put $(SOURCENAME).d64; bye
FTPCRTARG=cd /Usb0/dir-00-64tass-bin/crt; put $(SOURCENAME).crt; bye
FTPASMCMD=$(FTPCMDPATH) -e "$(FTPASMARG)" $(FTPSVRIP)
FTPTXTCMD=$(FTPCMDPATH) -e "$(FTPTXTARG)" $(FTPSVRIP)
FTPPRGCMD=$(FTPCMDPATH) -e "$(FTPPRGARG)" $(FTPSVRIP)
FTPD64CMD=$(FTPCMDPATH) -e "$(FTPD64ARG)" $(FTPSVRIP)
FTPCRTCMD=$(FTPCMDPATH) -e "$(FTPCRTARG)" $(FTPSVRIP)
#
# ===============================================
# ===== C B M   D R I V E S   S E C T I O N =====
# ===============================================
# These options enable you to mount utility disquette in drive 9.
# Complete path to the c64 Utility disk you would like to be moiunted on drive 9.
TMPSEP06=-9 $(BASEDIR)/dir-tmp-dskimg/turbo-macro-pro-sep06.d64
# Complete path to the Vic20 Utility disk you would like to be moiunted on drive 9.
V20MKASM=-9 /Users/Locals/Vic20/roms/tools/4k/D64/V20MikroAsmbler.d64
# Complete local path to be mounted as a disk on drive 8 and/or 9.  
# **** tests noy yet conclusive.
DISK8DIR=
DISK9DIR=
PRGDIR=dir-00-64tass-bin
#-------------------------------------------------------------------------------
# Some other variables just to reduce the lines length.
#-------------------------------------------------------------------------------
VICE=$(X64)
AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64:$(SOURCENAME)

all: 	$(SOURCENAME).d64
#		$(VICE) $(AUTOSTART) $(TMPSEP06)
		$(FTPASMCMD)
		$(FTPTXTCMD)
		$(FTPPRGCMD)
#		$(FTPD64CMD)
#		$(FTPCRTCMD)

ftp:	
#		echo $(FTPASMCMD)
#		echo $(FTPTXTCMD)
#		echo $(FTPPRGCMD)
#		echo $(FTPD64CMD)
#		echo $(FTPCRTCMD)
		$(FTPASMCMD)
		$(FTPTXTCMD)
		$(FTPPRGCMD)
#		$(FTPD64CMD)
#		$(FTPCRTCMD)

$(SOURCENAME).d64: $(SOURCENAME).prg
		$(C1541) -format $(SOURCENAME),0 d64 $(SOURCENAME).d64 -attach $(SOURCENAME).d64 -write $(SOURCENAME).prg $(SOURCENAME) 
		cp -f  $(SOURCENAME).d64 $(BASEDIR)/$(PRGDIR)/d64
		cp -f  $(SOURCENAME).d64 $(OUTDIR)

$(SOURCENAME).prg: $(SOURCENAME).asm
		$(TASS) -C -m -a -I $(TASSLIB) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
		cp -f  $(SOURCENAME).prg $(BASEDIR)/$(PRGDIR)/prg
		cp -f  $(SOURCENAME).prg $(OUTDIR)
		cp -f  $(SOURCENAME).txt $(BASEDIR)/$(PRGDIR)/txt
		cp -f  $(SOURCENAME).txt $(OUTDIR)

clean:
		rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 
		rm $(BASEDIR)/$(PRGDIR)/prg/$(SOURCENAME).prg
		rm $(BASEDIR)/$(PRGDIR)/txt/$(SOURCENAME).txt
		rm $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64