; c64asm  - commodore 64 (6510) assembler package for pc
; copyright (c) 1996 by b�lint t�th
;
; system.asm - example assembly source file
;   system declarations (no code in this file)
; ===================================================================
; use it with .include system.asm in other source files

; special memory sections
basicstart= $0801
screenram = $0400
basicrom  = $a000
vic       = $d000
sid       = $d400
colorram  = $d800
cia1      = $dc00
cia2      = $dd00
kernalrom = $e000

; kernal routines
carcol  = $0286 ; Caracter color : 
                ; +------------+-------------+------------+------------+
                ; | $0 Black   | $1 white    | $2 Red     | $3 Cyan    |
                ; | $4 Purple  | $5 Green    | $6 Blue    | $7 Yellow  |
                ; | $8 Orange  | $9 Brown    | $A Lt-Red  | $B Dk-Gray |
                ; | $C Md-Gray | $D Lt-Green | $E Lt-Blue | $F Lt-Gray |
                ; +------------+-------------+------------+------------+
cblack      = $0
cwhite      = $1
cred        = $2
ccyan       = $3
cpurple     = $4
cgreen      = $5
cblue       = $6
cyellow     = $7
corange     = $8
cbrown      = $9
clightred   = $a
cdarkgray   = $b
cmidgray    = $c
clightgreen = $d
clightblue  = $e
clightgray  = $f

cint    = $ff81 ; Initialize the screen editor and VIC-II Chip
ioinit  = $ff84 ; Initialize I/O devices
ramtas  = $ff87 ; Perform RAM test
restor  = $ff8a ; Set the top of RAM
vector  = $ff8d ; Manage RAM vectors
setmsg  = $ff90 ; Set system message output
second  = $ff93 ; Send secondary address for LISTEN
tksa    = $ff96 ; Send a secondary address to a device commanded to talk
memtop  = $ff99 ; Set the top of RAM
membot  = $ff9c ; Set bottom of memory
scnkey  = $ff9f ; Scan the keyboard
settmo  = $ffa2 ; Set IEEE bus card timeout flag
acptr   = $ffa5 ; Input byte from serial port
ciout   = $ffa8 ; Transmit a byte over the serial bus
untlk   = $ffab ; Send an UNTALK command
unlsn   = $ffae ; Send an UNLISTEN command
listen  = $ffb1 ; Command a device on the serial bus to listen
talk    = $ffb4 ; Command a device on the serial bus to talk
readst  = $ffb7 ; Read status word
setlfs  = $ffba ; Set up a logical file
setnam  = $ffbd ; Set up file name
open    = $ffc0 ; Open a logical file
close   = $ffc3 ; Close a logical file
chkin   = $ffc6 ; Open channel for input
chkout  = $ffc9 ; Open a channel for output
clrchn  = $ffcc ; Clear all I/O channels
chrin   = $ffcf ; Get a character from the input channel
chrout  = $ffd2 ; Output a character
load    = $ffd5 ; Load RAM from device
save    = $ffd8 ; Save memory to a device
settim  = $ffdb ; Set the system clock
rdtim   = $ffde ; Read system clock
stop    = $ffe1 ; Check if STOP key is pressed
getin   = $ffe4 ; Get a character
clall   = $ffe7 ; Close all open files
udtim   = $ffea ; Update the system clock
screen  = $ffed ; Return screen format
plot    = $fff0 ; Set or retrieve cursor location x=column, y=line
iobase  = $fff3 ; Define I/O memory page
pgmstart        jsr     main            ; 0000(3) le programme principale
                rts                     ; doit s'appeler "main"
