SOURCENAME=template
BASEDIR=/Users/Locals/CBM/00-usbkey32go
VICEDIR=/Users/Locals/temp/Vice
SD2IEC=/media/daniel/SD2IECV20/d-remote
V20=/usr/bin/xvic
X64=/usr/bin/x64
X64SC=/usr/bin/x64sc
C1541=/usr/bin/c1541
TASS=/usr/bin/64tass
TASSLIB=/Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/V20/lib
TMPSEP06=-9 $(BASEDIR)/dir-tmp-dskimg/turbo-macro-pro-sep06.d64
V20UTILDIR=/Users/Locals/Vic20/utils
V20MKASM=-9 ${V20UTILDIR}/V20MikroAsmbler.d64
V20MON=-9 ${V20UTILDIR}/vicmon.d64
V20MON6000=-9 ${V20UTILDIR}/vicmon-6000.d64
PRGBIN=/d-00-64tass-src/V20/prgbin
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
	$(VICE) $(V20MON) -autostart $(BASEDIR)/$(PRGDIR)/d81/$(SOURCENAME).d81:$(SOURCENAME) 

$(SOURCENAME).d64: $(SOURCENAME).prg
	$(C1541) -format $(SOURCENAME),0 d64 $(SOURCENAME).d64 -attach $(SOURCENAME).d64 \
	-write ${V20UTILDIR}/fb fb \
	-write $(SOURCENAME).prg $(SOURCENAME) \
	-write ${V20UTILDIR}/screenfmt.P00 screenfmt \
	-write ${V20UTILDIR}/vicmonb-sys45056.prg vicmonb-sys45056 \
	-write ${V20UTILDIR}/Vicmon-2-b000.prg vicmon-2-b000 \
	-write ${V20UTILDIR}/fb20 fb20 \
	-write ${V20UTILDIR}/fb20-3k fb20-3k \
	-write ${V20UTILDIR}/fb20-8k fb20-8k \
	-write ${V20UTILDIR}/fb20-mc fb20-mc
	$(C1541) -format $(SOURCENAME),0 d81 $(SOURCENAME).d81 -attach $(SOURCENAME).d81 \
	-write ${V20UTILDIR}/fb fb \
	-write $(SOURCENAME).prg $(SOURCENAME) \
	-write ${V20UTILDIR}/screenfmt.P00 screenfmt \
	-write ${V20UTILDIR}/vicmonb-sys45056.prg vicmonb-sys45056 \
	-write ${V20UTILDIR}/Vicmon-2-b000.prg vicmon-2-b000 \
	-write ${V20UTILDIR}/fb20 fb20 \
	-write ${V20UTILDIR}/fb20-3k fb20-3k \
	-write ${V20UTILDIR}/fb20-8k fb20-8k \
	-write ${V20UTILDIR}/fb20-mc fb20-mc
	cp -f  ${SOURCENAME}.asm ${BASEDIR}/${PRGBIN}/asm
	cp -f  ${SOURCENAME}.prg ${BASEDIR}/${PRGBIN}/prg
	cp -f  ${SOURCENAME}.txt ${BASEDIR}/${PRGBIN}/txt
	cp -f  ${SOURCENAME}.d81 ${BASEDIR}/${PRGBIN}/d81
	cp -f  ${SOURCENAME}.d64 ${BASEDIR}/${PRGBIN}/d64
	cp -f  ${SOURCENAME}.d81 ${BASEDIR}/${PRGBIN}/d81
	cp -f  ${SOURCENAME}.d64 ${BASEDIR}/${PRGDIR}/d64
	cp -f  ${SOURCENAME}.d81 ${BASEDIR}/${PRGDIR}/d81
	#cp -f  ${SOURCENAME}.d64 ${SD2IEC}/d64
	cp -f  ${SOURCENAME}.d64 ${VICEDIR}
	cp -f  ${SOURCENAME}.d81 ${VICEDIR}
$(SOURCENAME).prg: $(SOURCENAME).asm
	$(TASS) -C -m -a -I $(TASSLIB) -i $(SOURCENAME).asm -L $(SOURCENAME).txt -o $(SOURCENAME).prg
	cp -f  ${SOURCENAME}.prg ${BASEDIR}/${PRGDIR}/prg
	#cp -f  ${SOURCENAME}.prg ${SD2IEC}/prg
	cp -f  ${SOURCENAME}.prg ${VICEDIR}
	cp -f  ${SOURCENAME}.txt ${BASEDIR}/${PRGDIR}/txt
	#cp -f  ${SOURCENAME}.txt ${SD2IEC}/txt
	cp -f  ${SOURCENAME}.txt ${VICEDIR}

clean:
	rm $(SOURCENAME).txt $(SOURCENAME).prg $(SOURCENAME).d64 
	rm ${BASEDIR}/${PRGDIR}/prg/$(SOURCENAME).prg
	rm ${BASEDIR}/${PRGDIR}/txt/$(SOURCENAME).txt
	rm ${BASEDIR}/${PRGDIR}/d64/$(SOURCENAME).d64
