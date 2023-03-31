;--------------------------------------------------------------------------------
; c64_map.asm - Carthographie memoire et declaration de constantes pour les
; commodores 64 et 64c
;--------------------------------------------------------------------------------
; Scripteur...: daniel lafrance, j5w 1w5, canada.
; Version.....: 20230328-095101
; Inspiration.: isbn 0-87455-082-3
;--------------------------------------------------------------------------------
; Segmentation principales de la mÃ©moire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "c64_map.s"
;
; ... en prenant soin de placer le fichier dans le meme disque ou rÃ©pertoire que
; votre programme.
;--------------------------------------------------------------------------------
;* macro sur les elements importants *
;--------------------------------------------------------------------------------
u6510ddr        =       $00     ;   0 6510 port data dir. reg. (def: %xx101111)
                                ;        (0=input, 1=output)
u6510map        =       $01     ;   1 6510 port used as memory map reg.
                                ;     bit-0 LORAM select ROM or RAM at $a000
                                ;           1=Basic rom, 0=RAM          
                                ;     bit-1 HIRAM select ROM or RAM at $e000
                                ;           1=Kernal rom, 0=RAM          
                                ;     bit-2 CHARGEN signal
                                ;           1=Device I/O, 0=CharRom          
                                ;     bit-3 Cassette Data Output line          
                                ;     bit-4 Cassette switch sense
                                ;         Reads button 0=Pressed, 1=Released          
                                ;     bit-5 Cassette motor control
                                ;         1=Motor on, 0=Motor off
                                ;     bits 6 and 7 unused.
unused2         =       $02     ;   2 unused.                
adray1          =       $03     ; 3-4 Vector to routine to convert a number ...
                                ;     ... from floating pointto signed integer.                                            
adray1          =       $05     ; 5-6 Vector to routine to convert a number ...
                                ;     ... from integer to floating point.
b_charac        =       $07     ;   7 Search character for scanning ...
                                ;     ... BASIC text input.
b_endchr        =       $08     ;   8 Search character for scanning ... 
                                ;     ... BASIC statement terminator or quote.
b_trmpos        =       $09     ;   9 Cursor column position before the ...
                                ;     ... last TAB or SPC.
verck           =       $0a     ;  10 Flag: 0=Load or 1=Check
b_count         =       $0b     ;  11 Index into the Text Input Buffer ... 
                                ;     ... /Number of Array Subscripts.
dimflg          =       $0c     ;  12 Flags for routine that locate or build array.
valtyp          =       $0d     ;  13 Flag: Type of data ($ff=string or $00=numeric)
intflg          =       $0e     ;  14 Numeric data Type ($80=Integer or $00=Float)
garbfl          =       $0f     ;  15 Flag for list, Garbage collection, ...
                                ;          ... and program tokenization.
subflg          =       $10     ;  16 Flag: Subscript reference to an array or ...
                                ;           ... a User-Defined function call (FN).
inpflg          =       $11     ;  17 Flag: Is data input to GET, READ or INPUT.
                                ;           ($98=READ, $40=GET, $00=INPUT)                                                                      
tansgn          =       $12     ;  18 Flag: Sign of result of TAN or SIN.
channl          =       $13     ;  19 Current i/o channel # (CMD logical file).
linnum          =       $14     ;  20-21 Integer line number value.
temppt          =       $16     ;  22 Ptr to next space in temp. string stack.
lastpt          =       $17     ;  23-24 Ptr to last string in temp. string stack.
txttab          =       $2b     ;  43-44 Ptr to start of BASIC Program text.
vartab          =       $2d     ;  45-46 Ptr to start of BASIC Variable area.
arytab          =       $2f     ;  47-48 Ptr to start of BASIC Array area.
strebd          =       $31     ;  49-50 Ptr to END of BASIC Array area(+1) ...
                                ;        ... and start of free RAM.
fretop          =       $33     ;  51-52 Ptr to bottom of string text area.
frespc          =       $35     ;  53-54 Temp. ptr for string.
memsiz          =       $37     ;  55-56 Ptr to highest address used by BASIC.
curlib          =       $39     ;  57-58 Current BASIC line number.
oldlin          =       $3b     ;  59-60 Previous BASIC line number.
oldtxt          =       $3d     ;  61-62 Ptr to current BASIC statement address.
datlin          =       $3f     ;  63-64 Current DATA line number.
datptr          =       $41     ;  65-66 Current DATA item address ptr.
impptr          =       $43     ;  67-68 GET, READ or INPUT info. source ptr.
varnam          =       $45     ;  69-70 Current BASIC variable name.
varpnt          =       $47     ;  71-72 Ptr to current BASIC variable value.
forpnt          =       $49     ;  73-74 Temp Ptr to index variable used by FOR.
opptr           =       $4b     ;  75-76 Math operator table displacement.
opmask          =       $4d     ;  77 Mask for comparison operation.
defpnt          =       $4e     ;  78-79 Pointer to current FN descriptor.
dscpnt          =       $50     ;  80-82 Tmp ptr to current string descriptor.
                                ;        80-81 ptr to string
                                ;        82    string length
four6           =       $53     ;  83 Constant of garbage collector.
jmper           =       $54     ;  84-86 Jump to function Instruction.
fac1            =       $61     ; 97-102 Floating point Accumulator #1
;ICI
chrget          =       $73     ; 115
chrgot          =       $79     ; 121
kiostatus       =       $90     ; 144 Kernal I/O status word (st) (byte) 
curfnlen        =       $b7     ; 183 Current filename length (byte)
cursecadd       =       $b9     ; 185 Current secondary address (byte)
curdevno        =       $ba     ; 186 Current device number (byte)
curfptr         =       $bb     ; 187 Current file pointer (word)  
lstx            =       $c5     ; 197 matrix coordinate of last key pressed
ndx             =       $c6     ; 198 Number of character in keyboard buffer
zpage1          =       $fb     ; 251 zero page 1 address (word)
zpage2          =       $fd     ; 253 zero page 2 address (word)
zeropage        =       zpage1
zonepage        =       zpage2
kbbuff          =       $277    ; 631        
carcol          =       $286    ; 646 basic next chr colscreenram (byte)
kcarcol         =       carcol
bascol          =       carcol
shflag          =       $28d    ; 653
ieval           =       $30a
cinv            =       $314    ; $314-$315 brk instruction interupt
tbuffer         =       $33c    ; 828
ibsout          =       $326    ; 806
tpbuff          =       $33c    ; $033c-$03fb (828-1019)
scrnram         =       $400    ; 1024 video character ram
scrram0         =       scrnram ; 1024
scrram1         =       $500    ; 1280
scrram2         =       $600    ; 1536
scrram3         =       $700    ; 1792
basicsta        =       $801    ; 2049  basic start address
basicrom        =       $a000   ; 40960 Basic rom base address
sid             =       $d400   ; 54272 sid base address
colorram        =       $d800   ; 55296 video color ram
colram0         =       colorram; 55296
colram1         =       $d900   ; 55552
colram2         =       $da00   ; 55808
colram3         =       $db00   ; 56064
; ------------------------------------------------------------
; - C O M P L E X   I N T E R F A C E   A D A P T O R   # 1
; ------------------------------------------------------------
cia1            =       $dc00   ; 56320 cia1 base address
cia1pra         =       $dc00   ; 56320 cia1 dataport A (keyboard column Write)
cia1prb         =       $dc01   ; 56321 cia1 dataport B (keyboard row read)
cia1ddra        =       $dc02   ; 56322 cia1 data direction A
cia1ddrb        =       $dc03   ; 56323 cia1 data direction B
cia1tmalo       =       $dc04   ; 56324 cia1 timer A low byte
cia1tmahi       =       $dc05   ; 56325 cia1 timer A high byte
cia1tmblo       =       $dc06   ; 56326 cia1 timer B low byte
cia1tmbhi       =       $dc07   ; 56327 cia1 timer B high byte
cia1todten      =       $dc08   ; 56328 cia1 time of day clock seconds/10
cia1todsec      =       $dc09   ; 56329 cia1 time of day clock seconds
cia1todmin      =       $dc0a   ; 56330 cia1 time of day clock minutes
cia1todhrs      =       $dc0b   ; 56331 cia1 time of day clock hours
cia1sdr         =       $dc0c   ; 56332 cia1 serial data port
cia1icr         =       $dc0d   ; 56333 cia1 Interupt control register
cia1cra         =       $dc0e   ; 56334 cia1 control register A
cia1crb         =       $dc0f   ; 56335 cia1 control register B
; ------------------------------------------------------------
; - C O M P L E X   I N T E R F A C E   A D A P T O R   # 2
; ------------------------------------------------------------
cia2            =       $dd00   ; 56576 cia2 base address
cia2pra         =       $dd00   ; 56576 cia2 dataport A
cia2prb         =       $dd01   ; 56577 cia2 dataport B
cia2ddra        =       $dd02   ; 56578 cia2 data direction A
cia2ddrb        =       $dd03   ; 56579 cia2 data direction B
cia2tmalo       =       $dd04   ; 56580 cia2 timer A low byte
cia2tmahi       =       $dd05   ; 56581 cia2 timer A high byte
cia2tmblo       =       $dd06   ; 56582 cia2 timer B low byte
cia2tmbhi       =       $dd07   ; 56583 cia2 timer B high byte
cia2todten      =       $dd08   ; 56584 cia2 time of day clock seconds/10
cia2todsec      =       $dd09   ; 56585 cia2 time of day clock seconds
cia2todmin      =       $dd0a   ; 56586 cia2 time of day clock minutes
cia2todhrs      =       $dd0b   ; 56587 cia2 time of day clock hours
cia2sdr         =       $dd0c   ; 56588 cia2 serial data port
cia2icr         =       $dd0d   ; 56589 cia2 Interupt control register
cia2cra         =       $dd0e   ; 56590 cia2 control register A
cia2crb         =       $dd0f   ; 56501 cia2 control register B

kernalrom       =       $e000   ; 57344 start of kernal rom
irq             =       $ea31   ; 59953 irq entry point
;--------------------------------------------------------------------------------
;* Basic petscii control characters 
;  when printed with ?chr$(##) or jsr $ffd2 
;  Where keystroke are shown, []+[]=combined 
;--------------------------------------------------------------------------------
bstop           =       $03     ;  03 [STOP]
bwhite          =       $05     ;  05 [CTRL]+[2]        Set colour to WHITE
block           =       $08     ;  08 [SHIFT]+[C=]      disabled char map switch
bunlock         =       $09     ;  09 [SHIFT]+[C=]      enabled. char map switch
bcarret         =       $0d     ;  11 [RETURN]
btext           =       $0e     ;  14 select Uppercase+lowercase charset
bcrsdn          =       $11     ;  17 [CRS-D]           Cursor DOWN 1 line
brevcol         =       $12     ;  18 [CTRL]+[9]        REVERSE VIDEO ON
bhome           =       $13     ;  19 [HOME]            Cursor HOME
bdelete         =       $14     ;  20 [DELETE]          Delete 1 char
bred            =       $1c     ;  28 [CTRL]+[3]        Set colour to RED
bcuright        =       $1d     ;  29 [CRS-R]           Cursor RIGHT
bgreen          =       $1e     ;  30 [CTRL]+[6]        Set colour to GREEN
bblue           =       $1f     ;  31 [CTRL]+[7]        Set colour to BLUE
borange         =       $81     ; 129 [C=]+[1]          Set colour to ORANGE
bfkey1          =       $85     ; 133 [F1]
bfkey2          =       $86     ; 134 [F2]
bfkey3          =       $87     ; 135 [F3]
bfkey4          =       $88     ; 136 [F4]
bfkey5          =       $89     ; 137 [F5]
bfkey6          =       $8a     ; 138 [F6]
bfkey7          =       $8b     ; 139 [F7]
bfkey8          =       $8c     ; 140 [F8]
bcarret1        =       $8d     ; 141 [SHIFT]+[RETURN]
bgraph          =       $8e     ; 142 select Uppercase+graphics charset
bblack          =       $90     ; 144 [CTRL]+[1]        Set colour to BLACK
bcuup           =       $91     ; 145 [SHIFT]+[CRS-D]   cursor UP 1 line
brevoff         =       $92     ; 146 [CTRL]+[0]        REVERSE VIDEO OFF
bclear          =       $93     ; 147 [SHIFT]+[HOME]    CLEAR SCREEN
binsert         =       $94     ; 148 [SHIFT]+[DELETE]  INSERT a char
bbrown          =       $95     ; 149 [C=]+[2]          Set colour to BROWN
bltred          =       $96     ; 150 [C=]+[3]          Set colour to PINK
bdkgrey         =       $97     ; 151 [C=]+[4]          Set colour to DARK GREY
bmdgrey         =       $98     ; 152 [C=]+[5]          Set colour to MEDIUM GREY
bltgreen        =       $99     ; 153 [C=]+[6]          Set colour to LIGHT GREEN
bltblue         =       $9a     ; 154 [C=]+[7]          Set colour to LIGHT BLUE
bltgrey         =       $9b     ; 155 [C=]+[8]          Set colour to LIGHT GREY
bmagenta        =       $9c     ; 156 [CTRL]+[5]        Set colour to MAGENTA
bculeft         =       $9d     ; 157 [SHIFT]+[CRS-R]   cursor RIGHT 1 pos
byellow         =       $9e     ; 158 [CTRL]+[8]        Set colour to YELLOW 
bcyan           =       $9f     ; 159 [CTRL]+[4]        Set colour to CYAN
bspace1         =       $a0     ; 169                   space
bspace2         =       $e0     ; 224                   space
;+----+----------------------+-------------------------------------------------------------------------------------------------------+
;|    |                      |                                Peek from $dc01 (code in paranthesis):                                 |
;|row:| $dc00:               +------------+------------+------------+------------+------------+------------+------------+------------+
;|    |                      |   BIT 7    |   BIT 6    |   BIT 5    |   BIT 4    |   BIT 3    |   BIT 2    |   BIT 1    |   BIT 0    |
;+----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
;|1.  | #%11111110 (254/$fe) | DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
;|2.  | #%11111101 (253/$fd) |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
;|3.  | #%11111011 (251/$fb) |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
;|4.  | #%11110111 (247/$f7) |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
;|5.  | #%11101111 (239/$ef) |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
;|6.  | #%11011111 (223/$df) |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
;|7.  | #%10111111 (191/$bf) |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   Â£   ($1c)|
;|8.  | #%01111111 (127/$7f) | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
;+----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
; +==========================================================================+
; |     c o u l e u r s   p o s s i b l e   d e s   c a r a c t e r e s      |
; +==========================================================================+
; | dec | hex |  binaire  | couleur    || dec | hex |  binaire  | couleur    |
; +-----+-----+-----------+------------++-----+-----+-----------+------------+
; |  0  | $0  | b00000000 | noir       ||  1  | $1  | b00000001 | blanc      |
; |  2  | $0  | b00000010 | rouge      ||  3  | $3  | b00000011 | ocean      |
; |  4  | $0  | b00000100 | mauve      ||  5  | $5  | b00000101 | vert       |
; |  6  | $0  | b00000110 | bleu       ||  7  | $7  | b00000111 | jaune      |
; |  8  | $0  | b00001000 | orange     ||  9  | $9  | b00001001 | brun       |
; | 10  | $0  | b00001010 | rose       || 11  | $b  | b00001011 | gris fonce |
; | 12  | $0  | b00001100 | gris moyen || 13  | $d  | b00001101 | vert pale  |
; | 14  | $0  | b00001110 | blue pale  || 15  | $f  | b00001111 | gris pale  |
; +-----+-----+-----------+------------++-----+-----+-----------+------------+
; constantes de couleurs en franÃ§ais.
cnoir       = $0
cblanc      = $1
crouge      = $2
cocean      = $3
cmauve      = $4
cvert       = $5
cbleu       = $6
cjaune      = $7
corange     = $8
cbrun       = $9
crose       = $a
cgrisfonce  = $b
cgrismoyen  = $c
cvertpale   = $d
cbleupale   = $e
cgrispale   = $f
; pour anglosaxons
cblack      = $0
cwhite      = $1
cred        = $2
ccyan       = $3
cpurple     = $4
cgreen      = $5
cblue       = $6
cyellow     = $7
;corange     = $8 ; same as french :-)
cbrown      = $9
clightred   = $a
cdarkgray   = $b
cmidgray    = $c
clightgreen = $d
clightblue  = $e
clightgray  = $f
;--------------------------------------------------------------------------------
;* vic code couleur en francais *
; couleur %xxxx0000
;              |||+-> bit 0   : Inverse tous les autres bits
;              |++--> bit 1,2 : 00=rgb, 01=Rgb, 10=rGb, 11=rgB 
;              +----> bit 3   : Intensit          
;     0000=noir,  0001=Blanc, 1000=orange, 1001=brun        
;     0010=rouge, 0010=Cyan,  1010=rose  , 1011=gris      
;     0100=vert,  0101=mauve, 1100=gris1 , 1101=vert2           
;     0110=vleu,  0111=jaune, 1110=bleu1 , 1111=gris2           
;--------------------------------------------------------------------------------
vnoir     =    %00000000
vblack    =    %00000000
vblanc    =    %00000001
vwhite    =    %00000001
vrouge    =    %00000010
vred      =    %00000010
vocean    =    %00000011
vcyan     =    %00000011
vmauve    =    %00000100
vpurple   =    %00000100
vvert     =    %00000101
vgreen    =    %00000101
vbleu     =    %00000110
vblue     =    %00000110
vjaune    =    %00000111
vyellow   =    %00000111
vorange   =    %00001000
vbrun     =    %00001001
vbrown    =    %00001001
vrose     =    %00001010
vpink     =    %00001010
vgris     =    %00001011
vgray     =    %00001011
vgrey     =    %00001011
vgris1    =    %00001100
vgray1    =    %00001100
vgrey1    =    %00001100
vvert1    =    %00001101
vgreen1   =    %00001101
vbleu1    =    %00001110
vblue1    =    %00001110
vgris2    =    %00001111
vgray2    =    %00001111
vgrey2    =    %00001111
;-------------------------------------------------------------------------------
; R o u t i n e s   p o u r   l a   c o m m u n i c a t i o n   s é r i e
;-------------------------------------------------------------------------------
setprms = $e1d4 ; Set parameters for LOAD, SAVE, and verify
                ;---------------------------------------------------------------
                ; This routine is used in common by LOAD, SAVE, an veryfy for
                ; setting the filename, the logical file, device number, and 
                ; secondary address, all of witch must be done prior to these 
                ; operations. 
;-------------------------------------------------------------------------------
stalk   = $ed09 ; Send Talk command to serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - stalk send's talk command to serial bus.
                ; Imput :     A = Device number
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
slisten = $ed0c ; Send LISTEN command to serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - slisten send's LISTEN command to serial bus.
                ; Imput :     A = Device number
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sflush  = $ed40 ; Flush serial bus output cache at memory address $0095, to 
                ; serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - slisten send's LISTEN command to serial bus.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
slisten2= $edb9 ; Send LISTEN secondary addressto serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - slisten2 send's LISTEN command to serial bus.
                ; Imput :     A = secondary address
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
stalk2  = $edb9 ; Send TALK secondary addressto serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - stalk2 send's LISTEN command to serial bus.
                ; Imput :     A = secondary address
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sbout   = $eddd ; Write byte to serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - sbout write byte to serial bus.
                ; Imput :     A = secondary address
                ; Output :    -
                ; Altered registers : - 
;-------------------------------------------------------------------------------
sutalk  = $edef ; Send UNTalk command to serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - sutalk send's UNtalk command to serial bus.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sulisten= $edfe ; Send UNLISTEN command to serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - slisten send's UNLISTEN command to serial bus.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sclkhigh= $ee85 ; Set CLOCK OUT to High
                ;---------------------------------------------------------------
                ; Description:
                ;  - sclkhi set's CLOCK OUT to hight.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sclklow = $ee8e ; Set CLOCK OUT to low
                ;---------------------------------------------------------------
                ; Description:                
                ;  - sclkhi set's CLOCK OUT to low.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sdathigh= $ee97 ; Set DATA OUT to High
                ;---------------------------------------------------------------
                ; Description:
                ;  - sdtahigh set's DATA OUT to hight.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sdatlow = $eea0 ; Set DATA OUT to low
                ;---------------------------------------------------------------
                ; Description:                
                ;  - sdatlow set's DATA OUT to low.
                ; Imput :     -
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sclkdta = $eea9 ; Read CLOCK IN and DATA IN.
                ;---------------------------------------------------------------
                ; Description:                
                ;  - Read CLOCK IN and DATA IN.
                ; Imput :     -
                ; Output :    (C)arry = DATA IN; 
                ;             (N)egative = CLOCK IN; 
                ;             A = CLOCK IN (in bit #7)
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sbread  = $f1ad ; Read one byte from serial port.
                ;---------------------------------------------------------------
                ; Description:                
                ;  - Read one byte from serial port.
                ; Imput:     -
                ; Output:    A Byte Read. (Read $0d, Return, if dev stat <> 0.)
                ; Altered registers : A 
;-------------------------------------------------------------------------------
sstdin  = $F237 ; Define serial bus as standard input; do not send TALK 
                ; secondary address if secondary address bit #7 = 1.
                ;---------------------------------------------------------------
                ; Input: A = Device number.
                ; Output: –
                ; Used registers: A, X.
;-------------------------------------------------------------------------------
sstdout = $F279 ; Define serial bus as standard output; do not send LISTEN 
                ; secondary address if secondary address bit #7 = 1.
                ;---------------------------------------------------------------
                ; Input: A = Device number.
                ; Output: –
                ; Used registers: A, X.                
;-------------------------------------------------------------------------------
sfopen  = $F3D5 ; Open file on serial bus; do not send file name if secondary 
                ; address bit #7 = 1 or file name length = 0.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: –
                ; Used registers: A, Y.
;-------------------------------------------------------------------------------
sutclose= $F528 ; Send UNTALK and CLOSE command to serial bus.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: –
                ; Used registers: A.
;-------------------------------------------------------------------------------
sulclose= $F63F ; Send UNLISTEN and CLOSE command to serial bus.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: –
                ; Used registers: A.
;-------------------------------------------------------------------------------
sfclose = $F642 ; Close file on serial bus; do not send CLOSE secondary address 
                ; if secondary address bit #7 = 1.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: –
                ; Used registers: –
;-------------------------------------------------------------------------------
stimeout= $FE21 ; Unknown. (Set serial bus timeout.)
                ;---------------------------------------------------------------
                ; Input: A = Timeout value.
                ; Output: –
                ; Used registers: –
;-------------------------------------------------------------------------------
; r o u t i n e s   p r é s e n t e s   d a n s   l e   k e r n a l
;-------------------------------------------------------------------------------
acptr   = $ffa5 ; jmp $ee13 Recoit un caractere provenant du port serie
                ;---------------------------------------------------------------
                ; Description.:
                ; - acptr est utilisÃ© pour recupÃ©rer des donnÃ©es provenant du 
                ;   port série.
                ;---------------------------------------------------------------
                ; Input..: –
                ; Output.: A = Byte read.
                ; Used registers: A.
                ; Stack used : 13
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation.: TALK, TKSA
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Talk et tksa doivent d'abord Ãªtre appelÃ©.
                ;       jsr acptr
                ;       sta $0800
                ;---------------------------------------------------------------
                ; Note.:
                ; - Cet exemple ne montre que le rÃ©sultat final.
                ; - Effectuez d'abord lâ€™appel de talk et tksa.
;-------------------------------------------------------------------------------
chkin   = $ffc6 ; jmp ($031e) Define an input channel. 
                ;---------------------------------------------------------------
                ; Description.:
                ; - chkin is used to define any opened file as an input file. 
                ; - open must be called first.
                ;---------------------------------------------------------------
                ; Input..: X
                ; Output.: -
                ; Used registers: X.
                ; Stack used : None
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: OPEN
                ;---------------------------------------------------------------
                ; Error returns: 3,5,6
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Define logical file #2 as an input channel.
                ;       ldx #2
                ;       jsr chkin
                ;---------------------------------------------------------------
                ; Note.:
                ; - The x register designates which file #.
;-------------------------------------------------------------------------------
chkout  = $ffc9 ; jmp ($0320) Define an output channel.
                ;---------------------------------------------------------------
                ; Description.:
                ; - Just like chkin, but it defines the file for output. 
                ; - open must be called first.
                ;---------------------------------------------------------------
                ; Input..: X
                ; Output.: -
                ; Used registers: X.
                ; Stack used : None
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: OPEN
                ;---------------------------------------------------------------
                ; Error returns: 3,5,7
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Define logical file #4 as an output file.
                ;       ldx #4
                ;       jsr chkout
                ;---------------------------------------------------------------
                ; Note.:
                ; - The x register designates which file #.
;-------------------------------------------------------------------------------
chrin   = $ffcf ; jmp ($0324) Get a character from the input channel
                ;---------------------------------------------------------------
                ; Description.:
                ; - chrin will get a character from the current input device. 
                ; - Calling open and chkin can change the input device.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: A
                ; Used registers: A.
                ; Stack used : None
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: OPEN, CHKIN
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Store a typed string to the screen.
                ;       ldy #$00
                ; loop  jsr chkin
                ;       sta $0800,y
                ;       iny
                ;       cmp #$0d
                ;       bne loop
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - This example is like an input statement. try running it.
;-------------------------------------------------------------------------------
chrout  = $ffd2 ; jmp ($0326) Output a character
                ;---------------------------------------------------------------
                ; Description.:
                ; - Load the accumulator with your number and call. 
                ; - open and chkout will change the output device.
                ;---------------------------------------------------------------
                ; Input..: A
                ; Output.: -
                ; Used registers: A.
                ; Stack used : None
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: CHKOUT, OPEN
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Duplicate the command of cmd 4: print "a";
                ;       ldx #4
                ;       jsr chkout
                ;       lda #'a
                ;       jsr chrout
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The letter a is printed to the screen. 
                ; - Call open first for the printer.
;-------------------------------------------------------------------------------
cint    = $ff81 ; jsr $e518 Initialize the screen editor and vic-ii chip
                ;---------------------------------------------------------------
                ; Description:
                ; - cint resets the 6567 video controller chip and the screen 
                ;   editor.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Reset the 6567 chip and the 6566 vic chip.
                ;       jsr cint
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - Basically, just like pressing the stop and restore keys.
;-------------------------------------------------------------------------------
ciout   = $ffa8 ; jmp $eddd Transmit a byte over the serial bus
                ;---------------------------------------------------------------
                ; Description.:
                ; - ciout will send data to the serial bus. 
                ; - listen and second must be called first. 
                ; - Call unlsn to finish up neatly.
                ;---------------------------------------------------------------
                ; Input..: A = Byte to write.
                ; Output.: –
                ; Used registers: A
                ; Stack used : None
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: LISTEN, [SECOND]
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Send the letter x to the serial bus.
                ;       lda #'x
                ;       jsr ciout
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator is used to transfer the data.
;-------------------------------------------------------------------------------
clall   = $ffe7 ; jmp ($032c) Close all open files
                ;---------------------------------------------------------------
                ; Description.:
                ; - clall really does what its name implies-it closes all files 
                ;   and resets all channels.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: -
                ; Used registers: -
                ; Stack used : 11
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Close all files.
                ;       jsr clall
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The clrchn routine is called automatically.
;-------------------------------------------------------------------------------
close   = $ffc3 ; jmp ($031c) Close a logical file
                ;---------------------------------------------------------------
                ; Description.:
                ; - This routine will close any logical file that has been 
                ;   opened.
                ;---------------------------------------------------------------
                ; Input..: A
                ; Output.: -
                ; Used registers: A.
                ; Stack used : None
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Close logical file #2.
                ;       lda #2
                ;       jsr close
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator designates the file #.
;-------------------------------------------------------------------------------
clrchn  = $ffcc ; jmp ($0322) - Clear all i/o channels.
                ;---------------------------------------------------------------
                ; Description.:
                ; - clrchn resets all channels and i/o registers - the input to 
                ;   keyboard and the output to screen.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: -
                ; Used registers: -
                ; Stack used : 9
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: OPEN, CHKIN
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Restore default values to i/o devices.
                ;       jsr clrchn
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator and the x register are altered.
;-------------------------------------------------------------------------------
getin   = $ffe4 ; jmp ($032a) Get a character.
                ;---------------------------------------------------------------
                ; Description.:
                ; - getin will get one piece of data from the input device. 
                ; - Open and chkin can be used to change the input device.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: A
                ; Used registers: A.
                ; Stack used : None
                ; Register affected : A, X
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Wait for a key to be pressed.
                ;       wait    jsr getin
                ;               cmp #0
                ;               beq wait
                ;---------------------------------------------------------------
                ; Note.:
                ; - If the serial bus is used, then all registers are altered.
;-------------------------------------------------------------------------------
iobase  = $fff3 ; jmp $e500 Define i/o memory page
                ;---------------------------------------------------------------
                ; Description.:
                ; - iobase returns the low and high bytes of the starting 
                ;   address of the i/o devices in the x and y registers.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: X, Y
                ; Used registers: X, Y.
                ; Stack used : 2
                ; Register affected : X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Set the data direction register of the user port to 0 
                ;   (input).
                ;       jsr iobase
                ;       stx point
                ;       sty point+1
                ;       ldy #2
                ;       lda #0
                ;       sta (point),y
                ;---------------------------------------------------------------
                ; Note.:
                ; - Point is a zero-page address used to access the ddr 
                ;   indirectly.
;--------------------------------------------------------------------------------
ioinit  = $ff84 ; ($fda3) Initialize i/o devices.
                ;---------------------------------------------------------------
                ; Description:
                ; - ioinit initializes all i/o devices and routines. 
                ; - It is part of the system's powering-up routine.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Initialize all i/o devices.
                ;       jsr ioinit
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - All registers are altered.
;-------------------------------------------------------------------------------
listen  = $ffb1 ; jmp ($ed0c) Command a device on the serial bus to listen.
                ;---------------------------------------------------------------
                ; Description.:
                ; - listen will command any device on the serial bus to receive 
                ;   data.
                ;---------------------------------------------------------------
                ; Input..: A = Device number.
                ; Output.: –
                ; Used registers: A.
                ; Stack used : None
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Command device #8 to listen.
                ;       lda #8
                ;       jsr listen
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator designates the device #.
;-------------------------------------------------------------------------------
load    = $ffd5 ; jmp $f4e9 Load device to RAM.
                ;---------------------------------------------------------------
                ; Description.:
                ; - The computer will perform either the load or the verify 
                ;   command. 
                ; - If the ac cumulator is a 1, then load; if 0, then verify.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: A
                ; Used registers: A.
                ; Stack used : None
                ; Register affected : A, X, y
                ;---------------------------------------------------------------
                ; Preparation routines: SETLFS, SETNAM
                ;---------------------------------------------------------------
                ; Error returns: 0, 4, 5, 8, 9
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Load a program into memory.
                ;       lda #$08
                ;       ldx #$02
                ;       ldy #$00
                ;       jsr setlfs
                ;       lda #$04
                ;       ldx #<name
                ;       ldy #>name
                ;       jsr setnam
                ;       lda #$00
                ;       ldy #$20
                ;       jsr load
                ;       rts
                ;       name .byte 'file'
                ;---------------------------------------------------------------
                ; Note.:
                ; - Program 'file' will be loaded into memory starting at 8192 
                ;   decimal, x being the low byte and y being the high byte for 
                ;   the load.
;-------------------------------------------------------------------------------
membot  = $ff9c ; jmp $fe34 Get/set bottom of memory.
                ;---------------------------------------------------------------
                ; Description.:
                ; - If the carry bit is set, then the low byte and the 
                ;   high byte of ram are returned in the x and y registers. 
                ; - If the carry bit is clear, the bottom of ram is set to the 
                ;   x and y registers.
                ;---------------------------------------------------------------
                ; Input..: X, Y (C=0)
                ; Output.: X, Y (C=1)
                ; Used registers: X, Y.
                ; Stack used : None
                ; Register affected : X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns:None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Move bottom of memory up one page.
                ;       sec
                ;       jsr membot
                ;       iny
                ;       clc
                ;       jsr membot
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator is left alone.
;-------------------------------------------------------------------------------
memtop  = $ff99 ; jmp $fe25 Get/Set top of ram
                ;---------------------------------------------------------------
                ; Description.:
                ; - Same principle as membot, except the top of ram is affected.
                ;---------------------------------------------------------------
                ; Input..: X, Y (C=0)
                ; Output.: X, Y (C=1)
                ; Used registers: X, Y.
                ; Stack used : 2
                ; Register affected : X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Protect 1k of memory from basic.
                ;       sec
                ;       jsr memtop
                ;       dey
                ;       clc
                ;       jsr memtop
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator is left alone.
;-------------------------------------------------------------------------------
open    = $ffc0 ; jmp ($031a) Open a logical file
                ;---------------------------------------------------------------
                ; Description.:
                ; - After setlfs and setnam have been called, you can open a 
                ;   logical file.
                ;---------------------------------------------------------------
                ; Input..: A, X, Y
                ; Output.: -
                ; Used registers: A, X, Y.
                ; Stack used : None
                ; Register affected : A, X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: SETLFS, SETNAM
                ;---------------------------------------------------------------
                ; Error returns: 1, 2, 4, 5, 6
                ;---------------------------------------------------------------
                ; Exemple.:
                ; Duplicate the command open 15,8,15,'i/o'
                ;       lda #3
                ;       ldx #<name
                ;       ldy #>name
                ;       jsr setnam
                ;       lda #15
                ;       ldx #8
                ;       ldy #15
                ;       jsr setlfs
                ;       jsr open
                ;       rts
                ;       name .by 'i/o'
                ;---------------------------------------------------------------
                ; Note.:
                ; - Opens the current name file with the current lfs.
;-------------------------------------------------------------------------------
plot    = $fff0 ; jmp $e50a Set or retrieve cursor location x=column, y=line
                ;---------------------------------------------------------------
                ; Description.:
                ; - If the carry bit of the accumulator is set, then the 
                ;   cursor x,y is returned in the y and x registers. 
                ; - If the carry bit is clear, then the cursor is moved to x,y 
                ;   as determined by the y and x registers.
                ;---------------------------------------------------------------
                ; Input..: X, Y (C=0)
                ; Output.: X, Y (C=1)
                ; Used registers: X, Y.
                ; Stack used : 2
                ; Register affected : A, X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Move cursor to row 12, column 20 (12,20).
                ;       ldx #12
                ;       ldy #20
                ;       clc
                ;       jsr plot
                ;---------------------------------------------------------------
                ; Note.:
                ; - The cursor is now in the middle of the screen.
;-------------------------------------------------------------------------------
ramtas  = $ff87 ; ($fd50) Initialise ram, tape buffer and screen.
                ;---------------------------------------------------------------
                ; Description:
                ; - ramtas is used to test ram, reset the top and bottom of 
                ;   memory pointers, clear $0000 to $0101 and $0200 to $03ff, 
                ;   and set the screen memory to $0400.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Do ram test.
                ;       jsr ramtas
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - All registers are altered.
;-------------------------------------------------------------------------------
rdtim   = $ffde ; jmp $f6dd Read system clock
                ;---------------------------------------------------------------
                ; Description.:
                ; - Locations 160-162 are transferred, in order, to the y 
                ;   and x registers and the accumulator.
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Store system clock to screen.
                ;       jsr rdtim
                ;       sta 1026
                ;       stx 1025
                ;       sty 1024
                ;---------------------------------------------------------------
                ; Note.:
                ; - The system clock can be translated as hours/minutes/seconds.
;-------------------------------------------------------------------------------
readst  = $ffb7 ; jmp $fe07 Read i/o status word
                ;---------------------------------------------------------------
                ; Description.:
                ; - When called, readst returns the status of the i/o devices. 
                ; - Any error code can be translated as operator error.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: A
                ; Used registers: A
                ; Stack used : 2
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Check for read error.
                ;       jsr readst
                ;       cmp #16
                ;       beq error
                ;---------------------------------------------------------------
                ; Note.:
                ; - In this case, if the accumulator is 16, a read error 
                ;   occurred.
;-------------------------------------------------------------------------------
restor  = $ff8a ; jmp $fd15 Restore default I/O vectors.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: –
                ; Used registers: -
                ; Stack used : None
                ; Register affected : A, X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ;       jsr restor
                ;---------------------------------------------------------------
                ; Note.:
                ; - All registers are altered.
;-------------------------------------------------------------------------------
save    = $ffd8 ; jmp $f5dd Save memory to a device.
                ;---------------------------------------------------------------
                ; Description.:
                ; - The computer will perform either the load or the verify 
                ;   command. 
                ; - If the ac cumulator is a 1, then load; if 0, then verify.
                ;---------------------------------------------------------------
                ; Input..: A, X, Y
                ; Output.: -
                ; Used registers: A, X, Y
                ; Stack used : None
                ; Register affected : A, X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: SETLFS, SETNAM
                ;---------------------------------------------------------------
                ; Error returns: 5, 8, 9
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Load a program into memory.
                ;prog   lda #$08
                ;       jsr setlfs
                ;       lda #$0c
                ;       ldx #<name
                ;       ldy #>name
                ;       jsr setnam
                ;       lda prog
                ;       sta txttab
                ;       lda prog+1
                ;       sta txttab+1
                ;       ldx #<prgend
                ;       ldy #>prgend
                ;       ldy #$20
                ;       lda #<txttab
                ;       jsr save
                ;       rts
                ;       name .byte 'progfile.prg'
                ;prgend
                ;---------------------------------------------------------------
                ; Note.:
                ; - Program 'file' will be saved onto disk at 8192 
                ;   decimal, x being the low byte and y being the high byte for 
                ;   the load.
;-------------------------------------------------------------------------------
scnkey  = $ff9f ; jmp $ea87 Scan the keyboard
                ;---------------------------------------------------------------
                ; Description.:
                ; - TScan the keyboard to see if a key is pressed. 
                ;   Place that key into the keyboard buffer. 
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: -
                ; Used registers: -
                ; Stack used : None
                ; Register affected : A, X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; get   jsr scnkey
                ;       jsr getin
                ;       cmp #0
                ;       beq get
                ;       jsr chrout
                ;---------------------------------------------------------------
                ; Note.:
;-------------------------------------------------------------------------------
screen  = $ffed ; jmp $e505 Return screen format
                ;---------------------------------------------------------------
                ; Description.:
                ; - Screen returns the number of columns and rows the screen has 
                ;   in the x and y registers.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: X, Y
                ; Used registers: X, Y
                ; Stack used : 2
                ; Register affected : X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Determine the screen size.
                ;       jsr screen
                ;       stx maxcol
                ;       sty maxrow
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - screen allows further compatibility between the 64, the 
                ;   vic-20, and future versions of the 64.
;-------------------------------------------------------------------------------
second  = $ff93 ; jmp $edb9 Send secondary address after listen
                ;---------------------------------------------------------------
                ; Description.:
                ; - After listen has been called, a secondary address may be 
                ;   sent.
                ;---------------------------------------------------------------
                ; Input..: A = Secondary address.
                ; Output.: –
                ; Used registers: A
                ; Stack used : None
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Address device #8 with secondary address #15.
                ;       lda #8
                ;       jsr listen
                ;       lda #15
                ;       ora #60
                ;       jsr second
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator designates the address number.
;-------------------------------------------------------------------------------
setlfs  = $ffba ; jmp $fe00 Set up a logical file
                ;---------------------------------------------------------------
                ; Description.:
                ; - setlfs stands for set logical address, file address, and 
                ;   secondary address. 
                ; - After setlfs is called, open may be called.
                ;---------------------------------------------------------------
                ; Input..: A, X, Y
                ; Output.: –
                ; Used registers: A, X, Y
                ; Stack used : 2
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Set logical file #1, device #8, secondary address of 15.
                ;       lda #1
                ;       ldx #8
                ;       ldy #15
                ;       jsr setlfs
                ;---------------------------------------------------------------
                ; Note.:
                ; - If open is called, the command will be open 1,8,15.
;-------------------------------------------------------------------------------
setmsg  = $ff90 ; jmp $fe18 Set kernal message output flag
                ;---------------------------------------------------------------
                ; Description.:
                ; - Depending on the accumulator, either error messages, control 
                ;   messages, or neither is printed.
                ;---------------------------------------------------------------
                ; Input..: A
                ; Output.: –
                ; Used registers: A
                ; Stack used : 2
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Turn on control messages.
                ;       lda #$40
                ;       jsr setmsg
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - A 128 is for error messages; a zero, for turning both off.
;-------------------------------------------------------------------------------
setnam  = $ffbd ; jmp $fdf9 Set up file name
                ;---------------------------------------------------------------
                ; Description.:
                ; - In order to access the open, load, or save routines, 
                ; - Setnam must be called first.
                ;---------------------------------------------------------------
                ; Input..: A, X, Y
                ; Output.: –
                ; Used registers: A, X, Y
                ; Stack used : None
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Setnam will prepare the disk drive for'file#1'.
                ;       lda #6
                ;       ldx #l,name
                ;       ldy #h,name
                ;       jsr setnam
                ;       name.by 'file#l'
                ;---------------------------------------------------------------
                ; Note.:
                ; - Accumulator is file length, x = low byte, and y = high byte.
;-------------------------------------------------------------------------------
settim  = $ffdb ; jmp $f6e4 Set the system clock.
                ;---------------------------------------------------------------
                ; Description.:
                ; - settim is the opposite of rdtim: it sets the system clock
                ;   instead of reading it.
                ;---------------------------------------------------------------
                ; Input..: A, X, Y
                ; Output.: –
                ; Used registers: A, X, Y
                ; Stack used : 2
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Set system clock to 10 minutes =3600 jiffies.
                ;       lda #0
                ;       ldx #l,3600
                ;       ldy #h,3600
                ;       jsr settim
                ;---------------------------------------------------------------
                ; Note.:
                ; - This allows very accurate timing for many things.
;-------------------------------------------------------------------------------
settmo  = $ffa2 ; jmp $fe21 Set ieee bus card timeout flag
                ;---------------------------------------------------------------
                ; Description.:
                ; - settmo is used only with an ieee add-on card to access the 
                ;   serial bus.
                ;---------------------------------------------------------------
                ; Input..: A = Timeout value.
                ; Output.: –
                ; Used registers: A
                ; Stack used : 2
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Disable time-outs on serial bus.
                ;       lda #0
                ;       jsr settmo
                ;---------------------------------------------------------------
                ; Note.:
                ; - To enable time-outs, set the accumulator to a 128 and call 
                ;   settmo.
;-------------------------------------------------------------------------------
stop    = $ffe1 ; jmp ($0328) Check if stop key is pressed.
                ;---------------------------------------------------------------
                ; Description.:
                ; - Stop will set the z flag of the accumulator if the stop key 
                ;   was pressed.
                ;---------------------------------------------------------------
                ; Input..: A
                ; Output.: –
                ; Used registers: A
                ; Stack used : None
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Check for stop key being pressed.
                ;        wait      jsr stop
                ;                  bne wait
                ;                  rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - stop must be called if the stop key is to remain functional.
;-------------------------------------------------------------------------------
talk    = $ffb4 ; jmp $ed09 Command a device on the serial bus to talk
                ;---------------------------------------------------------------
                ; Description.:
                ; - This routine will command a device on the serial bus to 
                ;   send data.
                ;---------------------------------------------------------------
                ; Input..: A = Device number.
                ; Output.: –
                ; Used registers: A
                ; Stack used : None
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Command device #8 to talk.
                ;       lda #8
                ;       jsr talk
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The accumulator designates the file number.
;-------------------------------------------------------------------------------
tksa    = $ff96 ; jmp $edc7 Send a secondary address to a device commanded to talk
                ;---------------------------------------------------------------
                ; Description.:
                ; - tksa is used to send a secondary address for a talk device.
                ; - Function talk must be called first.
                ;---------------------------------------------------------------
                ; Input..: A = Secondary address.
                ; Output.: –
                ; Used registers: A
                ; Stack used : 2
                ; Register affected : None
                ;---------------------------------------------------------------
                ; Preparation routines: TALK
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Signal device #4 to talk with command #7.
                ;       lda #4
                ;       jsr talk
                ;       lda #7
                ;       jsr tksa
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - This example will tell the printer to print in uppercase.
;-------------------------------------------------------------------------------
udtim   = $ffea ; jmp $f69b Update the system clock
                ;---------------------------------------------------------------
                ; Description.:
                ; - If you are using your own interrupt system, you can update 
                ;   the system clock by calling udtim.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: –
                ; Used registers: -
                ; Stack used : 2
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Update the system clock.
                ;       jsr udtim
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - It is useful to call udtim before calling stop.
;-------------------------------------------------------------------------------
unlsn   = $ffae ; jmp $edfe Send an unlisten command
                ;---------------------------------------------------------------
                ; Description.:
                ; - unlsn commands all devices on the serial bus to stop
                ;   receiving data.
                ;---------------------------------------------------------------
                ; Input..: -
                ; Output.: –
                ; Used registers: -
                ; Stack used : None
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Command the serial bus to unlisten.
                ;       jsr unlsn
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - The serial bus can now be used for other things.
;-------------------------------------------------------------------------------
untlk   = $ffab ; jmp $edef Send an untalk command
                ;---------------------------------------------------------------
                ; Description.:
                ; - All devices previously set to talk will stop sending data.
                ;---------------------------------------------------------------
                ; Input..: –
                ; Output.: –
                ; Used registers: -
                ; Stack used : None
                ; Register affected : A
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: See READST
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Command serial bus to stop sending data.
                ;       jsr untlk
                ;       rts
                ;---------------------------------------------------------------
                ; Note.:
                ; - Sending untlk commands all talking devices to get off the 
                ;   serial bus.
;-------------------------------------------------------------------------------
vector  = $ff8d ; jmp $fd1a Read/set I/O vectors.
                ;---------------------------------------------------------------
                ; Description.:
                ; - If the carry bit of the accumulator is set, the start 
                ;   of a list of the current contents of the ram vectors is 
                ;   returned in the x and y registers. 
                ; - If the carry bit is clear, there the user list pointed to by 
                ;   the x and y registers is transferred to the system ram 
                ;   vectors.
                ;---------------------------------------------------------------
                ; Input..: X, Y (C=0)
                ; Output.: X, Y (C=1)
                ; Used registers: -
                ; Stack used : 2
                ; Register affected : A, X, Y
                ;---------------------------------------------------------------
                ; Preparation routines: None
                ;---------------------------------------------------------------
                ; Error returns: None
                ;---------------------------------------------------------------
                ; Exemple.:
                ; - Change the input routines to new system.
                ;       sec
                ;       jsr vector
                ;       lda #l,myinp
                ;       sta user+10
                ;       lda #h,myinp
                ;       sta user+11
                ;       ldx #l,user
                ;       ldy #h,user
                ;       clc
                ;       jsr vector
                ;       rts
                ;       user .de 26
                ;---------------------------------------------------------------
                ; Note.:
                ; - The new input list can start anywhere. user is the location 
                ;   for temporary strings, and 35-36 is the utility pointer 
                ;   area.
;-------------------------------------------------------------------------------
;* kernal function vectors *
;ayx=input ayx=outputs (c)=1 (c)=0
;--------------------------------------------------------------------------------
kd_poly1     =   $e043
kd_poly2     =   $e059
kd_rmulc     =   $e08d       ;
kd_raddc     =   $e092       ;
kd_rnd       =   $e097
kd_sys       =   $e12a
kd_save      =   $e156
kd_verify    =   $e165
kd_load      =   $e168
kd_chrout    =   $f1ca
kcint       =   cint        ;   , init vic + ecran.
kioinit     =   ioinit      ;   , init i/o dev.
kramtas     =   ramtas      ;   , test de memoire.
kciout      =   ciout       ;a  ,tx byte  acia
krestor     =   restor      ;   , set ram plafond
kvector     =   vector      ;
ksetmsg     =   setmsg      ;a  , set sys. msg. out
ksecond     =   second      ;a  , tx adresse sec.
ktksa       =   tksa        ;a  , talk adresse sec.
kmemtop     =   memtop      ; yx, (c) get mem high
kmembot     =   membot      ; yx, (c) get mem low
kscankey    =   scnkey      ;   , scan clavier
ksettmo     =   settmo      ;a  , set ieee timeout
kacptr      =   acptr       ;a  ,rx serie.
kuntlk      =   untlk       ;   , iec-cmc stop talk
kunlsn      =   unlsn       ;   , iec-cmd stop lsn
klisten     =   listen      ;a  , iec-cmd dev ecout
ktalk       =   talk        ;a  , iec-cmd dev parle
kreadst     =   readst      ;a  , lecture i/o stats
ksetlfs     =   setlfs      ;ayx, init fich logi.
ksetnam     =   setnam      ;ayx, init num.nom.fich
kopen       =   open        ;axy, ouvre fich-nom
kclose      =   close       ;a  , ferme fichier #a.
kchkin      =   chkin       ;  x,open canal in.
kchkout     =   chkout      ;  x,open canal out
kclrchn     =   clrchn      ;   , ferme canaux i/o.
kchrin      =   chrin       ;a  ,recup. un car.
kchrout     =   chrout      ;a  ,sort un car.
kload       =   load        ;ayx, dev->ram
ksave       =   save        ;   , sauve mem->dev
ksettim     =   settim      ;axy, init sysclock
krdtim      =   rdtim       ;axy, lecture sysclock
kstop       =   stop        ;a  , ret. stopkey stat
kgetin      =   getin       ;a  , recup. car. #dev.
kclall      =   clall       ;   , ferme fichiers.
kudtim      =   udtim       ;   , maj sysclock
kscreen     =   screen      ; yx, get format ecran
kplot       =   plot        ; yx, (c) get csr pos.
kiobase     =   iobase      ; yx, def. i/o mem page
;--------------------------------------------------------------------------------
; Kernal entry point
;--------------------------------------------------------------------------------
k_echostartup = $e39a
k_putch       = $e716 ; 52) Print a character.          ;a--;---; a = char
k_cls         = $e7a0
k_cursordown  = $e87c
k_scrollup    = $e8ea
k_home        = $e94e
k_insertline  = $e965
k_screlldown  = $e9c8
k_devsndlstn  = $ed0c ; 55) Send 'LISTEN'>IEEE/Serial.  ;a--;---; a = dev # 
k_ieeein      = $ee13 ; 60) Input from IEEE/Serial.     ;---;a--; a = Data byte  
k_devsndutalk = $eef6 ; 58) Send 'UNTALK'>IEEE/Serial.  ;---;---;
k_devsndulstn = $ef04 ; 59) Send 'UNLISTEN'>IEEE/Serial.;---;---; 
k_putsysmsg   = $f12f ; 53) Print system message.       ;--y;---; y = msg offset
k_cloself     = $f291 ; 61) Close logical file .        ;a--;---; a = file # 
k_loadsub     = $f49e ; 63) LOAD subroutine.            ;axy;---; a = # start=yyxx
k_prnsrch     = $f5af ; 64) Print SEARCHING if imm mode.;---;---;
k_echosearch  = $f5b3 ; 64b) Skipping test part of 64.  ;---;---; 
k_prnfnam     = $f5c1 ; 65) Print filename.             ;---;---;
k_stop        = $f6ed ; 62) Check for STOP key.         ;---;---; z = 1 pressed
k_gettaphdblk = $f7ea ; 66) Find a tape hdr blk.        ;a--;---; a = len 
                      ;     Prerequisit: Pointer to string in zpage1  
k_fndtaphdblk = $f7ea ; 67) Find any tape hdr blk.      ;---;---; 
k_waittapplay = $f817 ; 68) Press PLAY... (wait)        ;---;---;
k_rdtape2buff = $f841 ; 69) Read tape to buffer.        ;---;---;
k_readtape    = $f847 ; 70) Read tape.                  ;---;---;
k_wrbuff2tape = $f864 ; 71) write buffer to tape.       ;---;---;
k_wrtape      = $f869 ; 72) write tape.                 ;a--;---; a = ldr len
k_resettapeio = $fb8e ; 73) Reset tape I/O.             ;---;---;
k_setintvect  = $fcbd ; 74) set interupt vector.        ;---;---;
k_coldreset   = $fce2 ; 75) Power on reset.             ;---;---;
k_coldstart   = $fce2 ; 75) Power on reset.             ;---;---;
k_coldboot    = $fce2 ; 75) Power on reset.             ;---;---;
k_warmreset   = $fe66 ;     Warm resetstart
k_warmboot    = $fe66 ;     Warm resetstart
k_devsndaddr2 = $ff93 ; 56) Send second address.        ;a--;---; a = SA or #$60 

;--------------------------------------------------------------------------------
; error codes
;--------------------------------------------------------------------------------
; if an error occurs during a kernal routine, then the carry bit of the 
; accumulator is set and the error code is returned in the accumulator.
;---------------+---------------------------------------------------------------
; number        ; meaning
;---------------+---------------------------------------------------------------
kerr00 = 0      ; routine ended by the stop key.
kerr01 = 1      ; too many files open.
kerr02 = 2      ; file already open.
kerr03 = 3      ; file not open.
kerr04 = 4      ; file not found.
kerr05 = 5      ; device not present.
kerr06 = 6      ; file is not an input file.
kerr07 = 7      ; file is not an output file.
kerr08 = 8      ; file name is missing.
kerr09 = 9      ; illegal device number.
kerrf0 = 240    ; top-of-memory change rs-232 buffer allocation.
;---------------+---------------------------------------------------------------
;------------------------------ d e c i m a l-----------------------------------
;0000000001111111111222222222233333333334444444444555555555566666666667777777777
;1234567890123456789012345678901234567890123456789012345678901234567890123456789
;========================= h e x a - d e c i m a l==============================
;0000000000000001111111111111111222222222222222233333333333333334444444444444444
;123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
;--------------------------------------------------------------------------------
; a p p e l   d e   l a   s o u s   r o u t i n e   p r i n c i p a l e
;--------------------------------------------------------------------------------
libtart        ;jmp      main  ; le programme principale doit s'appeler "main"
                ;jsr      k_coldboot
                ;rts
