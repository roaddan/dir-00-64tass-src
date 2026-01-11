#!/bin/python3

def main():
    fptr=open("l-opcodes.bk4","r")
    
    contenu = fptr.readlines()
    #print(contenu)
    mnemonics=list()
    modes=list()
    opperhex=list()
    opperdec=list()
    bytelen=list()
    cycles=list()
    count=0
    for line in contenu:
        mne,mod,opph,oppd,byte,cycle = line.split(";")
        curoppd = int(str(oppd))
        #if count % 16 == 0:
            #print()
        while count < curoppd and count < 256:
            #print(str(count) + ":" + "noop", end=";")
            mnemonics.append("---")
            modes.append("-")
            opperhex.append("-")
            opperdec.append(count)
            bytelen.append(0)
            cycles.append(0)
            count+=1
            #if count % 16 == 0:
                #print()
        #print(str(count) + ":" + str(mne), end=";")
        mnemonics.append(mne)
        modes.append(mod)
        opperhex.append(opph)
        opperdec.append(oppd)
        bytelen.append(byte)
        cycles.append(cycle)
        count+=1
        #if count % 16 == 0:
            #print()
    while count < 256 :
        #print(str(count) + ":" + "noop", end=";");
        mnemonics.append("---")
        modes.append("-")
        opperhex.append("-")
        opperdec.append(count)
        bytelen.append(0)
        cycles.append(0)
        count+=1
        #if count % 16 == 0:
            #print()
    dline=8
    outf=open("../l-opmneumo.asm","w") 
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("; Table de mneumoniques\r\n".upper())
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("mneumon \r\n".upper())
    count = 0
    for x in mnemonics:
        if count % dline == 0:
            outf.write("\"\r\n\t.text \"".upper())
            print()
        else:
            outf.write(",")
        outf.write(str(x).upper())    
        print('"' + str(x) + '",' , end="")
        count+=1
    outf.close()
    
    outf=open("../l-opcodes.asm","w")     
    outf.write("\r\n;---------------------------------------\r\n".upper())
    outf.write("; Table des operandes hexadecimaux\r\n".upper())
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("opcode \r\n".upper())
    count = 0
    outf.write("\r\n")
    for x in opperhex:
        if count % dline == 0 and count != 0:
            outf.write("\r\n\t.byte ".upper())
            print()
        else:
            outf.write(",".upper())
        if str(x) == "-":
            outf.write("$ff".upper())
        else:
            outf.write(str(x).upper())    
        print(str(x) + ',' , end="")
        count+=1
    outf.close()
    
    outf=open("../l-opmodes.asm","w") 
    outf.write("\r\n;---------------------------------------\r\n".upper())
    outf.write("; Table des modes d'adressage.\r\n")
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("; mode d'adressage\r\n".upper())
    outf.write("; 0 = implicite ;0;\r\n".upper())
    outf.write("; 1 = accumulateur ;1;\r\n".upper())
    outf.write("; 2 = immediat ;2;\r\n".upper())
    outf.write("; 3 = absolue ;3;\r\n".upper())
    outf.write("; 4 = relatif ;4;\r\n".upper())
    outf.write("; 5 = absolue,x ;5;\r\n".upper())
    outf.write("; 6 = absolue,y ;6;\r\n".upper())
    outf.write("; 7 = zero page ;7;\r\n".upper())
    outf.write("; 8 = zero page,x ;8;\r\n".upper())
    outf.write("; 9 = zero page,y ;9;\r\n".upper())
    outf.write("; 10 = (zero page,x) ;10;\r\n".upper())
    outf.write("; 11 = (zeropage),y ;11;\r\n".upper())
    outf.write("; 12 = (absolue ind) ;12;\r\n".upper())
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("opmodes, \r\n".upper())
    count = 0
    for x in modes:
        if count % dline == 0 and count != 0:
            outf.write("\r\n\t.byte ".upper())
            print()
        else:
            outf.write(",".upper())
        if str(x) == "-":
            outf.write("  0".upper())
        else:
            outf.write("%3s"%(str(x).rstrip()).upper())    
        print(str(x) + ',' , end="")
        count+=1
    outf.close()
    
    outf=open("../l-oplenght.asm","w") 
    outf.write("\r\n;---------------------------------------\r\n".upper())
    outf.write("; Table des nombrer d'octets\r\n".upper())
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("opbytes \r\n".upper())
    count = 0
    outf.write("\r\n".upper())
    for x in bytelen:
        if count % dline == 0 and count != 0:
            outf.write("\r\n\t.byte ".upper())
            print()
        else:
            outf.write(",".upper())
        if str(x) == "-":
            outf.write("255".upper())
        else:
            outf.write("%3s"%(str(int(x))).upper())    
        print(str(int(x)) + ',' , end="")
        count+=1
    outf.close()
    outf=open("../l-opcycles.asm","w") 
    outf.write("\r\n;---------------------------------------\r\n".upper())
    outf.write("; Table des cycles\r\n".upper())
    outf.write(";---------------------------------------\r\n".upper())
    outf.write("opcycles \r\n".upper())
    count = 0
    for x in cycles:
        if count % dline == 0 and count != 0:
            outf.write("\r\n\t.byte ".upper())
            print()
        else:
            outf.write(",".upper())
        if str(x) == "-":
            outf.write("0".upper())
        else:
            outf.write("%3s"%(str(x).rstrip()).upper())    
        print(str(x).rstrip() + ',' , end="")
        count+=1
    outf.close()
    fptr.close()


def fillemptyfile():
    fptr=open("opcodes.asm","w")
    fptr.write(";mneum,mode,Hex,dec,bytes,tics\r\n")
    for I in range(0,256):
        fptr.write("mneu%03d,mode,$%02x,%03d,1,5\r\n" % (I,I,I))
    fptr.close()


if __name__ == "__main__":
    main()