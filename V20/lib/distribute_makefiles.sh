#!/usr/bin/bash
cd /Users/Locals/C64/00-usbkey32go/d-00-64tass-src/lib
clear
for I in Makefile Makefile.linux Makefile.macbpro Makefile.macos Makefile.macmini Makefile.mintpro2
do
export MAKFIL=${I}
echo ${MAKFIL}
find /Users/Locals/C64/00-usbkey32go/d-00-64tass-src -type f -iname "${MAKFIL}" -exec cp /Users/Locals/C64/00-usbkey32go/d-00-64tass-src/lib/${MAKFIL} {} \;
done
#endscript
