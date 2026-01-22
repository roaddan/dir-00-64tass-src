#!/usr/bin/python3
import os

def main():
    basedir="/Users/Locals/CBM/00-usbkey32go/d-00-64tass-src"
    c64lib="/C64/lib"
    for src in {basedir + c64lib + "/e-rom9000.asm", basedir + c64lib + "/e-romc000.asm"}:
        sortsrc(src)


def sortsrc(srcf):
    fname = os.path.basename(srcf)
    fpath = srcf.replace(fname,"")
    srcfptr=open(srcf,"r")
    items=srcfptr.readlines()
    srcfptr.close()
    new_items=[]
    for item in items:
        equs=item.strip().replace(" ","").split(":")[3].split("=")
        lib=item.strip().replace(" ","").split(":")[0].replace(".asm","").replace("-c64","")
        lib=lib.replace("sid-notes-ntsc","notes")
        lib=lib.replace("9000","")
        lib=lib.replace("c000","")
        nom=equs[0]
        val=equs[1]
        if val.startswith("$"):
            hex_val=val.replace("$","").strip()
            dec_val=int(hex_val,16)
        else:
            dec_val=val.strip()
            hex_val=hex(int(val)).replace("0x","")
        new_items.append("%-14s=%5s;%5s;%s" % (nom, "$"+hex_val, dec_val,lib))
    sorted_num = sorted(new_items, key=lambda line: int(line.split(';')[1].strip()))
    sorted_alpha = sorted(new_items, key=lambda line: line.split(';')[0].strip())
    fnum =  fpath + fname.replace("-","-c64-").replace(".","-num.")
    fntmp =  fpath + fname.replace("-","-c64-").replace(".","-ntmp.")

    outptr = open(fnum,"w")
    tmpnptr = open(fntmp,"w")
    for i in sorted_num:
        outptr.writelines(i+"\r")
        tmpnptr.writelines(i.upper()+"\r")
    outptr.close()
    tmpnptr.close()

    falpha = fpath + fname.replace("-","-c64-").replace(".","-alpha.")
    fatmp = fpath + fname.replace("-","-c64-").replace(".","-atmp.")
    outptr = open(falpha,"w")
    tmpaptr = open(fatmp,"w")
    for i in sorted_alpha:
        outptr.writelines(i+"\r")
        tmpaptr.writelines(i.upper()+"\r")
    outptr.close()
    tmpaptr.close()
    print(fnum)
    print(falpha)


if __name__ == "__main__":
    main()