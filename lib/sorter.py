#!/usr/bin/python3
#import grub as g


def main():
    srcf="/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/From-Books/0-pc-64tass-book-disks/99-TurboMacroPro/lib/e-c64-rom9000-back.asm"
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
                pass
                hex_num=nums[0].replace("$","").strip()
                dec_num=int(hex_num,16)
            else:
                dec_num=nums[0].strip()
                hex_num=hex(int(nums[0])).replace("0x","")
            new_items.append("%-16s= %5s;%6s ; %3d" % (nom, "$"+hex_num,dec_num,count))
            # print("%-16s= %5s;%6s ; %3d" % (nom, "$"+hex_num,dec_num,count))
    sorted_data = sorted(new_items, key=lambda line: int(line.split(';')[1].strip()))
    srcf="/Users/Locals/C64/00-usbkey32go/d-00-64tass-src/C64/From-Books/0-pc-64tass-book-disks/99-TurboMacroPro/lib/e-c64-rom9000.asm"
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