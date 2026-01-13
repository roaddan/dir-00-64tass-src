;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
; c64_map.asm - Carthographie memoire et declaration de constantes pour les
; commodores 64 et 64c
;--------------------------------------------------------------------------------
; Segmentation principales de la mémoire
;--------------------------------------------------------------------------------
; Pour l'utilisation de ce fichier dans turbo-macro-pro ou sans 64tass utilisez
; la syntaxes ...
;
;         .include "e-v20map.s"
;
; ... en prenant soin de placer le fichier dans le meme disque ou répertoire que
; votre programme.
;--------------------------------------------------------------------------------
;* Equates sur les elements importants *
;--------------------------------------------------------------------------------
eot       = $00
memmapreg = $01
chrget    = $73     ;Recup Basic car texte
chrgot    = $79     ;...une seconde fois.
chrtst    = $7c
kiostatus = $90     ; Kernal I/O status word (st) (byte) 
curfnlen  = $b7     ; Current filename length (byte)
cursecadd = $b9     ; Current secondary address (byte)
curdevno  = $ba     ; Current device number (byte)
curfptr   = $bb     ; Current file pointer (word)  
stal      = $c1     ;word
scrnlin   = $d1     ;pnt cur-scrn-line
zp1       = $fb     ;1er Zpage prog. usager address (word)
zpage1    = $fb     ; zero page 1 
zp2       = $fd     ;2em Zpage prog. usager address (word)
zpage2    = $fd     ; zero page 2 address (word)
fascii    = $0100;region conv FP a ascii
kcol      = $0286;Couleur car affiche.
basstart  = $1001     ;basic start address std
basstartx = $1201     ;basic start address exram
basicrom  = $a000
chargen   = $d000
vicii     = $d000
sid       = $d400     ;sid base address
colourram  = $d800     ;video colour ram
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
bstop     =   $03      ;stop
bwhite    =   $05      ;set colour white
block     =   $08      ;lock the charset
bunlock   =   $09      ;unlock the charset
bcarret   =   $0d
btext     =   $0e
bcrsdn    =   $11      ;cursor down 1 line
brevcol   =   $12
bhome     =   $13
bdelete   =   $14
bred      =   $1c
bcuright  =   $1d
bgreen    =   $1e
bblue     =   $1f
borange   =   $81
blrun     =   $83
bfkey1    =   $85
bfkey2    =   $86
bfkey3    =   $87
bfkey4    =   $88
bfkey5    =   $89
bfkey6    =   $8a
bfkey7    =   $8b
bfkey8    =   $8c
bcarret1  =   $8d
bgraph    =   $8e
bblack    =   $90
bcuup     =   $91
brevoff   =   $92
bclear    =   $93
binsert   =   $94
bbrown    =   $95
bltred    =   $96
bdkgrey   =   $97
bmdgrey   =   $98
bltgreen  =   $99
bltblue   =   $9a
bltgrey   =   $9b
bmagenta  =   $9c
bculeft   =   $9d
byellow   =   $9e
bcyan     =   $9f

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
;|7.  | #%10111111 (191/$bf) |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
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
; | 10  | $0  | b00001010 | rose       || 11  | $b  | b00001011 | gris foncé |
; | 12  | $0  | b00001100 | gris moyen || 13  | $d  | b00001101 | vert pâle  |
; | 14  | $0  | b00001110 | blue pale  || 15  | $f  | b00001111 | gris pâle  |
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
;--------------------------------------
;vic - registres de contrôle
;--------------------------------------
vic       = $9000;debut du vic
vic0      = $9000;ABBBBBBB 
                ;A =interlace 
                ;B =screen hor. origin
vic1      = $9001;CCCCCCCC 
                ;C =screen vert. origin 
vic2      = $9002;HDDDDDDD 
                ;H =Screen mem location
                ;D =Number video column
vic3      = $9003;GEEEEEEF
                ;G =Raster Value
                ;E =Number video rows
                ;F =Character size
                ;  0 = 8 x 8
                ;  1 = 8 x 16
vic4      = $9004;GGGGGGGG
                ;G =Raster Value
vic5      = $9005;HHHHIIII
                ;H =Screen mem location
                ;I =Character mem loc.
vic6      = $9006;JJJJJJJJ
                ;J =Light pen hor. pos.
vic7      = $9007;KKKKKKKK
                ;K =Light pen ver. pos.
vic8      = $9008;LLLLLLLL
                ;L =paddle 1
vic9      = $9009;MMMMMMMM
                ;M =paddle 2
vic10     = $900a;NRRRRRRR
                ;N =Bas sound switch
                ;R =Bas Frequency
vic11     = $900b;OSSSSSSS
                ;O =Alto sound switch
                ;S =Alto Frequency
vic12     = $900c;PTTTTTTT
                ;P =Soprano sound switch
                ;T =Soprano Frequency
vic13     = $900d;QUUUUUUU
                ;Q =Noise switch
                ;U =Noise Frequency
vic14     = $900e;WWWWVVVV
                ;W =Auxiliary colour
                ;V =Loudness of sound
vic15     = $900f;XXXXYZZZ
                ;X =Screen colour (16)
                ;Y =Reverse mode 0 =on
                ;Z =Border colour (8)
;--------------------------------------------------------------------------------
;* vic code couleur en francais *
; couleur %xxxx0000
;              |||+-> bit 0   : Inverse tous les autres bits
;              |++--> bit 1,2 : 00=rgb, 01=Rgb, 10=rGb, 11=rgB 
;              +----> bit 3   : Intensité          
;     0000=noir,  0001=Blanc, 1000=orange, 1001=brun        
;     0010=rouge, 0010=Cyan,  1010=rose  , 1011=gris      
;     0100=vert,  0101=mauve, 1100=gris1 , 1101=vert2           
;     0110=vleu,  0111=jaune, 1110=bleu1 , 1111=gris2           
;           
;--------------------------------------------------------------------------------
vnoir   =   %00000000
vblanc  =   %00000001
vrouge  =   %00000010
vocean  =   %00000011
vcyan   =   %00000011
vmauve  =   %00000100
vvert   =   %00000101
vbleu   =   %00000110
vjaune  =   %00000111
vorange =   %00001000
vbrun   =   %00001001
vrose   =   %00001010
vgris   =   %00001011
vgris1  =   %00001100
vvert1  =   %00001101
vbleu1  =   %00001110
vgris2  =   %00001111
bknoir  =   %00000000
bkcol1  =   %00010000
bkcol2  =   %00100000
bkcol3  =   %00110000
bkcol4  =   %01000000
bkcol5  =   %01010000
bkcol6  =   %01100000
bkcol7  =   %01110000
bkcol8  =   %10000000
bkcol9  =   %10010000
bkcola  =   %10100000
bkcolb  =   %10110000
bkcolc  =   %11000000
bkcold  =   %11010000
bkcole  =   %11100000
bkcolf  =   %11110000
;-------------------------------------------------------------------------------
; R o u t i n e s   B a s i c  d e   c o m m u n i c a t i o n   s é r i e
;-------------------------------------------------------------------------------
serout1 = $e4a0 ; Serial: Output a 1 on the serial data line.
;-------------------------------------------------------------------------------
serout0 = $e4a9 ; Serial: Output a 0 on the serial data line.
;-------------------------------------------------------------------------------
serget  = $e4b2 ; Serial: Get an input bit from VIA1 and stabilize.
;-------------------------------------------------------------------------------
patches = $e4bc ; Program patch area.
;-------------------------------------------------------------------------------
iobase  = $e500 ; ($e500) Define i/o memory page
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
;-------------------------------------------------------------------------------
screen  = $e505 ; Return screen format
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
plot    = $e50a ; Set or retrieve cursor location x=column, y=line
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
initsk  = $e518 ; Initialize 6550 Vic Chip, screen and related pointers.
;-------------------------------------------------------------------------------
clsr    = $e55f ; Clear the screen.
;-------------------------------------------------------------------------------
home    = $e55f ; Move the cursor to the screen home position.
;-------------------------------------------------------------------------------
setslink= $e587 ; Reset the screen line link table pointers.
;-------------------------------------------------------------------------------
unusdnmi= $e5b5 ; NMI entry for restore key (No entry for this routine found.)
;-------------------------------------------------------------------------------
setiodef= $e5bb ; Reset the default device number.
;-------------------------------------------------------------------------------
initvic = $e5c3 ; Reset the vic chip registers.
;-------------------------------------------------------------------------------
lp2     = $e5cf ; Get a character from the keyboard queue and shift it down.
;-------------------------------------------------------------------------------
getque  = $e5e5 ; Wait for character to appear in the keyboard buffer.
;-------------------------------------------------------------------------------
get2rtn = $e619 ; Empty the keyboard buffer up to a carriage return.
;-------------------------------------------------------------------------------
getscrn = $e64f ; Optain input from screen.
;-------------------------------------------------------------------------------
quoteck = $e6b8 ; Test for quote and set flag.
;-------------------------------------------------------------------------------
setchar = $e6c5 ; Set up diaplay of a character on the screen.
;-------------------------------------------------------------------------------
scroll  = $e6ea ; advance the cursor on the screen, adds lines, and scroll.
;-------------------------------------------------------------------------------
retreat = $e72d ; Backup the cursor into the previous ligical screen line from 
                ; the first column of the current logical line.
;-------------------------------------------------------------------------------
scrnout = $e742 ; Handle characters going to the screen.
;-------------------------------------------------------------------------------
nxtline = $e8c3 ; Advance cursor to the next logical line.
;-------------------------------------------------------------------------------
rtrn    = $e8d8 ; Handle the carriage return key.
;-------------------------------------------------------------------------------
backup  = $e8e8 ; Move the corsor to the end of the previoud physical screen 
                ; line from the first column of a continuation of a logical 
                ; line.
;-------------------------------------------------------------------------------
forward = $e8fa ; Move the cursor to the start of the next screen line if the 
                ; cursor is in the last column of the screen.
;-------------------------------------------------------------------------------
colourset=$e912 ; Set the current foreground colour code.
;-------------------------------------------------------------------------------
colourtbl=$e921 ; Colour code key table.
;-------------------------------------------------------------------------------
cnvrtcd = $e929 ; Code conversion table.
;-------------------------------------------------------------------------------
scrl    = $e975 ; Scroll the screen.
;-------------------------------------------------------------------------------
openlin = $e9ee : Open up a blank physical line on the screen for inserts.
;-------------------------------------------------------------------------------
movline = $ea56 ; Move screen line.
;-------------------------------------------------------------------------------
setaddr = $ea6e ; The address of the screen line + color line is set in memory.
;-------------------------------------------------------------------------------
linptr  = $ea7e ; Set a pointer to the address of the start of the screen line.
;-------------------------------------------------------------------------------
clraline= $ea8d ; Blank out a physical screen line.
;-------------------------------------------------------------------------------
synptr  = $eaa1 ; Synchronize color to byte and store character on screen.
;-------------------------------------------------------------------------------
putscrn = $eaaa ; store a character on the screen.
;-------------------------------------------------------------------------------
colorsyn= $eab2 ; The address of the color map byte for screen map byte is 
                ; found.
;-------------------------------------------------------------------------------
irq     = $eabf ; IRQ interupt handler.
;-------------------------------------------------------------------------------
scnkey  = $eb1e ; Scan the keyboard
cscnkey = $ff9f ;---------------------------------------------------------------
;-------------------------------------------------------------------------------
setkeys = $ebdc ; Set keyboard decode table address in 245-246 ($f6-$f6).
;-------------------------------------------------------------------------------
keyvctrs= $ec46 ; Keyboard decode table addresses.
;-------------------------------------------------------------------------------
normkeys= $ec5e ; Table used for decoding unshifted keys into ascii.
;-------------------------------------------------------------------------------
shftkeys= $ec9f ; Table used for decoding SHIFTed keys into ascii.
;-------------------------------------------------------------------------------
logokeys= $ece0 ; Table used for decoding Commodore SHIFTed keys into ascii.
;-------------------------------------------------------------------------------
charset = $ed21 ; Used to set uppercase/graphics character set.
;-------------------------------------------------------------------------------
graphmode=$ed30 ; Set the environment specified by graphics control characters.
;-------------------------------------------------------------------------------
wrapline= $ed5b ; 
;-------------------------------------------------------------------------------
whatkeys= $ed69 ; Apparently unused keyboard decoding table.
;-------------------------------------------------------------------------------
ctrlkeys= $eda3 ; Table used for decoding CTRL SHIFT keys into ascii.
;-------------------------------------------------------------------------------
vicinit = $ede4 ; Initial values for VIC chip registers. 
;-------------------------------------------------------------------------------
runtb   = $edf4 ; LOAD and RUN words for the SHIFT and RUN keys.
;-------------------------------------------------------------------------------
ldtb2   = $edfd ; Screen line link table LSB of line in screen map.
;-------------------------------------------------------------------------------
talk    = $ee14 ; Send Talk command to serial bus.
                ;---------------------------------------------------------------
                ; Description:
                ;  - stalk send's talk command to serial bus.
                ; Imput :     A = Device number
                ; Output :    -
                ; Altered registers : A 
;-------------------------------------------------------------------------------
listen  = $ee17 ; Command a device on the serial bus to listen.
                ;---------------------------------------------------------------
                ; Description:
                ; - listen will command any device on the serial bus to receive 
                ;   data.
                ;---------------------------------------------------------------
                ; Entrée: A = Device number.
                ; Sortie: –
                ; Registres Utilisés: A.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Command device #8 to listen.
                ;       lda #8
                ;       jsr listen
                ;---------------------------------------------------------------
                ; Note:
                ; - The accumulator designates the device #.
;-------------------------------------------------------------------------------
listi   = $ee1c ; Serial: Prepare to send serial command with attention.
;-------------------------------------------------------------------------------
srsend  = $ee49 ; Serial: Send command or data to serial device.
;-------------------------------------------------------------------------------
srbad   = $eeb4 ; Serial: Set ST for timeout or DEVICE NOT PRESENT.
;-------------------------------------------------------------------------------
second  = $eec0 ; Send secondary address after listen
                ;---------------------------------------------------------------
                ; Description:
                ; - After listen has been called, a secondary address may be 
                ;   sent.
                ;---------------------------------------------------------------
                ; Entrée: A = Secondary address.
                ; Sortie: –
                ; Registres Utilisés: A.
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
scatn   = $eec5 ; Serial: Clear attention.
;-------------------------------------------------------------------------------
tksa    = $eece ; Send a secondary address to a device commanded to talk
                ;---------------------------------------------------------------
                ; Description:
                ; - tksa is used to send a secondary address for a talk device.
                ; - Function talk must be called first.
                ;---------------------------------------------------------------
                ; Entrée: A = Secondary address.
                ; Sortie: –
                ; Registres Utilisés: A.
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
ciout   = $eee4 ; Transmit a byte over the serial bus
                ;---------------------------------------------------------------
                ; Description:
                ; - ciout will send data to the serial bus. 
                ; - listen and second must be called first. 
                ; - Call unlsn to finish up neatly.
                ;---------------------------------------------------------------
                ; Entrée: A = Byte to write.
                ; Sortie: –
                ; Registres Utilisés: –
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
untlk   = $eef6 ; Send an untalk command
                ;---------------------------------------------------------------
                ; Description:
                ; - All devices previously set to talk will stop sending data.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: –
                ; Registres Utilisés: A.
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
unlsn   = $ef04 ; Send an unlisten command
                ;---------------------------------------------------------------
                ; Description:
                ; - unlsn commands all devices on the serial bus to stop
                ;   receiving data.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: –
                ; Registres Utilisés: A.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Command the serial bus to unlisten.
                ;       jsr unlsn
                ;       rts
                ;---------------------------------------------------------------
                ; Note:
                ; - The serial bus can now be used for other things.
;-------------------------------------------------------------------------------
acptr   = $ef19 ; Recoit un caractere provenant du port serie
                ;---------------------------------------------------------------
                ; Description:
                ; - acptr est utilisé pour recupérer des données provenant du 
                ;   port série.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: A = Byte read.
                ; Registres Utilisés: A.
                ;---------------------------------------------------------------
                ; Exemple:
                ; - Talk et tksa doivent d'abord Ãªtre appelé.
                ;       jsr acptr
                ;       sta $0800
                ;---------------------------------------------------------------
                ; Note:
                ; - Cet exemple ne montre que le résultat final.
                ; - Effectuez d'abord lâ€™appel de talk et tksa.
;-------------------------------------------------------------------------------
srclkhi = $ef84 ; Serial: Set clock line high.
;-------------------------------------------------------------------------------
srclklo = $ef8d ; Serial: Set clock line low.
;-------------------------------------------------------------------------------
waitabit= $ef96 ; Serial: Delay one millisecond.
;-------------------------------------------------------------------------------
rsnxtbit= $efa3 ; RS-232: Send the next bin (NMI continuation routine).
;-------------------------------------------------------------------------------
rsprty  = $efbf ; RS-232: Calculate barity and stop bits value.
;-------------------------------------------------------------------------------
rsstops = $efe8 ; RS-232: Transmit stop bits.
;-------------------------------------------------------------------------------
rsnxtbyt= $efee ; RS-232: Prepare the next byte to be send from send buffer.
;-------------------------------------------------------------------------------
rsmissing=$f016 ; RS-232: Set Clear To Send or Data Set Ready Missing status.
;-------------------------------------------------------------------------------
rscptbit= $f027 ; RS-232: Compute desire word lenght bit count.
;-------------------------------------------------------------------------------
rsinbit = $f036 ; RS-232: Recieve an input bit (NMI driven).
;-------------------------------------------------------------------------------
rsstpbit= $f04b ; RS-232: Determine if all the stop bits have been recieved yet.
;-------------------------------------------------------------------------------
rsprepin= $f05b ; RS-232: Prepare to recieve the next input byte.
;-------------------------------------------------------------------------------
rsstrbit= $f068 ; RS-232: Check for start bit in recieve mode.
;-------------------------------------------------------------------------------
rsinbyte= $f06f ; RS-232: Put constructed byte into reciebe buffer.
;-------------------------------------------------------------------------------
rsinprty= $f08b ; RS-232: Parity checking of the input byte.
;-------------------------------------------------------------------------------
rsprtyer= $f09d ; RS-232: Parity error on input byte.
;-------------------------------------------------------------------------------
rsoverun= $f0a2 ; RS-232: Buffer overrun on input byte.
;-------------------------------------------------------------------------------
rsbreak = $f0a5 ; RS-232: Break detected on input.
;-------------------------------------------------------------------------------
rsframer= $f0a8 ; RS-232: Framing error on input.
;-------------------------------------------------------------------------------
rsinerr = $f0aa ; RS-232: Set input error status and continue.
;-------------------------------------------------------------------------------
rsdvcerr= $f0b9 ; RS-232: ILLEGAL DEVICE message for LOAD or SAVE.
;-------------------------------------------------------------------------------
rsopnout= $f0bc ; RS-232: Open an RS-232 channel for output.
;-------------------------------------------------------------------------------
rsoutsav= $f0ed ; RS-232: Store a character in the transmit buffer.
;-------------------------------------------------------------------------------
rsprepot= $f102 ; RS-232: Set up NMI for transmission.
;-------------------------------------------------------------------------------
rsopnin = $f116 ; RS-232: Open an RS-232 channel for input.
;-------------------------------------------------------------------------------
rsnxtin = $f14f ; RS-232: Retrieve the next character from the recieve buffer.
;-------------------------------------------------------------------------------
rspause = $f160 ; RS-232: Check if serial and tape are idle, protect from RS232.
;-------------------------------------------------------------------------------
kmsgtbl = $f174 ; Table of KERNAL messages.
;-------------------------------------------------------------------------------
spmsg   = $F1e2 ; Display LOADING or VERIFYING if control messages wanted.
;-------------------------------------------------------------------------------
kmsgshow= $f1e6 ; Print KERNAL control messages.
;-------------------------------------------------------------------------------
getin   = $f1f5 ; Get a character.
                ; jmp($032a) ---------------------------------------------------
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
ibasin  = $f20e ; Get a character from the input channel
                ; jmp ($0324) --------------------------------------------------
chrin   = $f20e ; Description:
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
chrintp = $f230 ; Obtain a byte from the tape buffer.
;-------------------------------------------------------------------------------
chrintp2= $f250 ; Load .A with next tape character, getting block when needed.
;-------------------------------------------------------------------------------
chrinsr = $f264 ; Obtain a byte from the serial line.
;-------------------------------------------------------------------------------
chrinrs = $f26f ; RS-232: Obtain a byte from the rs-232 device.
;-------------------------------------------------------------------------------
chrout  = $f27a ; Output character to current output device.
;-------------------------------------------------------------------------------
chrouttp= $f290 ; Output a character to tape.
;-------------------------------------------------------------------------------
chkin   = $f2c7 ; Define an input channel. 
                ; jmp ($031e) --------------------------------------------------
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
chkout  = $f309 ; Define an output channel.
                ; jmp ($0320) --------------------------------------------------
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
close   = $f34a ; (Close a logical file
                ; jmp ($031c) --------------------------------------------------
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
fndflno = $f3cf ; Find file number (.x) in file table at 601 ($0259).
;-------------------------------------------------------------------------------
setflch = $f3df ; Set file characteristics of file (.x) into 184-186 ($b8-$ba).
;-------------------------------------------------------------------------------
clall   = $f3ef ; Close all open files
                ; jmp ($032c) --------------------------------------------------
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
clrchn  = $f3f3 ; Clear all i/o channels.
                ; jmp ($0322) --------------------------------------------------
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
open    = $f40a ; Open a logical file
                ; jmp ($031a) --------------------------------------------------
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
sername = $f495 ; Send secondary address and filename to serial device.
;-------------------------------------------------------------------------------
openrs  = $f4c7 ; RS-232: open RS-232 device.
;-------------------------------------------------------------------------------
load    = $f542 ; Load device to RAM.
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
loadser = $f55c ; Load or Verify from serial device.
;-------------------------------------------------------------------------------
loadtp  = $f5d1 ; Load or Verify from tape.
;-------------------------------------------------------------------------------
srching = $f647 ; Display SEARCHING message for tape device.
;-------------------------------------------------------------------------------
filename= $f659 ; Display the filename.
;-------------------------------------------------------------------------------
ldvrmsg = $f66a ; Display LOADING or VERIFYING message.
;-------------------------------------------------------------------------------
save    = $f675 ; Save memory to a device.
                ;---------------------------------------------------------------
;-------------------------------------------------------------------------------
saveser = $f692 ; Save RAM to serial device (except: RS-232,screen or keyboard).
;-------------------------------------------------------------------------------
savetp  = $f6f1 : Save RAM to tape.
;-------------------------------------------------------------------------------
saving  = $f728 : Display SAVING message.
;-------------------------------------------------------------------------------
udtim   = $f734 ; Update the system clock
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
;--------------------------------------------------------------------------------
rdtim   = $f760 ; Read system clock
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
settim  = $f767 ; Set the system clock.
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
stop    = $f770 ; Check if stop key is pressed.
                ; jmp ($0328) --------------------------------------------------
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
filemsg = $f77e ; I/O error file error message handler.
;-------------------------------------------------------------------------------
fah     = $f7af ; Tape: find next tape header, .X back contains header ID#.
;-------------------------------------------------------------------------------
tapeh   = $f7e7 ; Tape: Build an output tape header in the tape buffer area.
;-------------------------------------------------------------------------------
tpbufa  = $f84d ; Tape: Load tape buffer address from 178-179($b2-$b3) in .X .Y.
;-------------------------------------------------------------------------------
ldad1   = $f854 ; Tape: Set Load/Save starting and ending pointers to the tape.
;-------------------------------------------------------------------------------
fndhrd  = $f867 ; Tape: Find the tape header for a specified filename (or next).
;-------------------------------------------------------------------------------
jtp20   = $f88a ; Tape: Increment the tape buffer character counter.
;-------------------------------------------------------------------------------
cstel   = $f894 ; Tape: Display PRESS PLAY ON TAPE message.
;-------------------------------------------------------------------------------
csio    = $f8ab ; Tape: Check Tape's play/rewind/forward button status.
;-------------------------------------------------------------------------------
cste2   = $f8b7 ; Tape: Display PRESS RECORD & PLAY ON TAPE message.
;-------------------------------------------------------------------------------
rdtpblks= $f8c0 ; Tape: Initiate tape header read.
;-------------------------------------------------------------------------------
rblk    = $f8c9 ; Tape: Read blocks from tape.
;-------------------------------------------------------------------------------
wblk    = $f8e3 ; Tape: Write blocks to tape.
;-------------------------------------------------------------------------------
tape    = $f8f4 ; Tape: Common tape read/write, start tape operations,
;-------------------------------------------------------------------------------
tstop   = $f94b ; Tape: Check for the STOP key.
;-------------------------------------------------------------------------------
stti    = $f95d ; Tape: Set time limit for tape dispole.
;-------------------------------------------------------------------------------
readt   = $f98e ; Tape: Read tape data bits into location 191 ($bf) (IRQ driven)
;-------------------------------------------------------------------------------
tpstore = $faad ; Tape: Determin if to store the input character from tape.
;-------------------------------------------------------------------------------
rd300   = $fbd2 ; Tape: Called to reset the tape read pointer.
;-------------------------------------------------------------------------------
newch   = $fbdb ; Tape: New tape character setup.
;-------------------------------------------------------------------------------
tptogle = $fbea ; Tape: Toggle the tape write line to invert the output signal.
;-------------------------------------------------------------------------------
blkend  = $fc06 ; Tape: End of block write processing.
;-------------------------------------------------------------------------------
write   = $fc0b ; Tape: Data write (IRQ driven).
;-------------------------------------------------------------------------------
wrtni   = $fc95 ; Tape: Block leader write (IRQ driven).
;-------------------------------------------------------------------------------
wrtz    = $fca8 ; Tape: Leader write (IRQ driven).
;-------------------------------------------------------------------------------
tnif    = $fccf ; Tape: Restore IRQ vector.
;-------------------------------------------------------------------------------
bsiv    = $fcf6 ; Tape: Reset the current IRQ vector.
;-------------------------------------------------------------------------------
tnoff   = $fd08 ; Tape: Kill motor.
;-------------------------------------------------------------------------------
vrpty   = $fd11 ; Comnpare current to end of load/save pointers (tape & serial).
;-------------------------------------------------------------------------------
wrt62   = $fd1b ; Increment current load/save pointer (tape & serial).
;-------------------------------------------------------------------------------
start   = $fd22 ; Power-on/reset routine (check for autostart cartridge).
;-------------------------------------------------------------------------------
chkauto = $fd3f ; Check for an autostarting program at $a000. if equ a0cbm
;-------------------------------------------------------------------------------
a0cbm   = $fd4d ; A0CBM characters with the high order bit on in the last 3 
                ; characters. $41,$30,$c3,$c2,$cd.
;-------------------------------------------------------------------------------
restor  = $fd52 ; Restore default I/O vectors.
                ;---------------------------------------------------------------
;-------------------------------------------------------------------------------
vector  = $fd57 ; ($fd1a) Read/set I/O vectors.
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
vectors = $fd6d ; Default system vector address storage table.
;-------------------------------------------------------------------------------
initmem = $fd8d ; Initialize system memory.
;-------------------------------------------------------------------------------
irqvctrs= $fdf1 ; IRQ vectors table.
;-------------------------------------------------------------------------------
initvis = $fdf9 ; Initialize the 6522 VIA registers.
;-------------------------------------------------------------------------------
setnam  = $fe49 ; Set up file name
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
setlfs  = $fe50 ; Set up a logical file
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
readst  = $fe57 ; Read i/o status word
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
setmsg  = $fe66 ; Set kernal message output flag
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
readiost= $fe68 ; Load .A with the non-RE-232 I/O status ST.
;-------------------------------------------------------------------------------
settmo  = $fe6f ; Set ieee bus card timeout flag
                ;---------------------------------------------------------------
                ; Description:
                ; - settmo is used only with an ieee add-on card to access the 
                ;   serial bus.
                ;---------------------------------------------------------------
                ; Entrée: A = Timeout value.
                ; Sortie: –
                ; Registres Utilisés: –
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
memtop  = $fe73 ; Get/Set top of ram
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
membot  = $fe82 ; Get/set bottom of memory.
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
tstmem  = $fe91 ; Test a memory location.
;-------------------------------------------------------------------------------
nmi     = $fea9 ; NMI handler routine.
;-------------------------------------------------------------------------------
break   = $fed2 ; BREAK interupt entry.
;-------------------------------------------------------------------------------
rsnmi   = $fede ; RS-232: nmi sequence.
;-------------------------------------------------------------------------------
krti    = $ff56 ; Restore 6502 registers frm the stack and return frm interrupt.
;-------------------------------------------------------------------------------
baudtbl = $ff5c ; RS-232: VIA timer 2 values for baud rate table.
;-------------------------------------------------------------------------------
irqrout = $ff72 ; irq routine initial 6502 entry point.
;-------------------------------------------------------------------------------
c4ffs   = $ff85 ; five unused bytes of 255 ($ff).
;-------------------------------------------------------------------------------
crestor = $ff8a ; Jump to 64850 ($fd52) RESTOR.
;-------------------------------------------------------------------------------
cvector = $ff8d ; Jump to 64855 ($fd57) VECTOR.
;-------------------------------------------------------------------------------
csetmsg = $ff90 ; Jump to 65126 ($fe66) SETMSG.
;-------------------------------------------------------------------------------
csecond = $ff93 ; Jump to 61120 ($eec0) SECOND.
;-------------------------------------------------------------------------------
ctksa   = $ff96 ; Jump to 61134 ($eece) TKSA.
;-------------------------------------------------------------------------------
cmemtop = $ff99 ; Jump to 65139 ($fe73) MEMTOP.
;-------------------------------------------------------------------------------
cmembot = $ff9c ; Jump to 65154 ($fe82) MEMBOT.
;-------------------------------------------------------------------------------
cscnkey = $ff9f ; Jump to 60190 ($eb1e) SCNKEY.
;-------------------------------------------------------------------------------
csettmo = $ffa2 ; Jump to 65135 ($fe6f) SETTMO.
;-------------------------------------------------------------------------------
cacptr  = $ffa5 ; Jump to 61209 ($ef19) ACPTR.
;-------------------------------------------------------------------------------
cciout  = $ffa8 ; Jump to 61156 ($eee4) CIOUT.
;-------------------------------------------------------------------------------
cuntlk  = $ffab ; Jump to 61174 ($eef6) UNTLK.
;-------------------------------------------------------------------------------
cunlsn  = $ffae ; Jump to 61188 ($ef04) UNLSN.
;-------------------------------------------------------------------------------
clisten = $ffb1 ; Jump to 60951 ($ee17) LISTEN.
;-------------------------------------------------------------------------------
ctalk   = $ffb4 ; Jump to 60948 ($ee14) TALK.
;-------------------------------------------------------------------------------
crdst   = $ffb7 ; Jump to 65111 ($fe57) READST.
;-------------------------------------------------------------------------------
csetlfs = $ffba ; Jump to 65104 ($fe50) SETLFS.
;-------------------------------------------------------------------------------
csetnam = $ffbd ; Jump to 65097 ($fe49) SETNAM.
;-------------------------------------------------------------------------------
copen   = $ffc0 ; Jump off 794-795 ($031a-$031b) IOPEN.
;-------------------------------------------------------------------------------
cclos   = $ffc3 ; Jump off 796-797 ($031c-$031d) ICLOSE.
;-------------------------------------------------------------------------------
inpchn  = $ffc6 ; Jump off 798-799 ($031e-$031f) ICHKIN.
;-------------------------------------------------------------------------------
outchn  = $ffc9 ; Jump off 800-801 ($0320-$0321) ICKOUT.
;-------------------------------------------------------------------------------
cclrchn = $ffcc ; Jump off 802-803 ($0322-$0323) ICLRCH.
;-------------------------------------------------------------------------------
cinch   = $ffcf ; Jump off 804-805 ($0324-$0325) IBASIN.
;-------------------------------------------------------------------------------
cchrout = $ffd2 ; Jump to 62074 ($f27a) CHROUT.
;-------------------------------------------------------------------------------
cload   = $ffd5 ; Jump to 67286 ($f542) LOAD.
;-------------------------------------------------------------------------------
csave   = $ffd8 ; Jump to 63093 ($f675) SAVE.
;-------------------------------------------------------------------------------
csettim = $ffdb ; Jump to 63335 ($f767) SETTIM.
;-------------------------------------------------------------------------------
crdtim  = $ffde ; Jump to 63328 ($f760) RDTIM.
;-------------------------------------------------------------------------------
iscntc  = $ffe1 ; Jump off 808-809 ($0328-$0329) ISTOP.
;-------------------------------------------------------------------------------
cgetl   = $ffe4 ; Jump off 810-811 ($032a-$032b) IGETIN.
;-------------------------------------------------------------------------------
ccall   = $ffe7 ; Jump to ;Ferme tout fichier ouv
;-------------------------------------------------------------------------------
cudtim  = $ffea ; Jump to 
;-------------------------------------------------------------------------------
cscreen = $ffed ; Jump to 
;-------------------------------------------------------------------------------
cplot   = $fff0 ; Jump to 
;-------------------------------------------------------------------------------
ciobase = $fff3 ; Jump to 
;-------------------------------------------------------------------------------
vctrnmi = $fffa ; Jump to 
;--------------------------------------------------------------------------------
vctrrst = $fffc ; Jump to 
;--------------------------------------------------------------------------------
vctrirq = $fffe ; Jump to 
;--------------------------------------------------------------------------------





;###############################################################################
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
                ; Entrée: A = Device number.
                ; Sortie: –
                ; Registres Utilisés: A, X.
;-------------------------------------------------------------------------------
sstdout = $F279 ; Define serial bus as standard output; do not send LISTEN 
                ; secondary address if secondary address bit #7 = 1.
                ;---------------------------------------------------------------
                ; Entrée: A = Device number.
                ; Sortie: –
                ; Registres Utilisés: A, X.                
;-------------------------------------------------------------------------------
sfopen  = $F3D5 ; Open file on serial bus; do not send file name if secondary 
                ; address bit #7 = 1 or file name length = 0.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: –
                ; Registres Utilisés: A, Y.
;-------------------------------------------------------------------------------
sutclose= $F528 ; Send UNTALK and CLOSE command to serial bus.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: –
                ; Registres Utilisés: A.
;-------------------------------------------------------------------------------
sulclose= $F63F ; Send UNLISTEN and CLOSE command to serial bus.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: –
                ; Registres Utilisés: A.
;-------------------------------------------------------------------------------
sfclose = $F642 ; Close file on serial bus; do not send CLOSE secondary address 
                ; if secondary address bit #7 = 1.
                ;---------------------------------------------------------------
                ; Entrée: –
                ; Sortie: –
                ; Registres Utilisés: –
;-------------------------------------------------------------------------------
stimeout= $FE21 ; Unknown. (Set serial bus timeout.)
                ;---------------------------------------------------------------
                ; Entrée: A = Timeout value.
                ; Sortie: –
                ; Registres Utilisés: –
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
talk    = $ffb4 ; ($ed09) Command a device on the serial bus to talk
                ;---------------------------------------------------------------
                ; Description:
                ; - This routine will command a device on the serial bus to 
                ;   send data.
                ;---------------------------------------------------------------
                ; Entrée: A = Device number.
                ; Sortie: –
                ; Registres Utilisés: A.
                ; Adresse Réelle: $ED09.
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
