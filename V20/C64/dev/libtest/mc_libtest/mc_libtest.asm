               VERSION="20230326-115700"

               .include "header-c64.asm"
               .include "macros-64tass.asm"
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
main            .block
               ;jsr  initnmi        ; À utiliser avec TMPreu
               ;jsr  setmyint
               ;jsr  mc_setvectors
               ;rts
               jsr  scrmaninit
               jsr  js_init
               lda  #$80
               sta  curcol
               lda  #0
               sta  bkcol
               lda  #vbleu
               sta  brdcol
               jsr  cls
               lda  #$20
               ora  #%00000000
               ldy  #$04
               ldx  #$04
               jsr  memfill
               lda  #$00
               ldy  #$d8
               jsr  memfill
               jsr  sprt_init
goagain        #printcxy bstring1 
               #printcxy bstring2
               #printcxy bstring3
;               #printcxy bstring4
               #printcxy js_status1
               #printcxy js_status2
               #printcxy js_status3
               #printcxy js_status4
               #printcxy js_status5
               #printcxy js_status6
               ldx  #$00
               ldy  #$0f
               jsr  gotoxy
               lda  #vjaune
               jsr  setcurcol
               ldx  #$00
               jsr  setbkcol
looper         jsr  js_scan
               jsr  js_showvals
               jsr  js_updatecurs
               jsr  sprt_move
               ; jsr  showstatus
               ;pha
               ;lda  js_2status
               ;beq  nochange
               ;sta  vicbordcol
nochange       ;pla
;????????????????????????????????????????????
;eternel            jmp  eternel
;????????????????????????????????????????????
               ;lda  js_2status
               ;sta  $d020
               inc  $d020
               jmp  looper
out             rts
               .bend

;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
showstatus     .block
               jsr  pushreg
               lda  js_2status
               ldx  #$03
               stx  bascol
               ldx  #3
               ldy  #22
               jsr  putabinxy
               jsr  popreg
               rts
               .bend               
;-------------------------------------------------------------------------------
;
;-------------------------------------------------------------------------------
               .include       "strings_fr.asm"
               .include        "lib-c64-text-mc.asm"
               .include        "lib-c64-showregs-mc.asm"               
               .include        "lib-c64-joystick-mc.asm"
               .include        "lib-c64-spriteman-mc.asm"
*=$c000
               .include        "map-c64-basic2.asm"
               .include        "map-c64-kernal.asm"
               .include        "map-c64-vicii.asm"
               .include        "lib-cbm-pushpop.asm"
               .include        "lib-cbm-mem.asm"
               .include        "lib-cbm-hex.asm"
