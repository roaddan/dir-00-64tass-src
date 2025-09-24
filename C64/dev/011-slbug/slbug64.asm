;-------------------------------------------------------------------------------
                Version = "20241205-163838"
;-------------------------------------------------------------------------------                .include    "header-c64.asm"
                
                .include    "header-c64.asm"

;-------------------------------------------------------------------------------
               .enc    "none"
main           .block
               jsr  scrmaninit
               #tolower
               #disable
               lda  #cnoir
               sta  vicbordcol
               lda  #cgris0
               sta  vicbackcol
               lda  #cblanc
               sta  bascol
               jsr  cls
               jsr  help
               jsr  anykey
               jsr  slbug64
               ;jmp  b_warmstart
               rts
               .bend
;*=$c000                
slbug64        .block
                pha
                jsr anykey
                lda vicbordcol
                sta byte
                lda #$10
                sta vicbordcol
                jsr anykey
                lda byte
                sta vicbordcol
                pla
                rts
byte            .byte 0
                .bend

help           .block      
               jsr cls
               #print line
               #print headera
               #print line
               #print headerb
               #print line
               #print headerc
               #print line
               #print shortcuts
;               #print helptext
               #print line
               rts                                
headera                       ;0123456789012345678901234567890123456789
               .text          "**** SL-BUG 64 Version 4.00 ****"
               .byte   $0d,0
headerb        .text          "*       POUR COMMODORE 64      *"
               .byte   $0d
               .text          "*  IDEE ORIGINALE: S. LEBLANC  *"
               .byte   $0d
               .text          "* Version originale sur MC6809 *"
               .byte   $0d
               .text          "* PORT C64 PAR DANIEL LAFRANCE *"
               .byte   $0d,0

headerc        .text          "*      (c) DECEMBRE 2024       *"
               .byte   $0d
               .text   format("* Version: %-20s*",Version)
               .byte   $0d,0

shortcuts      .byte   $0d
               .text          "*---- R A C C O U R C I S -----*"
               .byte   $0d
               .text   format("* Execution.: SYS%5d ($%X) *",slbug64,slbug64)
               .byte   $0d
               .text   format("* Aide......: SYS%5d ($%X) *",help,help)
               .byte   $0d
               .text   format("* CLS.......: SYS%5d ($%X) *",cls,cls)
               .byte   $0d,0
line           .text          "*------------------------------*"
               .byte   $0d,0
helptext       .text   format(" Lancement de slbug64  : SYS%5d",slbug64)
               .byte   $0d
                .text   format(" ex.: SYS%5d",slbug64)
               .byte   $0d,0
               .bend
;*=$4000
;-------------------------------------------------------------------------------
; Je mets les libtrairies à la fin pour que le code du projet se place aux debut
;-------------------------------------------------------------------------------
*=$c000        
                .include    "macros-64tass.asm"
                .include    "map-c64-kernal.asm"
                .include    "map-c64-vicii.asm"
                .include    "map-c64-basic2.asm"
                .include    "lib-c64-vicii.asm"
                .include    "lib-c64-basic2.asm"
                .include    "lib-cbm-pushpop.asm"
                .include    "lib-cbm-mem.asm"
                .include    "lib-cbm-hex.asm"
                .include    "lib-cbm-keyb.asm"
           
 