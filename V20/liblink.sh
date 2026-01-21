#!/usr/bin/bash
cd /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/C64/sources
for I in $(find -type l -iname "lib")
do
     echo ${I}
     rm ${I}
     ln -s /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/C64/lib ${I}
done
cd /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/V20/sources
for I in $(find -type l -iname "lib")
do
     echo ${I}
     rm ${I}
     ln -s /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/V20/lib ${I}
done
