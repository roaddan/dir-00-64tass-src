#!/usr/bin/python3
#import grub as g


def main():
    srcf="/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/From-Books/0-pc-64tass-book-disks/99-TurboMacroPro/lib/e-c64-romc000.asm"
    srcfptr=open(srcf,"r")
    items=



def sortedfiles():
    srcf="e-romx000.txt"
    srcptr=open(srcf,"r")
    items=srcptr.readlines()
    for lib in ( "e-64map","e-float","e-vars","l-bitmap", "l-conv", "l-float", "l-keyb", "l-conv","l-mem","l-push",\
                "l-string","" ):
        dstptr=open(lib+".ref","w")
        for item in items:
            if lib in item:
                dstptr.write(item.replace("\n","\r"))
                print(item)
        dstptr.close()
    print("It's alive!")
    srcptr.close()

if __name__ == "__main__":
    main()