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
    outptr = open(fnum,"w")
    for i in sorted_num:
        outptr.writelines(i+"\r")
    outptr.close()
    falpha = fpath + fname.replace("-","-c64-").replace(".","-alpha.")
    outptr = open(falpha,"w")
    for i in sorted_alpha:
        outptr.writelines(i+"\r")
    outptr.close()
    print(fnum)
    print(falpha)


def sortfile(srcf):
    srcfptr=open(srcf,"r")
    items=srcfptr.readlines()
    srcfptr.close()
    new_items=[]
    count = 0
    for item in items:
        count +=1
        if len(item.strip())>5:
            item = item.replace(" ","")
            #print(item, end='')
            parts = item.split("=")
            nom=parts[0]
            number=parts[1]
            nums=number.split(";")
            if number.startswith("$"):
                hex_num=nums[0].replace("$","").strip()
                dec_num=int(hex_num,16)
            else:
                dec_num=nums[0].strip()
                hex_num=hex(int(nums[0])).replace("0x","")
            new_items.append("%-16s= %5s;%6s ; %3d" % (nom, "$"+hex_num,dec_num,count))
            # print("%-16s= %5s;%6s ; %3d" % (nom, "$"+hex_num,dec_num,count))
    sorted_data = sorted(new_items, key=lambda line: int(line.split(';')[1].strip()))
    srcf=basedir + c64lib + "e-c64-rom9000.asm"
    srcfptr = open(srcf, "w")
    for item in sorted_data:
        srcfptr.write(item+"\n")
        print(item)
    srcfptr.close()

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