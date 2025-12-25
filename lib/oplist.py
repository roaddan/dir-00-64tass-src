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
    outf=open("optables.asm","w") 
    outf.write(";---------------------------------------\n")
    outf.write("; Table de mneumoniques\n")
    outf.write(";---------------------------------------\n")
    outf.write("mneumon \n")
    count = 0
    for x in mnemonics:
        if count % 6 == 0:
            outf.write("\"\n\t.text \"")
            print()
        else:
            outf.write(",")
        outf.write(str(x))    
        print('"' + str(x) + '",' , end="")
        count+=1
    outf.write("\n;---------------------------------------\n")
    outf.write("; Table des operandes hexadecimaux\n")
    outf.write(";---------------------------------------\n")
    outf.write("opcode \n")
    count = 0
    outf.write("\n")
    for x in opperhex:
        if count % 6 == 0 and count != 0:
            outf.write("\n\t.byte ")
            print()
        else:
            outf.write(",")
        if str(x) == "-":
            outf.write("$ff")
        else:
            outf.write(str(x))    
        print(str(x) + ',' , end="")
        count+=1
    
    outf.write("\n;---------------------------------------\n")
    outf.write("; Table des modes d'adressage.\n")
    outf.write(";---------------------------------------\n")
    outf.write("; mode d'adressage\n")
    outf.write("; 0 = implicite ;0;\n")
    outf.write("; 1 = accumulateur ;1;\n")
    outf.write("; 2 = immediat ;2;\n")
    outf.write("; 3 = absolue ;3;\n")
    outf.write("; 4 = relatif ;4;\n")
    outf.write("; 5 = absolue,x ;5;\n")
    outf.write("; 6 = absolue,y ;6;\n")
    outf.write("; 7 = zero page ;7;\n")
    outf.write("; 8 = zero page,x ;8;\n")
    outf.write("; 9 = zero page,y ;9;\n")
    outf.write("; 10 = (zero page,x) ;10;\n")
    outf.write("; 11 = (zeropage),y ;11;\n")
    outf.write("; 12 = (absolue ind) ;12;\n")
    outf.write(";---------------------------------------\n")
    outf.write("opmodes, \n")
    count = 0
    for x in modes:
        if count % 6 == 0 and count != 0:
            outf.write("\n\t.byte ")
            print()
        else:
            outf.write(",")
        if str(x) == "-":
            outf.write("  0")
        else:
            outf.write("%3s"%(str(x).rstrip()))    
        print(str(x) + ',' , end="")
        count+=1

    outf.write("\n;---------------------------------------\n")
    outf.write("; Table des operandes décimales\n")
    outf.write(";---------------------------------------\n")
    outf.write("deccode \n")
    count = 0
    outf.write("\n")
    for x in opperdec:
        if count % 6 == 0 and count != 0:
            outf.write("\n\t.byte ")
            print()
        else:
            outf.write(",")
        if str(x) == "-":
            outf.write("255")
        else:
            outf.write("%3s"%(str(int(x))))    
        print(str(int(x)) + ',' , end="")
        count+=1

    outf.write("\n;---------------------------------------\n")
    outf.write("; Table des nombrer d'octets\n")
    outf.write(";---------------------------------------\n")
    outf.write("opbytes \n")
    count = 0
    outf.write("\n")
    for x in bytelen:
        if count % 6 == 0 and count != 0:
            outf.write("\n\t.byte ")
            print()
        else:
            outf.write(",")
        if str(x) == "-":
            outf.write("255")
        else:
            outf.write("%3s"%(str(int(x))))    
        print(str(int(x)) + ',' , end="")
        count+=1
                    
    outf.write("\n;---------------------------------------\n")
    outf.write("; Table des cycles\n")
    outf.write(";---------------------------------------\n")
    outf.write("opcycles \n")
    count = 0
    for x in cycles:
        if count % 6 == 0 and count != 0:
            outf.write("\n\t.byte ")
            print()
        else:
            outf.write(",")
        if str(x) == "-":
            outf.write("0")
        else:
            outf.write("%3s"%(str(x).rstrip()))    
        print(str(x).rstrip() + ',' , end="")
        count+=1
        
        
        
        
    outf.close()
    fptr.close()


def fillemptyfile():
    fptr=open("opcodes.asm","w")
    fptr.write(";mneum,mode,Hex,dec,bytes,tics\n")
    for I in range(0,256):
        fptr.write("mneu%03d,mode,$%02x,%03d,1,5\n" % (I,I,I))
    fptr.close()


if __name__ == "__main__":
    main()