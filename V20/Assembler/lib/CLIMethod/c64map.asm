;--------------------------------------------------------------------------------
; Scripteur ......: Daniel Lafrance, G9B-0S5, canada.
; Nom du fichier .:
; Cernière m.à j. : 
; Inspiration ....: 
;--------------------------------------------------------------------------------
;=========================================
; c64map.asm - carthographie memoire et 
;    declaration de constantes pour les
;    commodores 64 et 64c
;========================================
; Scripteur...: daniel lafrance, 
;               j5w1w5, canada.
; Version.....: 20191223.1
; Inspiration.: isbn 0-87455-082-3
;========================================
; pour utilisation inscrire la ligne 
;     .include "c64map.asm" 
; dans votre fichier source principal.
;========================================
;1234567890123456789012345678901234567890
;========================================
; Segmentation principales de la mémoire
;========================================
basicstart = $0801
screenram  = $0400
colorram   = $d800
scrram0    = $0400
colram0    = $d800
scrram1    = $0500
colram1    = $d900
scrram2    = $0600
colram2    = $da00
scrram3    = $0700
colram3    = $db00
basicrom   = $a000
vic        = $d000
vborder    = $d020
border     = $d020
bground    = $d021
sid        = $d400
cia1       = $dc00
cia2       = $dd00
kernalrom  = $e000
zeropage   = $00fb
zonepage   = $00fd
framecol   = $d020
backgrnd   = $d021
;========================================
carcol  = $0286 ; Basic couleur caractere
ieval   = $030a
; vecteurs du basic
chrget  = $73
chrgot  = $79
zpage1  = $fb
zpage2  = $fd
;+====================================+
;|  couleurs possible des caractères  |
;+====================================+
;| dec | hex |  binaire  | couleur    |
;+-----+-----+-----------+------------+
;|  0  | $00 | b00000000 | noir       |
;|  1  | $01 | b00000001 | blanc      |
;|  2  | $02 | b00000010 | rouge      |
;|  3  | $03 | b00000011 | océan      |
;|  4  | $04 | b00000100 | mauve      |
;|  5  | $05 | b00000101 | vert       |
;|  6  | $06 | b00000110 | bleu       |
;|  7  | $07 | b00000111 | jaune      |
;|  8  | $08 | b00001000 | orange     |
;|  9  | $09 | b00001001 | brun       |
;| 10  | $0a | b00001010 | rose       |
;| 11  | $0b | b00001011 | gris foncé |
;| 12  | $0c | b00001100 | gris moyen |
;| 13  | $0d | b00001101 | vert pâle  |
;| 14  | $0e | b00001110 | blue pale  |
;| 15  | $0f | b00001111 | gris pâle  |
;+-----+-----+-----------+------------+
; constantes de couleurs en français.
cnoir       = $00
cblanc      = $01
crouge      = $02
cocean      = $03
cmauve      = $04
cvert       = $05
cbleu       = $06
cjaune      = $07
corange     = $08
cbrun       = $09
crose       = $0a
cgrisfonce  = $0b
cgrismoyen  = $0c
cvertpale   = $0d
cbleupale   = $0e
cgrispale   = $0f
; pour anglosaxons
cblack      = $00
cwhite      = $01
cred        = $02
ccyan       = $03
cpurple     = $04
cgreen      = $05
cblue       = $06
cyellow     = $07
;corange     = $08 ; same as french :)
cbrown      = $09
clightred   = $0a
cdarkgray   = $0b
cmidgray    = $0c
clightgreen = $0d
clightblue  = $0e
clightgray  = $0f
;========================================
; Routines présentes dans le kernel
;========================================
acptr   = $ffa5 ; Recoit caractère du 
                ; port serie
;----------------------------------------
; Description: Recupere les données 
; provenant du port série.
;----------------------------------------
; Exemple: Appeler d'abord talk et tksa.
;       jsr acptr
;       sta $0800
;----------------------------------------
; Note: Cet exemple ne montre que le
; résultat final.
; Appelez d'abord talk et tksa.
;========================================
chkin   = $ffc6 ; Ouvrir canal d’entrées. 
;----------------------------------------
; Description: Is used to define any
; opened file as an input file. 
; Open must be called first.
;----------------------------------------
; Exemple: Set file #2 as input channel
;       ldx #2
;       jsr chkin
;----------------------------------------
; Note:
; The x register designates which file #.
;========================================
chkout  = $ffc9 ; Open channel for output
;----------------------------------------
; Description: Just like chkin, but it
; defines the file for output. 
; Open must be called first.
;----------------------------------------
; Exemple: Set file #4 as an output file.
;       ldx #4
;       jsr chkout
;----------------------------------------
; Note:
; The x register defines the file #.
;========================================
chrin   = $ffcf ; Get char from input chn
;----------------------------------------
; Description: Will get character from
; input device. 
; Calling open and chkin can change the
; input device.
;----------------------------------------
; Exemple: Store a typed string to the 
; screen.
;       ldy #$00
; loop  jsr chkin
;       sta $0800,y
;       iny
;       cmp #$0d
;       bne loop
;       rts
;----------------------------------------
; Note:
; Example is like an input statement. 
;========================================
chrout  = $ffd2 ; Output a character
;----------------------------------------
; Description: Load the accumulator with
; your number and call. 
; open and chkout will change the output
; device.
;----------------------------------------
; Exemple:
; Mimics the command of cmd 4:print "a";
;       ldx #4
;       jsr chkout
;       lda #'a'
;       jsr chrout
;       rts
;----------------------------------------
; Note: The letter a is printed to the
; screen. Call open first for the printer
;========================================
ciout   = $ffa8 ; Send byte on serial bus
;----------------------------------------
; Description: Will send data to the
; serial bus. 
; Listen and second must be called first. 
; Call unlsn to finish up neatly.
;----------------------------------------
; Exemple: Send the letter x to the
; serial bus.
;       lda #'x
;       jsr ciout
;       rts
;----------------------------------------
; Note: The accumulator is used to 
;       transfer the data.
;========================================
cint    = $ff81 ; Init. screen and vic-ii
;----------------------------------------
; Description: Resets the 6567 video
; controller chip and the screen editor.
;----------------------------------------
; Exemple: Reset the 6567 chip and the 
; 6566 vic chip.
;       jsr cint
;       rts
;----------------------------------------
; Note: Sams as pressing the stop and
; restore keys.
;========================================
clall   = $0ffe7 ; Close all open files
;----------------------------------------
; Description: Close all files and resets
; all channels.
;----------------------------------------
; Exemple: close all files.
;       jsr clall
;       rts
;----------------------------------------
; Note: clrchn routine is called
; automatically.
;========================================
close   = $0ffc3 ; close a logical file
;----------------------------------------
; Description: Close any opened file, 
;----------------------------------------
; Exemple: close logical file #2.
;       lda #2
;       jsr close
;----------------------------------------
; Note: File # in accumulator.
;========================================
clrchn  = $ffcc ; Clear all i/o channels.
;----------------------------------------
; Description: Resets all channels and
; i/o registers and  the input to 
; keyboard and the output to screen.
;----------------------------------------
; Exemple: Restore default values to i/o 
; devices.
;       jsr clrchn
;       rts
;----------------------------------------
; Note: The accumulator and the x
; register are altered.
;========================================
getin   = $ffe4 ; Get a character.
;----------------------------------------
; Description: Get one piece of data from
; the input device. 
; open and chkin can be used to change
; the input device.
;----------------------------------------
; Exemple: Wait for a key to be pressed.
;       wait    jsr getin
;               cmp #0
;               beq wait
;----------------------------------------
; Note: if the serial bus is used, all
; registers are altered.
;========================================
iobase  = $fff3 ; define i/o memory page
;----------------------------------------
; Description: Returns the low and high
; bytes of the starting address of the
; i/o devices in the x and y registers.
;----------------------------------------
; Exemple: Set user port data direction
; register of the user port to 0(input).
;       jsr iobase
;       stx point
;       sty point+1
;       ldy #2
;       lda #0
;       sta (point),y
;----------------------------------------
; Note:
; Point is a zero-page address used to
; access the ddr indirectly.
;========================================
ioinit  = $ff84 ; initialize i/o devices.
;----------------------------------------
; Description: Init. all i/o devices and
; routines. 
; Part of the system cold boot routine.
;----------------------------------------
; Exemple: Init. all i/o devices.
;       jsr ioinit
;       rts
;----------------------------------------
; Note: All registers are altered.
;========================================
listen  = $ffb1 ; Order serial dev to
; listen.
;----------------------------------------
; Description: Tell any serial bus device
; to receive data.
;----------------------------------------
; Exemple: Tell device #8 to listen.
;       lda #8
;       jsr listen
;----------------------------------------
; Note: Reg A designates the device #.
;========================================
load    = $ffd5 ; Load ram from device
;----------------------------------------
; Description: Computer will perform load
; or the verify command. 
; a=1 -> load; a=0 -> verify.
;----------------------------------------
; Exemple: Load a program into memory.
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
;----------------------------------------
; Note: program 'file' will be loaded
; into memory starting at 8192 decimal,
; x being the low byte and y being the
; high byte for the load.
;========================================
membot  = $ff9c ; Set bottom of memory.
;----------------------------------------
; Description:
; C=1, get address (yyxx) of ram bottom.  
; C=0, set address (yyxx) of ram bottom. 
;----------------------------------------
; exemple: Move bottom ram up one page.
;       sec
;       jsr membot
;       iny
;       clc
;       jsr membot
;       rts
;----------------------------------------
; Note: Reg. A not altered.
;========================================
memtop  = $ff99 ; set the top of ram
;----------------------------------------
; Description:
; C=1, get address (yyxx) of ram top.  
; C=0, set address (yyxx) of ram top. 
;----------------------------------------
; Exemple: protect 1k of ram from basic.
;       sec
;       jsr memtop
;       dey
;       clc
;       jsr memtop
;----------------------------------------
; Note: Reg. A not altered.
;========================================
open    = $ffc0 ; Open a logical file
;----------------------------------------
; Description: After setlfs and setnam
; call, logical file can be opened.
;----------------------------------------
; Exemple: Duplicate the command
; open 15,8,15,'i/o'
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
;----------------------------------------
; Note: Opens the current name file with
; the current lfs.
;========================================
plot    = $fff0 ; set or retrieve cursor 
;----------------------------------------
; Description:
; C=1, cursor x,y is returned in (y,x). 
; C=0, cursor x,y is moved to (y,x), 
;        x=column, y=line
;----------------------------------------
; Exemple: move cursor to row 12, 
; column 20 (12,20).
;       ldx #12
;       ldy #20
;       clc
;       jsr plot
;----------------------------------------
; Note: Cursor set to middle of screen.
;========================================
ramtas  = $ff87 ; Perform ram test
;----------------------------------------
; Description: Test ram, reset the top 
; and bottom of  memory pointers,
; clear $00000 to $00101 and $00200 to $003ff 
; and set the screen memory to $00400.
;----------------------------------------
; Exemple: Do ram test.
;       jsr ramtas
;       rts
;----------------------------------------
; Note: All registers are altered.
;========================================
rdtim   = $ffde ; Read system clock
;----------------------------------------
; Description: Mem locations 160-162 are 
; transferred to y,x and a registers.
;----------------------------------------
; Exemple: Show system clock to screen.
;       jsr rdtim
;       sta 1026
;       stx 1025
;       sty 1024
;----------------------------------------
; Note: The system clock can be converted
; to hours/minutes/seconds.
;========================================
readst  = $ffb7 ; Read status word
;----------------------------------------
; Description: Returns the status of the
; i/o devices. Any error code can be
; translated as operator error.
;----------------------------------------
; Exemple: Check for read error.
;       jsr readst
;       cmp #16
;       beq error
;----------------------------------------
; Note: if A=16, a read error occurred.
;========================================
screen  = $ffed ; Return screen format
;----------------------------------------
; Description: Returns the number of
; columns and rows the screen in x and y.
;----------------------------------------
; Exemple: Determine the screen size.
;       jsr screen
;       stx maxcol
;       sty maxrow
;       rts
;----------------------------------------
; Note: Compatiblewith 64, vic-20, and
; future versions of the 64.
;========================================
second  = $ff93 ; Send 2nd add for listen
;----------------------------------------
; Description: After listen has been
; called, a 2nd address may be sent
;----------------------------------------
; Exemple: Access dev. #8 with secondary
; address #15.
;       lda #8
;       jsr listen
;       lda #15
;       jsr second
;----------------------------------------
; Note: A = address number.
;========================================
setlfs  = $ffba ; Set up a logical file
;----------------------------------------
; Description: Set logical address, file
; address, and secondary address. 
; Call setlfs prior to open.
;----------------------------------------
; Exemple: Set logical file #1, dev #8,
; secondary address of 15.
;       lda #1
;       ldx #8
;       ldy #15
;       jsr setlfs
;----------------------------------------
; Note: If open is called, the command 
;       will be open 1,8,15.
;========================================
setmsg  = $ff90 ; set mesg, system output
;----------------------------------------
; Description: Depending on A, error msg,
; control msg or neither is printed.
;----------------------------------------
; Exemple: Turn on control messages.
;       lda #$040
;       jsr setmsg
;       rts
;----------------------------------------
; Note: $00 = no message, $040 = control,
; 128 = error messages.
;========================================
setnam  = $ffbd ; Set up file name
;----------------------------------------
; Description: Must be called before
; open, load or save.
;----------------------------------------
; Exemple: Prepare disk drive for file#1
;       lda #6
;       ldx #l,name
;       ldy #h,name
;       jsr setnam
;       name.by 'file#l'
;----------------------------------------
; note: A = file name length, 
;       x = low byte, and y = high byte.
;========================================
settim  = $ffdb ; Set the system clock
;----------------------------------------
; Description: Sets the system clock.
;----------------------------------------
; Exemple: Set system clock to 10 minutes 
; thus 3600 jiffies.
;       lda #$00
;       ldx #<$3600
;       ldy #>$3600
;       jsr settim
;----------------------------------------
; Note: Allows very accurate timing.
;========================================
settmo  = $ffa2 ; set ieee timeout flag
;----------------------------------------
; Description: Used only with an ieee 
; add-on card to access the serial bus.
;----------------------------------------
; Exemple: Disable serial bus time-outs.
;       lda #0
;       jsr settmo
;----------------------------------------
; Note: A=0 -> disable, A=128 -> enable
;========================================
stop    = $ffe1 ; Check stop key pressed
;----------------------------------------
; Description: Z=1 if stop key pressed.
;----------------------------------------
; Exemple: Wait for stop key.
;  wait jsr stop
;       bne wait
;       rts
;----------------------------------------
; Note: stop must be called for it to 
; remain functional.
;========================================
talk    = $ffb4 ; Order serial dev. talk
;----------------------------------------
; Description: Order serial dev. to 
; send data.
;----------------------------------------
; Exemple: Command device #8 to talk.
;       lda #8
;       jsr talk
;       rts
;----------------------------------------
; Note: A=file number.
;========================================
tksa    = $ff96 ; Send a 2nd address to a 
; device commanded to talk
;----------------------------------------
; Description: Send a secondary address
; to a talk device.
; talk must be called first.
;----------------------------------------
; Exemple: Signal device #4 to talk with
; command #7.
;       lda #4
;       jsr talk
;       lda #7
;       jsr tksa
;       rts
;----------------------------------------
; Note: This example will tell printer to
; print in uppercase.
;========================================
udtim   = $ffea ; Update the system clock
;----------------------------------------
; Description: When you are using your
; own interrupt system, you can update
; the system clock by calling udtim.
;----------------------------------------
; Exemple: Update the system clock.
;       jsr udtim
;       rts
;----------------------------------------
; Note: Useful to call udtim before
; calling stop.
;========================================
unlsn   = $ffae ; send an unlisten command
;----------------------------------------
; Description: Order all serial bus dev,
; to stop receiving data.
;----------------------------------------
; Exemple: Order serial bus to unlisten.
;       jsr unlsn
;       rts
;----------------------------------------
; Note: Serial bus can now be used.
;========================================
untlk   = $ffab ; Send an untalk command
;----------------------------------------
; Description:
; All devices previously set to talk will
; stop sending data.
;----------------------------------------
; Exemple:
; Order serial bus to stop sending data.
;       jsr untlk
;       rts
;----------------------------------------
; Note:
; Sending untlk commands all talking
; devices to get off the serial bus.
;========================================
vector  = $ff8d ; Manage ram vectors
;----------------------------------------
; Description:
; If the carry bit of the accumulator is 
; set, the start of a list of the current 
; contents of the ram vectors is 
; returned in the x and y registers.
; If the carry bit is clear, there the
; user list pointed to by the x and y
; registers is transferred to the system
; ram vectors.
;----------------------------------------
; Exemple:
; Change input routines to new system.
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
;----------------------------------------
; Note:
; The new input list can start anywhere. 
; User is the location for temporary 
; strings, and 35-36 is the utility 
; pointer area.
;========================================
restor  = $ff8a ; Set the top of ram
;----------------------------------------
;========================================
scnkey  = $ff9f ; Scan the keyboard
;----------------------------------------
;========================================
save    = $ffd8 ; Save memory to a device
;----------------------------------------
;========================================
; Error codes
;========================================
; If an error occurs during a kernal 
; routine, then the carry bit of the 
; accumulator is set and the error code 
; is returned in the accumulator.
;----------------------------------------
; number        ; meaning
;----------------------------------------
kerr00 = 0      ; Prog ended by stop key.
kerr01 = 1      ; too many files open.
kerr02 = 2      ; file already open.
kerr03 = 3      ; file not open.
kerr04 = 4      ; file not found.
kerr05 = 5      ; device not present.
kerr06 = 6      ; file is not input.
kerr07 = 7      ; file is not output.
kerr08 = 8      ; file name is missing.
kerr09 = 9      ; illegal device number.
kerrf0 = 240    ; top-of-memory rs-232 
                ; buffer allocation.
;----------------------------------------
;========================================
; Appel de la sous routine principale
;========================================
pgmstart    
    jsr main    ; le programme principale
    rts         ; doit s'appeler "main"
;---------------decimal------------------
;0000000001111111111222222222233333333334
;1234567890123456789012345678901234567890
;============= hexa-decimal =============
;0000000000000001111111111111111222222222
;123456789abcdef0123456789abcdef012345678
