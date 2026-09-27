#!/usr/bin/bash
cd /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/C64/lib
clear
for I in Makefile
do
export MAKFIL=${I}
echo ${MAKFIL}
find /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/C64/sources -type f -iname "${MAKFIL}" -exec cp /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/C64/lib/${MAKFIL} {} \;
done
#endscript
