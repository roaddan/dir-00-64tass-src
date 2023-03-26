*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
; c64_map.asm - Carthographie memoire et declaration de constantes pour les
; commodores 64 et 64c
;--------------------------------------------------------------------------------
; Scripteur...: daniel lafrance, j5w 1w5, canada.
; Version.....: 20191223.1
; Inspiration.: isbn 0-87455-082-3
;--------------------------------------------------------------------------------
; Segmentation principales de la mÃ©moire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;
; ... en prenant soin de placer le fichier dans le meme disque ou rÃ©pertoire que
; votre programme.
;--------------------------------------------------------------------------------
;* macro sur les elements importants *
;--------------------------------------------------------------------------------
memmapreg = $01
kiostatus = $90       ; Kernal I/O status word (st) (byte) 
curfnlen  = $b7       ; Current filename length (byte)
cursecadd = $b9       ; Current secondary address (byte)
curdevno  = $ba       ; Current device number (byte)
curfptr   = $bb       ; Current file pointer (word)  
zpage1    = $fb       ; zero page 1 address (word)
zpage2    = $fd       ; zero page 2 address (word)
zeropage  = zpage1
zonepage  = zpage2
bascol    = $0286     ;basic next chr colscreenram (byte)
scrnram   = $0400     ;video character ram
scrram0   = $0400
scrram1   = $0500
scrram2   = $0600
scrram3   = $0700
basicsta  = $0801     ;basic start address
basicrom  = $a000
chargen   = $d000
vicii     = $d000
sid       = $d400     ;sid base address
colorram  = $d800     ;video color ram
colram0   = $d800
colram1   = $d900
colram2   = $da00
colram3   = $db00
cia1      = $dc00     ;cia1  base address
cia2      = $dd00     ;cia2 base address
kernalrom = $e000
;--------------------------------------------------------------------------------
;* basic petscii control characters *
;--------------------------------------------------------------------------------
bstop     =    $03      ;stop
bwhite    =    $05      ;set color white
block     =    $08      ;lock the charset
bunlock   =    $09      ;unlock the charset
bcarret   =    $0d
btext     =    $0e
bcrsdn    =    $11      ;cursor down 1 line
brevcol   =    $12
bhome     =    $13
bdelete   =    $14
bred      =    $1c
bcuright  =    $1d
bgreen    =    $1e
bblue     =    $1f
borange   =    $81
blrun     =    $83
bfkey1    =    $85
bfkey2    =    $86
bfkey3    =    $87
bfkey4    =    $88
bfkey5    =    $89
bfkey6    =    $8a
bfkey7    =    $8b
bfkey8    =    $8c
bcarret1  =    $8d
bgraph    =    $8e
bblack    =    $90
bcuup     =    $91
brevoff   =    $92
bclear    =    $93
binsert   =    $94
bbrown    =    $95
bltred    =    $96
bdkgrey   =    $97
bmdgrey   =    $98
bltgreen  =    $99
bltblue   =    $9a
bltgrey   =    $9b
bmagenta  =    $9c
bculeft   =    $9d
byellow   =    $9e
bcyan     =    $9f

;--------------------------------------------------------------------------------
; registre basic contienant la couleur du prochain caractÃ¨re. 
;--------------------------------------------------------------------------------
carcol  = $0286
ieval   = $030a
; vecteurs du basic
chrget  = $73
chrgot  = $79
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
; |     c o u l e u r s   p o s s i b l e   d e s   c a r a c t Ã¨ r e s      |
; +==========================================================================+
; | dec | hex |  binaire  | couleur    || dec | hex |  binaire  | couleur    |
; +-----+-----+-----------+------------++-----+-----+-----------+------------+
; |  0  | $0  | b00000000 | noir       ||  1  | $1  | b00000001 | blanc      |
; |  2  | $0  | b00000010 | rouge      ||  3  | $3  | b00000011 | ocÃ©an      |
; |  4  | $0  | b00000100 | mauve      ||  5  | $5  | b00000101 | vert       |
; |  6  | $0  | b00000110 | bleu       ||  7  | $7  | b00000111 | jaune      |
; |  8  | $0  | b00001000 | orange     ||  9  | $9  | b00001001 | brun       |
; | 10  | $0  | b00001010 | rose       || 11  | $b  | b00001011 | gris foncÃ© |
; | 12  | $0  | b00001100 | gris moyen || 13  | $d  | b00001101 | vert pÃ¢le  |
; | 14  | $0  | b00001110 | blue pale  || 15  | $f  | b00001111 | gris pÃ¢le  |
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
;              +----> bit 3   : IntensitÃ©          
;     0000=noir,  0001=Blanc, 1000=orange, 1001=brun        
;     0010=rouge, 0010=Cyan,  1010=rose  , 1011=gris      
;     0100=vert,  0101=mauve, 1100=gris1 , 1101=vert2           
;     0110=vleu,  0111=jaune, 1110=bleu1 , 1111=gris2           
;           
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
                ; Imput :     -
                ; Output :    A Byte Read. (Read $0d, Return, if dev stat <> 0.)
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
cint    = $ff81 ; ($ff5b) Initialize the screen editor and vic-ii chip
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
restor  = $ff8a ; ($fd15) Restore default I/O vectors.
                ;---------------------------------------------------------------
;-------------------------------------------------------------------------------
vector  = $ff8d ; ($fd1a) Read/set I/O vectors.
                ;---------------------------------------------------------------
                ; Description:
                ; - If the carry bit of the accumulator is set, the start 
                ;   of a list of the current contents of the ram vectors is 
                ;   returned in the x and y registers. 
                ; - If the carry bit is clear, there the user list pointed to by 
                ;   the x and y registers is transferred to the system ram 
                ;   vectors.
                ;---------------------------------------------------------------
                ; Exemple:
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
                ; Note:
                ; - The new input list can start anywhere. user is the location 
                ;   for temporary strings, and 35-36 is the utility pointer 
                ;   area.
;-------------------------------------------------------------------------------
setmsg  = $ff90 ; ($fe18) Set kernal message output flag
                ;---------------------------------------------------------------
                ; Description:
                ; - Depending on the accumulator, either error messages, control 
                ;   messages, or neither is printed.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Turn on control messages.
                ;       lda #$40
                ;       jsr setmsg
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - A 128 is for error messages; a zero, for turning both off.
;-------------------------------------------------------------------------------
second  = $ff93 ; ($edb9) Send secondary address after listen
                ;---------------------------------------------------------------
                ; Description:
                ; - After listen has been called, a secondary address may be 
                ;   sent.
                ;---------------------------------------------------------------
                ; Input: A = Secondary address.
                ; Output: –
                ; Used registers: A.
                ; Real address: $EDB9.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Address device #8 with secondary address #15.
                ;       lda #8
                ;       jsr listen
                ;       lda #15
                ;       jsr second
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator designates the address number.
;-------------------------------------------------------------------------------
tksa    = $ff96 ; ($edc7) Send a secondary address to a device commanded to talk
                ;---------------------------------------------------------------
                ; Description:
                ; - tksa is used to send a secondary address for a talk device.
                ; - Function talk must be called first.
                ;---------------------------------------------------------------
                ; Input: A = Secondary address.
                ; Output: –
                ; Used registers: A.
                ; Real address: $EDC7.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Signal device #4 to talk with command #7.
                ;       lda #4
                ;       jsr talk
                ;       lda #7
                ;       jsr tksa
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - This example will tell the printer to print in uppercase.
;-------------------------------------------------------------------------------
memtop  = $ff99 ; ($fe25) Get/Set top of ram
                ;---------------------------------------------------------------
                ; Description:
                ; - Same principle as membot, except the top of ram is affected.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Protect 1k of memory from basic.
                ;       sec
                ;       jsr memtop
                ;       dey
                ;       clc
                ;       jsr memtop
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator is left alone.
;-------------------------------------------------------------------------------
membot  = $ff9c ; ($fe34) Get/set bottom of memory.
                ;---------------------------------------------------------------
                ; Description:
                ; - If the carry bit is set, then the low byte and the 
                ;   high byte of ram are returned in the x and y registers. 
                ; - If the carry bit is clear, the bottom of ram is set to the 
                ;   x and y registers.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Move bottom of memory up one page.
                ;       sec
                ;       jsr membot
                ;       iny
                ;       clc
                ;       jsr membot
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator is left alone.
;-------------------------------------------------------------------------------
scankey = $ff9f ; $(ea87) Scan the keyboard
                ;---------------------------------------------------------------
;-------------------------------------------------------------------------------
settmo  = $ffa2 ; ($fe21) Set ieee bus card timeout flag
                ;---------------------------------------------------------------
                ; Description:
                ; - settmo is used only with an ieee add-on card to access the 
                ;   serial bus.
                ;---------------------------------------------------------------
                ; Input: A = Timeout value.
                ; Output: –
                ; Used registers: –
                ; Real address: $FE21.                
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Disable time-outs on serial bus.
                ;       lda #0
                ;       jsr settmo
                ;---------------------------------------------------------------
                ; Note:
                ; - To enable time-outs, set the accumulator to a 128 and call 
                ;   settmo.
;-------------------------------------------------------------------------------
acptr   = $ffa5 ; ($ee13) recoit un caractere provenant du port serie
                ;---------------------------------------------------------------
                ; Description:
                ; - acptr est utilisÃ© pour recupÃ©rer des donnÃ©es provenant du 
                ;   port série.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: A = Byte read.
                ; Used registers: A.
                ; Real address: $EE13.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Talk et tksa doivent d'abord Ãªtre appelÃ©.
                ;       jsr acptr
                ;       sta $0800
                ;---------------------------------------------------------------
                ; Note:
                ; - Cet exemple ne montre que le rÃ©sultat final.
                ; - Effectuez d'abord lâ€™appel de talk et tksa.
;-------------------------------------------------------------------------------
ciout   = $ffa8 ; ($eddd) Transmit a byte over the serial bus
                ;---------------------------------------------------------------
                ; Description:
                ; - ciout will send data to the serial bus. 
                ; - listen and second must be called first. 
                ; - Call unlsn to finish up neatly.
                ;---------------------------------------------------------------
                ; Input: A = Byte to write.
                ; Output: –
                ; Used registers: –
                ; Real address: $EDDD.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Send the letter x to the serial bus.
                ;       lda #'x
                ;       jsr ciout
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator is used to transfer the data.
;-------------------------------------------------------------------------------
untlk   = $ffab ; ($edef) Send an untalk command
                ;---------------------------------------------------------------
                ; Description:
                ; - All devices previously set to talk will stop sending data.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: –
                ; Used registers: A.
                ; Real address: $EDEF.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Command serial bus to stop sending data.
                ;       jsr untlk
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - Sending untlk commands all talking devices to get off the 
                ;   serial bus.
;-------------------------------------------------------------------------------
unlsn   = $ffae ; ($edfe) Send an unlisten command
                ;---------------------------------------------------------------
                ; Description:
                ; - unlsn commands all devices on the serial bus to stop
                ;   receiving data.
                ;---------------------------------------------------------------
                ; Input: –
                ; Output: –
                ; Used registers: A.
                ; Real address: $EDFE.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Command the serial bus to unlisten.
                ;       jsr unlsn
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The serial bus can now be used for other things.
;-------------------------------------------------------------------------------
listen  = $ffb1 ; ($ed0c) Command a device on the serial bus to listen.
                ;---------------------------------------------------------------
                ; Description:
                ; - listen will command any device on the serial bus to receive 
                ;   data.
                ;---------------------------------------------------------------
                ; Input: A = Device number.
                ; Output: –
                ; Used registers: A.
                ; Real address: $ED0C.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Command device #8 to listen.
                ;       lda #8
                ;       jsr listen
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator designates the device #.
;-------------------------------------------------------------------------------
talk    = $ffb4 ; ($ed09) Command a device on the serial bus to talk
                ;---------------------------------------------------------------
                ; Description:
                ; - This routine will command a device on the serial bus to 
                ;   send data.
                ;---------------------------------------------------------------
                ; Input: A = Device number.
                ; Output: –
                ; Used registers: A.
                ; Real address: $ED09.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Command device #8 to talk.
                ;       lda #8
                ;       jsr talk
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator designates the file number.
;-------------------------------------------------------------------------------
readst  = $ffb7 ; ($fe07) Read i/o status word
                ;---------------------------------------------------------------
                ; Description:
                ; - When called, readst returns the status of the i/o devices. 
                ; - Any error code can be translated as operator error.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Check for read error.
                ;       jsr readst
                ;       cmp #16
                ;       beq error
                ;---------------------------------------------------------------
                ; Note:
                ; - In this case, if the accumulator is 16, a read error 
                ;   occurred.
;-------------------------------------------------------------------------------
setlfs  = $ffba ; ($fe00) Set up a logical file
                ;---------------------------------------------------------------
                ; Description:
                ; - setlfs stands for set logical address, file address, and 
                ;   secondary address. 
                ; - After setlfs is called, open may be called.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Set logical file #1, device #8, secondary address of 15.
                ;       lda #1
                ;       ldx #8
                ;       ldy #15
                ;       jsr setlfs
                ;---------------------------------------------------------------
                ; Note:
                ; - If open is called, the command will be open 1,8,15.
;-------------------------------------------------------------------------------
setnam  = $ffbd ; ($fdf9) Set up file name
                ;---------------------------------------------------------------
                ; Description:
                ; - In order to access the open, load, or save routines, 
                ; - Setnam must be called first.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Setnam will prepare the disk drive for'file#1'.
                ;       lda #6
                ;       ldx #l,name
                ;       ldy #h,name
                ;       jsr setnam
                ;       name.by 'file#l'
                ;---------------------------------------------------------------
                ; Note:
                ; - Accumulator is file length, x = low byte, and y = high byte.
;-------------------------------------------------------------------------------
open    = $ffc0 ; ($f3a4) Open a logical file
                ;---------------------------------------------------------------
                ; Description:
                ; - After setlfs and setnam have been called, you can open a 
                ;   logical file.
                ;---------------------------------------------------------------
                ; Exemple:
                ; Duplicate the command open 15,8,15,'i/o'
                ;       lda #3
                ;       ldx #l,name
                ;       ldy #h,name
                ;       jsr setnam
                ;       lda #15
                ;       ldx #8
                ;       ldy #15
                ;       jsr setlfs
                ;       jsr open
                ;       rts
                ;       name .by 'i/o'
                ;---------------------------------------------------------------
                ; Note:
                ; - Opens the current name file with the current lfs.
;-------------------------------------------------------------------------------
close   = $ffc3 ; ($f291) Close a logical file
                ;---------------------------------------------------------------
                ; Description:
                ; - This routine will close any logical file that has been 
                ;   opened.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Close logical file #2.
                ;       lda #2
                ;       jsr close
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator designates the file #.
;-------------------------------------------------------------------------------
chkin   = $ffc6 ; ($f20e) Define an input channel. 
                ;---------------------------------------------------------------
                ; Description:
                ; - chkin is used to define any opened file as an input file. 
                ; - open must be called first.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Define logical file #2 as an input channel.
                ;       ldx #2
                ;       jsr chkin
                ;---------------------------------------------------------------
                ; Note:
                ; - The x register designates which file #.
;-------------------------------------------------------------------------------
chkout  = $ffc9 ; ($f250) Define an output channel.
                ;---------------------------------------------------------------
                ; Description:
                ; - Just like chkin, but it defines the file for output. 
                ; - open must be called first.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Define logical file #4 as an output file.
                ;       ldx #4
                ;       jsr chkout
                ;---------------------------------------------------------------
                ; Note:
                ; - The x register designates which file #.
;-------------------------------------------------------------------------------
clrchn  = $ffcc ; ($f333) - Clear all i/o channels.
                ;---------------------------------------------------------------
                ; Description:
                ; - clrchn resets all channels and i/o registers - the input to 
                ;   keyboard and the output to screen.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Restore default values to i/o devices.
                ;       jsr clrchn
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator and the x register are altered.
;-------------------------------------------------------------------------------
chrin   = $ffcf ; ($f157) Get a character from the input channel
                ;---------------------------------------------------------------
                ; Description:
                ; - chrin will get a character from the current input device. 
                ; - Calling open and chkin can change the input device.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Store a typed string to the screen.
                ;       ldy #$00
                ; loop  jsr chkin
                ;       sta $0800,y
                ;       iny
                ;       cmp #$0d
                ;       bne loop
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - This example is like an input statement. try running it.
;-------------------------------------------------------------------------------
chrout  = $ffd2 ; ($f1ca) Output a character
                ;---------------------------------------------------------------
                ; Description:
                ; - Load the accumulator with your number and call. 
                ; - open and chkout will change the output device.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Duplicate the command of cmd 4: print "a";
                ;       ldx #4
                ;       jsr chkout
                ;       lda #'a
                ;       jsr chrout
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The letter a is printed to the screen. 
                ; - Call open first for the printer.
;-------------------------------------------------------------------------------
load    = $ffd5 ; ($f49e) Load device to RAM.
                ;---------------------------------------------------------------
                ; Description:
                ; - The computer will perform either the load or the verify 
                ;   command. 
                ; - If the ac cumulator is a 1, then load; if 0, then verify.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Load a program into memory.
                ;       lda #$08
                ;       ldx #$02
                ;       ldy #$00
                ;       jsr setlfs
                ;       lda #$04
                ;       ldx #l,name
                ;       ldy #h,name
                ;       jsr setnam
                ;       lda #$00
                ;       ldy #$20
                ;       jsr load
                ;       rts
                ;       name .by 'file'
                ;---------------------------------------------------------------
                ; Note:
                ; - Program 'file' will be loaded into memory starting at 8192 
                ;   decimal, x being the low byte and y being the high byte for 
                ;   the load.
;-------------------------------------------------------------------------------
save    = $ffd8 ; ($f5dd) Save memory to a device.
                ;---------------------------------------------------------------
;-------------------------------------------------------------------------------
settim  = $ffdb ; ($f6e4) Set the system clock.
                ;---------------------------------------------------------------
                ; Description:
                ; - settim is the opposite of rdtim: it sets the system clock
                ;   instead of reading it.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Set system clock to 10 minutes =3600 jiffies.
                ;       lda #0
                ;       ldx #l,3600
                ;       ldy #h,3600
                ;       jsr settim
                ;---------------------------------------------------------------
                ; Note:
                ; - This allows very accurate timing for many things.
;-------------------------------------------------------------------------------
rdtim   = $ffde ; ($f6dd) Read system clock
                ;---------------------------------------------------------------
                ; Description:
                ; - Locations 160-162 are transferred, in order, to the y 
                ;   and x registers and the accumulator.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Store system clock to screen.
                ;       jsr rdtim
                ;       sta 1026
                ;       stx 1025
                ;       sty 1024
                ;---------------------------------------------------------------
                ; Note:
                ; - The system clock can be translated as hours/minutes/seconds.
;-------------------------------------------------------------------------------
stop    = $ffe1 ; ($f6ed) Check if stop key is pressed.
                ;---------------------------------------------------------------
                ; Description:
                ; - Stop will set the z flag of the accumulator if the stop key 
                ;   was pressed.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Check for stop key being pressed.
                ;        wait      jsr stop
                ;                  bne wait
                ;                  rts
                ;---------------------------------------------------------------
                ; Note:
                ; - stop must be called if the stop key is to remain functional.
;-------------------------------------------------------------------------------
getin   = $ffe4 ; ($f13e) Get a character.
                ;---------------------------------------------------------------
                ; Description:
                ; - getin will get one piece of data from the input device. 
                ; - Open and chkin can be used to change the input device.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Wait for a key to be pressed.
                ;       wait    jsr getin
                ;               cmp #0
                ;               beq wait
                ;---------------------------------------------------------------
                ; Note:
                ; - If the serial bus is used, then all registers are altered.
;-------------------------------------------------------------------------------
clall   = $ffe7 ; ($f32f) Close all open files
                ;---------------------------------------------------------------
                ; Description:
                ; - clall really does what its name implies-it closes all files 
                ;   and resets all channels.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Close all files.
                ;       jsr clall
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The clrchn routine is called automatically.
;-------------------------------------------------------------------------------
udtim   = $ffea ; ($f69b) Update the system clock
                ;---------------------------------------------------------------
                ; Description:
                ; - If you are using your own interrupt system, you can update 
                ;   the system clock by calling udtim.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Update the system clock.
                ;       jsr udtim
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - It is useful to call udtim before calling stop.
;-------------------------------------------------------------------------------
screen  = $ffed ; ($e505) Return screen format
                ;---------------------------------------------------------------
                ; Description:
                ; - Screen returns the number of columns and rows the screen has 
                ;   in the x and y registers.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Determine the screen size.
                ;       jsr screen
                ;       stx maxcol
                ;       sty maxrow
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - screen allows further compatibility between the 64, the 
                ;   vic-20, and future versions of the 64.
;-------------------------------------------------------------------------------
plot    = $fff0 ; ($e50a) Set or retrieve cursor location x=column, y=line
                ;---------------------------------------------------------------
                ; Description:
                ; - If the carry bit of the accumulator is set, then the 
                ;   cursor x,y is returned in the y and x registers. 
                ; - If the carry bit is clear, then the cursor is moved to x,y 
                ;   as determined by the y and x registers.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Move cursor to row 12, column 20 (12,20).
                ;       ldx #12
                ;       ldy #20
                ;       clc
                ;       jsr plot
                ;---------------------------------------------------------------
                ; Note:
                ; - The cursor is now in the middle of the screen.
;-------------------------------------------------------------------------------
iobase  = $fff3 ; ($e500) Define i/o memory page
                ;---------------------------------------------------------------
                ; Description:
                ; - iobase returns the low and high bytes of the starting 
                ;   address of the i/o devices in the x and y registers.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Set the data direction register of the user port to 0 
                ;   (input).
                ;       jsr iobase
                ;       stx point
                ;       sty point+1
                ;       ldy #2
                ;       lda #0
                ;       sta (point),y
                ;---------------------------------------------------------------
                ; Note:
                ; - Point is a zero-page address used to access the ddr 
                ;   indirectly.
;--------------------------------------------------------------------------------
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
kscankey    =   scankey     ;   , scan clavier
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
kd_chrout    =   $f1ca
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
pgmstart        jmp      main  ; le programme principale doit s'appeler "main"
;---------------------------------------------------------------------
; Macro et librairies pour gérer le VIC-II
;---------------------------------------------------------------------
vic00 		= $d000		; VicII C64 memorymap base address
vic 		= $d000		; $d000, 53248 Sprt 0 Horizontal position (X)
vicsprt0x 	= vic+$00	; -------------------------------------------- 						
vic01		= vic+$01	; $d001, 53249 Sprt 0 Vertical position (Y)						
vicsprt0y 	= vic+$01	; --------------------------------------------						
vic02 		= vic+$02	; $d002, 53250 Sprt 1 Horizontal position (X)						
vicsprt1x 	= vic+$02	; --------------------------------------------
vic03 		= vic+$03	; $d003, 53251 Sprt 1 Vertical position (Y)						
vicsprt1y 	= vic+$03	; --------------------------------------------
vic04 		= vic+$04	; $d004, 53252 Sprt 2 Horizontal position (X)						
vicsprt2x 	= vic+$04	; --------------------------------------------
vic05 		= vic+$05	; $d005, 53253 Sprt 2 Vertical position (Y)						
vicsprt2y 	= vic+$05	; --------------------------------------------
vic06		= vic+$06	; $d006, 53254 Sprt 3 Horizontal position (X)						
vicsprt3x 	= vic+$06	; --------------------------------------------
vic07 		= vic+$07	; $d007, 53255 Sprt 3 Vertical position (Y)						
vicsprt3y 	= vic+$07	; --------------------------------------------
vic08 		= vic+$08	; $d008, 53256 Sprt 4 Horizontal position (X)						
vicsprt4x 	= vic+$08	; --------------------------------------------
vic09 		= vic+$09	; $d009, 53257 Sprt 4 Vertical position (Y)						
vicsprt4y 	= vic+$09	; --------------------------------------------
vic0a 		= vic+$0a	; $d00a, 53258 Sprt 5 Horizontal position (X)						
vicsprt5x 	= vic+$0a	; --------------------------------------------
vic0b 		= vic+$0b	; $d00b, 53259 Sprt 5 Vertical position (Y)						
vicsprt5y 	= vic+$0b	; --------------------------------------------
vic0c 		= vic+$0c	; $d00c, 53260 Sprt 6 Horizontal position (X)						
vicsprt6x 	= vic+$0c	; --------------------------------------------
vic0d 		= vic+$0d	; $d00d, 53261 Sprt 6 Vertical position (Y)						
vicsprt6y 	= vic+$0d	; --------------------------------------------
vic0e 		= vic+$0e	; $d00e, 53262 Sprt 7 Horizontal position (X)						
vicsprt7x 	= vic+$0e	; --------------------------------------------
vic0f 		= vic+$0f	; $d00f, 53263 Sprt 7 Vertical position (Y)
vicsprt7y 	= vic+$0f	; --------------------------------------------
;---------------------------------------------------------------------
vicspxmsb   = vic+$10	; MSB sprites horizontal position
vic10       = vic+$10	; $D010, 53264		 |s7|s6|s5|s4|s3|s2|s1|s0|							
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  | sprt7 | sprt6 | sprt5 | sprt4 | sprt3 | sprt2 | sprt1 | sprt0 | 
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
vicctrl0v   = vic+$11	; Miscellaneous Function						
vic11       = vic+$11	; $d011, 53265
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  | rastr |  ext  |  bmp  | blank | 24/25 |  ver  |  ver  |  ver  | 
;  |  bit  |  col  |  mod  |  scr  | lines | scrol | scrol | scrol |
;  |   8   |  mod  |       |       |       | bit 2 | bit 1 | bit 0 |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
vicraster   = vic+$12	; Raster Register
vic12       = vic+$12	; $d012, 53266       |b7|b6|b5|b4|b3|b2|b1|b0|
;---------------------------------------------------------------------
viclpenhp   = vic+$13	; Light Pen Horizontal position
vic13       = vic+$13	; $d013, 53267	     |b7|b6|b5|b4|b3|b2|b1|b0|
;---------------------------------------------------------------------
viclpenvp   = vic+$14	; Light Pen Vertical position
vic14       = vic+$14	; $d014, 53268	     |b7|b6|b5|b4|b3|b2|b1|b0|
;---------------------------------------------------------------------
vicsprctl   = vic+$15	; Turn ON/OFF sprite (1/0)
vic15       = vic+$15	; $d015, 53269	     |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------

vicctrl1h   = vic+$16	; Miscellaneous Function
vic16       = vic+$16	; $d016, 53270
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |       |       | reset | multi | 38/40 |  hor  |  hor  |  hor  | 
;  |   X   |   X   |allways| color | colmn | scrol | scrol | scrol |
;  |       |       |   0   |  mod. |       | bit 2 | bit 1 | bit 0 |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
vicsprtexv  = vic+$17	; Expand sprite Vertically.
vic17       = vic+$17	; $d017, 53271	     |s7|s6|s5|s4|s3|s2|s1|s0|	
;---------------------------------------------------------------------
vicmemptr   = vic+$18	; PTR for character display, bitmap and screen
vic18       = vic+$18	; $d018, 53272 (Bits 7 10 1)
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  txt  |  txt  |  txt  |  txt  | chars | chars | chars |       | 
;  |  scr  |  scr  |  scr  |  scr  |  def  |  def  |  def  |   X   |
;  | bit 3 | bit 2 | bit 1 | bit 0 | bit 2 | bit 1 | bit 0 |       |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
vicirqreg   = vic+$19	; Interrupt register
vic19       = vic+$19	; $d019, 53273
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  vic  |       |       |       | light | sprit | sprit | rastr | 
;  | inter |   X   |   X   |   X   |  pen  | sprit | bkgnd | count |
;  |  flg  |       |       |       | latch | coll. | coll. | maich |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
vicirqena   = vic+$1a	; Interrupt enable register
vic1a       = vic+$1a	; $d01a, 53274
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |   7   |   6   |   5   |   4   |   3   |   2   |   1   |   0   |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;  |  vic  |       |       |       | light | sprit | sprit | rastr | 
;  | inter |   X   |   X   |   X   |  pen  | sprit | bkgnd | count |
;  |  flg  |       |       |       | latch | coll. | coll. | maich |
;  +-------+-------+-------+-------+-------+-------+-------+-------+
;---------------------------------------------------------------------
vicsprtprio = vic+$1b 	; Sprite background priority
vic1b       = vic+$1b 	; $d01b, 53275		 |s7|s6|s5|s4|s3|s2|s1|s0|	
;---------------------------------------------------------------------
vicsprtmcol = vic+$1c 	; Select multi-color mode for sprites
vic1c       = vic+$1c 	; $d01c, 53276		 |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
vicsprtexh  = vic+$1d 	; Expand sprites Horizontally
vic1d       = vic+$1d 	; $d01d, 53277		 |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
vicsprscol  = vic+$1e 	; Sprite to sprite collision
vic1e       = vic+$1e 	; $d01e, 53278		 |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
vicsprbkcol = vic+$1f   ; Sprite to Background collision
vic1f       = vic+$1f   ; $d01f, 53279		 |s7|s6|s5|s4|s3|s2|s1|s0|
;---------------------------------------------------------------------
vicbordcol  = vic+$20   ; Border Color : $00 to $0f
vic20       = vic+$20   ; $d020, 53280		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicback0col = vic+$21 	; Background color #0 : $00 to $0f
vicbackcol  = vic+$21 	; $d021, 53281		 |--|--|--|--|c3|c2|c1|c0|
vic21       = vic+$21 	; $d021, 53281		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicback1col = vic+$22 	; Background color #1 : $00 to $0f
vic22       = vic+$22 	; $d022, 53282		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicback2col = vic+$23 	; Background color #2 : $00 to $0f
vic23       = vic+$23 	; $d023, 53283		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicback3col = vic+$24 	; Background color #3 : $00 to $0f
vic24       = vic+$24 	; $d024, 53284		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprtmc0  = vic+$25 	; Sprite multicolor #0 : $00 to $0f
vic25       = vic+$25 	; $d025, 53285		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprtmc1  = vic+$26 	; Sprite multicolor #1 : $00 to $0f
vic26       = vic+$26 	; $d026, 53286		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt0col = vic+$27 	; Sprite #0 color : $00 to $0f
vic27       = vic+$27 	; $d027, 53287		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt1col = vic+$28 	; Sprite #1 color : $00 to $0f
vic28       = vic+$28 	; $d028, 53288		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt2col = vic+$29 	; Sprite #2 color : $00 to $0f
vic29       = vic+$29 	; $d029, 53289		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt3col = vic+$2a 	; Sprite #3 color : $00 to $0f
vic2a       = vic+$2a 	; $d02a, 53290		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt4col = vic+$2b 	; Sprite #4 color : $00 to $0f
vic2b       = vic+$2b 	; $d02b, 53291		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt5col = vic+$2c 	; Sprite #5 color : $00 to $0f
vic2c       = vic+$2c 	; $d02c, 53292		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt6col = vic+$2d 	; Sprite #6 color : $00 to $0f
vic2d       = vic+$2d 	; $d02d, 53293		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------
vicsprt7col = vic+$2e 	; Sprite #7 color : $00 to $0f
vic2e       = vic+$2e 	; $d02e, 53294		 |--|--|--|--|c3|c2|c1|c0|
;---------------------------------------------------------------------

;----------------------------------------------------------------------
; Fonction .: push
; Auteur ...: Daniel Lafrance
; Date .....: 2020-12-01
; Révision .: 0.0.1
; ---------------------------------------------------------------------
; Description:
; Place tous les registres et les cases mémoires sur $fb à $fe 
; sur la pile et replace pch et pcl au bas de la pile.
; ---------------------------------------------------------------------
; Utilise 4 octets privés pour memoriser manipuler A, P, PCh et PCl.   
;----------------------------------------------------------------------
; Skipped include >>                 .include  "c64_map_kernal.asm"  
push           .block          ; stack : pcl, pch
               php             ; stack : flg, pcl, pch  
               sei
               sta  ra         ; save a
               pla             ; stack : pcl, pch
               sta  rp         ; save rp
               pla             ; stack : pch
               sta  pc         ; save pcl
               pla             ; stack : -
               sta  pc+1       ; save pch
               lda  zpage1     ; get zpage1 low byte
               pha             ; stack : zp1l
               lda  zpage1+1   ; get zpage1 High byte
               pha             ; stack : zp1h, zp1l
               lda  zpage2     ; get zpage2 low byte
               pha             ; stack : zp2l, zp1h, zp1l
               lda  zpage2+1   ; get zpage2 High byte
               pha             ; stack : zp2h, zp2l, zp1h, zp1l 
               lda  rp         ; get rp
               pha             ; stack : flg, zp2h, zp2l, zp1h, zp1l
               lda  ra         ; get a
               pha             ; stack : a, flg, zp2h, zp2l, zp1h, zp1l
               txa             ; get x
               pha             ; stack : x, a, flg, zp2h, zp2l, zp1h, zp1l
               tya             ; get y
               pha             ; stack : y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               lda  pc+1       ; get pch
               pha             ; st ack : pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               lda  pc         ; get pcl
               pha             ; stack : pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               lda  rp         ; get rp
               pha             ; stack : flg, pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               lda  ra         ; get a
               plp             ; stack : pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               cli
               rts
rp             .byte           0
ra             .byte           0
pc             .word           0
               .bend
            
pull
pop            .block         ; stack : pcl, pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
;----------------------------------------------------------------------
; Fonction .: pull/pop
; Auteur ...: Daniel Lafrance
; Date .....: 2020-12-01
; Révision .: 0.0.1
; ---------------------------------------------------------------------
; Description:
; Récupère tous les registres et les cases mémoires $fb à $fe 
; de la pile et replace pch et pcl au bas de la pile.
; ---------------------------------------------------------------------
; Utilise 4 octets privés pour memoriser manipuler A, P, PCh et PCl.   
;----------------------------------------------------------------------
               sei
               pla             ; get pcl stack : pch, y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               sta  pc         ; save pcl
               pla             ; get pch stack : y, x, a, flg, zp2h, zp2l, zp1h, zp1l
               sta  pc+1       ; save pch
               pla             ; get y stack : x, a, flg, zp2h, zp2l, zp1h, zp1l
               tay             ; set y
               pla             ; get x stack : a, flg, zp2h, zp2l, zp1h, zp1l
               tax             ; set x
               pla             ; get a stack : flg, zp2h, zp2l, zp1h, zp1l
               sta  ra         ; save a
               pla             ; get flag stack : zp2h, zp2l, zp1h, zp1l
               sta  rp         ; save rp
               pla             ; stack : zp2l, zp1h, zp1l 
               sta  zpage2+1   ; get zpage1 low byte
               pla             ; stack : zp1h, zp1l
               sta  zpage2     ; get zpage2 High byte
               pla             ; stack : zp1l
               sta  zpage1+1   ; get zpage2 low byte
               pla             ; stack :
               sta  zpage1     ; get zpage1 High byte
               lda  pc+1       ; get pch
               pha             ; stack : pch
               lda  pc
               pha             ; stack : pcl, pch
               lda  rp         ; get rp
               pha             ; stack : rp, pcl, pch
               lda  ra         ; set ra        
               cli
               plp             ; stack : pcl, pch              
               rts
rp             .byte           0
ra             .byte           0
pc             .word           0
               .bend        
        ; Skipped include >>                 .include  "c64_lib_pushpop.asm"
;---------------------------------------------------------------------
; Rempli la page mémoire Y avec le code de A
;---------------------------------------------------------------------
blkfill        .block
bf0            jsr  push
               jsr  savezp1
               sty  zpage1+1
               ;jsr  showregs
               ldy  #$00
               sty  zpage1
bf1            sta  (zpage1),y
               iny
               bne  bf1
               jsr  restzp1
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
; Rempli les pages de Y à Y+X avec le code de A
;---------------------------------------------------------------------
memfill        .block
               jsr  push
mf1            jsr  blkfill
;               jsr  showregs
               iny
               dex
               bne  mf1
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
;    
;---------------------------------------------------------------------
memmove        .block
               jsr  push
               tsx            ; On se crée un pointeur ...
               txa
               clc
               adc  #11            
               tay            
               ldx  #$06
nextbyte       lda  $0100,y
               sta  words,y
               iny
               dex
               bne  nextbyte
               lda  s
               sta  source+1
               lda  s+1
               sta  source+2
               lda  d
               sta  destin+1
               lda  d+1
               sta  destin+2
destin         lda  $ffff
source         sta  $ffff
               inc  destin+1
               bne  src
               inc  destin+2
src            inc  source+1
               bne  cnt
               inc  source+2
cnt            lda  compte
               bne  decit
               lda  compte+1
               beq  fini
               dec  compte+1
decit          dec  compte
               ;jsr  showregs 
               jmp  destin             
fini           jsr  pop
               rts
words
s         .word     $0000
d         .word     $0000
compte    .word     $0000
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
decword        .block
               jsr  push
               stx  zpage2
               sty  zpage2+1

               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
inczp1         .block
               php
               pha
               inc  zpage1
               ;lda  zpage1
               bne  nopage
               inc  zpage1+1
nopage         pla       
               plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
deczp1         .block
               php
               pha
               lda  zpage1
               bne  nopage
               dec  zpage1+1
nopage         dec  zpage1       
               plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
inczp2         .block
               php
               pha
               inc  zpage2
               ;lda  zpage2
               bne  nopage
               inc  zpage2+1
nopage         pla        
               plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
deczp2         .block
               php
               pha
               lda  zpage2
               bne  nopage
               dec  zpage2+1
nopage         dec  zpage2       
               plp         
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
savezp1        .block
               php
               pha
               lda  zpage1
               sta  zp1
               lda  zpage1+1
               sta  zp1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
restzp1        .block
               php
               pha
               lda zp1
               sta zpage1
               lda zp1+1
               sta zpage1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
savezp2
         .block
         php
         pha
         lda zpage2
         sta zp2
         lda zpage2+1
         sta zp2+1
         pla
         plp
         rts
         .bend
;---------------------------------------------------------------------
;
;---------------------------------------------------------------------
restzp2
                .block
                php
                pha
                lda  zp2
                sta  zpage2
                lda  zp2+1
                sta  zpage2+1
                pla
                plp
                rts
                .bend
;---------------------------------------------------------------------
; Calcule 16bits de :
;              addr2 = addr1 + x + (y * ymult)  
;---------------------------------------------------------------------
xy2addr    .block
                php
                pha
                txa
                pha
                tya
                pha
                lda     addr1+1
                sta     addr2+1
                lda     addr1     
                sta     addr2
                cpy     #$00
                beq     addx
moreline        clc
                adc     ymult
                bcc     norepy
                inc     addr2+1     
norepy          sta     addr2
                dey
                bne     moreline
addx            txa
                clc
                adc     addr2
                bcc     thatsit
                inc     addr2+1
thatsit         sta     addr2
                pla
                tay
                pla
                tax
                pla
                plp
                rts
                .bend
;-------------------------------------------------------------------------------
; Variables globales
;-------------------------------------------------------------------------------
ymult          .byte     40                
addr1          .word     $0000    
addr2          .word     $0000
bytecnt        .word     $0000       
zp1        .word   $0000
zp2        .word   $0000

; Skipped include >>                 .include  "c64_lib_pushpop.asm"
;SOF
;*********************************************************************
; Librarie utilisant les Fonctions d'écran du Basic 2.0
;*********************************************************************
; Fichier : c64_lib_basic2.asm
; Auteur. : Daniel Lafrance
; Version : 20221029
;*********************************************************************
;SOS
;*********************************************************************
; Initialisation des paramêtres de base pour la gestion de l'écran 
; virtuelle.
;*********************************************************************
;--------------------------------------------------------------------------------
; c64_bas2map.asm - Carthographie memoire et declaration de constantes pour les
; le Basic 2.0 du commodores 64 et 64c
;--------------------------------------------------------------------------------
; Scripteur...: daniel lafrance, j5w 1w5, canada.
; Version.....: 20191223.1
; Inspiration.: isbn 0-9692086-0-X
; Auteur......: Karl J.H. Hildon
;--------------------------------------------------------------------------------
; Segmentation principales de la mémoire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;--------------------------------------------------------------------------------
; Macro sur les elements importants (* = called by)
;--------------------------------------------------------------------------------
; Basic 2.0 entry point
;--------------------------------------------------------------------------------
;fname        = Addr  ; ##) Description. Register used->;INP;OUT;
b_opentxtspc  = $a3bb ;  1) Open space in BASIC text.   ;a-y;---; Array top $yyaa
b_chkavailmem = $a408 ;  2) Check available Memory. *1  ;a-y;---; Array top $yyaa
b_outofmem    = $a435 ;  3) ?Out of memory.             ;---;---;        
b_errormesg   = $a437 ;  4) Send BASIC error message.   ;a--;---; a = errno
b_warmstart   = $a474 ;  5) Basic warm start.           ;---;---;
b_chrget      = $a48a ;  6) Main CHRGET entry.          ;---;---; 
                      ;     Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                   ($77,$78),
                      ;                   $01ff=Basic inbuf-1
b_newline     = $a49c ;  7) Crunch tokens, insert line. ;-x-;---; x = buff len
b_clrready    = $a52a ;  8) Fix chaining CLR and READY. ;---;---;
b_fixchaining = $a533 ;  9) Fix chaining.               ;---;---;
b_kbgetline   = $a560 ; 10) Recieve line from keyboard.
                      ;     Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                    ($77,$78),
                      ;                    $01ff=Basic inbuf-1
b_crunchtkns  = $a579 ; 11) Crunch token. *7            ;-x-;---: x = buff len
b_findline    = $a613 ; 12) Find line in BASIC.         ;ax-;---; strBAS = $xxaa
b_new         = $a642 ; 13) Do NEW                      ;---;---;
b_resetclr    = $a659 ; 14) Reset BASIC and do CLR      ;---;---; 
b_clr         = $a65e ; 15) Do CLR                      ;---;---;
;Not in BASIC 2 $xxxx ; 16) Purge Stack of all return values
b_rstchrget   = $a68e ; 17) Rst CHRGET to BASIC start   ;---;a--; strBAS hi
b_continue    = $a857 ; 18) Do CONTINUE.                ;a-y;---; curline $yyaa
b_getint      = $a96b ; 19) Get int from BASIX text.    ;---;---;
                      ;     Prerequizite : $7a=#$ff,$7b=#$01, 
                      ;                    ($77,$78),
b_sndcr       = $aad3 ; 20) Send RETURN, LF in scr mode.;---;a--; a = LF
b_sndcrlf     = $aad7 ; 21) Send RETURN, LINEFEED.      ;---;a--; a = LF
b_outstr_ay   = $ab1e ; 22) Print string from $yyaa.    ;a-y;---; sptr = $yyaa
b_puts        = b_outstr_ay
b_outstrprep  = $ab24 ; 23) Print precomputated string. ;a--;---; a = strlen
                      ;     Prerequisit: str addr in $22,$23 ($1f,$20)
b_printqm     = $ab45 ; 24) Print '?'.                  ;---;---;                      
b_sendchar    = $ab47 ; 25) Send char in a to device.   ;a--;a--; a = char                      
b_frmnum      = $ad8a ; Evaluate numeric expression and/or check for data type mismatch
b_evalexpr    = $ad9e ; 26) Evaluate expression.                      
                      ; Prerequisit: Addr of expr in CHRGET ptr.             
                      ; Result: string  $0d = #$FF ($07);---;a-y; expaddr = $yyaa               
                      ;         numeric $0d = #$00 ($07);---;a--; a = result
b_chk4comma   = $aefd ; 27) Check for coma.             ;---;a--; a = char
b_chk4lpar    = $aefa ; 28) check for '('.              ;---;a--; a = char
b_chk4rpar    = $aef7 ; 29) check for ')'.              ;---;a--; a = char
b_syntaxerr   = $af08 ; 30) send 'SYNTAX ERROR'.        ;---;---;
b_fndfloatvar = $b0e7 ; 31) find float var by name.     ;---;a-y; addr = $yyaa
                      ; Prerequisit : name in $45,$46 ($42,$43)
b_bumpvaraddr = $b185 ; 32) Bumb var addr by 2. *31     ;---;a-y; addr = $yyaa
                      ;     Prerequisit : name in $45,$46 ($42,$43).
b_float2int   = $b1bf ; 33) Float to int in Acc#1.      ;---;---;
b_fcerr       = $b248 ; Print ILLEGAL QUANTITY error message.
b_int2float   = $b391 ; 34) Int to float in Acc#1.      ;---;---;
b_getacc1lsb  = $b79e ; 35) Get Acc#1 LSB in x.         ;---;-x-; x = Acc#1 LSB
b_str2float   = $b7b5 ; 36) Evaluate str to float (VAL) ;---;---;
                      ;     Prerequisit : Straddr in CHRGET ptr.
                      ;     Result : Float in Acc#1.
b_strxy2float = $b7b9 ; 37) Eval. float from str in xy. ;---;-xy; strptr = $yyxx
                      ; Result : Float in Acc#1.
b_getpokeprms = $b7eb ; 38) Get 2 params for POKE, WAIT.;---;-x-; x = Param2
                      ;     Prerequisit : Straddr in CHRGET ptr.  
                      ;     Result : param2 in Acc#1.
b_getadr      = $b7f7 ; Convert Floating point number to an Unsighed TwoByte Integer.                      
b_memfloatadd = $b867 ; 39) Add from memory.            ;a-y;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1.
b_memfloatmul = $ba28 ; 40) Multiply from memory.       ;a-y;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1.
b_acc1mul10   = $bae2 ; 41) Multiply Acc#1 by 10.       ;---;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1.
b_memvar2acc1 = $bba2 ; 42) Unpack mem var to Acc#1.    ;a-y;---; ptr = $yyaa
                      ;     Result : floar result in Acc#1
b_copyacc12xy = $bbd7 ; 43) Copy Acc#1 to mem location. ;-xy;---; ptr = $yyxx
b_acc2toacc1  = $bbfc ; 44) Move Acc#2 to Acc#1.        ;---;---;  
b_rndac1ac2   = $bc0c ; 45) Move rnd Acc#1 to Acc#2.    ;---;---;  
b_urndac1ac2  = $bc0f ; 46) Move unrnd Acc#1 to Acc#2.  ;---;---;  
b_rndac1      = $bc1b ; 47) Round Acc#1.                ;---;---;  
b_putint      = $bdcd ; 48) Print fix point value.      ;ax-;---; Value = $xxaa 
b_putfloat    = $bdd7 ; 49) Print Acc#1 float.          ;---;---;
b_num2str     = $bddd ; 50) Cnv num to str at $0100. *48;a-y;---; a=#$00, y=#$01
; Skipped include >>                 .include  "c64_map_vicii.asm" 
; Skipped include >>                 .include  "c64_lib_pushpop.asm"
; Skipped include >>                 .include  "c64_lib_mem.asm"

bkcol0         =    0
bkcol1         =    0
bkcol2         =    0
bkcol3         =    0

scrmaninit     .block  
               jsr  push           ; Sauvegarde le statut CPU  
               lda  vicmemptr      ; Modifie le registre du VIC ...
               and  #%11111101     ; ... pour le pointer à la ...
               sta  vicmemptr      ; ... page normale.
               lda  #vbleu         ; Place la couleur vvert ...
               sta  vicbackcol     ; ... l'arrière plan.
               lda  #vbleu1        ; Place la couleur vbleu ...
               sta  vicbordcol     ; ... dans la bordure.
               lda  #vblanc        ; Sélectionne le vblanc ...
               sta  bascol         ; ... comme couleur des carac.
               lda  #$0e           ; Écrit le caractère ...
               jsr  putch          ; ... [LOWERCASE].
               jsr  cls            ; On efface l'écran. 
               jsr  pop            ; Récupère le statut CPU
               rts
               .bend  

scrnormal      .block               
               jsr  push               
;               lda  vicmemptr      ; Modifie le registre du VIC ...
;               and  #%11111101     ; ... pour le pointer à la ...
;               sta  vicmemptr      ; ... page normale.
               lda  #vbleu1         ; Place la couleur vvert ...
               sta  vicbackcol     ; ... l'arrière plan.
               lda  #vbleu         ; Place la couleur vbleu ...
               sta  vicbordcol     ; ... dans la bordure.
               lda  #vbleu         ; Sélectionne le vblanc ...
               sta  bascol         ; ... comme couleur des carac.
               lda  #$8e           ; Écrit le caractère ...
               jsr  putch          ; ... [LOWERCASE].
               jsr  cls            ; On efface l'écran. 
               jsr  pop
               rts
               .bend
;SOS
;*********************************************************************
; Place le curseur à HOME, efface l'écran et en mode minuscule.
;*********************************************************************
cls            .block
               php                 ; Sauvegarde le registre de statut.
               pha                 ; Sauvegarde le registre A.
               lda  #$93           ; Écrit le charactère ...
               jsr  putch          ; ... [CLR-HOME].
               pla                 ; Récupère le registre A.                 
               plp                 ; Récupère le registre de statut.
               rts
               .bend
;SOS
;*********************************************************************
; Positionne le curseur à la position Ligne X, Colonne Y 
;*********************************************************************
gotoxy         .block
               jsr  push
               txa                 ; On doit effectuer cet échange ...
               pha                 ; ... entre X et Y parce que    ... 
               tya                 ; ... la fonction PLOT prend la ... 
               tax                 ; ... colonne dans Y et la      ...
               pla                 ; ... ligne dans X. Ce qui est  ...
               tay                 ; ... contre intuitif.          ...
               clc                 ; Carry = 0 : set cursor 
               jsr  kplot          ; Appel au Kernal pour positionner.
               jsr  pop
               rts
               .bend
;SOS
;*********************************************************************
; Positionne C=1 ou Sauvegarde C=0 le curseur dans la couleur défaut.
;*********************************************************************
cursor         .block
bascol    =    $0286
               jsr  push           ; Sauvegarde le statut CPU
               bcc  restore        ; Si Carry = 0 on veut positionner.
               jsr  kplot          ; Si non on veut récupérer ...
               sty  cx             ; ... la colonne ...
               stx  cy             ; ... la ligne ...
               lda  bascol         ; ... et on sauvegarde ...
               sta  bcol           ; ... la couleur.
               jmp  out            ; c'est fini
restore        ldx  cy             ; On prend la ligne ...
               ldy  cx             ; ... la colonne et ...
               jsr  kplot          ; ... on positionne le curseur.
               lda  bcol           ; On replace la couleur ...
               sta  bascol         ; ... sauvegardée.
out            jsr  pop            ; Récupère le statut CPU
               rts
cx   .byte     $00
cy   .byte     $00
bcol .byte     $00
               .bend
;SOS
;*********************************************************************
; Sauvegarde la position du curseur virtuel.
;*********************************************************************
cursave        .block
               php                 ; Sauvegarde le registre de statut.
               sec                 ; Place le Carry à 1. 
               jsr  cursor         ; Appel la fonction curseur.
               plp                 ; Récupère le registre de statut.
               rts
               .bend
;SOS
;*********************************************************************
; Replace le curseur virtuel àa la dernière position sauvegardée.
;*********************************************************************
curput         .block
               php                 ; Sauvegarde le registre de statut.
               clc                 ; Place le Carry à 0.
               jsr  cursor         ; Appel la fonction curseur.
               plp                 ; Récupère le registre de statut.
               rts
               .bend
;SOS
;*********************************************************************
; Place le caractère présent dans A à la position du curseur.
;*********************************************************************
putch          .block
               php                 ; Sauvegarde le registre de statut.
               jsr  chrout         ; Appel au Kernal pour afficher.
               plp                 ; Récupère le registre de statut.
               rts
               .bend
;SOS
;*********************************************************************
; Affiche la chaine pointée par $YYXX se terminant par 0.
;*********************************************************************
puts           .block
               jsr  push           ; Sauvegarde le statut CPU
               stx  zpage1         ; Le LSB de l'adresse sur ZP1.
               sty  zpage1+1       ; Le MSB de l'adresse sur ZP1+1.
               ldy  #$00           ; On se fait un pointeur de caract.
nextcar        lda  (zpage1),y     ; On charge chacun des caractères.
               cmp  #$00           ; Jusqu'à ce que nous rencontrons
               beq  out            ; ...  un 0.
               jsr  putch          ; Appel à Basic pour afficher.
               iny                 ; On déplace le pointeur.
               jmp  nextcar        ; On passe au suivant.
out            jsr  pop            ; Récupère le statut CPU
               rts
               .bend
;SOS
;*********************************************************************
; Affiche un chaine de caractère se terminant par 0.
; Les deux premiers octets indiquent la position X,Y à l'écran du 
; début de la chaine.
;*********************************************************************
putsxy         .block
               jsr  push
               stx  zpage1
               sty  zpage1+1
               ldy  #$00           ; On pointe sur le premier octets
               lda  (zpage1),y     ; On récupère la colonne et ...
               tax                 ; ... on la sauvegarde.
               jsr  inczp1         ; On passe au paramètre suivant.
               lda  (zpage1),y     ; On récupère la ligne et ...
               tay                 ; ... on la sauvegarde.
               jsr  gotoxy
               jsr  inczp1
               ldx  zpage1
               ldy  zpage1+1
               jsr  puts
               jsr  pop
               rts
               .bend
;SOS
;*********************************************************************
; Affiche un chaine de caractère se terminant par 0.
; Le premier octet indique la couleur et les deux suivants indiquent
; la position X,Y à l'écran du début de la chaine.
;*********************************************************************
putscxy        .block
               jsr  push
               stx  zpage1         ; rX contient le LSB de l'adresse.
               sty  zpage1+1       ; rY contient le MSB de l'adresse.
               lda  bascol         ; Sauvegarde la couleur basic ...
               sta  bc+1           ; ... dans une variable locale.
               ldy  #$00
               lda  (zpage1),y     ; On charge le param de couleur ...
               sta  bascol         ; ... et on l'indique a BASIC.
               jsr  inczp1
               ldx  zpage1
               ldy  zpage1+1
               jsr  putsxy
bc             lda  #$00           ; On replace la couleur basic ...
               sta  bascol         ; ... originale.
               jsr  pop             
               rts
               .bend
;SOS
;*********************************************************************
; Place le Commodore 64 en mode d'affichage inversé. 
;*********************************************************************
setinverse     .block
               php
               pha                 ; Sauvegarde le registre A.
               lda  #$12           ; Commande Inversion.
               jmp  inverse        ; Branche àa l'action
               .bend
;SOS
;*********************************************************************
; Place le Commodore 64 en mode d'affichage non-inversé.
;*********************************************************************
clrinverse     .block
               php                 ; Sauvegarde le CCR.
               pha                 ; Sauvegarde le registre A.
               lda  #$92           ; Commande Annulation Inversion.
               jmp  inverse        ; Branche àa l'action.
               .bend
inverse        .block           
               jsr  $ffd2          ; Affiche la commande.
               pla                 ; Récupère le registre A.
               plp                 ; Récupère le CCR.
               rts
               .bend
;SOS
;*********************************************************************
; Sélectionne la couleur du texte basic
;*********************************************************************
settxtcol      .block
               sta  bascol
               rts
               .bend
;SOS
;*********************************************************************
; Sélectionne la couleur du fond d'écran du VICII.
;*********************************************************************
setbgndcol     .block
               sta  vicbackcol
               rts
               .bend
;SOS
;*********************************************************************
; Sélectionne la couleur du fond d'écran du VICII.
;*********************************************************************
setbordcol     .block
               sta  vicbordcol
               rts
               .bend

;EOF
;SOF
;*********************************************************************
; Librarie de fonctions pour afficher les nombres en hexadécimal et 
; en binaire.
;*********************************************************************
; Fichier : c64_lib_hex.asm
; Auteur. : Daniel Lafrance
; Version : 20221029
;*********************************************************************
; ** Note: Utilise: butils.asm
;*********************************************************************
;SOV
;*********************************************************************
; Région mémoire qui contiendra la chaine de conversion hexadécimale.
;*********************************************************************
a2hexbkcol     .byte     %00000000 ; Couleur arriere plan en mode MC.
a2hexcol       .byte     1         ; Couleur du texte.
a2hexpos                           ; Pointeur sur le début de chaine.
a2hexpx        .byte     0         ; Colonne X
a2hexpy        .byte     0         ; Ligne Y
a2hexfmt       .byte     "$"       ; Le préfix de la chaine.
a2hexstr       .word     $0000     ; Utilisé aussi pour la ... 
               .word     $0000     ; ...conversion 16 bit.
               .byte     0         ; 0 Fin de chaine de caractères.
;*********************************************************************
; Région mémoire qui contiendra la chaine de conversion binaire.
;*********************************************************************
a2binbkcol     .byte     %00000000 ; Couleur arriere plan en mode MC.
a2bincol       .byte     1         ; Couleur du texte.
a2binpos                           ; Pointeur sur le début de chaine.
a2binpx        .byte     0         ; Colonne X
a2binpy        .byte     0         ; Ligne Y
a2binfmt       .byte     "%"       ; Le préfix de la chaine.               
a2bin          .byte     0,0,0,0   ; Utilisé aussi pour la ...
               .byte     0,0,0,0   ; ...
               .byte     0,0,0,0   ; ...
               .byte     0,0,0,0   ; ... conversion 16 bit.
               .byte     0         ; 0 Fin de chaine de caractères.
;SOS
;*********************************************************************
; Transforme le quartets le moins significatif du registre A en son
; équivalent hexadécimal. La méthode décimal la plus rapide.
;*********************************************************************
nibtohex       .block          
               php                 ; Sauvegarde le registre d'état.             
               and  #$0f           ; On masque le MSN.
               sed                 ; On place le CPU en mode décimal.
               clc                 ; O -> Carry.
               adc  #$90           ; On ajoute 90. 
               adc  #$40           ; On ajoute 40.
               cld                 ; On place le CPU en mode hexa.
               plp                 ; Récupère le registre d'état.
               rts
               .bend
;SOS
;*********************************************************************
; Décale le contenu du registre A de 4 bits vers la droite.
;*********************************************************************
lsra4bits      .block
               php                 ; Sauvegarde le registre d'état.
               lsr                 ; Décale de   ...
               lsr                 ; ... 4 bits  ...
               lsr                 ; ... vers la ...
               lsr                 ; ... droite. 
               plp                 ; Récupère le registre d'état.  
               rts
               .bend
;SOS
;*********************************************************************
; Transforme le contenu du registre A
; dans son équivalent Petscii
; hehadécimal.
; Le résultat est une chaine-0.
; Entré : A
; Sortie : chaine-0 à a2hexstr.
; Il est possible de changer la couleur
; et la position de l'affichage en 
; modifiant les variables :
;         a2hexcol, a2hexpx et a2hexpy.
; Utilisez les pointeurs :
; a2hexcol - modifie couleur, position
; a2hexpos - modifie position
; a2hexstr - affiche la chaine
; a2hexstr+1 - sans afficher le ($)
;*********************************************************************
atohex         .block
               php                 ; Sauvegarde le registre d'état.
               pha                 ; Memorise le registre A.
               pha                 ; On le remémorise encore. 
               jsr  lsra4bits      ; On décale le MSN vers le LSN.
               jsr  nibtohex       ; On transforme le LSN en Petsci.
               sta  a2hexstr       ; On le sauvegarde dans la chaine.
               pla                 ; On récupère le registre A.
               jsr  nibtohex       ; On transforme le LSN en petscii.
               sta  a2hexstr+1     ; On le sauvegarde dans la chaine.
               lda  #$00           ; On marque la fin de la ...
               sta  a2hexstr+2     ; ... chaine d'un zéro.
               pla                 ; On récupère le registre A. 
               plp                 ; Récupère le registre d'état.
               rts
               .bend
;SOS
;*********************************************************************
; Transforme le contenu du registre A en hexadécimal l'affiche  à la 
; position du curseur.
; Entrée : A
; Sortie : Affiche de rA en hexadécimal à la position du curseur.
; **Note : a2hexcol, a2hexpx et a2hexpy doivent être modifiées avant 
;          l'appel.
;*********************************************************************
putatohex       .block
               jsr  push           ; Sauvegarde le registre de statut.
               jsr  atohex         ; Transforme A en chaine hexa.
               ldx  #<a2hexstr     ; Charge le LSB et ...
               ldy  #>a2hexstr     ; le MSB de la chaine dans YYAA.
               jsr  puts           ; Affiche par la fonction BASIC.
               jsr  pop            ; Récupère le registre de statut.
               rts
               .bend
;SOS
;*********************************************************************
; Transforme le contenu du registre A en hexadécimal l'affiche 
; à la position du curseur.
; Entrée : A
; Sortie : Affiche de rA en hexadécimal à la position du curseur.
; **Note : a2hexcol, a2hexpx et a2hexpy doivent être modifiées avant 
;          l'appel.
;*********************************************************************
putatohexfmt   .block
               jsr  push           ; Sauvegarde le registre de statut.
               jsr  atohex         ; Transforme A en chaine hexa.
               ldx  #<a2hexfmt     ; Charge le LSB et ...
               ldy  #>a2hexfmt     ; le MSB de la chaine dans YYAA.
               jsr  puts           ; Affiche par la fonction BASIC.
               jsr  pop            ; Récupère le registre de statut.
               rts
               .bend
;SOS
;*********************************************************************
; Converti le nombre 16 bits contenu dans $XXYY en hexadécimal.
;*********************************************************************
xytohex        .block
               jsr  push           ; Sauvegarde le statut du CPU.
               tya                 ; On place Y dans A (Le LSB du mot)
               jsr  atohex         ; On le converti en hexadécimal.
               lda  a2hexstr       ; On ...
               pha                 ; ... sauvegarde ...
               lda  a2hexstr+1     ; ... la chaine  de la ...
               pha                 ; ... première conversion ...
               lda  a2hexstr+2     ; ... sur la ...
               pha                 ; ... pile.
               txa                 ; On place X dans A (Le MSB du mot)
               jsr  atohex         ; On le converti en hexadécimal.
               pla                 ; On ramène ...
               sta  a2hexstr+4     ; ... la conversion sauvegardée ...
               pla                 ; ... en prenant soin de la ...
               sta  a2hexstr+3     ; ... placer à la suite de la ...
               pla                 ; ... conversion ...
               sta  a2hexstr+2     ; ... précédente.
               jsr  pop            ; Récupère le statut du CPU.
               .bend
;SOS
;*********************************************************************
; Converti le contenu de A en chaine binaire dans abin. 
;*********************************************************************
atobin         .block
               jsr  push           ; Sauvegarde le statut du CPU.
               ldx  #8             ; Il y a 8 bits dans un octets.
               ldy  #0             ; Initialise le pointeur de chaine.
               rol                 ; comme le MSb passe par carry ...
nextbit        rol                 ; ... on le rol 2 fois au début.
               pha                 ; Om mémorise A sur la pile.
               and  #1             ; On basque tout sauf le bit 0.
               jsr  nibtohex       ; On le transforme en Hexa.
               sta  a2bin,y        ; Place caractères du MSb au LSb. 
               pla                 ; On rappelle A de la pile.
               iny                 ; Pointe sur le caractère suivant.
               dex                 ; Un bit de fait.
               bne  nextbit        ; S'il en reste un continue.
               lda  #0             ; On place le caractère de fin ...
               sta  a2bin,y        ; ... à la fin de la chaine.
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend          
;SOS
;*********************************************************************
; Affiche le contenu de a2bin à la position du curseur.
;*********************************************************************
putatobin      .block
               jsr  push           ; Sauvegarde le statut du CPU.
               jsr  atobin         ; Conversion binaire -> chaine.
               ldx  #<a2bin        ; Pointe X et Y ...
               ldy  #>a2bin        ; ... sur l'adresse de la chaine.
               jsr  puts           ; On affiche la chaine sans format.
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend
;SOS
;*********************************************************************
; Affiche le contenu de abin à la position du curseur.
;*********************************************************************
putatobinfmt   .block
               jsr  push           ; Sauvegarde le statut du CPU.
               jsr  atobin         ; Conversion binaire -> chaine.
               ldx  #<a2binfmt     ; Pointe X et Y ...
               ldy  #>a2binfmt     ; ... sur l'adresse de la chaine.
               jsr  puts           ; On affiche la chaine formattée.
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend   
;SOS
;*********************************************************************
; Affiche le contenu de abin à la position x, y prédéterminée.
;*********************************************************************
putatobinpos   .block
               jsr  push           ; Sauvegarde le statut du CPU.
               ldx  a2binpx        ; On lit les positions x col. ...
               ldy  a2binpy        ; ... et y ligne pour...
               jsr  gotoxy         ; ... positionner le curseur.
               jsr  putatobin      ; On affiche la chaine binaire.
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend                
;SOS
;*********************************************************************
; Affiche le contenu de abin à la position x colonne, y ligne.
; *** Variante pour spécifier dynamiquement une position x/y a la  
; fonction putatobinpos.
;*********************************************************************
putatobinxy    .block
               jsr  push           ; Sauvegarde le statut du CPU.
               stx  a2binpx        ; On mémorise les nouvelles ...
               sty  a2binpy        ; ... positions x/y dans la chaine.
               jsr  putatobinpos   ; On affiche la chaine à sa ...
                                   ; ... nouvelle position
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend                
;SOS
;*********************************************************************
; Affiche le contenu de abin à la position déterminé en le préfixan du
; symbole (%).
;*********************************************************************
putatobinfmtpos  
               .block
               jsr  push           ; Sauvegarde le statut du CPU.
               ldx  a2binpx        ; On lit les positions x col. ...
               ldy  a2binpy        ; ... et y ligne pour...
               jsr  gotoxy         ; ... positionner le curseur.
               jsr  putatobinfmt   ; On affiche la chaine %binaire.
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend
;SOS
;*********************************************************************
; Affiche le contenu de abin à la position x colonne, y ligne.
; *** Variante pour spécifier dynamiquement une position x/y a la  
; fonction putatobinpos.
;*********************************************************************
putatobinfmtxy .block
               jsr  push           ; Sauvegarde le statut du CPU.
               stx  a2binpx        ; On mémorise les nouvelles ...
               sty  a2binpy        ; ... positions x/y dans la chaine.
               jsr  putatobinfmtpos; On affiche la chaine à sa ...
                                   ; ... nouvelle position
               jsr  pop            ; Récupère le statut du CPU.
               rts
               .bend
;EOF;---------------------------------------------------------------------------
; Program ...: VICII Multi Color mode screen managing utilities
; Fichier ...: c64_lib_text_mc.asm
; Auteur ....: Daniel Lafrance     
; Création ..: 2020-01-01     
; Version ...: 22.03.04     
; Dépendance : c64_map_kernal.asm, c64_map_vicii.asm
;---------------------------------------------------------------------------
; Ordinogramme fichier A
;---------------------------------------------------------------------------
; Variables globales Utilisees par ces fonctions
;---------------------------------------------------------------------------
                                        ; Pour le prochain catactère ...
scrptr         .word     $00            ; ... pointe position ecran, ...
colptr         .word     $00            ; ... pointe position couleur, ...
curcol         .byte     $01            ; ... la couleur du caractère, ...
brdcol         .byte     vbleu          ; ... la couleur de la bordure et
                                        ; ... les couleurs d'arrièere plan:
vicbkcol0      .byte     vnoir  ;$0b    ; 0,
vicbkcol1      .byte     vbleu  ;$0b    ; 1,
vicbkcol2      .byte     vblanc ;$0b    ; 2,
vicbkcol3      .byte     vrouge ;$0b    ; et 3.
inverse        .byte     $00
scraddr        .byte     0,0,0,0,0
coladdr        .byte     0,0,0,0,0
bkcol          .byte     %00000000      ; Pointeur de la couleur actuelle
virtaddr       .word     $0400          ; L'adresse de l'ecran virtuel 
;---------------------------------------------------------------------------
; Macros pour la sélection des couleurs d'arrière plan des caractèeres.
;---------------------------------------------------------------------------
bkcol0         =         %00000000      ; 
bkcol1         =         %01000000
bkcol2         =         %10000000
bkcol3         =         %11000000
;---------------------------------------------------------------------------
; Initialise le pointeur et efface l'ecran.
;---------------------------------------------------------------------------
scrmaninit  .block
               php            ; On sauvegarde les registres
               pha
               lda  #%00010101; Selectionne la plage memoire video
               sta  $d018     ; et le jeu de caracteeres.          
     ;----------------------------------------------------------------------
     ; Registre $18/24 du VIC-II - Role de l'octet place dans $d018
     ;----------------------------------------------------------------------
     ; bits: 
     ; 76543210         
     ; |||||||0->   Non utilise 
     ; ||||||1--\
     ; |||||2---->  Adresse du jeu de carac. 
     ; ||||3----/     (*2048) (*$800)
     ; ||||
     ; |||4-----\   Video RAM address 
     ; ||5-------\    (*1024) (*$400)
     ; |6--------/    1024, 2018, 3072,
     ; 7--------/     4096, ... 
     ;----------------------------------------------------------------------
               lda  $d016     ; 53270 Lecture valeur actuelle pour ne 
               ora  #%00010000; modifier que le bit 4.
               and  #%11101111
               sta  $d016 ; 53270
     ;----------------------------------------------------------------------
     ; Registre $16/22 du VIC-II - Role de l'octet place dans $d016
     ;----------------------------------------------------------------------
     ; bits: 
     ; 76543210         
     ; |||||||0\   
     ; ||||||1--> Defilement horizontal
     ; |||||2--/ 
     ; |||||
     ; ||||3----> Format 38/40 carac.  
     ; |||4-----> Mode multi-couleur On/Off 
     ; ||5------> Reinitialisation Tjrs 0
     ; |6-------> 
     ; 7--------> Non utilise 
     ;----------------------------------------------------------------------
               lda  $d011     ; On ne change que le bit 6 pour
               ora  #%01000000; selectionner le md. couleur de
               sta  $d011     ; 53270   ; fond etendu.
     ;----------------------------------------------------------------------
     ; Registre $11/17 du VIC-II - Role de l'octet place dans $d011
     ;----------------------------------------------------------------------
     ; bits: 
     ; 76543210         
     ; |||||||0-\
     ; ||||||1---> Defilement verticale
     ; |||||2---/
     ; ||||3----> Md. 24/25 ligne
     ; |||4-----> Inhibe l'affichage 
     ; ||5------> Md. bitmap
     ; |6-------> Md. coul. ext. fond ecran
     ; 7--------> Bit 8 reg. $d012 (Raster)
     ;----------------------------------------------------------------------
     ; La couleur de l'arriere plan est choisi par les bits 6 et 7 du 
     ; caractere affiche.
     ; Dans mode le jeux de caracteeres est restreind à 64;
     ;----------------------------------------------------------------------
     ; @ABCDEFGHIJKLMNOPQRSTUVWXYZ[£]^<  
     ;  !"#$%&'()*+,-./0123456789:;<=>?
     ; ou 
     ; @abcdefghijklmnopqrstuvwxyz[£]^<  
     ;  !"#$%&'()*+,-./0123456789:;<=>?
     ;----------------------------------------------------------------------
     ; Pre selection des quatre couleurs de fond d'ecran par defaut.
     ;----------------------------------------------------------------------
               lda  vicbkcol0
               sta  $d021     ; 53281
               lda  vicbkcol1
               sta  $d022     ; 53282
               lda  vicbkcol2
               sta  $d023     ; 53283
               lda  vicbkcol3
               sta  $d024     ; 54284
               lda  bkcol0    ; On charge et utilise la couleur de ...
               sta  bkcol     ; ... fond par defaut des caracteres.
               jsr  cls       ; Finalement on efface l'ecran          
               pla
               plp
               rts
               .bend
scrnormal      .block               
               jsr  push               
               lda  vicmemptr      ; Modifie le registre du VIC ...
               and  #%11111101     ; ... pour le pointer à la ...
               sta  vicmemptr      ; ... page normale.
               lda  #vbleu1         ; Place la couleur vvert ...
               sta  vicbackcol     ; ... l'arrière plan.
               lda  #vbleu         ; Place la couleur vbleu ...
               sta  vicbordcol     ; ... dans la bordure.
               lda  #vbleu         ; Sélectionne le vblanc ...
               sta  bascol         ; ... comme couleur des carac.
               lda  #$8e           ; Écrit le caractère ...
               jsr  putch          ; ... [LOWERCASE].
               jsr  cls            ; On efface l'écran. 
               jsr  pop
               rts
               .bend

;---------------------------------------------------------------------------
; Replace le curseur virtuel au coin supperieur gauche.
;---------------------------------------------------------------------------
curshome    .block          
               php                      ; Sauvegarde flags ...
               pha                      ; ... et accumulateur
               lda  virtaddr            ; In replace le pointeur ... 
               sta  scrptr              ; ... d'écran virtuel à sa ... 
               lda  virtaddr+1          ; ... position initiale.
               sta  scrptr+1
               jsr  synccolptr          ; On synchronise le ptr couleur.
               lda  vicbkcol0 
               sta  $d021               ; On recharge les couleurs ...
               lda  vicbkcol1           ; ... de fond par defaut tel ...
               sta  $d022               ; ... que specifie dans les ...
               lda  vicbkcol2           ; ... les variables globales.
               sta  $d023 
               lda  vicbkcol3 
               sta  $d024
               pla                      ; Récupère l'accumulateur ...
               plp                      ; ... et les flags
               rts
               .bend
;---------------------------------------------------------------------------
; Incremente le pointeur d'ecran de une position.
;---------------------------------------------------------------------------
incscrptr   .block
               php                      ; Sauvegarde flags ...
               pha                      ; ... et accumulateur
               inc  scrptr              ; Incremente le pointeur
               lda  scrptr              ; Regarde si on doit faire un ... 
               bne  pasdereport         ; ... report dans le MSB
               inc  scrptr+1            ; Si oui on fait le repport
pasdereport    jsr  synccolptr          ; On synchronise le ptr couleur.
               pla                      ; Récupère l'accumulateur ...
               plp                      ; ... et les flags
               rts
               .bend
;---------------------------------------------------------------------------
; Synchronise les pointeurs d'ecran et de couleur.
;---------------------------------------------------------------------------
synccolptr  .block
               php                      ; Sauvegarde flags ...
               pha                      ; ... et accumulateur
     ;----------------------------------------------------------------------
     ; On conserve le LSB comme offset.
     ;----------------------------------------------------------------------
               lda  scrptr              ; Récupère le LSB du scrptr ...
               sta  colptr              ; ... pour le placer dans le colptr.
     ;----------------------------------------------------------------------
     ; Peu importe ou se trouve la memoire video, la memoire de couleurs se 
     ; trouve  toujours à $d800.           
     ;----------------------------------------------------------------------
     ; Exemple: 
     ;  Si le curseur est à $0455 - 2009
     ;  On transforme le MSB en masquant 
     ;  les 6 bits les plus significatif
     ;  et en y ajoutant $d8. 
     ;  Ainsi $0455 devient $d855
     ;----------------------------------------------------------------------
               lda  scrptr+1            ; Récupère le mSB du scrptr, ...
               and  #%00000011          ; ... le converti pour pointer ...
               ora  #%11011000          ; ... la RAM couleur ...
               sta  colptr+1            ; ... et le sauvegarde.
               pla                      ; Récupère l'accumulateur ...
               plp                      ; ... et les flags
               rts
               .bend
;---------------------------------------------------------------------------
; Efface l'ecran avec la couleur voulue et place le curseur à 0,0.
;---------------------------------------------------------------------------
cls            
               .block
               jsr  push                ; On sauvegarde les registres
               lda  virtaddr            ; On replace le curseur d'ecran à
               sta  scrptr
               lda  virtaddr+1          ; sa position initiale, ($0400).
               sta  scrptr+1
               jsr  synccolptr          ; On synchronise la couleur.
               jsr  scrptr2zp1          ; L'adresse actuelle dans le ZP1.
               lda  brdcol              ; On place la couleur ...
               sta  vicbordcol          ; ... de la bordure.
               lda  bkcol               ; Associer couleur pour ...
               sta  vicback0col         ; ... remplir l'ecran ...
               lda  #$20                ; ... de caracteres espace. 
               ldx  #4                  ; Quatre blocs de ...
nextline       ldy  #0                  ; ... 256 caracteres.
     ;----------------------------------------------------------------------
     ; on ecrit l'espace ...
     ;----------------------------------------------------------------------
nextcar        
               sta  (zpage1),y          ;
     ;----------------------------------------------------------------------
     ; On sauvegarde le MSB du pointeur de caracteere actuel
     ;----------------------------------------------------------------------
               lda  zpage1+1
               pha
     ;----------------------------------------------------------------------
     ; On le transforme en pointeur de couleur.
     ;----------------------------------------------------------------------
               and  #%00000011
               ora  #%11011000
     ;----------------------------------------------------------------------     
     ; ... et sa couleur, mais dans laversion multi couleur la ram 
     ; inutilisee, alors on y met des 0            
     ;----------------------------------------------------------------------
               sta  zpage1+1
               lda  #0
               sta  (zpage1),y
     ;----------------------------------------------------------------------
     ; on recupeere le pointeur de caractere de la pile.
     ;----------------------------------------------------------------------
               pla
               sta  zpage1+1
     ;----------------------------------------------------------------------
     ; On remet un espace dans A
     ;----------------------------------------------------------------------
               lda  #$20
     ;----------------------------------------------------------------------
     ; Les 256 ont-ils ete fait ?
     ;----------------------------------------------------------------------
;               jsr  putch
               dey
               bne  nextcar
     ;----------------------------------------------------------------------
     ; On passe aux 256 suivants
     ;----------------------------------------------------------------------
               inc  zpage1+1
     ;----------------------------------------------------------------------
     ; Les 4 pages de 256 ont elles ete faites?
     ;----------------------------------------------------------------------
               dex
               bne  nextcar
     ;----------------------------------------------------------------------
     ; On replace le curseur à 0
     ;----------------------------------------------------------------------
               lda  #$00
               sta  scrptr
               lda  #$04
               sta  scrptr+1
     ;----------------------------------------------------------------------
     ; On synchronise les couleurs
     ;----------------------------------------------------------------------
               jsr  synccolptr
     ;----------------------------------------------------------------------
     ; On replace le ZP1 du programme appelant.
     ;----------------------------------------------------------------------
               ;jsr  restzp1
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------------
; Change la couleur du pourtour et sa valeur de reference.
;---------------------------------------------------------------------------
setborder      .block
               php
               sta  brdcol
               sta  vicbordcol
               plp
               rts
               .bend

;---------------------------------------------------------------------------
; Place le flag de l'inverse video pour le prochain caracteere à afficher.
;---------------------------------------------------------------------------
setinverse  .block
               php
               pha
     ;----------------------------------------------------------------------
     ; En multi couleur on choisi les couleurs de fond #2 ou #3 comme 
     ; inverse video.
     ;----------------------------------------------------------------------
               lda  #%10000000
               sta  inverse
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Retire le flag de l'inverse video pour le prochain caracteere à afficher.
;---------------------------------------------------------------------------
clrinverse     .block
               php
               pha
     ;----------------------------------------------------------------------
     ; En multi couleur on choisi les couleurs de fond #2 ou #3 comme 
     ; inverse video.
     ;----------------------------------------------------------------------
               lda  #%00000000
               sta  inverse
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche le caracteere dans A à la position/couleur de l'ecran virtuel.
;---------------------------------------------------------------------------
putch          .block              ; Voir Ordinogramme B
               jsr  push           ; On sauvegarde les registres
               jsr  scrptr2zp1     ; Place le ptr d'ecran sur zp1
               and  #%00111111     ; Masque des bits 6 et 7 pour la ouleur.
               ora  bkcol          ; On y ajoute la couleur du fond.
               ldy  #0             ; Met Y à 0
               sta  (zpage1),y     ; Affiche le caractere
               ldx  colptr+1       ; Place le MSB du ptr de couleur
               stx  zpage1+1       ; ... dans le MSB du zp1.
               lda  curcol         ; Charge la couleur voulu dans.
               sta  (zpage1),y     ; ... la ram de couleur.
               jsr  incscrptr      ; Incremente le pointeur d'ecran. 
               jsr  pop            ; Replace tous les registres
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche un caracteres dont l'adresse est dans zp2 à la position et la
; couleur du curseur virtuel.        
;---------------------------------------------------------------------------
z2putch        .block              ; Voir Ordinogramme A
               jsr  push           ; On sauvegarde les registres
               ldy  #$0            ; Met Y à 0
               lda  (zpage2),y     ; Charge le caractere
               jsr  putch          ; Appel pour affichage
               jsr  pop            ; Replace tous les registres
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres dont l'adresse est dans zp2 à la 
; position du curseur virtuel.        
;---------------------------------------------------------------------------
z2puts         .block              ; Voir Ordinogramme C
               jsr  push           ; On sauvegarde les registres
               ldy  #$0            ; Met Y à 0
nextcar        lda  (zpage2),y     ; Charge le caractere 
               beq  endstr         ; Est-ce le 0 de fin de chaine ?
               jsr  z2putch        ; Appel pour affichage
               jsr  inczp2         ; On pointe zp2 sur le prochain caractere.
               jmp  nextcar        ; On passe au prochain  
endstr         jsr  pop            ; Replace tous les registres
               rts
               .bend               
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres à la position du curseur virtuel.        
;         ldx <addr        
;         ldy >addr       
;---------------------------------------------------------------------------
puts           .block              ; Voir Ordinogramme D
               jsr  push           ; On sauvegarde les registres
               stx  zpage2         ; On positionne xp2 en fonction de
               sty  zpage2+1       ; l'adresse reçcu dans X et Y
               jsr  z2puts         ; Appel pour affichage
               jsr  pop            ; Replace tous les registres
               rts
               .bend    
;---------------------------------------------------------------------------
; Positionne le pointeur de position du prochain caractere de l'ecran 
; virtuel. 
;---------------------------------------------------------------------------
gotoxy         .block              ; Voir Ordinogramme E
               jsr  push           ; On sauvegarde les registres
               jsr  curshome       ;  retourne le curseur virtuel a 0,0.
yagain         cpy  #0             ; Devons nous changer de ligne ?
               beq  setx           ; Si non, on verifi les colonnes.
               lda  #40            ; Si oui on ajoute 40
               jsr  setaddscrptr   ;  à l'adresse du pointeur virtuel autant 
               dey                 ;  de fois qu'il est spécifié dans y.
               jmp  yagain         ; On passe au prochain y.
setx           txa                 ; On ajoute la valeur de X
               jsr  setaddscrptr   ;  à l'adresse di pointeur virtuel.
               jsr  synccolptr     ; Synchro du pointeur des couleurs
               jsr  pop            ; Replace tous les registres
               rts
               .bend
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres dans la couleus C, à la position X, Y 
; qui sont les trois premier octets de ladresse X = MSB, Y = LSB
;---------------------------------------------------------------------------
putsxy         .block              ; Voir Ordinogramme F
               jsr  push           ; On sauvegarde les registres et le zp2
               stx  zpage2         ; Place l'adr de chaine dans zp2
               sty  zpage2+1       ; X = MSB, Y = LSB
               ldy  #0             ; On place le compteur
               lda  (zpage2),y     ; Lecture de la position X
               tax                 ; de A à X
               jsr  inczp2         ; On deplace le pointeur
               lda  (zpage2),y     ; Lecture de la position Y
               tay                 ; de A à Y
               jsr  gotoxy         ; gotoxy : X=col, Y=ligne 
               jsr  inczp2         ; On deplace le pointeur
               jsr  z2puts         ; On imprime la chaine
               jsr  pop            ; Replace tous les registres
               rts
               .bend    
;---------------------------------------------------------------------------
; Affiche une chaine-0 de caracteres dans la couleus C, à la position X, Y 
; qui sont les trois premier octets deladresse X = MSB, Y = LSB
;---------------------------------------------------------------------------
putscxy        .block
               jsr  push           ; On Sauvegarde registres et zp2         
               stx  zpage2         ; On place l'adresse de chaine dans zp2
               sty  zpage2+1       ; X = MSB, Y = LSB
               ldy  #0             ; Place le compteur
               lda  (zpage2),y     ; Charge la couleur
               sta  curcol         ; ... et on la definie
               jsr  inczp2         ; Pointe le prochain byte
               lda  (zpage2),y     ; Récupere et sauvegarde ...
               sta  bkcol          ; ... l'index de couleur de fond 
               jsr  inczp2         ; Deplace le pointeur
               lda  (zpage2),y     ; Lecture de la position X
               tax                 ; ... de A à X
               jsr  inczp2         ; Deplace le pointeur
               lda  (zpage2),y     ; Lecture de la position Y
               tay                 ; de A à Y
               jsr  gotoxy         ; gotoxy : X=col, y=ligne 
               jsr  inczp2         ; Place le ptr en début de chaine
               jsr  z2puts         ; On imprime la chaine
               jsr  pop
               rts
               .bend    
;---------------------------------------------------------------------------
; Place A dans le registre de couleur du prochain caractere de l'ecran 
; virtuel. 
;---------------------------------------------------------------------------
setcurcol      .block
               php
               sta  curcol
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Place A dans le xieme registre de couleur de l'arriere plan du VIC. 
;---------------------------------------------------------------------------
setvicbkcol    .block
               php
               pha  
               txa
               and  #$03
               tax
               pla
               sta  vicbkcol0,x
               sta  $d021,x
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Place A dans le registre de couleur de l'arriere plan du VIC. 
;---------------------------------------------------------------------------
setbkcol    .block
               php
               pha
               asl
               asl
               asl
               asl
               asl
               asl
               and  #$c0
               sta  bkcol
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Deplace le pointeur du caractere virtuel de A position. 
;---------------------------------------------------------------------------
setaddscrptr  .block
               php
               pha
               clc
               adc  scrptr
               sta  scrptr
               bcc  norep
               inc  scrptr+1
norep          pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Conversion de l'adresse SCRPTR en hexadecimal.
;---------------------------------------------------------------------------
scrptr2str  .block
     ;----------------------------------------------------------------------
     ; on sauvegarde tout
     ;----------------------------------------------------------------------
               jsr  push
     ;----------------------------------------------------------------------
     ; chaine du msb de l'ecran
     ;----------------------------------------------------------------------
               lda  scrptr+1
               pha
               jsr  lsra4bits
               jsr  nibtohex
               sta  scraddr
               pla
               jsr  lsra4bits
               jsr  nibtohex
               sta  scraddr+1
     ;----------------------------------------------------------------------
     ; chaine du msb de la couleur
     ;----------------------------------------------------------------------
               lda  scrptr+1
               pha
               jsr  lsra4bits
               jsr  nibtohex
               sta  scraddr
               pla
               jsr  lsra4bits
               jsr  nibtohex
               sta  scraddr+1
     ;----------------------------------------------------------------------
     ; Chaine du lsb d'ecran et couleur
     ;----------------------------------------------------------------------
               lda  scrptr
               pha
               jsr  lsra4bits
               jsr  nibtohex
               sta  scraddr+2
               sta  coladdr+2
               pla
               jsr  lsra4bits
               jsr  nibtohex
               sta  scraddr+3
               sta  coladdr+3
     ;----------------------------------------------------------------------
     ; on recupere tout
     ;----------------------------------------------------------------------
               jsr  pop
               rts
               .bend
;---------------------------------------------------------------------------
; Copie scrptr dans zp1
;---------------------------------------------------------------------------
scrptr2zp1  .block
               php
               pha
               lda  scrptr
               sta  zpage1
               lda  scrptr+1
               sta  zpage1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Copie colptr dans zp1
;---------------------------------------------------------------------------
colptr2zp1   .block
               php
               pha
               lda  colptr
               sta  zpage1
               lda  colptr+1
               sta  zpage1+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Copie scrptr dans zp2
;---------------------------------------------------------------------------
scrptr2zp2   .block
               php
               pha
               lda  scrptr
               sta  zpage2
               lda  scrptr+1
               sta  zpage2+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Copie colptr dans zp2
;---------------------------------------------------------------------------
colptr2zp2   .block
               php
               pha
               lda  colptr
               sta  zpage2
               lda  colptr+1
               sta  zpage2+1
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Transforme le contenu du registre A en hexadecimal et retourne l'adresse
; de la chaine dans X-(lsb) et Y-(msb).
; Entree : A
; Sortie : Valeur hexadecimale à la 
;          position du curseur.
;---------------------------------------------------------------------------
putrahex    .block
               php
               pha
               jsr     atohex
               ldx     #<a2hexcol
               ldy     #>a2hexcol
               jsr     puts
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Transforme le contenu du registre A en hexadecimal et retourne l'adresse
; de la chaine dans X-(lsb) et Y-(msb).
; Entree : A
; Sortie : Valeur hexadecimale à la position (a2hexpx,a2hexpy).
; **Note : a2hexpx et a2hexpy doivent etre modifiees avant l'appel.
;---------------------------------------------------------------------------
putrahexxy  .block
               php
               pha
               jsr  atohex
               lda  #<a2hexpos
               ldy  #>a2hexpos
               jsr  putsxy
               pla
               plp
               rts
               .bend
;---------------------------------------------------------------------------
; Transforme le contenu du registre A en hexadecimal et retourne l'adresse
; de la chaine dans X-(lsb) et Y-(msb).
; Entree : A
; Sortie : Valeur hexadecimale à la position (a2hexpx,a2hexpy) et dans la 
;          couleur a2hexcol.
; **Note : a2hexcol, a2hexpx et a2hexpy doivent etre modifiees avant 
;          l'appel.
;---------------------------------------------------------------------------
putrahexcxy    .block
               php
               pla
               jsr  atohex
               lda  #<a2hexpos
               ldy  #>a2hexpos
               jsr  putscxy
               pla
               plp
               rts
               .bend

;---------------------------------------------------------------------------
;
;---------------------------------------------------------------------------
settxtcol      .block
               php
               sta  curcol 
               plp
               rts
               .bend

;---------------------------------------------------------------------------
; c64_lib_mc Fin
;---------------------------------------------------------------------------
;----------------------------------------
; Skipped include >>                 .include  "c64_map_kernal.asm"
;***************************************
; Affiche en hexadécimal le contenu des 
; registres A, X, Y, P, S et PC
; sur la ligne 25 de l'écran.
;***************************************
showregs        .block
line    =   23
coln    =   0
colr    =   vblanc
bkcol   =   bkcol3
                php
    ;----------------------------------- 
    ; stack-> p, pch, pcl
    ;----------------------------------- 
                sta  rega
                pla
    ;----------------------------------- 
    ; stack-> pch, pcl
    ;----------------------------------- 
                sta  regp
                stx  regx
                sty  regy
                tsx   
                stx  regs
                pla
    ;----------------------------------- 
    ; stack-> pcl     
    ;----------------------------------- 
                sta  regpcl         
                sta  regpcl2
                pla                       
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                sta  regpch         
    ;----------------------------------- 
    ; conversion de A en hexadecimal
    ;----------------------------------- 
                lda  rega
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  vala+1
                pla
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  vala
    ;----------------------------------- 
    ; conversion de Y en hexadecimal
    ;----------------------------------- 
                lda  regy
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  valy+1
                pla    
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  valy
    ;----------------------------------- 
    ; conversion de X en hexadecimal
    ;----------------------------------- 
                lda  regx
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  valx+1
                pla
    ;----------------------------------- 
    ; stack->
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  valx
    ;----------------------------------- 
    ; conversion de P en hexadecimal
    ;----------------------------------- 
                lda  regp
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  valp+1
                pla
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  valp
    ;----------------------------------- 
    ; conversion de S en hexadecimal
    ;----------------------------------- 
                lda  regs
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  vals+1
                pla
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  vals
    ;----------------------------------- 
    ; conversion de pch en hexadecimal
    ;----------------------------------- 
                lda  regpch
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  valpch+1
                pla
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  valpch
    ;----------------------------------- 
    ; conversion de pcl en hexadecimal
    ;----------------------------------- 
                lda  regpcl
                pha
    ;----------------------------------- 
    ; stack-> a
    ;----------------------------------- 
                jsr  nib2hex
                sta  valpcl+1
                pla
    ;----------------------------------- 
    ; stack-> 
    ;----------------------------------- 
                jsr  lsra4bits
                jsr  nib2hex
                sta  valpcl
    ;----------------------------------- 
    ; stack->   ZP1 et ZP2
    ;----------------------------------- 
                lda  zpage1
                pha
                jsr  nib2hex
                sta  valz1l 
                pla
                jsr  lsra4bits
                jsr  nib2hex
                sta  valz1l+1 

                lda  zpage1+1
                pha
                jsr  nib2hex
                sta  valz1h 
                pla
                jsr  lsra4bits
                jsr  nib2hex
                sta  valz1h+1

                lda  zpage2
                pha
                jsr  nib2hex
                sta  valz2l 
                pla
                jsr  lsra4bits
                jsr  nib2hex
                sta  valz2l+1 

                lda  zpage2+1
                pha
                jsr  nib2hex
                sta  valz2h 
                pla
                jsr  lsra4bits
                jsr  nib2hex
                sta  valz2h+1
                 
    ;----------------------------------- 
    ; On affiche les chaines
    ;----------------------------------- 
                jsr  setinverse
                sei
                ldx  #<srega
                ldy  #>srega+1
                jsr  putscxy
                ldx  #<sregx
                ldy  #>sregx+1
                jsr  putscxy
                ldx  #<sregy
                ldy  #>sregy+1
                jsr  putscxy
                ldx  #<sregp
                ldy  #>sregp+1
                jsr  putscxy
                ldx  #<sregs
                ldy  #>sregs+1
                jsr  putscxy
                ldx  #<sregpc
                ldy  #>sregpc+1
                jsr  putscxy

                ldx  #<sregz1
                ldy  #>sregz1+1
                jsr  putscxy
                ldx  #<sregz2
                ldy  #>sregz2+1
                jsr  putscxy
                cli
                jsr  clrinverse
                lda  regpch
                pha
    ;----------------------------------- 
    ; stack-> pcl
    ;----------------------------------- 
                lda  regpcl
                pha
    ;----------------------------------- 
    ; stack-> pch, pcl
    ;----------------------------------- 
                ;ldx  regs
                ;txs
                ldy  regy
                ldx  regx
                lda  regp
                pha
    ;----------------------------------- 
    ; stack-> p, pch, pcl
    ;----------------------------------- 
                lda  rega
                plp
    ;----------------------------------- 
    ; stack-> pch, pcl
    ;----------------------------------- 
                rts
srega   .byte   colr,bkcol,coln,line
        .text   ' a:$' ;4,24
vala    .byte   0,0,0
sregx   .byte   colr,bkcol,coln+6,line
        .text   ' x:$' ;4,24
valx    .byte   0,0,0
sregy   .byte   colr,bkcol,coln+12,line
        .text   ' y:$' ;4,24
valy    .byte   0,0,0
sregp   .byte   colr,bkcol,coln+18,line
        .text   ' p:$' ;4,24
valp    .byte   0,0,0
sregs   .byte   colr,bkcol,coln+24,line
        .text   ' s:$' ;4,24
vals    .byte   0,0,0
sregpc  .byte   colr,bkcol,coln+30,line
        .text   ' pc:$' ;4,24
valpch  .byte   0,0
valpcl  .byte   0,0,32,0

sregz1  .byte   colr,bkcol,coln+3,line+1
        .text   ' zp1:$' ;4,24
valz1h  .byte   0,0
valz1l  .byte   0,0,32,0

sregz2  .byte   colr,bkcol,coln+15,line+1
        .text   ' zp2:$' ;4,24
valz2h  .byte   0,0
valz2l  .byte   0,0,32,0

rega    .byte   0
regx    .byte   0
regy    .byte   0
regp    .byte   0
regs    .byte   0
regpch  .byte   0
regpcl  .byte   0
regpcl2 .byte   0
vzp1h   .byte   0
vzp1l   .byte   0
vzp2h   .byte   0
vzp2l   .byte   0
                .bend
; Skipped include >>                 .include  "c64_lib_pushpop.asm"
; Skipped include >>                 .include  "c64_lib_basic2.asm"
; Skipped include >>                 .include  "c64_lib_hex.asm"

;***************************************
; lecture de la des manettes de commande
; numériques.
;***************************************
js_2port       =    $dc00
js_1port       =    $dc01
js_2dir        =    $dc02
js_1dir        =    $dc03
js_xoffset     =    2
js_yoffset     =    2
js_location    =    0
js_init        .block
               jsr  push
               lda  js_1dir
               and  #$e0
               sta  js_1dir
               lda  js_2dir
               and  #$e0
               sta  js_2dir
               jsr  pop
               rts
               .bend
                
js_scan        .block
               jsr  js_1scan
               jsr  js_2scan
               rts
               .bend
;***************************************
; Port 1 js_1= %000FRLDU
;***************************************
js_1scan       .block
               jsr  push
               lda  js_1port 
               and  #$1f
               cmp  #$00
               bne  p1scan
               jmp  port1_out
p1scan         eor  #$1f
               ;ldx     #$01
               ;jsr     showregs
               clc
     ;------------------------
     ; BOUTON EN-HAUT
     ;------------------------
     ;On decale js_2 bit 0 dans C
js_1b0         lsr                     
     ;Est-ce vers le haut (U)
               bcc  js_1b1          
     ;On stack la valeur
               pha
               inc  js_1flag
     ;Oui!
               lda  js_1pixy
     ;On place la carry a 1
               sec
     ;On reduit
               sbc  #js_yoffset
               cmp  #$f0
               bcc  sto1ym
               lda  #$00
     ; le y 
sto1ym         sta  js_1pixy
     ;On recupere la valeur
               pla                     
     ;------------------------
     ; BOUTON EN-BAS
     ;------------------------
     ;On decale js_2 bit 0 dans C
js_1b1         lsr
     ;Est-ce vers le bas (D)
               bcc  js_1b2
     ;On stack la valeur
               pha
               inc  js_1flag
     ;Oui!
               lda  js_1pixy
     ;On place la carry a 0
               clc
     ;On augmente
               adc  #js_yoffset
               cmp  #199
               bcc  sto1yp
               lda  #199
     ; le y 
sto1yp         sta  js_1pixy
     ;On recupere la valeur
               pla
     ;------------------------
     ; BOUTON A-GAUCHE
     ;------------------------
     ;On decale js_1 bit 0 dans C
js_1b2         lsr
     ;Est-ce vers la gauche (L)
               bcc  js_1b3
     ;On stack la valeur
               pha
               inc  js_1flag
     ;Oui!
               lda  js_1pixx
               ora  js_1pixx+1
               beq  js_1b2out
     ;On place la carry a 1
               sec
     ;Oui!
               lda  js_1pixx
     ;On diminue
               sbc  #js_xoffset
     ; le X 
               sta  js_1pixx
     ; de offset
               bcs  js_1b2out
               lda  js_1pixx+1
               beq  js_1b2out
     ; sur 16 bits
               dec  js_1pixx+1
     ;On recupere la valeur
js_1b2out      pla
;------------------------
; BOUTON A-BROITE
;------------------------
     ;On decale js_1 bit 0 dans C
js_1b3         lsr
     ;Est-ce vers la droite (R)
               bcc  js_1b4
     ;On stack la valeur
               pha
               inc  js_1flag
               lda  js_1pixx+1
               beq  incj1x
               lda  js_1pixx
               cmp  #$40-4
               bmi  incj1x
               jmp  js_1b3out
     ;On place la carry a 0
incj1x         clc
               lda  js_1pixx       
     ;On augmente
               adc  #js_xoffset
     ; le X 
               sta  js_1pixx
     ; de offset
               bcc  js_1b3out
     ; sur 16 bits
               inc  js_1pixx+1
     ;On recupere la valeur
js_1b3out      pla
;------------------------
; BOUTON FIRE
;------------------------
js_1b4          lsr                     ;Estce le bbouton fire (F)
                bcc     port1_out       ;Oui!
                inc     js_1flag
                inc     js_1fire        ; on augmente le nombre de tir
js_1wait        ldx     #$01
                ldy     #$ff
js_1rel         iny
                ;jsr     showregs
                lda     js_1port 
                eor     #$ff
                and     #$10
                ;cmp     #$1f            ;On attend le telachement 
                bne     js_1rel         ; des boutons
port1_out       lda     js_1flag
                beq     out
                jsr     js_1correct
                lda     #0
                sta     js_1flag
out             jsr     pop
                .bend
;-------------------------------------------------------------------------------
; Port 2 js_2= %100FRLDU
;-------------------------------------------------------------------------------
js_2scan         .block
                jsr     push
port2           lda     js_2port 
                and     #$1f 
                cmp	#$1f
                bne     p2scan
                ;jsr     showregs
                jmp     port2_out
p2scan          eor     #$1f
                ldx     #$02
                ;jsr     showregs          
                clc
;------------------------
; BOUTON EN-HAUT
;------------------------
js_2b0          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b1          ;Est-ce vers le haut (U)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixy        ;Oui!
                sec                     ;On place la carry a 1
                sbc     #js_yoffset     ;On reduit
                cmp     #$f0
                bcc     sto2ym
                lda     #$00
sto2ym          sta     js_2pixy        ; le y 
                pla                     ;On recupere la valeur
;------------------------
; BOUTON EN-BAS
;------------------------
js_2b1          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b2          ;Est-ce vers le bas (D)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixy        ;Oui!
                clc                     ;On place la carry a 0
                adc     #js_yoffset     ;On augmente
                cmp     #199
                bcc     sto2yp
                lda     #199
sto2yp          sta     js_2pixy        ; le y 
                pla                     ;On recupere la valeur
;------------------------
; BOUTON A-GAUCHE
;------------------------
js_2b2          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b3          ;Est-ce vers la gauche (L)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixx        ;Oui!
                ora     js_2pixx+1
                beq     js_2b2out
                sec                     ;On place la carry a 1
                lda     js_2pixx        ;Oui!
                sbc     #js_xoffset     ;On diminue
                sta     js_2pixx        ; le X 
                bcs     js_2b2out       ; de offset
                lda     js_2pixx+1
                beq     js_2b2out
                dec     js_2pixx+1      ; sur 16 bits
js_2b2out       pla                     ;On recupere la valeur
;------------------------
; BOUTON A-DROITE
;------------------------
js_2b3          lsr                     ;On decale js_2 bit 0 dans C
                bcc     js_2b4          ;Est-ce vers la droite (R)
                pha                     ;On stack la valeur
                inc     js_2flag
                lda     js_2pixx+1
                beq     incj2x
                lda     js_2pixx
                cmp     #$40-js_xoffset
                bmi     incj2x
                jmp     js_2b3out
incj2x          clc                     ;On place la carry a 0
                lda     js_2pixx        ;Oui!
                adc     #js_xoffset     ;On augmente
                sta     js_2pixx        ; le X 
                bcc     js_2b3out       ; de offset
                inc     js_2pixx+1      ; sur 16 bits
js_2b3out       pla                     ;On recupere la valeur
;------------------------
; BOUTON FIRE
;------------------------
js_2b4          lsr                     ;Estce le bbouton fire (F)
                bcc     port2_out       ;Oui!
                inc     js_2flag
                inc     js_2fire        ; on augmente le nombre de tir
                lda     #%00000001
                sta     js_2events
                lda     js_2pixx
                sta     js_2clickx
                lda     js_2pixx+1
                sta     js_2clickx+1
                lda     js_2pixy
                sta     js_2clicky
                lda     js_2val16a+1
                eor     #%01000000
                sta     js_2val16a+1
js_2wait        ldx     #$00
                ldy     #$ff
js_2rel         iny
                bne     sr1
                inx
sr1             ;jsr     showregs
                lda     js_2port 
                eor     #$ff
                and     #$10
                ;cmp     #$1f           ;On attend le telachement 
                bne     js_2rel         ; des boutons
port2_out       lda     js_2flag
                beq     out
                jsr     js_2correct
                lda     #0
                sta     js_2flag
out             jsr     pop
                .bend
;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_corrector    .block          
                php          
                pha
                lda     js_1flag
                beq     check2
                jsr     js_1correct          
                lda     #0
                sta     js_1flag
check2          lda     js_2flag  
                beq     no_update
                jsr     js_2correct  
                lda     #0
                sta     js_2flag
no_update       pla
                plp
                rts
                .bend          
;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_1correct     .block
                php
                pha 
                ; Port 1 X
                lda     js_1pixx
                sta     vallsb  
                lda     js_1pixx+1
                ror                     ; ex = %0000000100000001 = 257 pixel
                ror     vallsb          ; Cnnnnnnn      On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn      caracteres de 8 pixels     
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_1x
                ; Port 1 Y
                lda     js_1pixy
                sta     vallsb  
                lsr     vallsb          ; Cnnnnnnn     On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn     caracteres de 8 pixels     
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_1y
                pla
                plp
                rts
vallsb          .byte     0
regx            .byte     0
                .bend
;-------------------------------------------------------------------------------          
;          
;-------------------------------------------------------------------------------          
js_2correct     .block
                php
                pha 
                ; Port 2 X
                lda     js_2pixx
                sta     vallsb  
                lda     js_2pixx+1
                ror                     ; ex = %0000000100000001 = 257 pixel
                ror     vallsb          ; Cnnnnnnn     On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn     caracteres de 8 pixels    
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_2x
                ; Port 2 Y
                lda     js_2pixy
                sta     vallsb
                lsr     vallsb          ; Cnnnnnnn     On divise par 8 pc les 
                lsr     vallsb          ; 0Cnnnnnn     caracteres de 8 pixels     
                lsr     vallsb          ; 00Cnnnnn
                lda     vallsb          ; devient = %00100000 = 32           
                sta     js_2y
                pla
                plp
                rts
vallsb          .byte     0
regx            .byte     0
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_showvals      .block
                ;jsr     js_1showvals
                jsr     js_2showvals
                rts
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_1showvals    .block
                jsr     push
                ; la valeur 8 bits de js_1 X
                lda     js_1x          
                jsr  atohex
                lda     a2hexstr+1 
                sta     js_1val8+19
                lda     a2hexstr+2 
                sta     js_1val8+20
                ; la valeur 16 bits de js_1 X
                lda     js_1pixx
                jsr  atohex
                lda     a2hexstr+1 
                sta     js_1val16+14
                lda     a2hexstr+2 
                sta     js_1val16+15
                lda     js_1pixx+1
                jsr  atohex
                lda     a2hexstr+1 
                sta     js_1val16+12
                lda     a2hexstr+2 
                sta     js_1val16+13
                ; la valeyr 8 bits de js_1 Y
                lda     js_1y          
                jsr  atohex
                ;lda  a2hexstr 
                ;sta  js_1val+21
                lda     a2hexstr+1 
                sta     js_1val8+23
                lda     a2hexstr+2 
                sta     js_1val8+24
                ; la valeur 16 bits de js_1 Y
                lda     js_1pixy
                jsr  atohex
                lda     a2hexstr+1 
                sta     js_1val16+20
                lda     a2hexstr+2 
                sta     js_1val16+21
                lda     #0
                jsr  atohex
                lda     a2hexstr+1 
                sta     js_1val16+18
                lda     a2hexstr+2 
                sta     js_1val16+19
                ; le bouton fire de js_1          
                lda     js_1fire          
                jsr  atohex
                lda     a2hexstr+2 
                sta     js_1val8+33
                ldx     #<js_1val8 
                ldy     #>js_1val8
                jsr     putscxy
                ldx     #<js_1val16 
                ldy     #>js_1val16
                jsr     putscxy
                jsr     pop                
                rts
                .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
js_2showvals    .block
                jsr     push                    ; stack : y, x, a, flg
                ; la valeur 8 bits de js_2 X
                lda     js_2x          
                jsr  atohex
                lda     a2hexstr 
                sta     js_2val8+19
                lda     a2hexstr+1 
                sta     js_2val8+20
                ; la valeur 16 bits de js_2 X
                ;lda     js_2pixx
                lda     js_2clickx
                jsr  atohex
                lda     a2hexstr 
                sta     js_2val16+14
                lda     a2hexstr+1 
                sta     js_2val16+15
                ;lda     js_2pixx+1
                lda     js_2clickx+1
                jsr  atohex
                lda     a2hexstr 
                sta     js_2val16+12
                lda     a2hexstr+1 
                sta     js_2val16+13
                ; la valeur 8 bits de js_2 Y
                lda     js_2y          
                jsr  atohex
                lda     a2hexstr 
                sta     js_2val8+23
                lda     a2hexstr+1 
                sta     js_2val8+24
                ; la valeur 16 bits de js_2 Y
                ;lda     js_2pixy
                lda     js_2clicky
                jsr  atohex
                lda     a2hexstr 
                sta     js_2val16+20
                lda     a2hexstr+1 
                sta     js_2val16+21
                lda     #0
                jsr  atohex
                lda     a2hexstr 
                sta     js_2val16+18
                lda     a2hexstr+1 
                sta     js_2val16+19
                ; le bouton fire de js_2          
                lda     js_2fire          
                jsr  atohex
                lda     a2hexstr+1 
                sta     js_2val8+33
; on affiche les données
                ldx     #<js_2val8
                ldy     #>js_2val8
                jsr     putscxy
                ldx     #<js_2val16a
                ldy     #>js_2val16a
                jsr     putscxy
                ldx     #<js_2val16
                ldy     #>js_2val16
                jsr     putscxy
                jsr     pop
                rts
                .bend
                
js_updatecurs   .block
                jsr     push                
                ;lda     js_oldx
                ;cmp     #$ff
                ;beq     running             
                ;ldx     js_2x
                ;ldy     js_2y
                ;stx     js_oldx
                ;sty     js_oldy
                ;jsr     js_eoraddrxy
                ;       on réécrit l'ancien caractèere àa sa place
running         lda     js_2x
                cmp     js_x
                beq     chky
                sta     js_x
                inc     flag
chky            lda     js_2y                
                cmp     js_y
                beq     chkflag
                sta     js_y
                inc     flag
chkflag         lda     flag
                beq     showit
                ldx     js_oldx
                ldy     js_oldy
                jsr     js_eoraddrxy
                ldx     js_x
                ldy     js_y
                jsr     js_eoraddrxy
                lda     js_x
                sta     js_oldx
                lda     js_y
                sta     js_oldy
showit          lda     #0
                sta     flag
                sta     addr1
                lda     #$04
                sta     addr1+1
                ldx     js_x
                ldy     js_y
                jsr     xy2addr
                ldy     addr2
                ldx     addr2+1
                ;jsr     showregs
                jsr pop
                rts
flag            .byte   0
                .bend

js_eoraddrxy    .block
                jsr     push
                ;jsr     showregs
                jsr     savezp2
                lda     #$04
                sta     addr1+1
                lda     #0
                sta     addr1
                jsr     xy2addr
                ldy     addr2
                sty     zpage2
                ldx     addr2+1
                stx     zpage2+1
                ldy     #0
                lda     (zpage2),y
                eor     #%01000000
                sta     (zpage2),y
                jsr     restzp2
                jsr     pop
                rts
                .bend
                
js_x            .byte   0
js_y            .byte   0
js_oldx         .byte   $ff   
js_oldy         .byte   $ff
js_oldcar       .byte   0
js_oldcol       .byte   0


js_1pixx        .word   0
js_1pixy        .byte   0
js_1x           .byte   0
js_1y           .byte   0
js_1fire        .byte   0
js_1flag        .byte   0
js_1clickx      .word   0        
js_1clicky      .byte   0
js_1events      .byte   0

js_2pixx        .word   0
js_2pixy        .byte   0     
js_2x           .byte   0
js_2y           .byte   0
js_2fire        .byte   0
js_2flag        .byte   0
js_2clickx      .word   0        
js_2clicky      .byte   0
js_2events      .byte   0

js_txtcol       =       vcyan         
js_txtbak       =       bkcol0        
js_1val8        .byte     js_txtcol,js_txtbak,4,5
                        ;      111111111122222222223333
                        ;456789012345678901234567890123
                .text   "Port 1 (x,y):($00,$00) Fire:(0)"
                .byte   0
                        ;      111111111122
                        ;456789012345678901
js_1val16       .byte   js_txtcol,js_txtbak,11,7
                .text   "(x,y):($0000,$0000)"
                .byte   0
                        ;      111111111122222222223333
                        ;456789012345678901234567890123
js_2val8        .byte   js_txtcol,js_txtbak,4,10
                .text   "CarPos (x,y):($00,$00) Fire:(0)"
                .byte   0
js_2val16a      .byte   vblanc,js_txtbak,4,12
                .text   "Click pos."
                .byte   0
js_2val16       .byte   js_txtcol,js_txtbak,16,12
                .text   "(x,y):($0000,$0000)"
                .byte   0


                ;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_init       .block
                jsr     push
;               ldy     sprt_ptr6+1
;               ldx     sprt_ptr6
;               jsr     sprt_setimage
                lda     sprt_ptr
                jsr     sprt_loadptr
                jsr     savezp1
                jsr     savezp2
;---------------POKE VIC+$15,4  53269 Sprite enable 76543210
                lda     vic+$15 ; enable sprite 2
                ora     #%00000100
                sta     vic+$15
;---------------POKE 2042,13
                lda     #$0d
                sta     $7fa
;---------------Source ZP2 
                lda     sprt_ptr0
                sta     zpage1
                lda     sprt_ptr0+1
                sta     zpage1+1
;---------------Destination ZP2 832 ou $340
                lda     #$40
                sta     zpage2
                lda     #$03
                sta     zpage2+1
                ldy     #65
                lda     (zpage1),y      ; sprite y offset
                sta     sprt_yoffset
                dey
                lda     (zpage1),y      ; sprite x offset
                sta     sprt_xoffset
                dey
                lda     (zpage1),y      ; sprite color
                sta     $d029
                dey
                ldy     #62     
nextbyte        lda     (zpage1),y
                sta     (zpage2),y
                dey
                bne     nextbyte
;                ldy     #$07
;nexty           tya
;                sta     $d026,y   ; 53287 Sprite 0 color
;                dey
;                bne     nexty
;                sta     $d028   ; 53288 Sprite 1 color
;                lda     #sprt_color
;                sta     $d029   ; 53289 Sprite 2 color
;                sta     $d02a   ; 53290 Sprite 3 color
;                sta     $d02b   ; 53291 Sprite 4 color
;                sta     $d02c   ; 53292 Sprite 5 color
;                sta     $d02d   ; 53293 Sprite 6 color
;                sta     $d02e   ; 53294 Sprite 7 color
                jsr     restzp1
                jsr     restzp2
                jsr     pop
                rts
                .bend
sprt_ptr        .byte   $01 
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_calcpos    .block
                jsr     push
                lda     #0
                sta     sprt_x+1
                sta     sprt_y+1
                lda     js_2pixx+1
                clc
                rol
                rol
                sta     sprt_x+1
                lda     js_2pixx
                clc
                adc     sprt_xoffset
                sta     sprt_x
                bcc     norepx
                lda     sprt_x+1
                ora     #$04
                sta     sprt_x+1
norepx          lda     js_2pixy
                clc
                adc     sprt_yoffset
                sta     sprt_y
                jsr     pop
                rts
                .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_move       .block
                jsr     push
                jsr     sprt_calcpos
                lda     sprt_x
                sta     vic+$04
                lda     sprt_x+1
                sta     vic+$10
                lda     sprt_y
                sta     vic+$05
                jsr     sprt_showpos
                jsr     pop
                rts
                .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_showpos    .block
                jsr     push
;---------------la valeur 16 bits de js_sprite
                lda     sprt_x
                jsr     a2hex
                lda     a2hexstr 
                sta     sprite_pos+26
                lda     a2hexstr+1 
                sta     sprite_pos+27

                lda     sprt_x+1
                jsr     a2hex
                lda     a2hexstr 
                sta     sprite_pos+24
                lda     a2hexstr+1 
                sta     sprite_pos+25
                
                lda     sprt_y
                jsr     a2hex
                lda     a2hexstr 
                sta     sprite_pos+32
                lda     a2hexstr+1 
                sta     sprite_pos+33
                
                lda     #0
                jsr     a2hex
                lda     a2hexstr 
                sta     sprite_pos+30
                lda     a2hexstr+1 
                sta     sprite_pos+31
                
                ldx     #<sprite_pos
                ldy     #>sprite_pos
                jsr     putscxy
                jsr     pop
                rts
                .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_loadptr2   .block                
                jsr     push                
                tax
                stx     sprt_ptr
                lda     sprt_ptr0+1
                sta     calcbuff+1
                lda     sprt_ptr0
                sta     calcbuff
                cpx     #0
                beq     addrok
                lda     calcbuff
nextx           clc
                adc     #66
                bcc     nocarry
                inc     calcbuff+1
nocarry         sta     calcbuff
                dex
                bne     nextx
addrok          ldy     calcbuff+1            
                ldx     calcbuff          
;                jsr     showregs
                jsr     sprt_setimage
                jsr     pop
                rts
calcbuff        .word   $0
                .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_loadptr    .block                
                jsr     push                
                lda     sprt_ptr
                clc
                rol
                tay
                lda     sprt_ptr0,y
                tax
                lda     sprt_ptr0+1,y
                tay
;                jsr     showregs
                jsr     sprt_setimage
                jsr     pop
                rts
calcbuff        .word   $0
                .bend
;-------------------------------------------------------------------------------               
;
;-------------------------------------------------------------------------------               
sprt_setimage   .block
                jsr     push
                jsr     savezp1
                jsr     savezp2
                sty     zpage1+1
                stx     zpage1
                ldy     #>sprt_image
                sty     zpage2+1
                ldy     #<sprt_image
                sty     zpage2
                ldy     #66
nextbyte        lda     (zpage1),y
                sta     (zpage2),y
                dey
                bne     nextbyte
                jsr     restzp2
                jsr     restzp1
                jsr     pop
                rts
                .bend
sprt_xoffset    .byte   $00               
sprt_yoffset    .byte   $00                
sprt_x          .word   $0000
sprt_y          .word   $0000     
;0     
sprt_image      .fill 66
;1
sprt_crxair     .byte $00, $00, $00, $00, $00, $00 ; 6
                .byte $00, $66, $00, $00, $3c, $00 ; 12
                .byte $00, $18, $00, $00, $00, $00 ; 18
                .byte $00, $00, $00, $00, $18, $00 ; 24
                .byte $80, $00, $01, $c0, $18, $03 ; 30
                .byte $66, $66, $66, $c0, $18, $03 ; 36
                .byte $80, $00, $01, $00, $18, $00 ; 42
                .byte $00, $00, $00, $00, $00, $00 ; 48
                .byte $00, $18, $00, $00, $3c, $00 ; 54
                .byte $00, $66, $00, $00, $00, $00 ; 60
                .byte $00, $00, $00, $01, $0c, $28 ; 66, X,X,X color, xoffset, yoffset
;2                
sprt_mouse      .byte $80, $00, $00, $e0, $00, $00 ; 6
                .byte $b8, $00, $00, $ce, $00, $00 ; 12
                .byte $83, $80, $00, $c0, $e0, $00 ; 18
                .byte $80, $18, $00, $c0, $3c, $00 ; 24
                .byte $80, $e0, $00, $c0, $60, $00 ; 30
                .byte $98, $30, $00, $fc, $18, $00 ; 36
                .byte $c6, $0c, $00, $03, $06, $00 ; 42
                .byte $01, $9c, $00, $00, $f0, $00 ; 48
                .byte $00, $40, $00, $00, $00, $00 ; 54
                .byte $00, $00, $00, $00, $00, $00 ; 60
                .byte $00, $00, $00, $01, $18, $31 ; 66, X,X,X color, xoffset, yoffset
;3                
sprt_pointer    .byte $00, $7c, $00, $01, $83, $00 ; 6
                .byte $06, $10, $c0, $08, $00, $30 ; 12
                .byte $12, $10, $88, $20, $00, $08 ; 18
                .byte $40, $ba, $04, $40, $6c, $04 ; 24
                .byte $80, $c6, $02, $aa, $82, $aa ; 30
                .byte $80, $c6, $02, $40, $6c, $04 ; 36
                .byte $40, $ba, $04, $20, $00, $08 ; 42
                .byte $12, $10, $90, $08, $00, $20 ; 48
                .byte $06, $10, $c0, $01, $83, $00 ; 54
                .byte $00, $7c, $00, $00, $00, $00 ; 60
                .byte $00, $00, $00, $01, $0c, $28 ; 66, X,X,X color, xoffset, yoffset
;4                
sprt_pointer2   .byte $55, $55, $55, $aa, $aa, $aa ; 6
                .byte $55, $55, $55, $aa, $aa, $aa ; 12
                .byte $55, $55, $55, $aa, $aa, $aa ; 18
                .byte $54, $00, $55, $aa, $00, $2a ; 24
                .byte $54, $00, $55, $aa, $00, $2a ; 30
                .byte $54, $00, $55, $aa, $00, $2a ; 36
                .byte $54, $00, $55, $aa, $00, $2a ; 42
                .byte $54, $00, $55, $aa, $aa, $aa ; 48
                .byte $55, $55, $55, $aa, $aa, $aa ; 54
                .byte $55, $55, $55, $aa, $aa, $aa ; 60
                .byte $55, $55, $55, $01, $0c, $28 ; 66, X,X,X color, xoffset, yoffset
;5                
sprt_hand       .byte $06, $00, $00, $0f, $00, $00 ; 6
                .byte $19, $80, $00, $10, $80, $00 ; 12
                .byte $19, $80, $00, $16, $b1, $8c ; 18
                .byte $10, $ca, $52, $10, $84, $21 ; 24
                .byte $10, $84, $21, $30, $84, $21 ; 30
                .byte $50, $84, $21, $90, $84, $21 ; 36
                .byte $90, $00, $01, $90, $00, $01 ; 42
                .byte $90, $7f, $c1, $90, $00, $01 ; 48
                .byte $40, $ff, $e2, $40, $00, $02 ; 54
                .byte $3c, $00, $04, $02, $00, $08 ; 60
                .byte $03, $ff, $f8, $01, $12, $31 ; 66, X,X,X color, xoffset, yoffset
;6                
sprt_ultraman   .byte $00, $3e, $00, $01, $c1, $c0 ; 6
                .byte $0e, $3e, $30, $08, $41, $08 ; 12
                .byte $10, $1c, $04, $10, $22, $04 ; 18
                .byte $24, $1c, $12, $23, $00, $62 ; 24
                .byte $20, $08, $02, $47, $c1, $f1 ; 30
                .byte $6a, $aa, $ab, $47, $c9, $f1 ; 36
                .byte $20, $08, $02, $20, $14, $02 ; 42
                .byte $20, $00, $02, $10, $00, $04 ; 48
                .byte $10, $7f, $04, $08, $00, $08 ; 54
                .byte $06, $3e, $30, $01, $c1, $c0 ; 60
                .byte $00, $3e, $00, $01, $0c, $28 ; 66, X,X,X color, xoffset, yoffset
;7                
sprt_male       .byte $00, $1c, $00, $00, $3e, $00 ; 6
                .byte $00, $3e, $00, $00, $3e, $00 ; 12
                .byte $00, $1c, $00, $00, $08, $00 ; 18
                .byte $00, $ff, $80, $00, $ff, $80 ; 24
                .byte $00, $be, $80, $00, $9c, $80 ; 30
                .byte $00, $88, $80, $00, $be, $80 ; 36
                .byte $00, $be, $80, $01, $9c, $c0 ; 42
                .byte $01, $94, $c0, $00, $14, $00 ; 48
                .byte $00, $14, $00, $00, $14, $00 ; 54
                .byte $00, $36, $00, $00, $77, $00 ; 60
                .byte $00, $77 ,$00, $01, $0c, $2f ; 66, X,X,X color, xoffset, yoffset                
;8                
sprt_robot      .byte $00, $3c, $00, $00, $24, $00 ; 6
                .byte $00, $66, $18, $00, $66, $38 ; 12
                .byte $00, $24, $38, $00, $3c, $10 ; 18
                .byte $00, $18, $10, $00, $18, $10 ; 24
                .byte $0f, $ff, $f0, $08, $7e, $00 ; 30
                .byte $08, $7e, $00, $08, $18, $00 ; 36
                .byte $1c, $18, $00, $1c, $18, $00 ; 42
                .byte $18, $3c, $00, $00, $3c, $00 ; 48
                .byte $00, $24, $00, $00, $24, $00 ; 54
                .byte $00, $24, $00, $03, $e7, $c0 ; 60
                .byte $03, $e7, $c0, $01, $0c, $28 ; 66, X,X,X color, xoffset, yoffset                
;9                
sprt_femme      .byte $00, $1c, $00, $00, $3e, $00 ; 6
                .byte $00, $3e, $00, $00, $3e, $00 ; 12
                .byte $00, $1c, $00, $00, $08, $00 ; 18
                .byte $00, $7f, $00, $00, $ff, $80 ; 24
                .byte $00, $be, $80, $00, $9c, $80 ; 30
                .byte $00, $88, $80, $00, $9c, $80 ; 36
                .byte $00, $be, $80, $01, $be, $c0 ; 42
                .byte $01, $be, $c0, $00, $7f, $00 ; 48
                .byte $00, $7f, $00, $00, $ff, $80 ; 54
                .byte $00, $36, $00, $00, $77, $00 ; 60
                .byte $00, $55 ,$00, $01, $0c, $2f ; 66, X,X,X color, xoffset, yoffset
                
sprt_ptr0       .word  sprt_image + (0*66)                    
sprt_ptr1       .word  sprt_image + (1*66)                    
sprt_ptr2       .word  sprt_image + (2*66)                    
sprt_ptr3       .word  sprt_image + (3*66)                    
sprt_ptr4       .word  sprt_image + (4*66)                    
sprt_ptr5       .word  sprt_image + (5*66)                    
sprt_ptr6       .word  sprt_image + (6*66)                       
sprt_ptr7       .word  sprt_image + (7*66)                       
sprt_ptr8       .word  sprt_image + (8*66)                       
sprt_ptr9       .word  sprt_image + (9*66)                       
testbyte        .byte 255                       
sprt_txtcol     =       vjaune         
sprt_txtbak     =       bkcol0        
sprt_color      =       vwhite                
sprite_pos      .byte   sprt_txtcol,sprt_txtbak,4,14
;                        0000000000111111111122222222223333333333                        
;                        0123456789012345678901234567890123456789                                
                .text       "Sprite pos. (x,y):($0000,$0000)"
                .byte   0
;---------------------------------------------------------------------
; On change le vecteur d'interruption pour y placer le retour a 
; l'editeur TMPREU par la touche [restore].
;---------------------------------------------------------------------
; Le vecteur nmi du C64 est à l'adresse $0318
; Pour TMPstd le retour à l'application se fait à 32768 ($8000).
; Pour TMPreu le retour à l'application se fait à 00320 ($0140).
;---------------------------------------------------------------------
initnmi                  ; On assume TMPreu par défaut
initjbnmireu
         .block
jumpback = $0140
nmivect  = $0318
         php
         pha
         sei
         lda #<jumpback
         sta nmivect
         lda #>jumpback
         sta nmivect+1
         pla
         plp
         rts
         .bend
initjbnmistd
         .block
jumpback = $8000
nmivect  = $0318
         php
         pha
         sei
         lda #<jumpback
         sta nmivect
         lda #>jumpback
         sta nmivect+1
         pla
         plp
         rts
         .bend
initjbbrkreu
         .block
jumpback = $0140
nmivect  = $0316
         php
         pha
         sei
         lda #<jumpback
         sta nmivect
         lda #>jumpback
         sta nmivect+1
         pla
         plp
         rts
         .bend
initjbbrkstd
         .block
jumpback = $8000
nmivect  = $0316
         php
         pha
         sei
         lda #<jumpback
         sta nmivect
         lda #>jumpback
         sta nmivect+1
         pla
         plp
         rts
         .bend
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
 ;               jsr    initnmi        ; À utiliser avec TMPreu
 ;               jsr    setmyint
 ;               rts
                ;jsr     initjbbrkreu
                ;jsr     initjbnmireu
                jsr     scrmaninit
                jsr     js_init
                lda     #$80
                sta     curcol
                lda     #0
                sta     vicbackcol
                lda     #vbleu
                sta     vicbordcol
                jsr     cls
                lda     #$20
                ora     #%00000000
                ldy     #$04
                ldx     #$04
                jsr     memfill
                lda     #$00
                ldy     #$d8
                jsr     memfill
                jsr     sprt_init
goagain         jsr     setinverse
                ldx     #<bstring1 
                ldy     #>bstring1
                jsr     putscxy
                
                ldx     #<bstring2 
                ldy     #>bstring2
                jsr     putscxy
                ldx     #<bstring3 
                ldy     #>bstring3
                jsr     putscxy
                ldx     #<bstring4 
                ldy     #>bstring4
                jsr     putscxy
                jsr     clrinverse
                ldx     #<js_status1 
                ldy     #>js_status1
                jsr     putscxy
                ldx     #<js_status2 
                ldy     #>js_status2
                jsr     putscxy
                ldx     #<js_status3 
                ldy     #>js_status3
                jsr     putscxy
                ldx     #<js_status4 
                ldy     #>js_status4
                jsr     putscxy
                ldx     #<js_status5 
                ldy     #>js_status5
                jsr     putscxy
                ldx     #<js_status6 
                ldy     #>js_status6
                jsr     putscxy
 ;               rts
                ldx     #$00
                ldy     #$0f
                jsr     gotoxy
                lda     #vjaune
                jsr     setcurcol
                ldx     #$00
                jsr     setbkcol
;                lda     #$00
;nextcar         jsr     putch
;                clc
;                adc     #$01
;                cmp     #64
;                bne     nextcar
                
looper         brk
               ;jsr  showregs
               jsr  js_scan
               jsr     js_showvals
;               jsr     js_updatecurs
               jsr     sprt_move
loopit         
;               jsr     showregs
               ldx     #$16
               ldy     #$11
               jsr     gotoxy
               lda     #3
               jsr     setcurcol
               inc     onebyte
               lda     onebyte
               lda     js_2fire
               jsr     putabinfmt
;               jsr     showregs
;               jsr     putabin
;               jmp     loopit
;               rts
;               lda     #$0
;               sta     c64u_addr1+1
;               lda     #$00
;               sta     c64u_addr1
;               ldy     #10
;               ldx     #05
;               jsr     c64u_xy2addr
;               ldy     c64u_addr2
;               ldx     c64u_addr2+1
;               ldx     js_2pixx+1
;               ldy     js_2pixx
;               lda     js_2fire
;               jsr     showregs
               pha
               lda     js_2fire
               beq     nochange     
               lda     vicbordcol
               clc
               adc     #$0
               and     #$0f
               sta     vicbordcol
               lda     js_2y
               cmp     #$04
               bne     toborder
               lda  js_2x
               cmp  #$0b
               bmi  toborder
               cmp  #$1d
               bpl  toborder
               inc  sprt_ptr
               lda  sprt_ptr
               jsr  showregs
               cmp  #9         
               bcc  drawsptr
               lda  #$00
drawsptr       sta  sprt_ptr
               jsr     sprt_init
;               jsr  showregs    
toborder       lda     vicbordcol
               sec
               adc     #0
               and     #$0f
               sta     $d029
               lda     #$00
               sta     js_2fire    
nochange       ;jsr  showregs
               inx 
               pla
               jsr     kstop
               bne     looper
               jsr     k_warmboot
out            rts
onebyte        .byte   0    
               .enc    "screen"
bstring1       .byte   vjaune,bkcol0,0,0        
;                                 111111111122222222223333333333
;                       0123456789012345678901234567890123456789    
               .text   "      Visualisation du port jeu #2      "
               .byte   0
bstring2       .byte   vjaune,bkcol1,0,1
               .text   " Programme assembleur pour 6502 sur C64 "
               .byte   0
bstring3       .byte   vbleu1,bkcol2,0,2
               .text   "      par Daniel Lafrance (2021) C      "
               .byte   0
bstring4       .byte   vjaune,bkcol3,11,4
               .text   " Changer pointeur "
               .byte   0
js_status1     .byte   vvert1,bkcol0,19,22
               .text   "   up <----1> haut "
               .byte   0
js_status2     .byte   vbleu1,bkcol0,19,21
               .text   " down <---2-> bas "
               .byte   0
js_status3     .byte   vrose,bkcol0,19,20
               .text   " left <--4--> gauche"
               .byte   0
js_status4     .byte   vjaune,bkcol0,19,19
               .text   "right <-8---> droite"
               .byte   0
js_status5     .byte   vblanc,bkcol0,19,18
               .text   " Fire <1----> Feu"
               .byte   0
js_status6     .byte   vcyan,bkcol0,1,23
               .text   "+-> Etat de JS2:     %---FRLDU EOR #$1F"
               .byte   0
               .bend
                
                
