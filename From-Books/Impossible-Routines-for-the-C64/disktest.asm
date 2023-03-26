;---------;---------;---------;---------;---------;---------;---------;---------
; Book......: The impossible routines
; Author....: Kevin Bergin (1984)
; ISBN......: 0 7156 1806 7
; Typist....: Daniel Lafrance
; Program...: diskdir.asm
; Book Page.: 62
;---------;---------;---------;---------;---------;---------;---------;---------
; Description : Restore Basic program erased with the NEW command. 
;---------;---------;---------;---------;---------;---------;---------;---------
*= $801
.word (+), 10
.null $9e, "2061"
+ .word 0
               .include "c64_map_kernal.asm"
               .include "c64_map_basic2.asm"
               .include "c64_lib_basic2.asm"
               .include "c64_lib_hex.asm"
               .include "c64_lib_pushpop.asm"
               .include "diskdir.asm"
               .include "diskerror.asm"
driveno   .byte 0               
main           .block
               jsr  push
               jsr  cls
               lda  #142
               jsr  chrout
               lda  #<chaine
               ldy  #>chaine
               jsr  puts
               lda  #$08
               sta  driveno
               jsr  diskdir  
               lda  #<chaine2
               ldy  #>chaine2
               jsr  puts
               jsr  diskerror
               jsr  pop
               rts
chaine         .text   "recherche dans le lecteur 8 ..."
               .byte   $0d,$0d, 0
chaine3        .byte   $0d
               .text   "appuyez [return] pour quitter."
               .byte   $0d, 0
chaine2        .byte   $0d
               .text   "code d'erreur :"
               .byte   $0d,$0d 
               .text   "    "
               .byte   0
               .bend
         