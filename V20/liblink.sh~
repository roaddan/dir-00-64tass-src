#!/usr/bin/bash
export C64SRCDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/C64/sources"
export C64LIBDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/C64/lib"
export V20SRCDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/V20/sources"
export V20LIBDIR="/Users/Locals/CBM/00-usbkey32go/dir-00-64tass-src/V20/lib"
cd ${C64SRCDIR}
for I in $(find -type l -iname "lib")
do
     echo ${I}
     rm ${I}
     ln -s ${C64LIBDIR} ${I}
done
cd ${V20SRCDIR}
for I in $(find -type l -iname "lib")
do
     echo ${I}
     rm ${I}
     ln -s ${V20LIBDIR} ${I}
done
