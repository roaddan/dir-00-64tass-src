SOURCENAME=keyfinder
BASEDIR=/Users/Locals/CBM/00-usbkey32go
VICEDIR=/Users/Locals/temp/Vice
SD2IEC=/media/daniel/SD2IECV20/d-remote
V20=/usr/bin/xvic
X64=/usr/bin/x64
X64SC=/usr/bin/x64sc
C1541=/usr/bin/c1541
TASS=/usr/bin/64tass

TASSLIB=$(BASEDIR)/d-00-64tass-src/V20/lib
EXPORTDIR=/media/daniel/DATASSET/vic20/d-remote
TMPSEP06=-9 $(BASEDIR)/dir-tmp-dskimg/turbo-macro-pro-sep06.d64
V20UTILDIR=$(BASEDIR)/d-00-64tass-src/V20/utils
V20MKASM=-9 ${V20UTILDIR}/V20MikroAsmbler.d64
V20MON=-9 ${V20UTILDIR}/vicmon.d64
V20MON6000=-9 ${V20UTILDIR}/vicmon-6000.d64
PRGBIN=$(BASEDIR)/d-00-64tass-src/V20/prgbin
VICE=$(V20)
DISK8DIR=
PRGDIR=$(BASEDIR)/d-00-64tass-bin
# FTP SERVER CONFIG
FTPSVR=10.0.1.10
FTPPRGARG=cd /Usb0/d-00-64tass-bin/prg; put $(SOURCENAME).prg; bye
FTPD64ARG=cd /Usb0/d-00-64tass-bin/d64; put $(SOURCENAME).d64; bye
FTPCRTARG=cd /Usb0/d-00-64tass-bin/crt; put $(SOURCENAME).crt; bye


all: $(SOURCENAME).d64
	$(VICE) $(V20MON) -autostart $(SOURCENAME).d64:$(SOURCENAME) 

$(SOURCENAME).d64: $(SOURCENAME).prg
	$(C1541) -format $(SOURCENAME),0 d64 $(SOURCENAME).d64 -attach $(SOURCENAME).d64 \
	-write $(SOURCENAME).prg $(SOURCENAME) \
	-write ${V20UTILDIR}/fb fb \
	-write ${V20UTILDIR}/vicmonb-sys45056.prg vicmonb-sys45056 \
	-write ${V20UTILDIR}/Vicmon-2-b000.prg vicmon-2-b000 \
	-write ${V20UTILDIR}/fb20 fb20 \
	-write ${V20UTILDIR}/fb20-3k fb20-3k \
	-write ${V20UTILDIR}/fb20-8k fb20-8k \
	-write ${V20UTILDIR}/fb20-mc fb20-mc
	$(C1541) -format $(SOURCENAME),0 d81 $(SOURCENAME).d81 -attach $(SOURCENAME).d81 \
	-write $(SOURCENAME).prg $(SOURCENAME) \
	-write ${V20UTILDIR}/fb fb \
	-write ${V20UTILDIR}/vicmonb-sys45056.prg vicmonb-sys45056 \
	-write ${V20UTILDIR}/Vicmon-2-b000.prg vicmon-2-b000 \
	-write ${V20UTILDIR}/fb20 fb20 \
	-write ${V20UTILDIR}/fb20-3k fb20-3k \
	-write ${V20UTILDIR}/fb20-8k fb20-8k \
	-write ${V20UTILDIR}/fb20-mc fb20-mc

	cp -f  ${SOURCENAME}.d81 ${PRGBIN}/d81
	cp -f  ${SOURCENAME}.d64 ${PRGBIN}/d64
	cp -f  ${SOURCENAME}.d81 ${EXPORTDIR}/d81
	cp -f  ${SOURCENAME}.d64 ${EXPORTDIR}/d64
	#cp -f  ${SOURCENAME}.d64 ${SD2IEC}/d64
	cp -f  ${SOURCENAME}.d64 ${VICEDIR}
	cp -f  ${SOURCENAME}.d81 ${VICEDIR}

$(SOURCENAME).prg: $(SOURCENAME).asm
	$(TASS) -C -m -a -I $(TASSLIB) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
	cp -f  ${SOURCENAME}.prg ${VICEDIR}
	cp -f  ${SOURCENAME}.txt ${VICEDIR}
	cp -f  ${SOURCENAME}.prg ${PRGDIR}/prg
	cp -f  ${SOURCENAME}.txt ${PRGDIR}/txt
	cp -f  ${SOURCENAME}.asm ${PRGBIN}/asm
	cp -f  ${SOURCENAME}.prg ${PRGBIN}/prg
	cp -f  ${SOURCENAME}.txt ${PRGBIN}/txt
	#cp -f  ${SOURCENAME}.prg ${SD2IEC}/prg
	#cp -f  ${SOURCENAME}.txt ${SD2IEC}/txt
	cp -f  ${SOURCENAME}.asm ${EXPORTDIR}/asm
	cp -f  ${SOURCENAME}.prg ${EXPORTDIR}/prg
	cp -f  ${SOURCENAME}.txt ${EXPORTDIR}/txt

clean:
	rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 
	rm ${PRGDIR}/prg/$(SOURCENAME).prg
	rm ${PRGDIR}/txt/$(SOURCENAME).txt
	rm ${PRGDIR}/d64/$(SOURCENAME).d64
