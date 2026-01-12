SOURCENAME=v20start
BASEDIR=/Users/Locals/C64/00-usbkey32go
VICEDIR=/Users/Locals/temp/Vice
SD2IEC=/media/daniel/SD2IECV20/d-remote
V20=/usr/bin/xvic
X64=/usr/bin/x64
X64SC=/usr/bin/x64sc
C1541=/usr/bin/c1541
TASS=/usr/bin/64tass
TASSLIB=./libV20
TMPSEP06=-9 $(BASEDIR)/dir-tmp-dskimg/turbo-macro-pro-sep06.d64
V20MKASM=-9 /Users/Locals/Vic20/roms/tools/4k/D64/V20MikroAsmbler.d64
V20MON=-9 /Users/Locals/Vic20/d64/vicmon-6000.d64
VICE=$(V20)
DISK8DIR=
PRGDIR=d-00-64tass-bin
# FTP SERVER CONFIG
FTPSVR=10.0.1.10
FTPPRGARG=cd /Usb0/d-00-64tass-bin/prg; put $(SOURCENAME).prg; bye
FTPD64ARG=cd /Usb0/d-00-64tass-bin/d64; put $(SOURCENAME).d64; bye
FTPCRTARG=cd /Usb0/d-00-64tass-bin/crt; put $(SOURCENAME).crt; bye


all: $(SOURCENAME).d64
	#cp -f  ${SOURCENAME}.crt ${BASEDIR}/${PRGDIR}/crt
	#cp -f  ${SOURCENAME}.crt ${VICEDIR}
	$(VICE) -autostart $(BASEDIR)/$(PRGDIR)/d64/$(SOURCENAME).d64:$(SOURCENAME) $(V20MON)

$(SOURCENAME).d64: $(SOURCENAME).prg
	$(C1541) -format $(SOURCENAME),0 d64 $(SOURCENAME).d64 -attach $(SOURCENAME).d64 -write $(SOURCENAME).prg $(SOURCENAME) 
	cp -f  ${SOURCENAME}.d64 ${BASEDIR}/${PRGDIR}/d64
	cp -f  ${SOURCENAME}.d64 ${SD2IEC}/d64
	cp -f  ${SOURCENAME}.d64 ${VICEDIR}
$(SOURCENAME).prg: $(SOURCENAME).asm
	$(TASS) -C -m -a -I $(TASSLIB) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
	cp -f  ${SOURCENAME}.prg ${BASEDIR}/${PRGDIR}/prg
	cp -f  ${SOURCENAME}.prg ${SD2IEC}/prg
	cp -f  ${SOURCENAME}.prg ${VICEDIR}
	cp -f  ${SOURCENAME}.txt ${BASEDIR}/${PRGDIR}/txt
	cp -f  ${SOURCENAME}.txt ${SD2IEC}/txt
	cp -f  ${SOURCENAME}.txt ${VICEDIR}

clean:
	rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 
	rm ${BASEDIR}/${PRGDIR}/prg/$(SOURCENAME).prg
	rm ${BASEDIR}/${PRGDIR}/txt/$(SOURCENAME).txt
	rm ${BASEDIR}/${PRGDIR}/d64/$(SOURCENAME).d64
