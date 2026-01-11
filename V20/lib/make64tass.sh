#!/usr/local/bin/bash
if [ $1.==. ]
then
    export SOURCENAME="./main"
else   
    export SOURCENAME=${1}
fi   
export OPTION=${2}
export FTPPRGARG="cd /Usb0/d-00-64tass-bin/prg; put ${SOURCENAME}.prg; bye"
export FTPD64ARG="cd /Usb0/d-00-64tass-bin/d64; put ${SOURCENAME}.d64; bye"
export FTPCRTARG="cd /Usb0/d-00-64tass-bin/crt; put ${SOURCENAME}.crt; bye"
export FTPSVR="10.0.1.10" 
export TMPSEP06="-9 /Volumes/MACDATA/EMU_SDC/d-all-types/c64/d64/t/tu/turbo-macro-pro-sep06.d64"
/Users/daniel/bin/64tass -C -m -a -I "/Users/daniel/Documents/Mes Sources/C64/Assembleur/64tass/Sources/lib" -i ${SOURCENAME}.asm -L ${SOURCENAME}.txt -o ${SOURCENAME}.prg
/Users/Daniel/bin/c1541 -format ${SOURCENAME},0 d64 ${SOURCENAME}.d64 -attach ${SOURCENAME}.d64 -write ${SOURCENAME}.prg ${SOURCENAME}
cp -f  "${SOURCENAME}.prg" "/Users/daniel/Documents/Mes Sources/C64/bin"
cp -f  "${SOURCENAME}.d64" "/Users/daniel/Documents/Mes Sources/C64/dir-tmp-dskimg"
cp -f  "${SOURCENAME}.d64" "/Users/daniel/Documents/Mes Sources/C64/bin"
case ${OPTION} in
	"Vice36SDL")
		/Applications/vice-x86-64-sdl2-3.6.1/bin/x64sc ${TMPSEP06} ${SOURCENAME}.d64 
	;;
	"Vice36GTK")
		/Applications/vice-x86-64-gtk3-3.6.1/bin/x64sc ${TMPSEP06} ${SOURCENAME}.d64
	;;
	"Vice35SDL")
		/Applications/VICE/x64sc.app/Contents/MacOS/x64sc ${TMPSEP06} ${SOURCENAME}.d64
	;;
	"Vice35GTK")
		/Applications/vice-gtk3-3.5/bin/x64sc ${TMPSEP06} ${SOURCENAME}.d64
	;;
	Virtual44)
		/Applications/VirtualC64_4.app/Contents/MacOS/VirtualC64 ${SOURCENAME}.d64
	;;
	Virtual)
		/Applications/VirtualC64.app/Contents/MacOS/VirtualC64 ${SOURCENAME}.d64
	;;
	ftp)
		if [ -f ${SOURCENAME}.prg ]
		then 
			echo "Sending ${SOURCENAME}.prg by FTP."
		     /usr/local/bin/lftp -e "${FTPPRGARG}" ${FTPSVR}
		fi
		if [ -f ${SOURCENAME}.d64 ]
		then 
			echo "Sending ${SOURCENAME}.d64 by FTP."
			/usr/local/bin/lftp -e "${FTPD64ARG}" ${FTPSVR}
		fi
		if [ -f ${SOURCENAME}.crt ]
		then 
			echo "Sending ${SOURCENAME}.crt by FTP."
			/usr/local/bin/lftp -e "${FTPCRTARG}" ${FTPSVR}
		fi
		# /Applications/VICE/x64sc.app/Contents/MacOS/x64sc ${SOURCENAME}.d64
	;;
	*)
	echo ${SOURCENAME}.d64
	;;
esac
#/Users/Daniel/bin/x64 ${SOURCENAME}.d64
