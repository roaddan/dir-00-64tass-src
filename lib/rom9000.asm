;--------------------------------------
; version: 0.0.1
;--------------------------------------

     *=$9000
     .null "libc64"
     .include "e-64map.asm"
     .include "e-float.asm"
     .include "e-vars.asm"
     .include "l-bitmap.asm"
     .include "l-conv.asm"
     .include "l-drawbox.asm"
     .include "l-float.asm"
     .include "l-keyb.asm"
     .include "l-math.asm"
     .include "l-mem.asm"
     .include "l-push.asm"
     .include "l-screen.asm"
     .include "l-string.asm"
     .include "l-disk.asm"
     .include "m-utils.asm"
