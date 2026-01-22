;--------------------------------------
; version: 0.0.1
;--------------------------------------

     *=$c000
     .null "libc64"
     ;Code dans $c000 vars dans $9000
     .include "e-c64-basic2.asm"
     .include "e-c64-float.asm"
     .include "e-c64-kernal.asm"
     .include "e-c64-map.asm"
     .include "e-c64-sid-notes-ntsc.asm"
     .include "e-c64-sid.asm"
     .include "e-c64-vicii.asm"
     .include "l-c64-bitmap.asm"
     .include "l-c64-conv.asm"
     .include "l-c64-disk.asm"
     .include "l-c64-drawbox.asm"
     .include "l-c64-float.asm"
     .include "l-c64-keyb.asm"
     .include "l-c64-math.asm"
     .include "l-c64-mem.asm"
     .include "l-c64-push.asm"
     .include "l-c64-screen.asm"
     .include "l-c64-string.asm"
     .include "m-c64-utils.asm"
     .include "e-c64-vars9000.asm"
