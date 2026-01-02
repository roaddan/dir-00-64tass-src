;--------------------------------------
; version: 0.0.0
;--------------------------------------

     *=$c000
     .null "libc64"
     .include "e-64map.asm"
     .include "e-float.asm"
     ;Code dans $c000 vars dans $9000
     .include "e-vars9000.asm"
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
     .include "l-vectors.asm"
     .include "m-utils.asm"
