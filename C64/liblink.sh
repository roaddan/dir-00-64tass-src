#!/usr/bin/bash
export C64SRCDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/C64/sources"
export C64LIBDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/C64/lib/libstd"
cd ${C64SRCDIR}
for I in $(find -type l -iname "lib")
do
     echo ${I}
     rm ${I}
     ln -s ${C64LIBDIR} ${I}
done

for I in $(find -type f -iname "Makefile")
do
    echo ${I}
    cp -f ${C64LIBDIR}/Makefile ${I}
done

for I in $(find -type f -iname "Makefile.linux")
do
    echo ${I}
    cp -f ${C64LIBDIR}/Makefile.linux ${I}
done

for I in $(find -type f -iname "Makefile.macos")
do
    echo ${I}
    cp -f ${C64LIBDIR}/Makefile.macos ${I}
done

