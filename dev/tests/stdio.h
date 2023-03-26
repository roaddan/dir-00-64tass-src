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

acptr   = $ffa5 ;
chkin   = $ffc6
chkout  = $ffc9
chrin   = $ffcf
chrout  = $ffd2
putch   = $ffd2
ciout   = $ffa8
cint    = $ff81
clall   = $ffe7
close   = $ffc3
clrchn  = $ffcc
getin   = $ffe4
iobase  = $fff3
ioinit  = $ff84
listen  = $ffb1
load    = $ffd5
membot  = $ff9c
memtop  = $ff99
open    = $ffc0
plot    = $fff0
ramtas  = $ff87
rdtim   = $ffde
readst  = $ffb7
restor  = $ff8a
save    = $ffd8
scnkey  = $ff9f
screen  = $ffed
second  = $ff93
setlfs  = $ffba
setmsg  = $ff90
setnam  = $ffbd
settim  = $ffdb
settmo  = $ffa2
stop    = $ffe1
talk    = $ffb4
tksa    = $ff96
udtim   = $ffea
unlsn   = $ffae
untlk   = $ffab
vector  = $ff8d

