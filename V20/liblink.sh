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
