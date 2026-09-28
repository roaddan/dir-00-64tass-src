;-----------------------------------------------------------------------------
; Auteur: Daniel Lafrance
;-----------------------------------------------------------------------------
            .enc "none"

;-----------------------------------------------------------------------------
; Inclure l'entête de démarrage des programmes basics
;-----------------------------------------------------------------------------
            .include   "l-c64-bashead.asm"
main        .block
            jsr   pushall
            jsr   scrmaninit
            jsr   cls
            #tolower
            #changebord   vvert
            #outstr akey
;            jsr   getkey
            ldx   #<msg1a        
            ldy   #>msg1a       
            jsr   putscxy
            #locate 2,5
            #loadaxmem $fffe
            jsr b_praxstr
            #locate 2,10
            #loadaximm $fffe
            jsr b_praxstr
            #locate 0,22
            jsr   popall
out         rts
            .bend
msg1a       .byte 13,0,12
msg1b       .text"C64/C64c - SID alternatives comparison"
            .byte 0
akey        .text "Une clef!"
            .byte 0
;-----------------------------------------------------------------------------
; Include library files 
;-----------------------------------------------------------------------------
      .include    "e-c64-kernal.asm"
      .include    "e-c64-basic2.asm"
      .include    "e-c64-vars.asm"
      .include    "e-c64-vicii.asm"

      .include    "l-c64-basic2.asm"
      .include    "l-c64-basic2-math.asm"
      .include    "l-cbm-push.asm"
      .include    "l-cbm-hex.asm"
;      .include    "l-c64-string.asm"
;      .include    "l-c64-std-text.asm"
      .include    "l-c64-vicii.asm"
;      .include    "l-c64-mcd-text.asm"
      .include    "l-c64-showregs.asm"                
;      .include    "l-c64-joystick.asm"
;      .include    "l-c64-spriteman.asm"
      .include    "l-cbm-mem.asm"
      .include    "l-cbm-keyb.asm"
      .include   "m-c64-utils.asm"
;-----------------------------------------------------------------------------
