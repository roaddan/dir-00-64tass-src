# Note: Drive name should be specified under windows. 
# ===============================================
# ======== P R O J E C T   S E C T I O N ========
# ===============================================
# The basename of your project main file ((no extension) .asm is presumed).
SOURCENAME=joystick2-mc
# The lowest common project shared directory complete path.
# for thingds like librairies, data files, images, etc.
BASEDIR=/Users/Locals/C64/00-usbkey32go
# Since the make file will be executed from within your project ...
# ... the following detail is used to specify where the resulting ...
# ... files will be placed. # Complete path where the compiled files will be deposited. 
OUTDIR=/Users/Locals/temp/Vice
# ===============================================
# =========== V I C E   S E C T I O N ===========
# ===============================================
# Complete path to the Vic20 emulator program.
V20=/Applications/VICE/xvic.app/Contents/MacOS/xvic
# Complete path to the C64 emulator program.
X64=/Applications/VICE/x64.app/Contents/MacOS/x64
# Complete path to the C64sc emulator program.
X64SC=/Applications/VICE/x64sc.app/Contents/MacOS/x64sc
# Complete path to the c1541 disk creation program.
C1541=/Applications/vice-x86-64-gtk3-3.7.1/bin/c1541
# Complete path to the cartconv cartridge converter program.
CARTCONV=/Applications/vice-x86-64-gtk3-3.7.1/bin/cartconv
# Complete path to some other emulators emulator program.
X64SCSDL=/Applications/vice-x86-64-sdl2-3.7.1/x64sc.app/Contents/MacOS/x64sc
X64SCGTK=/Applications/vice-x86-64-gtk3-3.7.1/x64sc.app/Contents/MacOS/x64sc
# ===============================================
# ========= 6 4 T A S S   S E C T I O N =========
# ===============================================
# Tis can be change to any assembler od your liking.
# Complete path to the 64tass assembler program.
TASS=/Users/daniel/bin/64tass_dir/64tass
# The Complete path to the library directory.
TASSLIB=$(BASEDIR)/dir-00-64tass-src/lib
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
# ===============================================
# ============ F T P   S E C T I O N ============
# ===============================================
# This section is to transfer the resulting files to the Ultimite cartridge II ...
# ... the ftpserver enabeled.
# FTP SERVER CONFIG
FTPSVRIP=10.0.1.10
FTPCMDPATH=/usr/local/bin/lftp 
FTPPRGARG=cd /Usb0/d-00-64tass-bin/prg; put $(SOURCENAME).prg; bye
FTPD64ARG=cd /Usb0/d-00-64tass-bin/d64; put $(SOURCENAME).d64; bye
FTPCRTARG=cd /Usb0/d-00-64tass-bin/crt; put $(SOURCENAME).crt; bye
FTPPRGCMD=$(FTPCMDPATH) -e "$(FTPPRGARG)" $(FTPSVRIP)
FTPD64CMD=$(FTPCMDPATH) -e "$(FTPD64ARG)" $(FTPSVRIP)
FTPCRTCMD=$(FTPCMDPATH) -e "$(FTPCRTARG)" $(FTPSVRIP)

# SOME OTHER VARIABLES JUST TO REDUCE THE LINE LENGTH.
VICE=$(X64)
AUTOSTART=-autostart $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64:$(SOURCENAME)

all: 	$(SOURCENAME).d64
		$(VICE) $(AUTOSTART) $(TMPSEP06)

ftp:	$(SOURCENAME).d64
		$(FTPPRGCMD)
		$(FTPD64CMD)
		$(FTPCRTCMD)

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
