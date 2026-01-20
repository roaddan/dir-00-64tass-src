#!/usr/bin/bash
cd /Users/Locals/CBM/00-usbkey32go/d-00-64tass-src/C64/sources
for I in $(find -type l -iname "lib")
do
     echo "$I"
done