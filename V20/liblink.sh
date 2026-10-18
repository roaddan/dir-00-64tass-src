#!/usr/bin/bash
export V20SRCDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/V20/sources"
export V20LIBDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/V20/lib"
cd ${V20SRCDIR}
for I in $(find -type l -iname "lib")
do
     echo ${I}
     rm ${I}
     ln -s ${V20LIBDIR} ${I}
done

for I in $(find ${V20SRCDIR} -type f -iname "Makefile")
do
    echo ${I}
    cp -f ${V20LIBDIR}/Makefile ${I}
done

for I in $(find ${V20SRCDIR} -type f -iname "Makefile.linux")
do
    echo ${I}
    cp -f ${V20LIBDIR}/Makefile.linux ${I}
done

for I in $(find ${V20SRCDIR} -type f -iname "Makefile.macos")
do
    echo ${I}
    cp -f ${V20LIBDIR}/Makefile.macos ${I}
done
